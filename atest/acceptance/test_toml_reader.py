import pytest

from testdoc.helper.cliargs import CommandLineArguments
from testdoc.helper.toml_reader import TOMLReader


@pytest.fixture(autouse=True)
def _reset_cli_args():
    """CommandLineArguments is a process-wide singleton; keep tests isolated from each other."""
    CommandLineArguments().set_args()
    yield
    CommandLineArguments().set_args()


def test_load_from_config_file_pyproject_style(tmp_path):
    config_file = tmp_path / "pyproject.toml"
    config_file.write_text(
        '[tool.testdoc]\ntitle = "Custom Title"\nname = "Custom Suite Name"\n',
        encoding="utf-8",
    )

    TOMLReader().load_from_config_file(config_file)

    assert CommandLineArguments().title == "Custom Title"
    assert CommandLineArguments().name == "Custom Suite Name"


def test_load_from_config_file_custom_toml(tmp_path):
    config_file = tmp_path / "testdoc.toml"
    config_file.write_text(
        'title = "Flat Title"\nsourceprefix = "https://example.com/blob/main/"\ninclude = ["smoke"]\n',
        encoding="utf-8",
    )

    TOMLReader().load_from_config_file(config_file)

    assert CommandLineArguments().title == "Flat Title"
    assert CommandLineArguments().sourceprefix == "https://example.com/blob/main/"
    assert CommandLineArguments().include == ["smoke"]


def test_config_file_does_not_override_already_set_args(tmp_path):
    CommandLineArguments().set_args(title="From CLI")
    config_file = tmp_path / "testdoc.toml"
    config_file.write_text('title = "From Config"\n', encoding="utf-8")

    TOMLReader().load_from_config_file(config_file)

    assert CommandLineArguments().title == "From CLI"


def test_read_toml_invalid_file_raises_import_error(tmp_path):
    bad_file = tmp_path / "broken.toml"
    bad_file.write_text("not = [valid toml", encoding="utf-8")

    with pytest.raises(ImportError, match="Cannot read toml file"):
        TOMLReader()._read_toml(bad_file)
