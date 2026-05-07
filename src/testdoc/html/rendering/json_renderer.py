import json
from dataclasses import asdict
from pathlib import Path

from ...helper.logger import Logger
from ...parser.models import CustomTestSuite


class JsonRenderer:
    def render(self, suites: CustomTestSuite, output_file: Path) -> None:
        data = asdict(suites)
        output_file = Path(output_file)
        output_file.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
        Logger().log_key_value("Generated Test Documentation JSON: ", output_file)
