{% if suite.is_folder %}

# :material-folder: {{ suite.name }}

!!! tip ""
    📊 **{{ suite.test_count }} Test Cases in all Sub-Suites**

{% if suite.custom_source != "" %}
!!! note "GitLab Source Code"
    You can directly visit the suite directory: [Navigate to Source]({{ suite.custom_source }})
{% endif %}

## **Available Sub-Suites**
```
{{ suite.suites | map(attribute='name') | join('\n') }}
```

{% else %}

# :simple-robotframework: {{ suite.name }}

!!! tip ""
    📊 **{{ suite.test_count }} Test Cases in Current Suite**

{% if suite.custom_source %}
!!! note "GitLab Source Code"
    You can directly visit the suite source code: [Navigate to Source]({{ suite.custom_source }})
{% endif %}

{% if suite.doc %}
!!! abstract "Suite Documentation"
{{ suite.doc | indent(4, true) }}
{% endif %}

## Test Case Overview

{% if suite.tests %}
Below you can find a list of all test cases defined in this suite:
```robotframework
*** Settings ***
Name    {{ suite.name }}

*** Test Cases ***
{{ suite.tests | map(attribute='name') | join('\n') }}
```

{% if suite.user_keywords %}
## Suite User Keywords
Below you can find a list of all user keywords defined in this suite.

!!! tip "Suite User Keyword - Defintion"
    User keywords defined in a suite are most probably a kind of "helper" keywords required in any test case of the suite.
```robotframework
*** Keywords ***
{{ suite.user_keywords | join('\n') }}
```
{% endif %}


## Test Case Details

{% for test in (suite.tests or []) %}

---

### {{ test.name }}

{% if test.doc %}
!!! abstract "**Documentation:**"
{{ test.doc | indent(4, true) }}
{% endif %}

!!! tip "Tags"
    {% for tag in (test.tags or ["No tags defined for this test"]) -%}
    ``{{ tag }}``{% if not loop.last %} {% endif %}
    {%- endfor %}

{% if test.custom_source %}
!!! note "GitLab Source Code"
    You can directly visit the test source code: [Navigate to Source]({{ test.custom_source }})
{% endif %}


{% if test.body %}
**Test Case Body:**
??? note "Test Case Body"
    ```robotframework
    *** Test Cases ***
    {{ test.name }}
        {{ test.body | format_test_body | join('\n        ') }}
    ```
{% endif %}

{% endfor %}

{% endif %}

{% endif %}
