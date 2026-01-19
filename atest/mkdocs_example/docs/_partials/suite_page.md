# {{ suite.name }}

## Suite Documentation
{% if not suite.is_folder %}
{% for doc_line in (suite.doc or ["No documentation available for this suite"]) %}
{{ doc_line }}
{% endfor %}
{% else %}
Suite is a directory - no documentation available
{% endif %}

{% if suite.user_keywords %}
## Suite User Keywords
```robotframework
*** Keywords ***
{{ suite.user_keywords | join('\n') }}
```
{% endif %}

## Test Cases

Count of Tests: {{ suite.total_tests }}

{% if suite.tests | length > 0 %}
```robotframework
*** Test Cases ***
{{ suite.tests | map(attribute='name') | join('\n') }}
```
{% endif %}



{% if suite.tests | length > 0 %}
{% for test in (suite.tests or []) %}
## {{ test.name }}

### Documentation

{% for doc_line in (test.doc or ["No documentation available for this test case"]) %}
{{ doc_line }}
{% endfor %}

{% if test.tags | length > 0 %}
### Tags
{{ (test.tags or []) | join(', ') }}
{% endif %}


### Test Case Body
{% if test.keywords %}
```robotframework
*** Test Cases ***
{{ test.name }}
    {{ test.keywords | join('\n    ') }}
```
{% endif %}

{% endfor %}
{% endif %}
