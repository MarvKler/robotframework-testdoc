from pathlib import Path

from ..html.rendering.webapp import TestDocWebRenderer
from ..parser.models import CustomTestSuite
from .mapper import ManagementMapper


class ManagementWebRenderer(TestDocWebRenderer):
    """Compatibility facade for the former management renderer API."""

    def render_documentation(self, suite: CustomTestSuite, output_dir: Path) -> Path:
        management_suite = ManagementMapper().build(suite, {})
        return self.render(management_suite, output_dir, show_history=False)


__all__ = ["ManagementWebRenderer"]
