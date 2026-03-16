import textwrap
from pathlib import Path
from typing import Any

from robot.api.parsing import get_model
from robot.api import TestSuite
from robot.libdoc import LibraryDocumentation
from robot.running.model import Body
from robot.utils import normalize

from ..helper.cliargs import CommandLineArguments
from .models import CustomTestCase, CustomTestCaseBody, CustomTestSuite


KeywordDocEntry = tuple[str, str]
KeywordDocIndex = dict[str, list[KeywordDocEntry]]

BUILTIN_LIBRARY = "BuiltIn"


class TestCaseParser:
    def __init__(self) -> None:
        self.args = CommandLineArguments()
        self._keyword_docs_cache: dict[str, KeywordDocIndex] = {}

    def _first_doc_line(self, doc: str) -> str:
        """Return only the first (meaningful) documentation line.

        Keyword documentation can be multi-line (e.g. Python docstrings). The UI
        info dialog should display only the first line and ignore everything
        after the first line break.

        Note: Some doc sources may contain leading empty lines. We therefore
        return the first non-empty line.
        """
        if not doc:
            return ""

        for line in doc.splitlines():
            stripped = line.strip()
            if stripped:
                return stripped
        return ""

    def parse_test(self, suite: TestSuite, suite_info: CustomTestSuite) -> CustomTestSuite:
        suite_source_path = self._to_path(getattr(suite, "source", None))
        suite_keyword_docs = self._get_keyword_docs_for_source(suite_source_path)

        for test in suite.tests:
            test_source_path = self._to_path(getattr(test, "source", None)) or suite_source_path
            keyword_docs = (
                self._get_keyword_docs_for_source(test_source_path) if test_source_path != suite_source_path else suite_keyword_docs
            )

            test_info: CustomTestCase = CustomTestCase(
                id=test.id,
                name=test.name,
                doc=test.doc,
                tags=list(test.tags) if test.tags else None,
                source=str(test.source),
                body=self.test_body_parser(test.body, keyword_docs),
                setup=self._parse_fixture(test.setup, keyword_docs),
                teardown=self._parse_fixture(test.teardown, keyword_docs),
            )
            suite_info.tests.append(test_info)
        return suite_info

    def _parse_fixture(self, fixture, keyword_docs: KeywordDocIndex) -> CustomTestCaseBody | None:
        """Parse a test setup or teardown keyword into a CustomTestCaseBody."""
        if fixture is None or not getattr(fixture, "name", None):
            return None

        keyword_doc, keyword_owner = self._get_keyword_details(fixture.name, keyword_docs)

        return CustomTestCaseBody(
            id=getattr(fixture, "id", ""),
            type="KEYWORD",
            name=fixture.name,
            args=list(fixture.args) if getattr(fixture, "args", None) else None,
            keyword_doc=keyword_doc,
            keyword_owner=keyword_owner,
        )

    def test_body_parser(self, body: Body, keyword_docs: KeywordDocIndex) -> list[CustomTestCaseBody]:
        result = []
        for item in body:
            body_item = self._create_body_item(item, keyword_docs)

            if hasattr(item, "body") and item.body:
                body_item.body = self.test_body_parser(item.body, keyword_docs)

            result.append(body_item)

        return result

    def _keyword_parser(self, test_body: list[CustomTestCaseBody] | list[dict]):
        """Parse keywords and their child-items"""
        _keyword_object = []
        for kw in test_body:
            _keyword_object.extend(self._handle_keyword_types(kw))

        _keyword_object = self._kw_post_processing(_keyword_object)

        # Fallback in case of no keywords
        if len(_keyword_object) == 0:
            return ["No Keyword Calls in Test"]
        return _keyword_object

    def _handle_keyword_types(self, kw: CustomTestCaseBody | dict, indent: int = 0):  # noqa
        """Handle different keyword types"""
        result = []
        kw_type = self._get_value(kw, "type", None)

        _sd = "    "  # classic rfw delimiter with 4 spaces
        _indent = _sd * indent

        # Classic keyword
        if kw_type == "KEYWORD" and self._get_value(kw, "name", None):
            args = _sd.join(self._get_value(kw, "args", [])) if self._get_value(kw, "args", None) else ""
            entry = _indent + self._get_value(kw, "name", "")
            if args:
                entry += _sd + args
            wrapped = textwrap.wrap(entry, width=200, subsequent_indent=_indent + "..." + _sd)
            result.extend(wrapped)

        # VAR syntax
        elif kw_type == "VAR" and self._get_value(kw, "name", None):
            value = _sd.join(self._get_value(kw, "value", [])) if self._get_value(kw, "value", None) else ""
            result.append(f"{_indent}VAR    {self._get_value(kw, 'name', '')} =    {value}")

        # IF/ELSE/ELSE IF
        elif kw_type == "IF/ELSE ROOT":
            for branch in self._get_value(kw, "body", []):
                branch_type = self._get_value(branch, "type", None)
                if branch_type == "IF":
                    header = f"{_indent}IF{_sd}{self._get_value(branch, 'condition', '')}".rstrip()
                elif branch_type == "ELSE IF":
                    header = f"{_indent}ELSE IF{_sd}{self._get_value(branch, 'condition', '')}".rstrip()
                elif branch_type == "ELSE":
                    header = f"{_indent}ELSE"
                else:
                    header = f"{_indent}{branch_type or ''}"
                if header:
                    result.append(header)
                for subkw in self._get_value(branch, "body", []):
                    result.extend(self._handle_keyword_types(subkw, indent=indent + 1))
            result.append(f"{_indent}END\n" if indent == 0 else f"{_indent}END")

        # FOR loop
        elif kw_type == "FOR":
            header = f"{_indent}FOR"
            assign = self._get_value(kw, "assign", [])
            if self._get_value(kw, "assign") and assign:
                header += f"    {'    '.join(assign)}"
            flavor = self._get_value(kw, "flavor", "")
            if self._get_value(kw, "flavor") and flavor:
                header += f"    {flavor}"
            else:
                header += "    IN"
            values = self._get_value(kw, "values", [])
            if self._get_value(kw, "values") and values:
                header += f"    {'    '.join(values)}"
            result.append(header)
            body = self._get_value(kw, "body", [])
            if self._get_value(kw, "body"):
                for subkw in body:
                    result.extend(self._handle_keyword_types(subkw, indent=indent + 1))
            result.append(f"{_indent}END\n" if indent == 0 else f"{_indent}END")

        # GROUP loop
        elif kw_type == "GROUP":
            header = f"{_indent}GROUP"
            name = self._get_value(kw, "name", "")
            if name != "":
                header += f"{_sd}{name}"
            condition = self._get_value(kw, "condition", "")
            if self._get_value(kw, "condition") and condition:
                header += f"    {condition}"
            result.append(header)
            body = self._get_value(kw, "body", [])
            if self._get_value(kw, "body"):
                for subkw in body:
                    result.extend(self._handle_keyword_types(subkw, indent=indent + 1))
            result.append(f"{_indent}END\n" if indent == 0 else f"{_indent}END")

        # WHILE loop
        elif kw_type == "WHILE":
            header = f"{_indent}WHILE"
            condition = self._get_value(kw, "condition", "")
            if self._get_value(kw, "condition") and condition:
                header += f"    {condition}"
            result.append(header)
            body = self._get_value(kw, "body", [])
            if self._get_value(kw, "body"):
                for subkw in body:
                    result.extend(self._handle_keyword_types(subkw, indent=indent + 1))
            result.append(f"{_indent}END\n" if indent == 0 else f"{_indent}END")

        # TRY/EXCEPT/FINALLY
        elif kw_type in ("TRY", "EXCEPT", "FINALLY"):
            header = f"{_indent}{kw_type}"
            patterns = self._get_value(kw, "patterns", [])
            if self._get_value(kw, "patterns") and patterns:
                header += f"    {'    '.join(patterns)}"
            condition = self._get_value(kw, "condition", "")
            if self._get_value(kw, "condition") and condition:
                header += f"    {condition}"
            result.append(header)
            body = self._get_value(kw, "body", [])
            if self._get_value(kw, "body"):
                for subkw in body:
                    result.extend(self._handle_keyword_types(subkw, indent=indent + 1))
            if kw_type in ("EXCEPT", "FINALLY"):
                result.append(f"{_indent}END\n" if indent == 0 else f"{_indent}END")

        # BREAK, CONTINUE, RETURN, ERROR
        elif kw_type in ("BREAK", "CONTINUE", "RETURN", "ERROR"):
            entry = f"{_indent}{kw_type}"
            values = self._get_value(kw, "values", [])
            if self._get_value(kw, "values") and values:
                entry += f"    {_sd.join(values)}"
            result.append(entry)

        # Unknown types
        elif self._get_value(kw, "body"):
            body = self._get_value(kw, "body", [])
            for subkw in body:
                result.extend(self._handle_keyword_types(subkw))

        return result

    def _kw_post_processing(self, kw: list):
        """Post-processing of generated keyword list to handle special cases"""
        # TRY/EXCEPT/FINALLY
        # post-process list for specific handling
        for i in range(len(kw) - 1):
            _cur = str(kw[i]).replace(" ", "")
            _next = str(kw[i + 1]).replace(" ", "")
            if _cur == "END" and _next == "FINALLY":
                kw.pop(i)
                break
        return kw

    def _get_value(self, obj: CustomTestCaseBody | dict, key: str, default=None) -> Any:
        """
        TBD
        """
        if isinstance(obj, dict):
            return obj.get(key, default)
        return getattr(obj, key, default)

    def _to_path(self, value: Any) -> Path | None:
        if not value:
            return None
        return Path(str(value)).expanduser().resolve()

    def _normalize_keyword_name(self, name: str) -> str:
        return normalize(name, ignore=("_",))

    def _get_keyword_details(
        self,
        keyword_name: str | None,
        keyword_docs: KeywordDocIndex,
    ) -> tuple[str | None, str | None]:
        if not keyword_name:
            return None, None
        return self._resolve_keyword_doc(keyword_name, keyword_docs)

    def _create_body_item(self, item: Any, keyword_docs: KeywordDocIndex) -> CustomTestCaseBody:
        item_type = getattr(item, "type", "")
        item_name = getattr(item, "name", item_type)
        keyword_doc, keyword_owner = (None, None)
        if item_type == "KEYWORD":
            keyword_doc, keyword_owner = self._get_keyword_details(item_name, keyword_docs)

        return CustomTestCaseBody(
            id=item.id,
            type=item_type,
            name=item_name,
            args=getattr(item, "args", None),
            value=getattr(item, "value", None),
            values=getattr(item, "values", None),
            condition=getattr(item, "condition", None),
            assign=getattr(item, "assign", None),
            flavor=getattr(item, "flavor", None),
            patterns=getattr(item, "patterns", None),
            keyword_doc=keyword_doc,
            keyword_owner=keyword_owner,
        )

    def _split_explicit_keyword_name(self, name: str) -> tuple[str | None, str]:
        if "." not in name:
            return None, name
        owner, keyword_name = name.split(".", 1)
        owner = owner.strip()
        keyword_name = keyword_name.strip()
        if owner and keyword_name:
            return owner, keyword_name
        return None, name

    def _resolve_import_target(self, import_name: str, base_dir: Path) -> str:
        import_path = Path(import_name)
        should_resolve = (
            import_path.is_absolute()
            or any(sep in import_name for sep in ("/", "\\"))
            or import_name.endswith((".py", ".robot"))
        )
        if not should_resolve:
            return import_name

        resolved = import_path if import_path.is_absolute() else (base_dir / import_path).resolve()
        return str(resolved) if resolved.exists() else import_name

    def _iter_file_imports(self, file_path: Path) -> list[tuple[str, str, str | None]]:
        imports: list[tuple[str, str, str | None]] = []
        model = get_model(str(file_path))
        for section in model.sections:
            for node in getattr(section, "body", []):
                node_type = type(node).__name__
                if node_type == "LibraryImport":
                    imports.append(("library", str(getattr(node, "name", "")), getattr(node, "alias", None)))
                elif node_type == "ResourceImport":
                    imports.append(("resource", str(getattr(node, "name", "")), None))
        return imports

    def _add_library_keywords(self, index: KeywordDocIndex, library_or_resource: str, owner: str | None = None) -> None:
        try:
            libdoc = LibraryDocumentation(library_or_resource)
        except Exception:
            return

        keyword_owner = owner or getattr(libdoc, "name", None) or library_or_resource
        for kw in getattr(libdoc, "keywords", []):
            self._add_keyword_candidate(
                index,
                keyword_name=getattr(kw, "name", ""),
                keyword_owner=keyword_owner,
                keyword_doc=getattr(kw, "doc", ""),
            )

    def _add_keyword_candidate(
        self,
        index: KeywordDocIndex,
        keyword_name: str,
        keyword_owner: str,
        keyword_doc: str,
    ) -> None:
        keyword_doc = self._first_doc_line(keyword_doc)
        if not keyword_name or not keyword_doc:
            return

        normalized_name = self._normalize_keyword_name(keyword_name)
        candidates = index.setdefault(normalized_name, [])
        candidate = (keyword_owner, keyword_doc)
        if candidate not in candidates:
            candidates.append(candidate)

    def _get_library_owner(self, import_name: str, import_alias: str | None) -> str | None:
        if import_alias:
            return import_alias
        if import_name.endswith(".py"):
            return Path(import_name).stem
        return None

    def _collect_keyword_docs_from_file(
        self,
        source_file: Path,
        index: KeywordDocIndex,
        visited_files: set[str],
    ) -> None:
        cache_key = str(source_file)
        if cache_key in visited_files or not source_file.exists() or source_file.suffix.lower() != ".robot":
            return

        visited_files.add(cache_key)

        for import_type, import_name, import_alias in self._iter_file_imports(source_file):
            if not import_name:
                continue

            if import_type == "library":
                target = self._resolve_import_target(import_name, source_file.parent)
                owner = self._get_library_owner(import_name, import_alias)
                self._add_library_keywords(index, target, owner)
            elif import_type == "resource":
                resource_path = (source_file.parent / import_name).resolve()
                if not resource_path.exists():
                    continue
                self._add_library_keywords(index, str(resource_path), resource_path.stem)
                self._collect_keyword_docs_from_file(resource_path, index, visited_files)

    def _get_keyword_docs_for_source(self, source_path: Path | None) -> KeywordDocIndex:
        cache_key = str(source_path) if source_path else "<default>"
        if cache_key in self._keyword_docs_cache:
            return self._keyword_docs_cache[cache_key]

        keyword_docs: KeywordDocIndex = {}

        # BuiltIn is always available and should resolve common keywords such as `Log`.
        self._add_library_keywords(keyword_docs, BUILTIN_LIBRARY, owner=BUILTIN_LIBRARY)

        if source_path and source_path.exists() and source_path.suffix.lower() == ".robot":
            # Include user keywords defined in the current suite/resource itself.
            self._add_library_keywords(keyword_docs, str(source_path), source_path.stem)
            self._collect_keyword_docs_from_file(source_path, keyword_docs, set())

        self._keyword_docs_cache[cache_key] = keyword_docs
        return keyword_docs

    def _resolve_keyword_doc(
        self,
        keyword_name: str,
        keyword_docs: KeywordDocIndex,
    ) -> tuple[str | None, str | None]:
        explicit_owner, clean_keyword_name = self._split_explicit_keyword_name(keyword_name)
        normalized_name = self._normalize_keyword_name(clean_keyword_name)
        candidates = keyword_docs.get(normalized_name, [])
        if not candidates:
            return None, None

        if explicit_owner:
            normalized_owner = self._normalize_keyword_name(explicit_owner)
            for owner, doc in candidates:
                if self._normalize_keyword_name(owner) == normalized_owner:
                    return doc, owner

        if len(candidates) == 1:
            owner, doc = candidates[0]
            return doc, owner

        for owner, doc in candidates:
            if self._normalize_keyword_name(owner) == self._normalize_keyword_name(BUILTIN_LIBRARY):
                return doc, owner

        owner, doc = candidates[0]
        return doc, owner
