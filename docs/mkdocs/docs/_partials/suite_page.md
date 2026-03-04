{% if suite.is_folder %}

# :material-folder: {{ suite.name }}

!!! tip ""
    📊 **{{ suite.test_count }} Test Cases in all Sub-Suites**

{% if suite.custom_source != "" %}
!!! note "GitLab Source Code"
    You can directly visit the suite directory: [Navigate to GitLab]({{ suite.custom_source }})
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
    You can directly visit the suite source code: [Navigate to GitLab]({{ suite.custom_source }})
{% endif %}

{% if suite.doc %}
!!! abstract "Suite Documentation"
{{ suite.doc | indent(4, true) }}
{% endif %}

{% if suite.user_keywords %}
🔑 **Available Suite User Keyword:**
```robotframework
*** Keywords ***
{{ suite.user_keywords | join('\n') }}
```
{% endif %}

## Test Case Overview

{% if suite.tests %}
**All Test Cases in Suite:**
```robotframework
*** Settings ***
Name    {{ suite.name }}

*** Test Cases ***
{{ suite.tests | map(attribute='name') | join('\n') }}
```


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
    You can directly visit the test source code: [Navigate to GitLab]({{ test.custom_source }})
{% endif %}


{% if test.body %}
**Test Case Body:**
```robotframework
*** Test Cases ***
{{ test.name }}
    {{ test.body | format_test_body | join('\n    ') }}
```
{% endif %}

{% endfor %}

{% endif %}

{% endif %}
