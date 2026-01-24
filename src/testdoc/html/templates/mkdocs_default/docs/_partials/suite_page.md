{% if suite.is_folder %}

# 📁 {{ suite.name }}

!!! tip ""
    📊 **{{ suite.total_tests }} Test Cases in all Sub-Suites**

{% if suite.source != "" %}
!!! note "GitLab Source Code"
    You can directly visit the suite directory: [Navigate to GitLab]({{ suite.source }})
{% endif %}

## **Available Sub-Suites**
```
{{ suite.sub_suites | map(attribute='name') | join('\n') }}
```

{% else %}

# {{ suite.name }}

!!! tip ""
    📊 **{{ suite.num_tests }} Test Cases in Current Suite**

!!! abstract "📝 Suite Documentation"
    {% for doc_line in (suite.doc or ["No documentation available for this suite"]) %}
    {{ doc_line }}
    {% endfor %}

{% if suite.source != "" %}
!!! note "GitLab Source Code"
    You can directly visit the suite source code: [Navigate to GitLab]({{ suite.source }})
{% endif %}


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
    {% for tag in (test.tags or ["No tags defined for this test"]) %}
    ``{{ tag }}``
    {% endfor %}

{% if test.source != "" %}
!!! note "GitLab Source Code"
    You can directly visit the test source code: [Navigate to GitLab]({{ test.source }})
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
