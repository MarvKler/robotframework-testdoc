from __future__ import annotations

import html
from pathlib import Path

from fpdf import FPDF
from jinja2 import Environment, FileSystemLoader

from ...helper.cliargs import CommandLineArguments
from ...helper.datetimeconverter import DateTimeConverter
from ...helper.logger import Logger
from ...parser.models import CustomTestSuite


class BrandedPdf(FPDF):
    def header(self) -> None:
        # Soft, high-contrast background applied to every page, including auto page breaks.
        self.set_fill_color(244, 247, 252)
        self.rect(0, 0, self.w, self.h, "F")


class PdfRenderer:
    MIN_TITLE_FONT_SIZE = 18

    def __init__(self) -> None:
        self.args = CommandLineArguments()

    def render(self, suites: CustomTestSuite, output_file: Path) -> None:
        suite_entries = self._collect_suites(suites)
        executable_suites = [
            suite
            for _, suite in suite_entries
            if not suite.is_folder and str(suite.source).lower().endswith(".robot")
        ]
        all_test_count = sum(len(suite.tests) for suite in executable_suites)

        pdf = BrandedPdf(format="A4")
        pdf.set_auto_page_break(auto=True, margin=14)
        pdf.set_margins(14, 14, 14)
        pdf.set_author("robotframework-testdoc")
        pdf.set_text_color(15, 23, 42)

        generated_at = DateTimeConverter().get_generated_datetime("%d.%m.%Y")
        generated_date = generated_at.split(" ", 1)[0]
        safe_title = self._to_pdf_text(self.args.title)
        suite_toc = [
            {
                "suite": suite,
                "name": self._to_pdf_text(suite.name),
                "link": pdf.add_link(),
            }
            for suite in executable_suites
        ]
        for item in suite_toc:
            # fpdf2 requires links to have an initial page assignment before first usage.
            pdf.set_link(item["link"], y=0, page=1)

        # Title page
        self._start_page(pdf)
        self._render_title_page(pdf, safe_title, self._to_pdf_text(generated_date))

        # Table of contents page with clickable links to suite pages.
        self._start_page(pdf)
        self._render_toc_page(pdf, suite_toc)

        # First page: overall summary + bullet list of all .robot suites
        self._start_page(pdf)
        pdf.write_html(
            self._render_pdf_html(
                view="overview",
                title=safe_title,
                generated_at=self._to_pdf_text(generated_at),
                root_suite_name=self._to_pdf_text(suites.name),
                suite_count=len(executable_suites),
                test_count=all_test_count,
            )
        )
        self._render_suite_links_section(pdf, suite_toc)

        # One page per suite: each suite starts on a fresh page.
        for item in suite_toc:
            suite = item["suite"]
            self._start_page(pdf)
            pdf.set_link(item["link"], y=pdf.t_margin, page=pdf.page_no())
            pdf.write_html(
                self._render_pdf_html(
                    view="suite",
                    title=safe_title,
                    suite_name=self._to_pdf_text(suite.name),
                    tests=[
                        {
                            "name": self._to_pdf_text(test.name),
                            "tags": [self._to_pdf_text(tag) for tag in (test.tags or [])],
                        }
                        for test in suite.tests
                    ],
                )
            )

        output_file = Path(output_file)
        pdf.output(str(output_file))
        Logger().log_key_value("Generated Test Documentation PDF: ", output_file)

    def _render_pdf_html(self, **context) -> str:
        template_path = self._get_pdf_template_path()
        env = Environment(loader=FileSystemLoader(template_path.parent))
        template = env.get_template(template_path.name)
        return template.render(**context)

    def _get_pdf_template_path(self) -> Path:
        if self.args.custom_pdf_template:
            return Path(self.args.custom_pdf_template).expanduser().resolve()
        return Path(__file__).resolve().parent / ".." / "templates" / "jinja_pdf_default" / "pdf_template.html"

    def _start_page(self, pdf: FPDF) -> None:
        pdf.add_page()
        pdf.set_text_color(15, 23, 42)
        pdf.set_xy(pdf.l_margin, pdf.t_margin)

    def _render_title_page(self, pdf: FPDF, title: str, generated_date: str) -> None:
        max_width = pdf.w - (2 * pdf.l_margin)
        title_font_size = 34
        pdf.set_font("Helvetica", "B", title_font_size)
        while pdf.get_string_width(title) > (max_width * 0.92) and title_font_size > self.MIN_TITLE_FONT_SIZE:
            title_font_size -= 1
            pdf.set_font("Helvetica", "B", title_font_size)

        title_line_height = 12
        center_y = pdf.h / 2

        pdf.set_y(center_y - title_line_height)
        pdf.cell(max_width, title_line_height, title, align="C", new_x="LMARGIN", new_y="NEXT")

        pdf.set_font("Helvetica", "", 13)
        pdf.set_y(center_y + 4)
        pdf.cell(max_width, 8, generated_date, align="C")

    def _render_toc_page(self, pdf: FPDF, suite_toc: list[dict]) -> None:
        pdf.set_font("Helvetica", "B", 20)
        pdf.cell(0, 12, "Inhaltsverzeichnis", align="C", new_x="LMARGIN", new_y="NEXT")
        pdf.ln(2)

        if not suite_toc:
            pdf.set_font("Helvetica", "", 11)
            pdf.cell(0, 8, "No .robot suites found.", new_x="LMARGIN", new_y="NEXT")
            return

        for idx, item in enumerate(suite_toc, start=1):
            pdf.set_font("Helvetica", "", 11)
            pdf.set_text_color(30, 64, 175)
            pdf.write(7, f"{idx}. {item['name']}", link=item["link"])
            pdf.ln(7)

        pdf.set_text_color(15, 23, 42)

    def _render_suite_links_section(self, pdf: FPDF, suite_toc: list[dict]) -> None:
        pdf.ln(4)
        pdf.set_font("Helvetica", "B", 13)
        pdf.cell(0, 9, "Test Suites", new_x="LMARGIN", new_y="NEXT")

        if not suite_toc:
            pdf.set_font("Helvetica", "", 11)
            pdf.cell(0, 7, "No .robot suites found.", new_x="LMARGIN", new_y="NEXT")
            return

        for item in suite_toc:
            pdf.set_font("Helvetica", "", 11)
            pdf.set_text_color(30, 64, 175)
            pdf.write(7, f"- {item['name']}", link=item["link"])
            pdf.ln(7)

        pdf.set_text_color(15, 23, 42)

    def _collect_suites(self, root: CustomTestSuite) -> list[tuple[int, CustomTestSuite]]:
        result: list[tuple[int, CustomTestSuite]] = []

        def _walk(suite: CustomTestSuite, level: int) -> None:
            result.append((level, suite))
            for child in suite.suites:
                _walk(child, level + 1)

        _walk(root, 0)
        return result

    def _to_pdf_text(self, value: str) -> str:
        text = str(value)
        replacements = {
            "\u2014": "-",
            "\u2013": "-",
            "\u2026": "...",
            "\u201c": '"',
            "\u201d": '"',
            "\u201e": '"',
            "\u2019": "'",
            "\u2018": "'",
            "\u00a0": " ",
        }

        for src, dst in replacements.items():
            text = text.replace(src, dst)

        # Keep output safe for both core-font latin-1 encoding and HTML rendering.
        text = text.encode("latin-1", errors="replace").decode("latin-1")
        return html.escape(text)
