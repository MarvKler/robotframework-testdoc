import os
from pathlib import Path
import shutil
import tempfile
from click.testing import CliRunner
from testdoc.cli import main

def test_cli_help():
    runner = CliRunner()
    result = runner.invoke(main, ["--help"])
    assert result.exit_code == 0
    assert "Usage" in result.output
    assert "Welcome" in result.output

def test_cli_cmd():
    parent_dir = Path(__file__).parent.parent
    robot = os.path.join(parent_dir, "testdata", "acceptance")
    output = os.path.join(parent_dir, "output_classic.html")
    runner = CliRunner()
    result = runner.invoke(main, [robot, output])
    assert result.exit_code == 0
    assert "Generated" in result.output
    assert "output_classic.html" in result.output
    assert os.path.exists(output)

def test_cli_cmd_mkdocs():
    parent_dir = Path(__file__).parent.parent
    robot = os.path.join(parent_dir, "testdata", "acceptance")
    output = os.path.join(parent_dir, "mkdocs_test")
    if Path(output).exists():
        shutil.rmtree(output)
    os.mkdir(output)
    runner = CliRunner()
    result = runner.invoke(main, ["--mkdocs", robot, output])
    assert result.exit_code == 0
    assert "Generated mkdocs pages here" in result.stdout
    assert output in result.stdout
    assert os.path.exists(os.path.join(output, "testdoc_output"))

def test_cli_cmd_github_prefix():
    parent_dir = Path(__file__).parent.parent
    robot = os.path.join(parent_dir, "testdata", "acceptance")
    output = os.path.join(parent_dir, "output_big.html")
    runner = CliRunner()
    result = runner.invoke(main, ["-s", "github::https://github.com/project-name", "--verbose", robot, output])
    assert result.exit_code == 0
    assert "Using Prefix for Source" in result.stdout
    assert "github::" in result.stdout
    assert output in result.stdout
    assert os.path.exists(output)

def test_cli_cmd_gitlab_prefix():
    parent_dir = Path(__file__).parent.parent
    robot = os.path.join(parent_dir, "testdata", "acceptance")
    output = os.path.join(parent_dir, "output_big.html")
    runner = CliRunner()
    result = runner.invoke(main, ["-s", "gitlab::https://gitlab.com/project-name", "--verbose", robot, output])
    assert result.exit_code == 0
    assert "Using Prefix for Source" in result.stdout
    assert "gitlab::" in result.stdout
    assert output in result.stdout
    assert os.path.exists(output)

def test_cli_cmd_mkdocs_custom_template():
    parent_dir = Path(__file__).parent.parent
    robot = os.path.join(parent_dir, "testdata", "acceptance")
    output = os.path.join(parent_dir, "mkdocs_test_custom")
    templ_dir = Path(__file__).parent.parent.parent / "src" / "testdoc" / "html" / "templates" / "mkdocs_default"
    if Path(output).exists():
        shutil.rmtree(output)
    os.mkdir(output)
    runner = CliRunner()
    result = runner.invoke(main, ["--mkdocs", "--mkdocs-template-dir", templ_dir, robot, output])
    assert result.exit_code == 0
    assert "Generated mkdocs pages here" in result.stdout
    assert output in result.stdout
    assert os.path.exists(os.path.join(output, "testdoc_output"))


def test_cli_cmd_verbose():
    parent_dir = Path(__file__).parent.parent
    robot = os.path.join(parent_dir, "testdata", "acceptance")
    output = os.path.join(parent_dir, "output.html")
    runner = CliRunner()
    result = runner.invoke(main, [robot, output, "-v"])
    assert result.exit_code == 0
    assert "Generated" in result.output
    assert "output.html" in result.output
    assert "Saving" in result.output
    assert os.path.exists(output)


def test_cli_cmd_pdf_output_format():
    parent_dir = Path(__file__).parent.parent
    robot = os.path.join(parent_dir, "testdata", "acceptance")
    output = os.path.join(parent_dir, "output_testdoc.pdf")
    runner = CliRunner()
    result = runner.invoke(main, ["-f", "pdf", robot, output])
    assert result.exit_code == 0
    assert "Generated Test Documentation PDF" in result.output
    assert os.path.exists(output)

    with open(output, "rb") as file:
        header = file.read(4)
    assert header == b"%PDF"


def test_cli_cmd_pdf_output_format_with_custom_template():
        parent_dir = Path(__file__).parent.parent
        robot = os.path.join(parent_dir, "testdata", "acceptance")
        output = os.path.join(parent_dir, "output_testdoc_custom_template.pdf")

        template_content = """
<html>
    <body>
        {% if view == "overview" %}
            <h2>Custom Overview</h2>
            <p>Total Suites: {{ suite_count }}</p>
            <p>Total Tests: {{ test_count }}</p>
        {% elif view == "suite" %}
            <h2>{{ suite_name }}</h2>
            {% if tests %}
                <table width="100%" border="0" cellspacing="0" cellpadding="2">
                    {% for test in tests %}
                        {% if loop.first %}
                            <tr>
                                <td width="4%">-</td>
                                <td width="96%">{{ test.name }}</td>
                            </tr>
                        {% else %}
                            <tr>
                                <td>-</td>
                                <td>{{ test.name }}</td>
                            </tr>
                        {% endif %}
                    {% endfor %}
                </table>
            {% endif %}
        {% endif %}
    </body>
</html>
""".strip()

        with tempfile.NamedTemporaryFile("w", suffix=".html", delete=False, encoding="utf-8") as tf:
                tf.write(template_content)
                template_file = tf.name

        runner = CliRunner()
        result = runner.invoke(main, ["-f", "pdf", "--custom-pdf-template", template_file, robot, output])

        os.unlink(template_file)

        assert result.exit_code == 0
        assert "Generated Test Documentation PDF" in result.output
        assert os.path.exists(output)

        with open(output, "rb") as file:
                header = file.read(4)
        assert header == b"%PDF"
