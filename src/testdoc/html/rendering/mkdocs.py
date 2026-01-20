import json
from pathlib import Path
import shutil
import subprocess

import yaml

from ...parser.models import SuiteInfoModel
from ...helper.cliargs import CommandLineArguments


class MkdocsIntegration:
    """
    - copies user template into a work dir
    - writes suites.json
    - ensures mkdocs-macros-plugin has access to suites via main.py
    - generates wrapper pages for each (sub)suite
    - patches mkdocs.yml nav recursively
    - builds site with mkdocs
    """

    def __init__(self):
        self.args = CommandLineArguments()

    def render_mkdocs_page(self, suites: list[SuiteInfoModel]) -> Path:
        if not self.args.mkdocs_template_dir:
            user_template_dir = Path(__file__).resolve().parent.parent / "templates" / "mkdocs_default"
        else:
            user_template_dir = Path(self.args.mkdocs_template_dir).expanduser().resolve()
        work_dir_prefix = Path(self.args.output_file).expanduser().resolve()
        p = Path(work_dir_prefix)
        if not p.is_dir():
            raise ValueError("Output path must be path to directory - not path to file!")
        work_dir = (work_dir_prefix / "testdoc_output")

        self._prepare_workdir(user_template_dir, work_dir)

        suites_data = self._dump_suites_to_json(work_dir, suites)

        self._install_main_py(work_dir)

        # generate wrapper pages + patch mkdocs.yml nav
        docs_dir = work_dir / "docs"
        self._generate_wrapper_pages(docs_dir, suites_data, user_suite_template="_partials/suite_page.md")
        self._patch_mkdocs_nav(work_dir / "mkdocs.yml", suites_data)

        self._mkdocs_build(work_dir)

        site_dir = work_dir / "site"
        return site_dir / "index.html"

    # -----------------------
    # internals
    # -----------------------

    def _prepare_workdir(self, user_template_dir: Path, work_dir: Path) -> None:
        if work_dir.exists():
            shutil.rmtree(work_dir)
        shutil.copytree(user_template_dir, work_dir)

    def _dump_suites_to_json(self, work_dir: Path, suites: list[SuiteInfoModel]) -> list[dict]:
        # IMPORTANT: ensure pydantic dumps nested sub_suites recursively
        suites_dict = [s.model_dump(mode="python") for s in suites]

        # make output readable + keep umlauts etc.
        json_path = work_dir / "suites.json"
        json_path.write_text(
            json.dumps(suites_dict, ensure_ascii=False, indent=2),
            encoding="utf-8",
        )
        return suites_dict

    def _install_main_py(self, work_dir: Path) -> None:
        # Your existing approach: copy a minimal main.py
        src = Path(__file__).parent / "mkdocs" / "example_main.py"
        dst = work_dir / "main.py"
        shutil.copyfile(src, dst)

    def _mkdocs_build(self, work_dir: Path) -> None:
        subprocess.check_call(["mkdocs", "build", "-f", str(work_dir / "mkdocs.yml")])

    # -----------------------
    # nav + pages generation
    # -----------------------

    def _slugify(self, s: str) -> str:
        s = (s or "").strip().lower().replace(" ", "-")
        keep = "abcdefghijklmnopqrstuvwxyz0123456789-_"
        out = "".join(ch for ch in s if ch in keep)
        return out or "suite"

    def _ensure_suite_ids(self, suites: list[dict]) -> None:
        """
        Ensure each suite/subsuite has a stable 'id'. Needed for wrapper filenames.
        If user already has an id -> keep it.
        """
        def rec(suite: dict, prefix: str) -> None:
            if not suite.get("id"):
                suite["id"] = self._slugify(f"{prefix}-{suite.get('name', 'suite')}")
            for child in (suite.get("sub_suites") or []):
                rec(child, suite["id"])

        for s in suites:
            rec(s, "root")

    def _generate_wrapper_pages(self, docs_dir: Path, suites: list[dict], user_suite_template: str) -> None:
        """
        Creates:
          docs/generated/<suite-id>.md        (one per suite/subsuite)
          docs/generated/_resolve_suite.md    (find suite by suite_id and include user template)
        """
        docs_dir.mkdir(parents=True, exist_ok=True)
        gen_dir = docs_dir / "generated"
        gen_dir.mkdir(parents=True, exist_ok=True)

        self._ensure_suite_ids(suites)

        # Resolver template: finds the suite object for suite_id and includes the user’s template
        (gen_dir / "_resolve_suite.md").write_text(
            "{% macro find(items, target) %}\n"
            "  {% for s in items %}\n"
            "    {% if s.id == target %}{% set ns.found = s %}{% endif %}\n"
            "    {% if not ns.found and s.sub_suites %}{{ find(s.sub_suites, target) }}{% endif %}\n"
            "  {% endfor %}\n"
            "{% endmacro %}\n\n"
            "{% set ns = namespace(found=None) %}\n"
            "{{ find(suites, suite_id) }}\n"
            "{% set suite = ns.found %}\n"
            "{% include '" + user_suite_template + "' %}\n",
            encoding="utf-8",
        )

        # Create one wrapper page per suite/subsuite
        def write_wrapper(suite: dict) -> None:
            suite_id = suite["id"]
            (gen_dir / f"{suite_id}.md").write_text(
                "{% set suite_id = '" + suite_id + "' %}\n"
                "{% include 'generated/_resolve_suite.md' %}\n",
                encoding="utf-8",
            )
            for child in (suite.get("sub_suites") or []):
                write_wrapper(child)

        for s in suites:
            write_wrapper(s)

    def _build_nav_tree(self, suite: dict) -> dict:
        """
        MkDocs nav item:
          - No children: { "SuiteName": "generated/<id>.md" }
          - With children: { "SuiteName": [ {"Overview": "...md"}, <child items...> ] }
        """
        page = f"generated/{suite['id']}.md"
        children = suite.get("sub_suites") or []
        if children:
            return {suite["name"]: [{"Overview": page}] + [self._build_nav_tree(c) for c in children]}
        return {suite["name"]: page}

    def _patch_mkdocs_nav(self, mkdocs_yml_path: Path, suites: list[dict]) -> None:
        self._ensure_suite_ids(suites)

        mk = yaml.safe_load(mkdocs_yml_path.read_text(encoding="utf-8")) or {}

        # Keep user's existing nav if present; otherwise give a minimal default
        base_nav = mk.get("nav") or [{"Home": "index.md"}]

        suites_nav = [self._build_nav_tree(s) for s in suites]

        # append under a single top-level entry, so user can still have their own structure
        mk["nav"] = base_nav + [{"Test Documentation": suites_nav}]

        mkdocs_yml_path.write_text(
            yaml.safe_dump(mk, sort_keys=False, allow_unicode=True),
            encoding="utf-8",
        )
