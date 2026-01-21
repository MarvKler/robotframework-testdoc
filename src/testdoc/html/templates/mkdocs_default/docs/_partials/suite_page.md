{% if suite.is_folder %}

# 📁 {{ suite.name }}

!!! tip ""
    📊 **{{ suite.total_tests }} Test Cases in all Sub-Suites**

**Available Sub-Suites:**
```
{{ suite.sub_suites | map(attribute='name') | join('\n') }}
```

{% else %}

# {{ suite.name }}

!!! tip ""
    📊 **{{ suite.num_tests }} Test Cases in Current Suite**

!!! info "📝 Suite Documentation"
    {% for doc_line in (suite.doc or ["No documentation available for this suite"]) %}
    {{ doc_line }}
    {% endfor %}

{% if suite.user_keywords %}
🔑 **Available Suite User Keyword:**
```robotframework
*** Keywords ***
{{ suite.user_keywords | join('\n') }}
```
{% endif %}

## Test Case Overview

{% if suite.tests | length > 0 %}
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

!!! abstract "**Documentation:**"
    {% for doc_line in (test.doc or ["No documentation available for this test case"]) %}
    {{ doc_line }}
    {% endfor %}

!!! tip "Tags"
    {% if test.tags and ((test.tags | default([])) | length > 0) %}
    {{ (test.tags or []) | join(', ') }}
    {% endif %}

{% if test.keywords %}
**Test Case Body:**
```robotframework
*** Test Cases ***
{{ test.name }}
    {{ test.keywords | join('\n    ') }}
```
{% endif %}

{% endfor %}

{% endif %}

{% endif %}
