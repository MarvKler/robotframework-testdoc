*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    ../../resources/libraries/fastjson.py
Resource    common.robot

*** Variables ***
# *** API SUITE VARIABLES ***
${api_timeout}    15
${max_retries}    0
${default_password}    change123
${default_secure_password}    qweRTY_123456
${default_allow_redirects}     true
${default_auth}    ${NONE}
&{default_headers}
${api_session}    api

# *** default headers example: applied to all requests if not empty ***
# &{default_headers}    Store=DE    Accept-Language=EN

# *** API VARIABLES ***
${glue_env}
${bapi_env}
${sapi_env}

*** Keywords ***
API_suite_setup
    [Documentation]    Basic steps before each suite. Should be sed with the ``Suite Setup`` tag.
    ...
    ...    *Example:*
    ...
    ...    ``Suite Setup       API_suite_setup``
    Common_suite_setup    skip_if_already_executed=${True}

Overwrite api variables
    Log Many    @{Test Tags}
    VAR    ${current_url}    ${EMPTY}
    FOR  ${tag}  IN  @{Test Tags}
        Set Test Variable    ${tag}
        IF    '${tag}' == 'dms-on'    CONTINUE
        IF    '${glue_env}' == '${EMPTY}'
            IF    '${tag}' == 'glue'
                IF    ${dms}
                    Set Suite Variable    ${current_url}    ${glue_dms_url}
                ELSE
                    Set Suite Variable    ${current_url}    ${glue_url}
                END
                Set Suite Variable    ${tag}    glue
            END
        ELSE
            IF    '${tag}' == 'glue'
                Set Suite Variable    ${current_url}    ${glue_env}
                Set Suite Variable    ${tag}    glue
            END
        END
        IF    '${bapi_env}' == '${EMPTY}'
            IF    '${tag}'=='bapi'
                IF    ${dms}
                    Set Suite Variable    ${current_url}    ${bapi_dms_url}
                ELSE
                    Set Suite Variable    ${current_url}    ${bapi_url}
                END
                Set Suite Variable    ${tag}    bapi
            END
        ELSE
            IF    '${tag}' == 'bapi'
                Set Suite Variable    ${current_url}    ${bapi_env}
                Set Suite Variable    ${tag}    bapi
            END
        END
        IF    '${sapi_env}' == '${EMPTY}'
            IF    '${tag}' == 'sapi'
                IF    ${dms}
                    Set Suite Variable    ${current_url}    ${sapi_dms_url}
                ELSE
                    Set Suite Variable    ${current_url}    ${sapi_url}
                END
                Set Suite Variable    ${tag}    sapi
            END
        ELSE
            IF    '${tag}' == 'sapi'
                Set Suite Variable    ${current_url}    ${sapi_env}
                Set Suite Variable    ${tag}    sapi
            END
        END
        ${current_url_last_character}=    Get Regexp Matches    ${current_url}    .$    flags=IGNORECASE
        ${current_url_last_character}=    Convert To String    ${current_url_last_character}
        ${current_url_last_character}=    Replace String    ${current_url_last_character}    '   ${EMPTY}
        ${current_url_last_character}=    Replace String    ${current_url_last_character}    [   ${EMPTY}
        ${current_url_last_character}=    Replace String    ${current_url_last_character}    ]   ${EMPTY}
        IF    '${current_url_last_character}' == '/'
            ${current_url}=    Replace String Using Regexp    ${current_url}    .$    ${EMPTY}
            Set Suite Variable    ${current_url}
        END
    END
    Create Session    ${api_session}    ${current_url}    timeout=${api_timeout}    max_retries=${max_retries}

Setup_api_host_if_undefined
    ${api_host_is_undefined}=    Run Keyword And Return Status    Variable Should Not Exist    ${current_url}
    IF    ${api_host_is_undefined}    Overwrite api variables

API_test_setup
    [Documentation]   This setup should be called in Settings of every test suite. It defines which url variable will be used in the test suite.
    ...
    ...    At the moment it is used to define if the test is for GLUE (``glue`` tag) or BAPI (``bapi`` tag) by checking for the default or test tag.
    ...    If the tag is there it replaces the domein URL with bapi url.
    ...
    ...    To set a tag to a test case use ``[Tags]`` under the test name.
    ...    To set Test Tags for the whole test suite (.robotframework file), use ``Test Tags`` keyword in the suite Settings.
    ...
    ...    *Notes*:
    ...
    ...    1. If a test suite has no Test Setup and/or tests in the suite have no bapi/glue tags, GLUE URL will be used by default as the current URL.
    ...
    ...    2. Do not set both tags to a suite, each suite/robot file should have tests only for GLUE or only for BAPI.
    ...
    ...    3. You can set other tags for tests and suites with no restrictions, they will be ignored in suite setup.
    ...
    ...    *Example:*
    ...
    ...    ``*** Settings ***``
    ...
    ...    ``Test Setup    TestSetup``
    ...
    ...    ``Test Tags    bapi``
    Should Test Run
    Overwrite api variables
    I set default Headers:    &{default_headers}

I set Headers:
    [Documentation]    Keyword sets any number of headers for the further endpoint calls.
    ...    Headers can have any name and any value, they are set as test variable - which means they can be used throughtout one test if set once.
    ...    This keyword can be used to add access token to the next endpoint calls or to set header for the guest customer, etc.
    ...
    ...    It accepts a list of pairs haader-name=header-value as an argument. The list items should be separated by 4 spaces.
    ...
    ...    *Example:*
    ...
    ...    ``I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}``

    [Arguments]    &{headers}
    Set To Dictionary    ${headers}    &{headers}    &{default_headers}
    Set Test Variable    &{headers}
    RETURN    &{headers}

Reset API Headers
    [Documentation]    This keyword resets all previously set headers to their default values.
    ...    It can be used to ensure that no unwanted headers persist between API requests.
    ...
    ...    *Example:*
    ...
    ...    ``I Reset Headers``

    # Clear previously set headers
    ${headers}=    Create Dictionary

    # Reapply default headers if needed
    Set To Dictionary    ${headers}    &{default_headers}
    Log    Default headers have been restored.

    # Re-register headers as a test variable
    Set Test Variable    &{headers}
    RETURN    &{headers}

I set default Headers:
    [Arguments]    &{headers}
    Set Suite Variable    &{headers}
    RETURN    &{headers}

I get access token for the customer:
    [Documentation]    This is a helper keyword which helps get access token for future use in the headers of the following requests.
    ...
    ...    It gets the token for the specified customer ``{email}`` and saves it into the test variable ``{token}``, which can then be used within the scope of the test where this keyword was called.
    ...    After the test ends the ``{token}`` variable is cleared. This keyword needs to be called separately for each test where you expect to need a customer token.
    ...
    ...    The password in this case is not passed to the keyword and the default password stored in ``{default_password}`` will be used when getting token.
    ...
    ...    *Example:*
    ...
    ...    ``I get access token for the customer:    ${yves_user.email}``
    [Arguments]    ${email}    ${password}=${default_password}
    Setup_api_host_if_undefined
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${data}=    Convert String To JSON    {"data":{"type":"access-tokens","attributes":{"username":"${email}","password":"${password}"}}}
    ${response}=    IF    ${headers_not_empty}    POST On Session    ${api_session}    ${current_url}/access-tokens    json=${data}    headers=${headers}    verify=${verify_ssl}
    ...    ELSE    POST On Session    ${api_session}    ${current_url}/access-tokens    json=${data}    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204
        TRY
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${token}=    Set Variable    Bearer ${response.json()['data']['attributes']['accessToken']}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${token}    ${token}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${expected_self_link}    ${current_url}/access-tokens
    RETURN    ${token}

I get access token for the company user by uuid:
    [Documentation]    This is a helper keyword which helps get company user access token by uuid for future use in the headers of the following requests.
    ...
    ...    It gets the token for the specified company user by ``{company_user_uuid}`` and saves it into the test variable ``{token}``, which can then be used within the scope of the test where this keyword was called.
    ...    After the test ends the ``{token}`` variable is cleared. This keyword needs to be called separately for each test where you expect to need a company user token.
    ...
    ...    *Example:*
    ...
    ...    ``I get access token for the company user by uuid:    ${company_user_uuid}``
    [Arguments]    ${company_user_uuid}
    Setup_api_host_if_undefined
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${data}=    Convert String To JSON    {"data":{"type":"company-user-access-tokens","attributes":{"idCompanyUser":"${company_user_uuid}"}}}
    ${response}=    IF    ${headers_not_empty}    POST On Session    ${api_session}    ${current_url}/company-user-access-tokens    json=${data}    headers=${headers}    verify=${verify_ssl}
    ...    ELSE    POST On Session    ${api_session}    ${current_url}/company-user-access-tokens    json=${data}    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204
        TRY
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${token}=    Set Variable    Bearer ${response.json()['data']['attributes']['accessToken']}
    ${response_headers}=    Set Variable    ${response.headers}
    Set Test Variable    ${token}    ${token}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${expected_self_link}    ${current_url}/company-user-access-tokens
    RETURN    ${token}

I send a POST request:
    [Documentation]    This keyword is used to make POST requests. It accepts the endpoint *without the domain* and the body in JOSN.
    ...    Variables can and should be used in the endpoint url and in the body JSON.
    ...
    ...    If the endpoint needs to have any headers (e.g. token for authorisation), ``I set Headers`` keyword should be called before this keyword to set the headers beforehand.
    ...
    ...    After this keyword is called, response body, selflink, response status and headers are recorded into the test variables which have the scope of the current test and can then be used by other keywords to get and compare data.
    ...
    ...    *Example:*
    ...
    ...    ``I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}``
    [Arguments]   ${path}    ${json}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    Setup_api_host_if_undefined
    ${data}=    Convert String To JSON    ${json}
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${headers_not_empty}    POST On Session    ${api_session}    ${current_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ...    ELSE    POST On Session    ${api_session}    ${current_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=ANY    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204
        TRY
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${response_headers}=    Set Variable    ${response.headers}
    IF    ${response.status_code} == 204
        ${response_body}=    Set Variable    ${EMPTY}
    END
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${current_url}${path}
    RETURN    ${response_body}

I send a POST request with data:
    [Documentation]    This keyword is used to make POST requests with a plain text data. It accepts the endpoint *without the domain* and the body in plain text.
    ...    Variables can and should be used in the endpoint url and in the body.
    ...
    ...    If the endpoint needs to have any headers (e.g. token for authorisation), ``I set Headers`` keyword should be called before this keyword to set the headers beforehand.
    ...
    ...    After this keyword is called, response body, selflink, response status and headers are recorded into the test variables which have the scope of the current test and can then be used by other keywords to get and compare data.
    ...
    ...    *Example:*
    ...
    ...    ``I send a POST request:    /agent-access-tokens    This is plain text body``
    [Arguments]   ${path}    ${data}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    Setup_api_host_if_undefined
    ${data}=    Evaluate    ${data}
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${headers_not_empty}    POST On Session    ${api_session}    ${current_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ...    ELSE    POST On Session    ${api_session}    ${current_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204
        TRY
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${response_headers}=    Set Variable    ${response.headers}
    IF    ${response.status_code} == 204
        ${response_body}=    Set Variable    ${EMPTY}
    END
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${current_url}${path}
    RETURN    ${response_body}

I send a PUT request:
    [Documentation]    This keyword is used to make PUT requests. It accepts the endpoint *without the domain* and the body in JSON.
    ...    Variables can and should be used in the endpoint url and in the body JSON.
    ...
    ...    If the endpoint needs to have any headers (e.g. token for authorisation), ``I set Headers`` keyword should be called before this keyword to set the headers beforehand.
    ...
    ...    After this keyword is called, response body, selflink, response status and headers are recorded into the test variables which have the scope of the current test and can then be used by other keywords to get and compare data.
    ...
    ...    *Example:*
    ...
    ...    ``I send a PUT request:    /some-endpoint/${someID}    {"data": {"type": "some-type"}}``
    [Arguments]   ${path}    ${json}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    Setup_api_host_if_undefined
    ${data}=    Convert String To JSON    ${json}
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${headers_not_empty}    PUT On Session    ${api_session}    ${current_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ...    ELSE    PUT On Session    ${api_session}    ${current_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204
        TRY
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${response_headers}=    Set Variable    ${response.headers}
    IF    ${response.status_code} == 204
        ${response_body}=    Set Variable    ${EMPTY}
    END
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${current_url}${path}
    RETURN    ${response_body}

I send a PUT request with data:
    [Documentation]    This keyword is used to make PUT requests with a plain text data. It accepts the endpoint *without the domain* and the body in plain text.
    ...    Variables can and should be used in the endpoint url and in the body plain text.
    ...
    ...    If the endpoint needs to have any headers (e.g. token for authorisation), ``I set Headers`` keyword should be called before this keyword to set the headers beforehand.
    ...
    ...    After this keyword is called, response body, selflink, response status and headers are recorded into the test variables which have the scope of the current test and can then be used by other keywords to get and compare data.
    ...
    ...    *Example:*
    ...
    ...    ``I send a PUT request:    /some-endpoint/${someID}    This is plain text body``
    [Arguments]   ${path}    ${data}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    Setup_api_host_if_undefined
    ${data}=    Evaluate    ${data}
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${headers_not_empty}    PUT On Session    ${api_session}    ${current_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ...    ELSE    PUT On Session    ${api_session}    ${current_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204
        TRY
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${response_headers}=    Set Variable    ${response.headers}
    IF    ${response.status_code} == 204
        ${response_body}=    Set Variable    ${EMPTY}
    END
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${current_url}${path}
    RETURN    ${response_body}

I send a PATCH request:
    [Documentation]    This keyword is used to make PATCH requests. It accepts the endpoint *without the domain* and the body in JOSN.
    ...    Variables can and should be used in the endpoint url and in the body JSON.
    ...
    ...    If the endpoint needs to have any headers (e.g. token for authorisation), ``I set Headers`` keyword should be called before this keyword to set the headers beforehand.
    ...    If this keyword was already called within this test case (e.g. before POST request), there is no need to call it again.
    ...
    ...    Usually for PATCH requests you need to know and use the ID (UID) if the resource you need to update.
    ...    To  get the ID you need forst to make a POST or GET request to get the data and then call ``Save value to a variable:`` endpoint to save the ID to a test variable to be able to use it in the PATCH request.
    ...
    ...    After this keyword is called, response body, selflink, response status and headers are recorded into the test variables which have the scope of the current test and can then be used by other keywords to get and compare data.
    ...
    ...    *Example:*
    ...
    ...    ``I send a PATCH request:    /carts/${cartUID}/items/${itemUID}    {"data": {"type": "items","attributes": {"quantity": 5}}}``

    [Arguments]   ${path}    ${json}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    Setup_api_host_if_undefined
    ${data}=    Convert String To JSON    ${json}
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${headers_not_empty}    PATCH On Session    ${api_session}    ${current_url}${path}    json=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ...    ELSE    PATCH On Session    ${api_session}    ${current_url}${path}    json=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204
        TRY
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${response_headers}=    Set Variable    ${response.headers}
    IF    ${response.status_code} == 204
        ${response_body}=    Set Variable    ${EMPTY}
    END
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${current_url}${path}
    RETURN    ${response_body}

I send a PATCH request with data:
    [Documentation]    This keyword is used to make PATCH requests with a plain text data. It accepts the endpoint *without the domain* and the body in plain text.
    ...    Variables can and should be used in the endpoint url and in the body JSON.
    ...
    ...    If the endpoint needs to have any headers (e.g. token for authorisation), ``I set Headers`` keyword should be called before this keyword to set the headers beforehand.
    ...    If this keyword was already called within this test case (e.g. before POST request), there is no need to call it again.
    ...
    ...    Usually for PATCH requests you need to know and use the ID (UID) if the resource you need to update.
    ...    To  get the ID you need forst to make a POST or GET request to get the data and then call ``Save value to a variable:`` endpoint to save the ID to a test variable to be able to use it in the PATCH request.
    ...
    ...    After this keyword is called, response body, selflink, response status and headers are recorded into the test variables which have the scope of the current test and can then be used by other keywords to get and compare data.
    ...
    ...    *Example:*
    ...
    ...    At the moment Spryker does not offer this type of calls, so example is theoretical.
    ...
    ...    ``I send a PATCH request:    /some-endpoint/${someID}   This is plain text body``
    [Arguments]   ${path}    ${data}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    Setup_api_host_if_undefined
    ${data}=    Evaluate    ${data}
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${headers_not_empty}   PATCH On Session    ${api_session}    ${current_url}${path}    data=${data}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ...    ELSE    PATCH On Session    ${api_session}    ${current_url}${path}    data=${data}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204
        TRY
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${response_headers}=    Set Variable    ${response.headers}
    IF    ${response.status_code} == 204
        ${response_body}=    Set Variable    ${EMPTY}
    END
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${current_url}${path}
    RETURN    ${response_body}

I send a GET request:
    [Documentation]    This keyword is used to make GET requests. It accepts the endpoint *without the domain*.
    ...    Variables can and should be used in the endpoint url.
    ...
    ...    If the endpoint needs to have any headers (e.g. token for authorisation), ``I set Headers`` keyword should be called before this keyword to set the headers beforehand.
    ...    If this keyword was already called within this test case (e.g. before POST request), there is no need to call it again.
    ...
    ...    Sometimes for GET requests you need to know and use the ID (UID) if the resource you need to view.
    ...    To  get the ID you need forst to make a POST or GET request to get the data and then call ``Save value to a variable:`` endpoint to save the ID to a test variable to be able to use it in the GET request.
    ...
    ...    After this keyword is called, response body, selflink, response status and headers are recorded into the test variables which have the scope of the current test and can then be used by other keywords to get and compare data.
    ...
    ...    *Example:*
    ...
    ...    ``I send a GET request:    /abstract-products/${abstract_sku}``
    [Arguments]   ${path}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    Setup_api_host_if_undefined
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${headers_not_empty}    GET On Session    ${api_session}    ${current_url}${path}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ...    ELSE    GET On Session    ${api_session}    ${current_url}${path}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204
        TRY
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    ${response_headers}=    Set Variable    ${response.headers}
    IF    ${response.status_code} == 204
        ${response_body}=    Set Variable    ${EMPTY}
    END
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${expected_self_link}    ${current_url}${path}
    RETURN    ${response_body}

I send a DELETE request:
    [Documentation]    This keyword is used to make DELETE requests. It accepts the endpoint *without the domain*.
    ...    Variables can and should be used in the endpoint url.
    ...
    ...    This endpoint usually needs to have any headers (e.g. token for authorisation), ``I set Headers`` keyword should be called before this keyword to set the headers beforehand.
    ...    If this keyword was already called within this test case (e.g. before POST request), there is no need to call it again.
    ...
    ...    For DELETE requests you need to know and use the ID (UID) if the resource you need to delete.
    ...    To  get the ID you need forst to make a POST or GET request to get the data and then call ``Save value to a variable:`` endpoint to save the ID to a test variable to be able to use it in the GET request.
    ...
    ...    After this keyword is called, response body, selflink, response status and headers are recorded into the test variables which have the scope of the current test and can then be used by other keywords to get and compare data.
    ...    Body is recorded only in case there was an error, if DELETE endpoint worked without errors, reqponse body is empty and so not recorded.
    ...
    ...    *Example:*
    ...
    ...    For example below you will need to set headers and get address UID and customer reference recorded into a variables before you can call the DELETE request.
    ...
    ...    ``I send a DELETE request:    /customers/${customer_reference}/addresses/addressUID``
    [Arguments]   ${path}    ${timeout}=${api_timeout}    ${allow_redirects}=${default_allow_redirects}    ${auth}=${default_auth}    ${expected_status}=ANY
    Setup_api_host_if_undefined
    ${headers_not_empty}    Run Keyword and return status     Should not be empty    ${headers}
    ${response}=    IF    ${headers_not_empty}    DELETE On Session    ${api_session}   ${current_url}${path}    headers=${headers}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ...    ELSE    DELETE On Session    ${api_session}    ${current_url}${path}    timeout=${timeout}    allow_redirects=${allow_redirects}    auth=${auth}    expected_status=${expected_status}    verify=${verify_ssl}
    ${response_headers}=    Set Variable    ${response.headers}
    ${response.status_code}=    Set Variable    ${response.status_code}
    IF    ${response.status_code} != 204
        TRY
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    IF    ${response.status_code} == 204
        ${response_body}=    Set Variable    ${EMPTY}
    END
    Set Test Variable    ${response}    ${response}
    Set Test Variable    ${response_headers}    ${response_headers}
    Set Test Variable    ${response_body}    ${response_body}
    Set Test Variable    ${expected_self_link}    ${current_url}${path}
    RETURN    ${response_body}

Response reason should be:
    [Documentation]    This keyword checks that response reason saved  in ``{response}`` test variable matches the reason passed as an argument.
    ...
    ...    *Example:*
    ...
    ...    ``Response reason should be:    Created``
    [Arguments]    ${reason}
    Should Be Equal As Strings    ${reason}    ${response.reason}    Expected 'reason': '${reason}' does not equal actual 'reason': '${response.reason}'

Response status code should be:
    [Documentation]    This keyword checks that response status code saved  in ``{response}`` test variable matches the status code passed as an argument.
    ...
    ...    *Example:*
    ...
    ...    ``Response status code should be:    201``
    [Arguments]    ${status_code}
    Should Be Equal As Strings    ${response.status_code}    ${status_code}    Expected 'status code': '${status_code}' does not equal actual 'status code': '${response.status_code}'.

Response body should contain:
    [Documentation]    This keyword checks that the response saved  in ``{response_body}`` test variable contains the string passed as an argument.
    ...
    ...    *Example:*
    ...
    ...    ``Response body should contain:    "localizedName": "Weight"``
    [Arguments]    ${value}
    ${response_body}=    Convert To String    ${response_body}
    ${response_body}=    Replace String    ${response_body}    '    "
    Should Contain    ${response_body}    ${value}    Response body does not contain expected: '${value}'.

Response body should not contain:
    [Documentation]    This keyword checks that the response saved  in ``{response_body}`` test variable does not contain the string passed as an argument.
    ...
    ...    *Example:*
    ...
    ...    ``Response body should not contain:    "localizedName": "Weight"``
    [Arguments]    ${value}
    ${response_body}=    Convert To String    ${response_body}
    ${response_body}=    Replace String    ${response_body}    '    "
    Should Not Contain    ${response_body}    ${value}    Response body contains not expected: '${value}'.

Response body parameter should be:
    [Documentation]    This keyword checks that the response saved  in ``{response_body}`` test variable contains the specified parameter ``{json_path}`` with the specified value ``{expected_value}``.
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should be:    [data][0][type]    abstract-product-availabilities``
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Should Be Equal    ${data}    ${expected_value}    Response data in: '${json_path}', does not equal expected: '${expected_value}', actual is: '${data}'.

Response body case-insensitive parameter should be:
    [Documentation]    This keyword checks that the response saved in ``{response_body}`` test variable contains the specified parameter ``{json_path}`` with the specified case-insensitive value ``{expected_value}``.
    ...
    ...    *Example:*
    ...
    ...    ``Response body case-insensitive parameter should be:    [data][0][type]    Abstract-Product-Availabilities``
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    ${data}=    Convert To Lower Case    ${data}
    ${expected_value}=    Convert To Lower Case    ${expected_value}
    Should Be Equal    ${data}    ${expected_value}    Response data in: '${json_path}', does not equal expected: '${expected_value}', actual is: '${data}'.

Perform arithmetical calculation with two arguments:
    [Documentation]    This keyword calculates ``{expected_value1}``, ``{expected_value2}`` and saves  in ``{variable_name}`` variable.
    ...
    ...    First you need to set variable name. You can use also existing variable name, in this case variable should be overwritten.
    ...    Set integer values for ${expected_value1} and ${expected_value2}, add supported math symbol {'+', '-', '*', '/'} for ``{math_symbol}``.
    ...
    ...    *Example:*
    ...
    ...    ``Perform arithmetical calculation with two arguments:    discount_total_sum    ${discount_total_sum}    +    ${discount.product_3.with_10%_discount}``
    [Arguments]    ${variable_name}    ${expected_value1}    ${math_symbol}    ${expected_value2}
    IF    '${math_symbol}' == '+'
        ${result}    Evaluate    ${expected_value1} + ${expected_value2}
    ELSE IF    '${math_symbol}' == '-'
        ${result}    Evaluate    ${expected_value1} - ${expected_value2}
    ELSE IF    '${math_symbol}' == '*'
        ${result}    Evaluate    ${expected_value1} * ${expected_value2}
    ELSE IF    '${math_symbol}' == '/'
        ${result}    Evaluate    ${expected_value1} / ${expected_value2}
    ELSE
        ${result}    Set Variable    None
    END
    ${result}=    Convert To String    ${result}
    Set Test Variable    ${${variable_name}}    ${result}
    RETURN    ${variable_name}

Response body parameter should be in:
    [Documentation]    This keyword checks that the response saved  in ``{response_body}`` test variable contains the specified parameter ``{json_path}`` with the value that matches one of the parameters ``{expected_value1}``, ``{expected_value2}``.
    ...
    ...    The minimal number of arguments are 2, maximum is 4
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should be in:    [data][attributes][allowInput]    true    false``
    [Arguments]    ${json_path}    ${expected_value1}    ${expected_value2}    ${expected_value3}=robotframework-dummy-value    ${expected_value4}=robotframework-dummy-value    ${expected_value5}=robotframework-dummy-value    ${expected_value6}=robotframework-dummy-value    ${expected_value7}=robotframework-dummy-value    ${expected_value8}=robotframework-dummy-value    ${expected_value9}=robotframework-dummy-value
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    TRY
        Should Contain Any   ${data}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ${expected_value5}    ${expected_value6}    ${expected_value7}    ${expected_value8}    ${expected_value9}      ignore_case=True
    EXCEPT
        Fail    Response data in: '${json_path}', does not contains any: '${expected_value1}', '${expected_value2}', '${expected_value3}', '${expected_value4}', '${expected_value5}', '${expected_value6}', '${expected_value7}', '${expected_value8}', '${expected_value9}', in '${data}'.
    END

Response body parameter with rounding should be:
    [Documentation]    This keyword checks that the response saved  in ``{response_body}`` test variable contains the specified parameter ``{json_path}`` that was rounded and can differ from the expected value by 1 more cent or 1 less cent.
    ...    It can be used if you need to check value with rounding for prices etg.
    ...
    ...    Range is calculated as
    ...
    ...    Minimal range: ``{expected_value}`` - ``1``
    ...    Maximum range: ``{expected_value}`` + ``1``
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter with rounding should be:    [data][attributes][discounts][0][amount]    ${discount.product_3.with_10%_discount}``
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    ${range_value_min}=    Evaluate    ${expected_value} - 1
    ${range_value_max}=    Evaluate    ${expected_value} + 1
    IF    ${data} >= ${range_value_min} and ${data} <= ${range_value_max}
        ${result}    Set Variable    True
    ELSE
        ${result}    Set Variable    False
    END
    Should Be Equal    ${result}    True    Actual ${data} is not in expected Range [${range_value_min}; ${range_value_max}], json_path: '${json_path}'

Response body parameter should be NOT in:
    [Documentation]    This keyword checks that the response saved  in ``{response_body}`` test variable contains the specified parameter ``{json_path}`` with the value that matches one of the parameters ``{expected_value1}``, ``{expected_value2}``.
    ...
    ...    The minimal number of arguments is 1, maximum is 4
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should be NOT in:    [data][attributes][allowInput]    None``
    [Arguments]    ${json_path}    ${expected_value1}    ${expected_value2}=robotframework-dummy-value    ${expected_value3}=robotframework-dummy-value    ${expected_value4}=robotframework-dummy-value
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    TRY
        Should NOT Contain Any   ${data}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ignore_case=True
    EXCEPT
        Fail    Response data in: '${json_path}', should not contain any: ${expected_value1}, ${expected_value2}, ${expected_value3}, ${expected_value4} in '${data}'.
    END

Response body parameter should NOT be:
    [Documentation]    This keyword checks that the response saved in ``{response_body}`` test variable contains the specified parameter ``{json_path}`` has a value that is DIFFERENT from the value passed as an argument ``{expected_value}``.
    ...
    ...    This keyword can be conveniently used when you need to make sure the parameter is not empty. To check for ``null`` value in robot Framework use ``None`` keyword as shown in the example below.
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should NOT be:    data.id    None``
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Should Not Be Empty    ${data}    '${data}' in '${json_path}' is empty but should not be.
    Should Not Be Equal    ${data}    ${expected_value}    '${data}' in '${json_path}' should be equal to '${expected_value}'.

Response body parameter should have datatype:
    [Documentation]    This keyword checks that the response saved  in ``{response_body}`` test variable contains the specified parameter ``{parameter}`` and that parameter has the specified data type ``{expected_data_type}``.
    ...
    ...    Some types that can be used are: ``int``, ``str``, ``list``. It uses a custom keyword ``Evaluate datatype of a variable:`` to evaluate the datatype.
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should have datatype:    [data][0][attributes][name]    str``
    ...    ``Response body parameter should have datatype:    [data][0][attributes][sort][sortParamNames]    list``
    [Arguments]    ${parameter}    ${expected_data_type}
    @{parameter}=    Get Value From Json    ${response_body}    ${parameter}
    ${actual_data_type}=    Evaluate datatype of a variable:    @{parameter}
    Should Be Equal    ${actual_data_type}    ${expected_data_type}    Parameter: '${parameter}' should be '${expected_data_type}' but got: '${actual_data_type}'.

Evaluate datatype of a variable:
    [Documentation]    This is a technical keyword that is used in ``Response body parameter should have datatype:`` and is used to evaluate the actual data type of a variable.
    ...
    ...        Example of assertions:
    ...
    ...    ``{is int}=      Evaluate     isinstance($variable, int) ``    will be True
    ...
    ...    ``{is string}=   Evaluate     isinstance($variable, str) ``    will be False
    [Arguments]    ${variable}
    ${data_type}=    Evaluate     type($variable).__name__
    RETURN    ${data_type}

Response header parameter should be:
    [Documentation]    This keyword checks that the response header saved previiously in ``{response_headers}`` test variable has the expected header with name ``{header_parameter}`` and this header has value ``{header_value}``
    ...
    ...    *Example:*
    ...
    ...    ``Response header parameter should be:    Content-Type    ${default_header_content_type}``
    [Arguments]    ${header_parameter}    ${header_value}
    ${actual_header_value}=    Get From Dictionary    ${response_headers}    ${header_parameter}
    Should Be Equal    ${actual_header_value}    ${header_value}    Header parameter: '${header_parameter}' should have value: '${header_value}' but got: '${actual_header_value}'.

Response header parameter should contain:
    [Documentation]    This keyword checks that the response header saved previiously in ``{response_headers}`` test variable has the expected header with name ``{header_parameter}`` and this header contains substring ``{header_value}``
    ...
    ...    *Example:*
    ...
    ...    ``Response header parameter should be:    Content-Type    ${default_header_content_type}``
    [Arguments]    ${header_parameter}    ${header_value}
    ${actual_header_value}=    Get From Dictionary    ${response_headers}    ${header_parameter}
    Should Contain    ${actual_header_value}    ${header_value}    Header parameter: '${header_parameter}' should contain value: '${header_value}' but got: '${actual_header_value}'.

Response body has correct self link
    [Documentation]    This keyword checks that the actual selflink retrieved from the test variable ``{response_body}`` matches the self link recorded into the ``{expected_self_link}`` test variable on endpoint call.
    ...
    ...     This keyword does not accept any arguments. Expected self link on the endpoint call as assembled from the domain and the endpoint passed to the request.
    ...
    ...    *NOTE:* this keyword checks the first link that is OUTSUDE of the ``data[]`` array in the response
    ${actual_self_link}=    Get Value From Json    ${response_body}    $.links.self    #Exampleof path: $..address.streetAddress
    ${actual_self_link}=    Convert To String    ${actual_self_link}
    ${actual_self_link}=    Replace String    ${actual_self_link}    [    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    ]    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    '    ${EMPTY}
    Should Be Equal    ${actual_self_link}    ${expected_self_link}    Expected self link: '${expected_self_link}' does not match actual link: '${actual_self_link}'.

Response body has correct self link internal
    [Documentation]    This keyword checks that the actual selflink retrieved from the test variable ``{response_body}`` matches the self link recorded into the ``{expected_self_link}`` test variable on endpoint call.
    ...
    ...     This keyword does not accept any arguments. Expected self link on the endpoint call as assembled from the domain and the endpoint passed to the request.
    ...
    ...    *NOTE:* this keyword checks the first link that is INSIDE of the ``data[]`` array in the response.
    ${actual_self_link}=    Get Value From Json    ${response_body}    [data][links][self]    #Exampleof path: $..address.streetAddress
    ${actual_self_link}=    Convert To String    ${actual_self_link}
    ${actual_self_link}=    Replace String    ${actual_self_link}    [    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    ]    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    '    ${EMPTY}
    Should Be Equal    ${actual_self_link}    ${expected_self_link}    Expected internal self link: '${expected_self_link}' does not match the actual link: '${actual_self_link}'.

Response body has correct self link for created entity:
    [Documentation]    This keyword checks that the actual selflink retrieved from the test variable ``{response_body}`` plus the UID of the entity that was created and matches the self link recorded into the ``{expected_self_link}`` test variable on endpoint call.
    ...
    ...     This keyword requires one argument which is the ending of the URL usually containing the UID of the created resource. Expected self link on the endpoint call as assembled from the domain, the endpoint passed to the request and the end of the URTL passed as the argument.
    ...
    ...    *NOTE:* this keyword checks the first link that is INSIDE of the ``data[]`` array in the response.
    ...
    ...    *Example:*
    ...
    ...    ``Response body has correct self link for created entity:    ${address_uid_1}``
    ...
    ...    ``Response body has correct self link for created entity:    687b806f-2fab-555f-90ae-e32d96b6aa71``
    ...
    ...    In the case above the self link for create cart would be ``glue.domain/carts/687b806f-2fab-555f-90ae-e32d96b6aa71``, ``{expected_self_link}`` would be ``glue.domain/carts/`` and the UID will come from the argument.
    [Arguments]    ${url}    #the ending of the url, usually the ID
    ${actual_self_link}=    Get Value From Json    ${response_body}    [data][links][self]    #Exampleof path: $..address.streetAddress
    ${actual_self_link}=    Convert To String    ${actual_self_link}
    ${actual_self_link}=    Replace String    ${actual_self_link}    [    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    ]    ${EMPTY}
    ${actual_self_link}=    Replace String    ${actual_self_link}    '    ${EMPTY}
    Should Be Equal    ${actual_self_link}    ${expected_self_link}/${url}    Expected self link for created entity: '${expected_self_link}/${url}' does not match actual self link for created entity: '${actual_self_link}'.

Response body parameter should not be EMPTY:
    [Documentation]    This keyword checks that the body parameter sent in ``{json_path}`` argument is not empty. If the parameter value is other that ``null`` the keyword will fail.
    ...
    ...    This keyword checks both that the parameter does not have null value or that it does not have an empty string value and makes sure that the pagameter actually exists.
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should not be EMPTY:    [data][attributes][description]``
    [Arguments]    ${json_path}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Should Not Be Empty    ${data}    '${json_path}' property value '${data}' is empty but shoud not be
    Should Not Be Equal    ${data}    None    '${json_path}' property value is '${data}' which is null, but it shoud be a non-null.

Response body parameter should be greater than:
    [Documentation]    This keyword checks that the body parameter sent in ``{json_path}`` argument is greater than a specific integer value ``{expected_value}``.
    ...    It can be used to check that the number of items in stock is more than the minimum, that the number of returned products or cms pages in search is more than the minimum.
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should be greater than:    [data][0][attributes][price]   100``
    ...
    ...    ``Response body parameter should be greater than:    data[0].attributes.dateSchedule[0].date    ${today}``
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    ${result}=    Evaluate    float('${data}') > float('${expected_value}')
    ${result}=    Convert To String    ${result}
    Should Be Equal    ${result}    True    Actual '${data}' is not greater than expected '${expected_value}' in '${json_path}'.

Response body parameter should be less than:
    [Documentation]    This keyword checks that the body parameter sent in ``{json_path}`` argument is less than a specific integer value ``{expected_value}``.
    ...    It can be used to check that the default price of the product is less than the original price, that the date of the order is before the certain date.
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should be less than:    [data][0][attributes][price]   100``
    ...
    ...    ``Response body parameter should be less than:    data[0].attributes.dateSchedule[0].date    2019-01-01``
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    ${result}=    Evaluate    '${data}' < '${expected_value}'
    ${result}=    Convert To String    ${result}
    Should Be Equal    ${result}    True    Actual '${data}' is not less than expected '${expected_value}' in '${json_path}'.

Response should contain the array of a certain size:
    [Documentation]    This keyword checks that the body array sent in ``{json_path}`` argument contains the specific number of items ``{expected_size}``. The expected size should be an integer value.
    ...    It can be used to check how many products, addresses, etc. were returned, if you know the exact number of elements that should be returned.
    ...
    ...    *Example:*
    ...
    ...    ``Response should contain the array of a certain size:    [data][0][relationships][abstract-product-image-sets][data]    1``
    [Arguments]    ${json_path}    ${expected_size}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${list_length}=    Convert To String    ${list_length}
    Should Be Equal    ${list_length}    ${expected_size}    actual size '${list_length}' doesn't equal expected '${expected_size}' in '${json_path}'.

Response should contain the array of size in:
    [Documentation]    This keyword verifies that the array at the given JSON path has a length equal to one of the expected sizes provided.
    ...              It accepts one or more expected sizes as optional arguments.
    [Arguments]    ${json_path}    @{expected_sizes}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${actual_length}=    Get Length    @{data}
    ${actual_length}=    Convert To String    ${actual_length}
    Should Contain    ${expected_sizes}    ${actual_length}    msg=Actual size '${actual_length}' does not match any of the expected sizes '${expected_sizes}' in '${json_path}'.

Response should contain the array larger than a certain size:
    [Documentation]    This keyword checks that the body array sent in ``{json_path}`` argument contains the number of items that is more than ``{expected_size}``.
    ...    The expected size should be an integer value that is less than you expect elements. So if you expect an array to have at least 2 elements, the ``{expected_size}`` should be 1.
    ...
    ...    It can be used to check how many elements were returned, if you know the exact number of elements that should be returned, but know there should be at least 1 for example.
    ...
    ...    *Example:*
    ...
    ...    `` Response should contain the array larger than a certain size:    [data][relationships][category-nodes][data]    1``
    [Arguments]    ${json_path}    ${expected_size}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${list_length}=    Convert To Integer    ${list_length}
    ${result}=    Evaluate   ${list_length} > ${expected_size}
    ${result}=    Convert To String    ${result}
    Should Be Equal    ${result}    True    Actual array length is '${list_length}' and it is not greater than expected '${expected_size}' in '${json_path}'.

Response should contain the array larger or equal than a certain size:
    [Documentation]    This keyword checks that the body array sent in ``{json_path}`` argument contains the number of items that is more than ``{expected_size}`` or equals.
    ...    *Example:*
    ...
    ...    `` Response should contain the array larger or equal than a certain size:    Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][1][values]    ${default_qty.labels}+1``
    [Arguments]    ${json_path}    ${expected_size}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${list_length}=    Convert To Integer    ${list_length}
    ${expected_size}=    Evaluate    ${expected_size}
    ${expected_size}=    Convert To Integer    ${expected_size}
    ${result}=    Evaluate   ${list_length} >= ${expected_size}
    ${result}=    Convert To String    ${result}
    Should Be Equal    ${result}    True    Actual array length is '${list_length}' and it is not greater (or equal) than expected '${expected_size}' in '${json_path}'.

Response should contain the array less or equal than a certain size:
    [Documentation]    This keyword checks that the body array sent in ``{json_path}`` argument contains the number of items that is less than ``{expected_size}`` or equals.
    ...    *Example:*
    ...
    ...    `` Response should contain the array less or equal than a certain size:    [data][0][attributes][valueFacets][1][values]    ${default_qty.labels}``
    [Arguments]    ${json_path}    ${expected_size}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${list_length}=    Convert To Integer    ${list_length}
    ${expected_size}=    Evaluate    ${expected_size}
    ${expected_size}=    Convert To Integer    ${expected_size}
    ${result}=    Evaluate   ${list_length} <= ${expected_size}
    ${result}=    Convert To String    ${result}
    Should Be Equal    ${result}    True    Actual array length is '${list_length}' and it is not less (or equal) than expected '${expected_size}' in '${json_path}'.

Each array element of the array in response should contain a nested array larger than a certain size:
    [Documentation]    This keyword checks that each element in the array specified as ``{json_path}`` contains the `` ${nested_array}` with certain size greater than ``{expected_size}``.
    ...
    ...    If at least one array element has ``{nested_array} `` less than ``{expected_size}``, the keyword will fail.

    ...    *Example:*
    ...
    ...    `` Each array element of the array in response should contain a nested array larger than a certain size:    [data]    [attributes][stores]    0``
    [Arguments]    ${json_path}    ${nested_array}    ${expected_size}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${list_length}=    Get From List    @{data}    ${index}
    @{data}=    Get Value From Json    ${list_length}    ${nested_array}
    ${nested_array_list_length}=    Get Length    @{data}
    ${result}=    Evaluate   ${nested_array_list_length} > ${expected_size}
    ${result}=    Convert To String    ${result}
    Should Be Equal    ${result}    True    Actual nested array length is '${nested_array_list_length}' not greater than expected '${expected_size}'.
    END

Response should contain the array smaller than a certain size:
    [Documentation]    This keyword checks that the body array sent in ``{json_path}`` argument contains the number of items that is fewer than ``{expected_size}``.
    ...    The expected size should be an integer value that is less than you expect elements. So if you expect an array to have 0 or 1 elements, the ``{expected_size}`` should be 2.
    ...
    ...    It can be used to check how many elements were returned, if you know the exact number of elements that should be returned, but know there should be fewer, than the default value for example.
    ...    It is useful when you check search and know how many values are there if there is no filtering, but you also know that with filtering, there should be fewer values than without it.
    ...
    ...    *Example:*
    ...
    ...    ``Response should contain the array smaller than a certain size:    [data][0][attributes][valueFacets][1]    5``
    [Arguments]    ${json_path}    ${expected_size}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    ${list_length}=    Convert To Integer    ${list_length}
    ${result}=    Evaluate   ${list_length} < ${expected_size}
    ${result}=    Convert To String    ${result}
    Should Be Equal    ${result}    True    Actual array length is '${list_length}' and it is not smaller than expected '${expected_size}' in '${json_path}'.

Each array element of array in response should contain property:
    [Documentation]    This keyword checks whether the array ``{json_path}`` that is present in the ``{response_body}`` test variable contains a property with ``{expected_property}`` name in every of it's array elements.
    ...
    ...    It does not take into account the property value, just checks it is there for every element. If some of the elements have this property and others do not, the keyword will fail.
    ...
    ...    *Example:*
    ...
    ...   ``Each array element of array in response should contain property:    [data][0][attributes][prices][0][volumePrices]    quantity``
    ...
    ...    The example above checks if ALL prices returned in volumePrices array have quantity property, while quantity value can be any and even null.
    [Arguments]    ${json_path}    ${expected_property}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        List Should Contain Value    ${list_element}    ${expected_property}    msg=Array element '${list_element}' of array '${json_path}' does not contain property: '${expected_property}'.
    END

Each array element of array in response should contain value:
        [Documentation]    This keyword checks whether the array ``{json_path}`` that is present in the ``{response_body}`` test variable contains a value ``{expected_value}`` in every of it's array elements.
    ...
    ...    It does not take into account the property name, just checks if the value is there for every element. If some of the array elements have this value and others do not, the keyword will fail.
    ...
    ...    *Example:*
    ...
    ...   ``Each array element of array in response should contain value:    [data][0][attributes][prices]    ${currency.eur.code}``
    ...
    ...    The example above checks if ALL prices returned in volumePrices array have currency code, regardless of which property has this value.
    [Arguments]    ${json_path}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${sub_list_element}=    Create List    ${list_element}
        ${sub_list_element}=    Convert To String    ${sub_list_element}
        Should Contain    : ${sub_list_element}    ${expected_value}    msg=Array element:'${sub_list_element}' of array:'${json_path}' does not contain:'${expected_value}'.
    END

Each array element of array in response should contain a nested array of a certain size:
        [Documentation]    This keyword checks whether the array ``{parent_array}`` that is present in the ``{response_body}`` test variable contains an array ``{nested_array}`` in every of it's array elements and for every its occurrence that nested array has sixe ``{array_expected_size}``.
    ...
    ...    If the nested arrays are of different sizes, this keyword will fail.
    ...
    ...    *Example:*
    ...
    ...   ``Each array element of array in response should contain a nested array of a certain size:    [data]    [prices]    2``

    [Arguments]    ${parent_array}    ${nested_array}    ${array_expected_size}
    @{data}=    Get Value From Json    ${response_body}    ${parent_array}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        @{list_element2}=    Get Value From Json    ${list_element}    ${nested_array}
        ${list_length2}=    Get Length    @{list_element2}
        ${list_length2}=    Convert To String    ${list_length2}
        Should Be Equal    ${list_length2}    ${array_expected_size}    Actual nested array size:'${list_length2}' in '${nested_array}' does not match '${array_expected_size}'.
    END

Each array element of array in response should contain property with value:
    [Documentation]    This keyword checks that each element in the array specified as ``{json_path}`` contains the specified property ``{expected_property}`` with the specified value ``{expected_value}``.
    ...
    ...    If at least one array element has this property with another value, the keyword will fail.
    ...
    ...    *NOTE*: ``{expected_property}`` is a first level property in an array like this ``"data":[{"type": "some-type", "attributes": {"name": "some name", "sku": "1234"}},...] e.g. ``attributes``.
    ...    While second level property is `attributes.sku`` and it won't be identified with this keyword.
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should contain property with value:    [errors]    status    422``
    ...
    ...    ``Each array element of array in response should contain property with value:    [data][0][attributes][prices]    volumePrices    []``
    [Arguments]    ${json_path}    ${expected_property}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        Dictionary Should Contain Item    ${list_element}    ${expected_property}    ${expected_value}    msg='${json_path}' does not contain property: '${expected_property}' with value: '${expected_value}'.
    END

Each array element of array in response should contain property with value in:
    [Documentation]    This keyword checks that each array element contains the specified parameter ``{expected_property}`` with the value that matches one of the parameters ``{expected_value1}``, ``{expected_value2}``, etc..
    ...
    ...    The minimal number of arguments are 2, maximum is 4
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should contain property with value in:    [data]    [attributes][allowInput]    True    False``
    [Arguments]    ${json_path}    ${expected_property}    ${expected_value1}    ${expected_value2}    ${expected_value3}=robotframework-dummy-value    ${expected_value4}=robotframework-dummy-value

    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${list_element}=    Get Value From Json    ${list_element}    ${expected_property}
        ${list_element}=    Convert To String    ${list_element}
        ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
        TRY
            Should Contain Any   ${list_element}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ignore_case=True
        EXCEPT
            Fail    Array element: '${expected_property}' of array: '${json_path}' does not contain any: ${expected_value1}, ${expected_value2}, ${expected_value3}, ${expected_value4}
        END
    END

Each array in response should contain property with NOT EMPTY value:
    [Documentation]    This keyword checks that each element in the array specified as ``{json_path}`` contains the specified property ``{expected_property}`` with NOT EMPTY  value.
    ...
    ...    If at least one array element has this property with EMPTY value, the keyword will fail.

    ...    *Example:*
    ...
    ...    ``Each array element in response should contain property with NOT EMPTY value:    [data]    [attributes][name]``

    [Arguments]    ${json_path}    ${expected_property}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${list_element}=    Get Value From Json    ${list_element}    ${expected_property}
        ${list_element}=    Convert To String    ${list_element}
        ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
    Should Not Be Empty     ${list_element}    '${expected_property}' property value in json path '${json_path}' is empty but shoud Not Be EMPTY
    END

Each array in response should contain property with value NOT in:
    [Documentation]    This keyword checks that each array element contains the specified parameter ``{expected_property}`` with the value that does not match any of the parameters ``{expected_value1}``, ``{expected_value2}``, etc..
    ...
    ...    The minimal number of arguments is 1, maximum is 4
    ...
    ...    *Example:*
    ...
    ...    ``Each array element in response should contain property with value NOT in:    [data]    [attributes][isSuper]    None``
    [Arguments]    ${json_path}    ${expected_property}    ${expected_value1}    ${expected_value2}=robotframework-dummy-value    ${expected_value3}=robotframework-dummy-value    ${expected_value4}=robotframework-dummy-value

    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${list_element}=    Get Value From Json    ${list_element}    ${expected_property}
        ${list_element}=    Convert To String    ${list_element}
        ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
        TRY
            Should Not Contain Any   ${list_element}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ignore_case=True
        EXCEPT
            Fail    Element: '${expected_property}' of array: '${json_path}' contain any but SHOULD NOT: ${expected_value1}, ${expected_value2}, ${expected_value3}, ${expected_value4}
        END
    END

Each array element of array in response should contain property with value NOT in:
    [Documentation]    This keyword checks that each array element of array contains the specified parameter ``{expected_property}`` with the value that does not match any of the parameters ``{expected_value1}``, ``{expected_value2}``, etc..
    ...
    ...    The minimal number of arguments is 1, maximum is 4
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should contain property with value NOT in:    [data]    [attributes][isSuper]    None``
    [Arguments]    ${json_path}    ${expected_property}    ${expected_value1}    ${expected_value2}=robotframework-dummy-value    ${expected_value3}=robotframework-dummy-value    ${expected_value4}=robotframework-dummy-value

    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${list_element}=    Get Value From Json    ${list_element}    ${expected_property}
        ${list_element}=    Convert To String    ${list_element}
        ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
        TRY
            Should Not Contain Any   ${list_element}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ignore_case=True
        EXCEPT
            Fail    Array element: '${expected_property}' of array: '${json_path}' contain any but SHOULD NOT: ${expected_value1}, ${expected_value2}, ${expected_value3}, ${expected_value4}
        END
    END

Each array element of array in response should NOT be empty:
    [Documentation]    This keyword checks that each array element of array contains the specified parameter ``{expected_property}`` with the value that does not empty.
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should NOT be empty:    [data]    id``
    [Arguments]    ${json_path}    ${expected_property}

    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${list_element}=    Get Value From Json    ${list_element}    ${expected_property}
        ${list_element}=    Convert To String    ${list_element}
        ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
        TRY
            Should Not Be Empty    ${list_element}
        EXCEPT
            Fail    Array element: '${expected_property}' of array: '${json_path}' is empty but SHOULD NOT
        END
    END

Each array element of nested array should contain property with value in:
    [Documentation]    This keyword checks that each array element of ``{nested_array} that is inside the parent array ``{json_path}`` contains the specified parameter ``{expected_property}`` with the value that matches any of the parameters ``{expected_value1}``, ``{expected_value2}``, etc..
    ...
    ...    The minimal number of arguments is 1, maximum is 4
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of nested array should contain property with value in:    [data]    [attributes][localizedKeys]    translation    en_US    de_DE``
    [Arguments]    ${json_path}    ${nested_array}    ${expected_property}    ${expected_value1}    ${expected_value2}    ${expected_value3}=robotframework-dummy-value    ${expected_value4}=robotframework-dummy-value

    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length1}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index1}    IN RANGE    0    ${list_length1}
        ${list_element}=    Get From List    @{data}    ${index1}
        @{list_element2}=    Get Value From Json    ${list_element}    ${nested_array}
        ${list_length2}=    Get Length    @{list_element2}
        FOR    ${index2}    IN RANGE    0    ${list_length2}
            ${list_element}=    Get From List    @{list_element2}    ${index2}
            ${list_element}=    Get Value From Json    ${list_element}    ${expected_property}
            ${list_element}=    Convert To String    ${list_element}
            ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
            ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
            ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
            TRY
                Should Contain Any   ${list_element}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ignore_case=True
            EXCEPT
                Fail    Nested array:'${nested_array}' of array:'${json_path}' does NOT contain property:'${expected_property}' with value in: ${expected_value1}, ${expected_value2}, ${expected_value3}, ${expected_value4}
            END
        END
    END

Each array element of nested array should contain property with value NOT in:
    [Documentation]    This keyword checks that each array element of ``{nested_array} that is inside the parent array ``{json_path}`` contains the specified parameter ``{expected_property}`` with the value that does not match any of the parameters ``{expected_value1}``, ``{expected_value2}``, etc..
    ...
    ...    The minimal number of arguments is 1, maximum is 4
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of nested array should contain property with value NOT in:    [data]    [attributes][localizedKeys]    translation    None``
    [Arguments]    ${json_path}    ${nested_array}    ${expected_property}    ${expected_value1}    ${expected_value2}=robotframework-dummy-value   ${expected_value3}=robotframework-dummy-value    ${expected_value4}=robotframework-dummy-value

    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length1}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index1}    IN RANGE    0    ${list_length1}
        ${list_element}=    Get From List    @{data}    ${index1}
        @{list_element2}=    Get Value From Json    ${list_element}    ${nested_array}
        ${list_length2}=    Get Length    @{list_element2}
        FOR    ${index2}    IN RANGE    0    ${list_length2}
            ${list_element}=    Get From List    @{list_element2}    ${index2}
            ${list_element}=    Get Value From Json    ${list_element}    ${expected_property}
            ${list_element}=    Convert To String    ${list_element}
            ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
            ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
            ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
            TRY
                Should Not Contain Any   ${list_element}    ${expected_value1}    ${expected_value2}    ${expected_value3}    ${expected_value4}    ignore_case=True
            EXCEPT
                Fail    Nested array:'${nested_array}' of array:'${json_path}' contain property:'${expected_property}' with value in: '${expected_value1}', '${expected_value2}', '${expected_value3}', '${expected_value4}', BUT SHOULD NOT!
            END
        END
    END

Each array element of array in response should contain nested property with value:
    [Documentation]    This keyword checks that each element in the array specified as ``{json_path}`` contains the specified property ``{expected_nested_property}`` with the specified value ``{expected_value}``.
    ...
    ...    If at least one array element has this property with another value, the keyword will fail.
    ...
    ...    *NOTES*:
    ...
    ...    1. ``{expected_nested_property}`` is a second level property. In an array like this
    ...
    ...    ``{"data":[{"type": "some-type", "attributes": {"name": "some name", "sku": "1234"}},...]}``
    ...
    ...    it will be ``attributes.sku``.
    ...
    ...    2. The first level property in the above array is just ``attributes``, but it cannot be checked by this keyword.
    ...
    ...    3. Syntax for the second level property is ``[firstlevel][secondlevel]`` or ``firstlevel.secondlevel``.
    ...
    ...    4. This keyword supports any level of nesting.
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should contain nested property with value:    [data]    [attributes][sku]    "M1234"``
    ...
    ...    ``Each array element of array in response should contain nested property with value:    [data]    attributes.sku    "M1234"``
    ...
    ...    ``Each array element of array in response should contain nested property with value:    [data]    [relationships][concrete-products][data][0][type]    concrete-products``
    [Arguments]    ${json_path}    ${expected_nested_property}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${list_element}=    Get Value From Json    ${list_element}    $.${expected_nested_property}
        ${list_element}=    Convert To String    ${list_element}
        ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
        Should Be Equal    ${list_element}    ${expected_value}
    END

Each array element of array in response should contain nested property in range:
    [Documentation]    This keyword checks that each element in the array specified as ``{json_path}`` contains the specified property ``{expected_nested_property}`` that's in the range between ``{lower_value}`` and  ``{higher_value}``
    ...
    ...    If at least one array element has this property not in this range, the keyword will fail.
    ...
    ...    *NOTES*:
    ...
    ...    1. ``{expected_nested_property}`` is a second level property. In an array like this
    ...
    ...    ``{"data":[{"type": "some-type", "attributes": {"name": "some name", "sku": "1234"}},...]}``
    ...
    ...    it will be ``attributes.sku``.
    ...
    ...    2. The first level property in the above array is just ``attributes``, but it cannot be checked by this keyword.
    ...
    ...    3. Syntax for the second level property is ``[firstlevel][secondlevel]`` or ``firstlevel.secondlevel``.
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should contain nested property in range:    [data]    [attributes][sku]    0    10``
    ...
    ...    ``Each array element of array in response should contain nested property in range:    [data]    attributes.sku    20    100``
    ...
    ...    ``Each array element of array in response should contain nested property in range:    [data]    [relationships][concrete-products][data][0][price]    10     500``
    [Arguments]    ${json_path}    ${expected_nested_property}    ${lower_value}    ${higher_value}
    IF    ${lower_value} == ${higher_value}    Fail    Your higher and lower values cannot be the same.
    IF    ${lower_value} > ${higher_value}    Fail    Your lower value cannot be greater than the lower value.
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${list_element}=    Get Value From Json    ${list_element}    $.${expected_nested_property}
        ${list_element}=    Convert To String    ${list_element}
        ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
        IF    ${list_element} < ${lower_value}    Fail    Value ${list_element} is less than lower value ${lower_value}.
        IF    ${list_element} > ${higher_value}    Fail    Value ${list_element} is greater than higher value ${higher_value}.
    END

Each array element of array in response should be greater than:
    [Documentation]    This keyword checks that each element in the array specified as ``{json_path}`` contains the specified property ``{expected_nested_property}`` that's greater than ``{expected_value}``
    ...
    ...    If at least one array element has this property not greater than ``{expected_value}``, the keyword will fail.
    ...
    ...    *NOTES*:
    ...
    ...    1. ``{expected_nested_property}`` is a second level property. In an array like this
    ...
    ...    ``{"data":[{"type": "some-type", "attributes": {"name": "some name", "sku": "1234"}},...]}``
    ...
    ...    it will be ``attributes.sku``.
    ...
    ...    2. The first level property in the above array is just ``attributes``, but it cannot be checked by this keyword.
    ...
    ...    3. Syntax for the second level property is ``[firstlevel][secondlevel]`` or ``firstlevel.secondlevel``.
    ...
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should be greater than:    [data]    [attributes][price]    1000``
    ...
    ...    ``Each array element of array in response should be greater than:    [data]    attributes.price    2000``
    ...
    ...    ``Each array element of array in response should be greater than:    [data]    [relationships][concrete-products][data][0][price]     5000``
    [Arguments]    ${json_path}    ${expected_nested_property}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${list_element}=    Get Value From Json    ${list_element}    $.${expected_nested_property}
        ${list_element}=    Convert To String    ${list_element}
        ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
        ${result}=    Evaluate    '${list_element}' > '${expected_value}'
        ${result}=    Convert To String    ${result}
        Should Be Equal    ${result}    True    Actual ${list_element} is not greater than expected ${expected_value}
    END

Each array element of array in response should be less than:
    [Documentation]    This keyword checks that each element in the array specified as ``{json_path}`` contains the specified property ``{expected_nested_property}`` that's less than ``{expected_value}``
    ...
    ...    If at least one array element has this property not less than ``{expected_value}``, the keyword will fail.
    ...
    ...    *NOTES*:
    ...
    ...    1. ``{expected_nested_property}`` is a second level property. In an array like this
    ...
    ...    ``{"data":[{"type": "some-type", "attributes": {"name": "some name", "sku": "1234"}},...]}``
    ...
    ...    it will be ``attributes.sku``.
    ...
    ...    2. The first level property in the above array is just ``attributes``, but it cannot be checked by this keyword.
    ...
    ...    3. Syntax for the second level property is ``[firstlevel][secondlevel]`` or ``firstlevel.secondlevel``.
    ...
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should be less than:    [data]    [attributes][price]    1000``
    ...
    ...    ``Each array element of array in response should be less than:    [data]    attributes.price    2000``
    ...
    ...    ``Each array element of array in response should be less than:    [data]    [relationships][concrete-products][data][0][price]     5000``
    [Arguments]    ${json_path}    ${expected_nested_property}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${list_element}=    Get Value From Json    ${list_element}    $.${expected_nested_property}
        ${list_element}=    Convert To String    ${list_element}
        ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
        ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
        ${result}=    Evaluate    '${list_element}' < '${expected_value}'
        ${result}=    Convert To String    ${result}
        Should Be Equal    ${result}    True    Actual ${list_element} is not less than expected ${expected_value}
    END

Each array element of array in response should contain nested property with datatype:
    [Documentation]    This keyword checks that each element in the array specified as ``{json_path}`` contains the specified property ``{expected_nested_property}`` with the value of the specified data type ``{expected_type}``.
    ...
    ...    If at least one array element has this property with another value, the keyword will fail.
    ...
    ...    *NOTES*:
    ...
    ...    1. ``{expected_nested_property}`` is a second level property. In an array like this
    ...
    ...    ``{"data":[{"type": "some-type", "attributes": {"name": "some name", "sku": "1234"}},...]}``
    ...
    ...    it will be ``attributes.sku``.
    ...
    ...    2. The first level property in the above array is just ``attributes``, but it cannot be checked by this keyword.
    ...
    ...    3. Syntax for the second level property is ``[firstlevel][secondlevel]`` or ``firstlevel.secondlevel``.
    ...
    ...    4. This keyword supports any level of nesting.
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should contain nested property with datatype:    [data]    [attributes][sku]    str``
    ...
    ...    ``Each array element of array in response should contain nested property with datatype:    [data]    attributes.price    int``
    [Arguments]    ${json_path}    ${expected_nested_property}    ${expected_type}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        @{list_element}=    Get Value From Json    ${list_element}    $.${expected_nested_property}
        ${actual_data_type}=    Evaluate datatype of a variable:    @{list_element}
        Should Be Equal    ${actual_data_type}    ${expected_type}
    END

Each array element of array in response should contain nested property with datatype in:
    [Documentation]    This keyword checks that each element in the array specified as ``{json_path}`` contains the specified property ``{expected_nested_property}`` with the value of one of the specified data types ``{expected_type1}``, ``{expected_type1}``, etc..
    ...
    ...    This keyword requires 2 parameters and may optionally use up to 4 datatypes
    ...
    ...    *NOTES*:
    ...
    ...    1. ``{expected_nested_property}`` is a second level property. In an array like this
    ...
    ...    ``{"data":[{"type": "some-type", "attributes": {"name": "some name", "sku": "1234"}},...]}``
    ...
    ...    it will be ``attributes.sku``.
    ...
    ...    2. The first level property in the above array is just ``attributes``, but it cannot be checked by this keyword.
    ...
    ...    3. Syntax for the second level property is ``[firstlevel][secondlevel]`` or ``firstlevel.secondlevel``.
    ...
    ...    4. This keyword supports any level of nesting.
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should contain nested property with datatype in:    [data]    attributes.price    int    float``
    [Arguments]    ${json_path}    ${expected_nested_property}    ${expected_type1}    ${expected_type2}    ${expected_type3}=test    ${expected_type4}=test
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        @{list_element}=    Get Value From Json    ${list_element}    $.${expected_nested_property}
        ${actual_data_type}=    Evaluate datatype of a variable:    @{list_element}
        Should Contain Any    ${actual_data_type}    ${expected_type1}    ${expected_type2}    ${expected_type3}    ${expected_type4}
    END

Each array element of array in response should contain nested property:
    [Documentation]    This keyword checks that each element in the array specified as ``{json_path}`` contains the specified property ``{level1_property}``, that is not an array and contains a certain second level property ``{level2_property}``,.
    ...
    ...    *Example:*
    ...
    ...    ``Each array element of array in response should contain nested property:    [data]    [attributes]    sku``
    ...
    ...    The example above checks if inside [data] array there is property attributes and inside that there is sku property
    [Arguments]    ${json_path}    ${level1_property}    ${level2_property}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${list_element}=    Get Value From Json    ${list_element}    ${level1_property}
        ${list_element}=    Convert To String    ${list_element}
        Should Contain    ${list_element}    ${level2_property}
    END


Response should return error message:
    [Documentation]    This keyword checks if the ``{response_body}`` test variable that contains the response of the previous request contains the specific  ``{error_message}``.
    ...
    ...    Call only for negative tests where you expect an error. NOTE: it checks only the first error, if there are more than one, better use this keyword: ``Array in response should contain property with value``.
    ...
    ...    *Example:*
    ...
    ...    ``Response should return error message:    Can`t find abstract product image sets.``
    [Arguments]    ${error_message}
    FOR  ${tag}  IN  @{Test Tags}
        IF    '${tag}'=='bapi' or '${tag}'=='sapi'
            ${data}=    Get Value From Json    ${response_body}    [errors][0][message]
        END
        IF    '${tag}'=='glue'
            ${data}=    Get Value From Json    ${response_body}    [errors][0][detail]
        END
    END
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Should Be Equal    ${data}    ${error_message}    Actual '${data}' error reason doens't match expected '${error_message}'

Response should return error code:
    [Documentation]    This keyword checks if the ``{response_body}`` test variable that contains the response of the previous request contains the specific  ``{error_code}``.
    ...
    ...    Call only for negative tests where you expect an error. NOTE: it checks only the first error code in the array, if there are more than one error, better use this keyword: ``Array in response should contain property with value``.
    ...
    ...    *Example:*
    ...
    ...    ``Response should return error code:    204``
    [Arguments]    ${error_code}
    ${error_code}=    Convert To String    ${error_code}
    ${data}=    Get Value From Json    ${response_body}    [errors][0][code]
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Should Be Equal    ${data}    ${error_code}    Actual '${data}' response error code doesn't match expected '${error_code}'

Response should contain certain number of values:
    [Documentation]    This keyword checks if a certain response parameter ``{json_path} `` in the ``{response_body}`` test variable has the specified number ``{expected_count}`` of the specified values ``{expected_value}`` in it.
    ...
    ...    It can check that response contains 5 categories or 4 cms pages.
    ...
    ...    *Example:*
    ...
    ...    ``Response should contain certain number of values:    [data][attributes][nodes]    cms_page    4``
    [Arguments]    ${json_path}    ${expected_value}    ${expected_count}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    # ${log_list}=    Log List    @{data}
    ${list_as_string}=    Convert To String    @{data}
    ${count}=    Get Count    : ${list_as_string}    ${expected_value}
    ${count}=    Convert To String    ${count}
    Should Be Equal    ${count}    ${expected_count}    Actual count '${count}' of '${expected_value}' in '${json_path}' does not match '${expected_count}'

Response include should contain certain entity type:
    [Documentation]    This keyword checks that a certain entity with type ``{expected_value}`` is included into the ``[included]`` section of the ``{response_body}`` test variable.
    ...    It accepts the type of the included entity (usually can be found in [included][index][type]) and checks if such entity exists in the response at least once.
    ...
    ...    *Example:*
    ...
    ...    ``Response include should contain certain entity type:    concrete-products``
    [Arguments]    ${expected_value}    #this should be the 'type' of the included item, e.g. abstract-product-prices
    @{include}=    Get Value From Json    ${response_body}    [included]
    ${list_length}=    Get Length    @{include}
    # ${log_list}=    Log List    @{include}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${include_element}=    Get From List    @{include}    ${index}
        ${type}=    Get Value From Json    ${include_element}    [type]
        ${type}=    Convert To String    ${type}
        ${type}=    Replace String    ${type}    '   ${EMPTY}
        ${type}=    Replace String    ${type}    [   ${EMPTY}
        ${type}=    Replace String    ${type}    ]   ${EMPTY}
        ${result}=    Evaluate    '${type}' == '${expected_value}'
        IF    ${result}    Exit For Loop
    END
    Should Be Equal As Strings    ${result}    True    Include section '${expected_value}' was not found

Response include element has self link:
    [Documentation]    This keyword checks that the ``[included]`` section of the response contains a self link in the included element with ``{expected_value}`` type.
    ...
    ...     This keyword does accepts type of the included element as the parameter. If there is not include with this type or the include with this type does not have/has wrong selflink, the keyword will fail.
    ...
    ...    *Example:*
    ...
    ...    ``Response include element has self link:   concrete-products``
    [Arguments]    ${expected_value}    #this should be the 'type' of the included item, e.g. abstract-product-prices
    @{include}=    Get Value From Json    ${response_body}    [included]
    ${list_length}=    Get Length    @{include}
    # ${log_list}=    Log List    @{include}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${include_element}=    Get From List    @{include}    ${index}
        ${type}=    Get Value From Json    ${include_element}    [type]
        ${type}=    Convert To String    ${type}
        ${type}=    Replace String    ${type}    '   ${EMPTY}
        ${type}=    Replace String    ${type}    [   ${EMPTY}
        ${type}=    Replace String    ${type}    ]   ${EMPTY}
        ${result}=    Evaluate    '${type}' == '${expected_value}'
        ${link_found}=    IF    ${result}    Get Value From Json    ${include_element}    [links][self]
        IF    ${link_found}    Should Not Be Equal    ${link_found}    None    ${link_found} is  empty for ${expected_value} include section
        IF    ${result}    Exit For Loop
    END
    Should Be Equal As Strings    ${result}    True    Include section '${expected_value}' was not found

Save value to a variable:
    [Documentation]    This keyword saves any value located in a response parameter ``{json_path}`` to a test variable called ``{name}``.
    ...
    ...    It can be used to save a value returned by any request into a custom test variable.
    ...    This variable, once created, can be used during the cpecific test where this keyword is used and can be re-used by the keywords that follow this keyword in the test.
    ...    It will not be visible to other tests.
    ...
    ...    *Examples:*
    ...
    ...    ``Save value to a variable:    [data][id]    cart_uid``
    ...
    ...    The example above should be called after POST request for cart creation. It gets cart ID from the ``{response_body}`` test vatialbe and saves it into ``{cart_uid}`` test variable whcih can then be used in other requests, e.g. in a checkout request.
    [Arguments]    ${json_path}    ${name}
    ${var_value}=    Get Value From Json    ${response_body}    ${json_path}
    ${var_value}=    Convert To String    ${var_value}
    ${var_value}=    Replace String    ${var_value}    '   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    [   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    ]   ${EMPTY}
    Set Test Variable    ${${name}}    ${var_value}
    RETURN    ${name}

Save Header value to a variable:
    [Documentation]    This keyword saves any value located in a response Header parameter ``{header_parameter}`` to a test variable called ``{name}``.
    ...
    ...    It can be used to save a value returned by any request into a custom test variable.
    ...    This variable, once created, can be used during the cpecific test where this keyword is used and can be re-used by the keywords that follow this keyword in the test.
    ...    It will not be visible to other tests.
    ...
    ...    *Examples:*
    ...
    ...    ``Save Header value to a variable:    ETag    header_tag``
    ...
    ...    The example above should be called after POST request for cart creation. It gets ETag from the ``{response_headers}`` test vatialbe and saves it into ``{header_tag}`` test variable which can then be used in other requests, e.g. in a PATCH request.
    [Arguments]    ${header_parameter}    ${name}
    ${actual_header_value}=    Get From Dictionary    ${response_headers}    ${header_parameter}
    Set Test Variable    ${${name}}    ${actual_header_value}
    RETURN    ${name}

Response body parameter should contain:
    [Documentation]    This keyword checks that response parameter with name ``{json_path}`` contains the specified substing ``{expected_value}``.
    ...    It can check that a long value has the required substing without needing to know the whole value. It is a partial patch check.
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should contain:    [data][attributes][superAttributes]    ${abstract_sku}``
    ...
    ...    The example above checks that ``superAttributes`` parameter contains the sku of the concrete product.
    ...    In fact this is abstract product request and this array returns the list of concrete products that are variants of this abstract.
    ...    Since in Spryker often concrete SKU includes abstract sku, this checks that the list contains abstract sku.
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Should Contain   ${data}    ${expected_value}    Body parameter:'${json_path}' does not contain '${expected_value}'

Response body parameter should start with:
    [Documentation]    This keyword checks that response parameter with name ``{json_path}`` starts with the specified substing ``{expected_value}``.
    ...
    ...    *Example:*
    ...
    ...    ``Response body parameter should start with:    [data][attributes][name]    Comp``
    ...
    ...    The example above checks that ``name`` parameter starts with 'comp', e.g. as in Computer.
    [Arguments]    ${json_path}    ${expected_value}
    ${data}=    Get Value From Json    ${response_body}    ${json_path}
    ${data}=    Convert To String    ${data}
    ${data}=    Replace String    ${data}    '   ${EMPTY}
    ${data}=    Replace String    ${data}    [   ${EMPTY}
    ${data}=    Replace String    ${data}    ]   ${EMPTY}
    Should Start With   ${data}    ${expected_value}    msg=Body parameter:'${json_path}' does not start with:'${expected_value}'

Array in response should contain property with value:
    [Documentation]    This keyword checks is the specified array (usually error array) ``{json_path} `` contains the specified property name ``{expected_property}`` with the specified value ``{expected_value}``.
    ...
    ...    This keyword can be used in negative tests where you expect more than one error to be returned by the request. But it can also be used for checking that property-value combination exists in an array element of the array.
    ...
    ...    *Example:*
    ...
    ...    ``Array in response should contain property with value:    [errors]    detail    iso2Code => This field is missing.``
    [Arguments]    ${json_path}    ${expected_property}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${value}=    Get Value From Json    ${list_element}    ${expected_property}
        ${value}=    Convert To String    ${value}
        ${value}=    Replace String    ${value}    '   ${EMPTY}
        ${value}=    Replace String    ${value}    [   ${EMPTY}
        ${value}=    Replace String    ${value}    ]   ${EMPTY}
        ${result}=    Evaluate    '${value}' == '${expected_value}'
        IF    ${result}    Exit For Loop
    END
    Should Be Equal As Strings    ${result}    True    Property:'${expected_property}' with value '${expected_value}' was not found in the array:'${json_path}'

Cleanup existing customer addresses:
    [Documentation]    This keyword deletes any and all addresses customer with the specified customer reference has.
    ...
    ...    Before using this method you should get customer token and set it into the headers with the help of ``I get access token for the customer:`` and ``I set Headers:``
    ...
    ...    *Example:*
    ...
    ...    ``Cleanup existing customer addresses:    ${yves_user.reference}``
    [Arguments]    ${customer_reference}
    Setup_api_host_if_undefined
    ${response}=    GET On Session    ${api_session}    ${current_url}/customers/${customer_reference}/addresses    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=200    verify=${verify_ssl}
    IF    ${response.status_code} != 204
        TRY
            ${response_body}=    Set Variable    ${response.json()}
        EXCEPT
            ${content_type}=    Get From Dictionary    ${response.headers}    content-type
            Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
        END
    END
    IF    ${response.status_code} == 204
        ${response_body}=    Set Variable    ${EMPTY}
    END
    Set Variable    ${response_body}    ${response_body}
    Set Variable    ${response}    ${response}
    Should Be Equal As Strings    ${response.status_code}    200    Could not get customer addresses
    @{data}=    Get Value From Json    ${response_body}    [data]
    ${list_length}=    Get Length    @{data}
    ${list_length}=    Convert To Integer    ${list_length}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${address_uid}=    Get Value From Json    ${list_element}    [id]
        ${address_uid}=    Convert To String    ${address_uid}
        ${address_uid}=    Replace String    ${address_uid}    '   ${EMPTY}
        ${address_uid}=    Replace String    ${address_uid}    [   ${EMPTY}
        ${address_uid}=    Replace String    ${address_uid}    ]   ${EMPTY}
        ${response_delete}=    DELETE On Session    ${api_session}    ${current_url}/customers/${customer_reference}/addresses/${address_uid}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204    verify=${verify_ssl}
        ${response.status_code}=    Set Variable    ${response_delete.status_code}
        IF    ${response.status_code} != 204
            TRY
                ${response_body}=    Set Variable    ${response.json()}
            EXCEPT
                ${content_type}=    Get From Dictionary    ${response.headers}    content-type
                Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
            END
        END
        Set Variable    ${response_delete}    ${response_delete}
        Should Be Equal As Strings    ${response_delete.status_code}    204    Could not delete a customer address
    END

Find or create customer cart
    [Documentation]    This keyword creates or retrieves cart (in gross price mode and with eur currency) for the current customer token. This keyword sets ``{cart_id} `` variable
        ...                and it can be re-used by the keywords that follow this keyword in the test
        ...
        ...     This keyword does not accept any arguments. Makes GET request in order to fetch cart for the customer or creates it otherwise.
        ...
        Setup_api_host_if_undefined
        ${response}=    GET On Session    ${api_session}    ${current_url}/carts    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=200    verify=${verify_ssl}
        ${response.status_code}=    Set Variable    ${response.status_code}
        IF    ${response.status_code} != 204
            TRY
                ${response_body}=    Set Variable    ${response.json()}
            EXCEPT
                ${content_type}=    Get From Dictionary    ${response.headers}    content-type
                Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
            END
        END
        IF    ${response.status_code} == 204
            ${response_body}=    Set Variable    ${EMPTY}
        END
        ${response_headers}=    Set Variable    ${response.headers}
        Set Test Variable    ${response_headers}    ${response_headers}
        @{data}=    Get Value From Json    ${response_body}    [data]
        ${cart_id}=    Get Value From Json    ${response_body}    [data][0][id]
        ${hasCart}    Run Keyword and return status     Should not be empty    ${cart_id}
        IF    ${hasCart}
            ${carts_number}=    Get Length    @{data}
            FOR    ${index}    IN RANGE    0    ${carts_number}
                    ${cart}=    Get From List    @{data}    ${index}
                    ${cart_id}=    Get Value From Json    ${cart}    [id]
                    ${cart_id}=    Convert To String    ${cart_id}
                    ${cart_id}=    Replace String    ${cart_id}    '   ${EMPTY}
                    ${cart_id}=    Replace String    ${cart_id}    [   ${EMPTY}
                    ${cart_id}=    Replace String    ${cart_id}    ]   ${EMPTY}
                    ${cart_mode}=    Get Value From Json    ${cart}    [attributes][priceMode]
                    ${cart_mode}=    Convert To String    ${cart_mode}
                    ${cart_mode}=    Replace String    ${cart_mode}    '   ${EMPTY}
                    ${cart_mode}=    Replace String    ${cart_mode}    [   ${EMPTY}
                    ${cart_mode}=    Replace String    ${cart_mode}    ]   ${EMPTY}
                    ${cart_currency}=    Get Value From Json    ${cart}    [attributes][currency]
                    ${cart_currency}=    Convert To String    ${cart_currency}
                    ${cart_currency}=    Replace String    ${cart_currency}    '   ${EMPTY}
                    ${cart_currency}=    Replace String    ${cart_currency}    [   ${EMPTY}
                    ${cart_currency}=    Replace String    ${cart_currency}    ]   ${EMPTY}
                    ${expected_cart_found}=    Run Keyword And Return Status    Should Be True    '${cart_mode}' == 'GROSS_MODE' and '${cart_currency}' == 'EUR'
                    IF    ${expected_cart_found} == 1
                        Set Test Variable    ${cart_id}    ${cart_id}
                        BREAK
                    END
                    IF    '${env}' in ['api_b2c','api_mp_b2c']
                        Set Test Variable    ${cart_id}    ${cart_id}
                        BREAK
                    END
                    IF    ${index} < ${carts_number}-1 and ${expected_cart_found} == 0
                        Continue For Loop
                    ELSE
                        I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "dummyCart${random}"}}}
                        Save value to a variable:    [data][id]    cart_id
                    END
            END
        ELSE
            I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "dummyCart${random}"}}}
            Save value to a variable:    [data][id]    cart_id
        END

Create empty customer cart:
    [Documentation]    This keyword creates cart for the current customer token. This keyword sets ``{cart_id} `` variable
        ...                and it can be re-used by the keywords that follow this keyword in the test.
        ...
        ...    Note: work only for registered customers. For guest users use ``Create a guest cart:``
        ...
        ...    *Example:*
        ...
        ...    ``Create empty customer cart:    ${mode.gross}    ${currency.eur.code}    ${store.de}    cart_rules``
        ...
        [Arguments]    ${price_mode}    ${currency_code}    ${store_code}    ${cart_name}
        I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${price_mode}","currency": "${currency_code}","store": "${store_code}","name": "${cart_name}-${random}"}}}
        Save value to a variable:    [data][id]    cart_id

Get ETag header value from cart
    [Documentation]    This keyword first retrieves cart for the current customer token.
        ...   and then It gets the Etag header value and saves it into the test variable ``{Etag}``, which can then be used within the scope of the test where this keyword was called.
        ...
        ...    and it can be re-used by the keywords that follow this keyword in the test
        ...    This keyword does not accept any arguments. This keyword is used for removing unused/unwanted (ex. W/"") characters from ETag header value.
        ${response}=    I send a GET request:    /carts
        ${Etag}=    Get Value From Json   ${response_headers}    [ETag]
        ${Etag}=    Convert To String    ${Etag}
        ${Etag}=    Replace String    ${Etag}    '   ${EMPTY}
        ${Etag}=    Replace String    ${Etag}    [   ${EMPTY}
        ${Etag}=    Replace String    ${Etag}    ]   ${EMPTY}
        ${Etag}=    Replace String    ${Etag}    W   ${EMPTY}
        ${Etag}=    Replace String    ${Etag}    /   ${EMPTY}
        ${Etag}=    Replace String    ${Etag}    "   ${EMPTY}
        Set Test Variable    ${Etag}
        RETURN    ${Etag}

Create a guest cart:
    [Documentation]    This keyword creates guest cart and sets ``{x_anonymous_customer_unique_id}`` that specify guest reference
        ...             and ``{guest_cart_id}`` that specify guest cart, variables
        ...             can be re-used by the keywords that follow this keyword in the test
        ...
        ...     This keyword does not accept any arguments. Makes POST request in order to create cart for the guest.
        ...    *Example:*
        ...
        ...    ``Create guest cart: ${random}    ${concrete_product_with_concrete_product_alternative_sku}    1``
        [Arguments]    ${x_anonymous_customer_unique_id}    ${product_sku}    ${product_quantity}
        Set Test Variable    ${x_anonymous_customer_unique_id}    ${x_anonymous_customer_unique_id}
        I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}    Content-Type=${default_header_content_type}
        ${response}=    I send a POST request:    /guest-cart-items    {"data": {"type": "guest-cart-items","attributes": {"sku": "${product_sku}","quantity": ${product_quantity}}}}
        Save value to a variable:    [data][id]    guest_cart_id
        Log    x_anonymous_customer_unique_id:${x_anonymous_customer_unique_id} guest_cart_id:${guest_cart_id}

Cleanup all items in the cart:
    [Documentation]    This keyword deletes any and all items in the given cart uid.
        ...
        ...    Before using this method you should get customer token and set it into the headers with the help of ``I get access token for the customer:`` and ``I set Headers:``
        ...
        ...    *Example:*
        ...
        ...    ``Cleanup items in the cart:    ${cart_id}``
        [Arguments]    ${cart_id}
        Setup_api_host_if_undefined
        ${response}=    GET On Session    ${api_session}    ${current_url}/carts/${cart_id}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}  params=include=items,bundle-items     expected_status=200    verify=${verify_ssl}
        ${response.status_code}=    Set Variable    ${response.status_code}
        IF    ${response.status_code} != 204
            TRY
                ${response_body}=    Set Variable    ${response.json()}
            EXCEPT
                ${content_type}=    Get From Dictionary    ${response.headers}    content-type
                Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
            END
        END
        IF    ${response.status_code} == 204
            ${response_body}=    Set Variable    ${EMPTY}
        END
        @{included}=    Get Value From Json    ${response_body}    [included]
        ${list_not_empty}=    Get length    ${included}
        IF    ${list_not_empty} > 0
            ${list_length}=    Get length    @{included}
            FOR    ${index}    IN RANGE    0    ${list_length}
                    ${list_element}=    Get From List    @{included}    ${index}
                    ${cart_item_uid}=    Get Value From Json    ${list_element}    [attributes][groupKey]
                    ${cart_item_sku}=    Get Value From Json    ${list_element}    [attributes][sku]
                    ${cart_item_uid}=    Convert To String    ${cart_item_uid}
                    ${cart_item_uid}=    Replace String    ${cart_item_uid}    '   ${EMPTY}
                    ${cart_item_uid}=    Replace String    ${cart_item_uid}    [   ${EMPTY}
                    ${cart_item_uid}=    Replace String    ${cart_item_uid}    ]   ${EMPTY}
                    ${cart_item_sku}=    Convert To String    ${cart_item_sku}
                    ${cart_item_sku}=    Replace String    ${cart_item_sku}    '   ${EMPTY}
                    ${cart_item_sku}=    Replace String    ${cart_item_sku}    [   ${EMPTY}
                    ${cart_item_sku}=    Replace String    ${cart_item_sku}    ]   ${EMPTY}
                    TRY
                        ${response_delete}=    DELETE On Session    ${api_session}    ${current_url}/carts/${cart_id}/items/${cart_item_uid}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204    verify=${verify_ssl}
                    EXCEPT
                        ${response_delete}=    DELETE On Session    ${api_session}    ${current_url}/carts/${cart_id}/items/${cart_item_sku}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204    verify=${verify_ssl}
                    END
            END
        END

Cleanup all customer carts
    [Documentation]    This keyword deletes all customer carts
        ...
        ...    Before using this method you should get customer token and set it into the headers with the help of ``I get access token for the customer:`` and ``I set Headers:``
        ...    This keyword does not accept any arguments.
        ...
        ...    *Example:*
        ...
        ...    ``Cleanup all customer carts``
        IF    '${env}' not in ['api_b2c','api_mp_b2c']
            I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "dummyCart-${{random.randint(0, 100)}}${random}"}}}
            Save value to a variable:    [data][id]    cart_id
        END
        Setup_api_host_if_undefined
        ${response}=    GET On Session    ${api_session}    ${current_url}/carts    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}  params=include=items,bundle-items     expected_status=200    verify=${verify_ssl}
        ${response.status_code}=    Set Variable    ${response.status_code}
        IF    ${response.status_code} != 204
            TRY
                ${response_body}=    Set Variable    ${response.json()}
            EXCEPT
                ${content_type}=    Get From Dictionary    ${response.headers}    content-type
                Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
            END
        END
        IF    ${response.status_code} == 204
            ${response_body}=    Set Variable    ${EMPTY}
        END
        @{data}=    Get Value From Json    ${response_body}    [data]
        ${list_not_empty}=    Get length    ${data}
        IF    ${list_not_empty} > 0
            ${list_length}=    Get Length    @{data}
            FOR    ${index}    IN RANGE    0    ${list_length}-1
                    ${list_element}=    Get From List    @{data}    ${index}
                    ${cart_uuid}=    Get Value From Json    ${list_element}    [id]
                    ${cart_uuid}=    Convert To String    ${cart_uuid}
                    ${cart_uuid}=    Replace String    ${cart_uuid}    '   ${EMPTY}
                    ${cart_uuid}=    Replace String    ${cart_uuid}    [   ${EMPTY}
                    ${cart_uuid}=    Replace String    ${cart_uuid}    ]   ${EMPTY}
                    IF    '${env}' not in ['api_b2c','api_mp_b2c']
                        IF    '${cart_uuid}' == '${cart_id}'
                            Continue For Loop
                        ELSE
                            ${response_delete}=    DELETE On Session    ${api_session}    ${current_url}/carts/${cart_uuid}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204    verify=${verify_ssl}
                        END
                    ELSE
                        ${response_delete}=    DELETE On Session    ${api_session}    ${current_url}/carts/${cart_uuid}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204    verify=${verify_ssl}
                    END
            END
        END

Cleanup all items in the guest cart:
    [Documentation]    This keyword deletes any and all items in the given GUEST cart uid.
        ...
        ...    Before using this method you should set any value as X-Anonymous-Customer-Unique-Id into the headers with the help of ``I set Headers:``
        ...
        ...    *Example:*
        ...
        ...    ``Cleanup all items in the guest cart:    ${cart_id}``
        [Arguments]    ${cart_id}
        Setup_api_host_if_undefined
        ${response}=    GET On Session    ${api_session}    ${current_url}/guest-carts/${cart_id}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}  params=include=guest-cart-items,bundle-items    expected_status=200    verify=${verify_ssl}
        ${response.status_code}=    Set Variable    ${response.status_code}
        IF    ${response.status_code} != 204
            TRY
                ${response_body}=    Set Variable    ${response.json()}
            EXCEPT
                ${content_type}=    Get From Dictionary    ${response.headers}    content-type
                Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
            END
        END
        IF    ${response.status_code} == 204
            ${response_body}=    Set Variable    ${EMPTY}
        END
        @{included}=    Get Value From Json    ${response_body}    [included]
        ${list_not_empty}=    Get length    ${included}
        IF    ${list_not_empty} > 0
            ${list_length}=    Get length    @{included}
            FOR    ${index}    IN RANGE    0    ${list_length}
                    ${list_element}=    Get From List    @{included}    ${index}
                    ${cart_item_uid}=    Get Value From Json    ${list_element}    [id]
                    ${cart_item_uid}=    Convert To String    ${cart_item_uid}
                    ${cart_item_uid}=    Replace String    ${cart_item_uid}    '   ${EMPTY}
                    ${cart_item_uid}=    Replace String    ${cart_item_uid}    [   ${EMPTY}
                    ${cart_item_uid}=    Replace String    ${cart_item_uid}    ]   ${EMPTY}
                    ${response_delete}=    DELETE On Session    ${api_session}    ${current_url}/guest-carts/${cart_id}/guest-cart-items/${cart_item_uid}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204    verify=${verify_ssl}
            END
        END
Cleanup all availability notifications:
    [Documentation]    This keyword deletes any and all availability notifications related to the given customer reference.
        ...
        ...    Before using this method you should get customer token and set it into the headers with the help of ``I get access token for the customer:`` and ``I set Headers:``
        ...
        ...    *Example:*
        ...
        ...    ``Cleanup all availability notifications in the guest cart:    ${yves_user.reference}``
        [Arguments]    ${yves_user.reference}
        Setup_api_host_if_undefined
        ${response}=    GET On Session    ${api_session}    ${current_url}/customers/${yves_user.reference}/availability-notifications    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}   expected_status=200    verify=${verify_ssl}
        ${response.status_code}=    Set Variable    ${response.status_code}
        IF    ${response.status_code} != 204
            TRY
                ${response_body}=    Set Variable    ${response.json()}
            EXCEPT
                ${content_type}=    Get From Dictionary    ${response.headers}    content-type
                Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
            END
        END
        IF    ${response.status_code} == 204
            ${response_body}=    Set Variable    ${EMPTY}
        END
        @{data}=    Get Value From Json    ${response_body}    [data]
        ${list_not_empty}=    Get length    ${data}
        IF    ${list_not_empty} > 0
            ${list_length}=    Get Length    @{data}
            ${list_length}=    Convert To Integer    ${list_length}
            # ${log_list}=    Log List    @{data}
            FOR    ${index}    IN RANGE    0    ${list_length}
                    ${list_element}=    Get From List    @{data}    ${index}
                    ${availability_notification_id}=    Get Value From Json    ${list_element}    [id]
                    ${availability_notification_id}=    Convert To String    ${availability_notification_id}
                    ${availability_notification_id}=    Replace String    ${availability_notification_id}    '   ${EMPTY}
                    ${availability_notification_id}=    Replace String    ${availability_notification_id}    [   ${EMPTY}
                    ${availability_notification_id}=    Replace String    ${availability_notification_id}    ]   ${EMPTY}
                    ${response_delete}=    DELETE On Session    ${api_session}    ${current_url}/availability-notifications/${availability_notification_id}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204    verify=${verify_ssl}
            END
        END

Get the first company user id and its' customer email
    [Documentation]    This keyword sends the GET request to the ``/company-users?include=customers`` endpoint and returns first available company user id and its' customer email in
    ...    ``{companyUserId}``  and  ``{companyUserEmail}`` variables.
    ...    If the fist company user is anne.boleyn@spryker.com - the next one will be taken and Anna is a 'BoB' user
    ...
    I send a GET request:    /company-users?include=customers
    Save value to a variable:    [data][0][id]    companyUserId
    Save value to a variable:    [included][0][attributes][email]    companyUserEmail
    IF    '${companyUserEmail}' == 'anne.boleyn@spryker.com'
        Save value to a variable:    [included][1][attributes][email]    companyUserEmail
        Save value to a variable:    [data][1][id]    companyUserId
    END

Array element should contain nested array at least once:
    [Documentation]    This keyword checks whether the array ``{parent_array}`` that is present in the ``{response_body}`` test variable contains an array ``{expected_nested_array}`` at least once.
    ...
    ...    *Example:*
    ...
    ...   ``Array element should contain nested array at least once:    [data]    [relationships]``
    ...
    [Arguments]    ${parent_array}    ${expected_nested_array}
    @{data}=    Get Value From Json    ${response_body}    ${parent_array}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    [   ${EMPTY}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    ]   ${EMPTY}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    '   ${EMPTY}
    ${expected_nested_array}=    Create List    ${expected_nested_array}
    FOR    ${index}    IN RANGE    0    ${list_length}
        @{list_element}=    Get From List    @{data}    ${index}
        ${result}=    Run Keyword And Ignore Error    List Should Contain Sub List    ${list_element}    ${expected_nested_array}
        IF    'PASS' in $result    Exit For Loop
        IF    ${index} == ${list_length}-1
            Fail    expected '${expected_nested_array}' array is not present in '@{data}'
        END
        IF    'FAIL' in $result    Continue For Loop
    END

Array element should contain property with value at least once:
    [Documentation]    This keyword checks that element in the array specified as ``{json_path}`` contains the specified property ``{expected_property}`` with the specified value ``{expected_value}`` at least once.
    ...
    ...    *Example:*
    ...
    ...    ``And Array element should contain property with value at least once:    [data][0][attributes][categoryTreeFilter]    docCount    ${${category_lvl2.qty}}``
    ...
    [Arguments]    ${json_path}    ${expected_property}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${result}=    Run Keyword And Ignore Error    Dictionary Should Contain Item    ${list_element}    ${expected_property}    ${expected_value}
        IF    'PASS' in $result    Exit For Loop
        IF    ${index} == ${list_length}-1
            Fail    expected '${expected_property}' with value '${expected_value}' is not present in '{data}' but should
        END
        IF    'FAIL' in $result    Continue For Loop
    END

Array element should contain property or array value at least once:
    [Documentation]    Verifies that at least one element in the array at JSON path ``{json_path}`` has the property ``{expected_property}`` whose value is either:
    ...    - a scalar equal (as string) to ``{expected_value}``, or
    ...    - a list/tuple containing ``{expected_value}``.
    ...    *Usage:*
    ...    ``And Array element should contain property or array value at least once    [data][0][attributes][valueFacets]    activeValue    ${brand_1}``
    ...    ``And Array element should contain property or array value at least once    [data][0][attributes][valueFacets]    activeValue    ${brand_2}``
    [Arguments]    ${json_path}    ${expected_property}    ${expected_value}
    @{elements}=    Get Value From Json             ${response_body}    ${json_path}
    ${count}=       Get Length                     @{elements}

    FOR    ${idx}    IN RANGE    0    ${count}
        ${elem}=    Get From List                  @{elements}    ${idx}
        Dictionary Should Contain Key              ${elem}         ${expected_property}
        ${value}=  Get From Dictionary             ${elem}         ${expected_property}

        ${is_list}=    Run Keyword And Return Status    Should Be True    isinstance(${value}, (list, tuple))
        IF    ${is_list}
            ${match}=    Run Keyword And Return Status    Should Contain    ${value}    ${expected_value}
        ELSE
            ${match}=    Run Keyword And Return Status    Should Be Equal As Strings    ${value}    ${expected_value}
        END

        IF    ${match}
            Exit For Loop
        END

        IF    ${idx} == ${count} - 1
            Fail    Expected property '${expected_property}' with value '${expected_value}' was not found in any element of array at path '${json_path}'
        END
    END

Each array element should contain property with value:
    [Documentation]    This keyword checks that each element in the array at JSON path ``{json_path}`` contains the specified property ``{expected_property}`` with the specified value ``{expected_value}``, comparing both as strings.
    ...    *Example:*    ``Each array element should contain property with value    [data][0][attributes][valueFacets]    activeValue    None``
    [Arguments]    ${json_path}    ${expected_property}    ${expected_value}
    @{data}=           Get Value From Json       ${response_body}    ${json_path}
    ${list_length}=    Get Length               @{data}
    FOR    ${index}    IN RANGE                 0    ${list_length}
        ${element}=       Get From List            @{data}    ${index}
        Dictionary Should Contain Key    ${element}    ${expected_property}
        ${actual}=         Get From Dictionary      ${element}    ${expected_property}
        ${actual_str}=     Convert To String        ${actual}
        ${expected_str}=   Convert To String        ${expected_value}
        Should Be Equal    ${actual_str}    ${expected_str}    ignore_case=True    msg=Property '${expected_property}' with value '${expected_value}' is not present in the array at JSON path '${json_path}' but should be.
    END

Nested array element should contain sub-array at least once:
    [Documentation]    This keyword checks that nested array ``{parent_array}`` in the array specified as ``{json_path}`` contains the specified sub-array ``{expected_nested_array}`` at least once.
    ...
    ...    *Example:*
    ...
    ...    ``And Nested array element should contain sub-array at least once:      [data]    [relationships]    company-role``
    ...
    [Arguments]    ${json_path}     ${parent_array}    ${expected_nested_array}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${result}=    Set Variable    'FALSE'
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    [   ${EMPTY}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    ]   ${EMPTY}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    '   ${EMPTY}
    ${expected_nested_array}=    Create List    ${expected_nested_array}
    FOR    ${index}    IN RANGE    0    ${list_length}
        IF    'PASS' in $result    BREAK
        ${list_element}=    Get From List    @{data}    ${index}
        @{list_element2}=    Get Value From Json    ${list_element}    ${parent_array}
        @{list_element}=    Get From List    ${list_element2}    0
        ${result}=    Run Keyword And Ignore Error    List Should Contain Sub List   ${list_element}    ${expected_nested_array}    ignore_case=True
        IF    'PASS' in $result    Exit For Loop
        IF    ${index} == ${list_length}-1
                Fail    expected '${expected_nested_array}' array is not present in '@{data}'
        END
        IF    'FAIL' in $result    Continue For Loop
    END

Nested array element should contain sub-array with property and value at least once:
    [Documentation]    This keyword checks whether the nested array ``{expected_nested_array}`` that is present in the parent array ``{parent_array}`` under the json path ``{json_path}``  contains propery ``{expected_property}`` with value ``{expected_value}`` at least once.
    ...
    ...    *Example:*
    ...
    ...   ``Nested array element should contain sub-array with property and value at least once:    [included]    [attributes]    [productConfigurationInstance]    configuration    {"time_of_day":"4"}``
    ...
    [Arguments]    ${json_path}     ${parent_array}    ${expected_nested_array}    ${expected_property}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${result}=    Set Variable    'FALSE'
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    [   ${EMPTY}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    ]   ${EMPTY}
    ${expected_nested_array}=    Replace String    ${expected_nested_array}    '   ${EMPTY}
    ${expected_nested_array}=    Convert To String    ${expected_nested_array}
    FOR    ${index}    IN RANGE    0    ${list_length}
        IF    'PASS' in $result    BREAK
        ${parent_array_element}=    Get From List    @{data}    ${index}
        @{actual_parent_element}=    Get Value From Json    ${parent_array_element}    ${parent_array}
        # Log List    @{actual_parent_element}
        ${actual_nested_array}=    Get From List    ${actual_parent_element}    0
        ${actual_property_array}=    Get Value From Json    ${actual_nested_array}    ${expected_nested_array}
        ${actual_property_value}=    Get From List    ${actual_property_array}    0
        ${actual_property_value}=    Get Value From Json    ${actual_property_value}    ${expected_property}
        ${actual_property_value}=    Convert To String    ${actual_property_value}
        ${actual_property_value}=    Replace String    ${actual_property_value}    '   ${EMPTY}
        ${actual_property_value}=    Replace String    ${actual_property_value}    [   ${EMPTY}
        ${actual_property_value}=    Replace String    ${actual_property_value}    ]   ${EMPTY}
        ${result}=    Run Keyword And Ignore Error    Should Contain   ${actual_property_value}    ${expected_value}    ignore_case=True
            IF    'PASS' in $result    BREAK
            IF    ${index} == ${list_length}-1
                Fail    expected '${expected_property}' with value '${expected_value}' is not present in '${expected_nested_array}' but should
            END
            IF    'FAIL' in $result    Continue For Loop
    END

Array element should contain nested array with property and value at least once:
    [Documentation]    This keyword checks whether the array ``{nested_array}`` that is present in the parent array ``{json_path}``  contains propery ``{expected_property}`` with value ``{expected_value}`` at least once.
    ...
    ...    *Example:*
    ...
    ...   ``And Array element should contain nested array with property and value at least once:    [data][0][attributes][categoryTreeFilter]    [children]    docCount    ${category_lvl2.qty}``
    ...
    [Arguments]    ${json_path}    ${nested_array}    ${expected_property}    ${expected_value}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length1}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    ${result}=    Set Variable    'FALSE'
    FOR    ${index1}    IN RANGE    0    ${list_length1}
        IF    'PASS' in $result    BREAK
        ${list_element}=    Get From List    @{data}    ${index1}
        @{list_element2}=    Get Value From Json    ${list_element}    ${nested_array}
        ${list_length2}=    Get Length    @{list_element2}
        FOR    ${index2}    IN RANGE    0    ${list_length2}
            ${list_element}=    Get From List    @{list_element2}    ${index2}
            ${list_element}=    Get Value From Json    ${list_element}    ${expected_property}
            ${list_element}=    Convert To String    ${list_element}
            ${list_element}=    Replace String    ${list_element}    '   ${EMPTY}
            ${list_element}=    Replace String    ${list_element}    [   ${EMPTY}
            ${list_element}=    Replace String    ${list_element}    ]   ${EMPTY}
            ${result}=    Run Keyword And Ignore Error    Should Contain   ${list_element}    ${expected_value}    ignore_case=True
            IF    'PASS' in $result    BREAK
            IF    ${index1} == ${list_length1}-1 and ${index2} == ${list_length2}-1
                Fail    expected '${expected_property}' with value '${expected_value}' is not present in '${nested_array}' but should
            END
            IF    'FAIL' in $result    Continue For Loop
        END
    END

Response should contain a nested array of a certain size at least once:
    [Documentation]    This keyword checks whether the nested array ``{nested_array}`` present at the JSON path ``{json_path}`` in the ``{response_body}`` test variable contains at least one element whose size is at least ``{expected_size}``.
    ...
    ...    *Example:*
    ...
    ...    ``Response should contain a nested array of a certain size at least once:    [data][0][attributes][valueFacets]    values    5``
    [Arguments]    ${json_path}    ${nested_array}    ${expected_size}
    @{data}=    Get Value From Json    ${response_body}    ${json_path}
    ${list_length}=    Get Length    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${item}=    Get From List    @{data}    ${index}
        @{sub_array}=    Get Value From Json    ${item}    ${nested_array}
        ${sub_length}=    Get Length    @{sub_array}
        ${sub_length}=    Convert To Integer    ${sub_length}
        ${expected_size}=    Convert To Integer    ${expected_size}
        ${result}=    Run Keyword And Ignore Error    Should Be True    ${sub_length} == ${expected_size}
        IF    'PASS' in ${result}
            Exit For Loop
        END
        IF    ${index} == ${list_length}-1
            Fail    expected nested array '@{nested_array}' with size  '${expected_size}' is not present in '[data]'
        END
        IF    'FAIL' in ${result}
            Continue For Loop
        END
    END

Response body array element should contain property with value at least once:
    [Documentation]    This keyword checks that in the response saved in ``{response_body}``,
    ...    the array at JSON path ``{json_path}`` has at least one element whose
    ...    property (itself at JSON path ``{property_path}``) equals ``{expected_value}``
    ...    *Example:*
    ...
    ...    ``Response body array element should contain property with value at least once:    [data]    [attributes][name]    GTC``
    [Arguments]    ${json_path}    ${property_path}    ${expected_value}
    @{elements}=    Get Value From Json    ${response_body}    ${json_path}
    ${length}=      Get Length             @{elements}
    ${result}=      Set Variable          FALSE
    FOR    ${i}    IN RANGE    0    ${length}
        ${elem}=          Get From List            @{elements}    ${i}
        ${actual}=        Get Value From Json      ${elem}          ${property_path}
        ${actual}=        Convert To String        ${actual}
        ${actual}=        Replace String           ${actual}    '    ${EMPTY}
        ${actual}=        Replace String           ${actual}    [    ${EMPTY}
        ${actual}=        Replace String           ${actual}    ]    ${EMPTY}
        ${check}=         Run Keyword And Ignore Error    Should Be Equal As Strings
        ...                                  ${actual}    ${expected_value}    ignore_case=True
        IF    'PASS' in ${check}
            ${result}=      Set Variable    TRUE
            Exit For Loop
        END
    END
    Should Be Equal As Strings    ${result}    TRUE
    ...    Property '${property_path}' with value '${expected_value}' was not found in array at '${json_path}'

Array element should contain property with value greater than at least once:
    [Documentation]    Checks that within the array at ${json_path}, at least one element has
    ...                property ${expected_property} whose numeric value is > ${expected_value}.
    ...                Elements lacking the property are ignored.
    ...
    ...    *Example:*
    ...    Array element should contain property with value greater than at least once:    [data][0][attributes][abstractProducts][0][prices]    DEFAULT    1
    [Arguments]    ${json_path}    ${expected_property}    ${expected_value}
    @{arr}=    Get Value From Json    ${response_body}    ${json_path}
    ${length}=    Get Length    @{arr}
    Should Be True    ${length} > 0    No elements found at path '${json_path}'.

    ${hit}=    Set Variable    ${False}
    FOR    ${i}    IN RANGE    0    ${length}
        ${el}=    Get From List    @{arr}    ${i}
        ${got}=    Run Keyword And Ignore Error    Get From Dictionary    ${el}    ${expected_property}
        ${status}=    Set Variable    ${got}[0]
        ${raw}=       Set Variable    ${got}[1]
        IF    '${status}' == 'PASS'
            # Coerce both sides to numbers (int/float or numeric strings)
            ${act_conv}=    Run Keyword And Ignore Error    Convert To Number    ${raw}
            IF    '${act_conv}[0]' == 'PASS'
                ${actual}=    Set Variable    ${act_conv}[1]
            ELSE
                ${actual}=    Evaluate    float(${raw})
            END
            ${exp_conv}=    Run Keyword And Ignore Error    Convert To Number    ${expected_value}
            IF    '${exp_conv}[0]' == 'PASS'
                ${expected}=    Set Variable    ${exp_conv}[1]
            ELSE
                ${expected}=    Evaluate    float(${expected_value})
            END

            IF    ${actual} > ${expected}
                ${hit}=    Set Variable    ${True}
                Exit For Loop
            END
        END
    END
    Should Be True    ${hit}    No element at '${json_path}' has property '${expected_property}' greater than '${expected_value}'.

Array element should contain property with value less than at least once:
    [Documentation]    Checks that within the array at ${json_path}, at least one element has
    ...                property ${expected_property} whose numeric value is < ${expected_value}.
    ...                Elements lacking the property are ignored.
    ...
    ...    *Example:*
    ...    Array element should contain property with value less than at least once:    [data][0][attributes][abstractProducts][0][prices]    ORIGINAL    200000
    [Arguments]    ${json_path}    ${expected_property}    ${expected_value}
    @{arr}=    Get Value From Json    ${response_body}    ${json_path}
    ${length}=    Get Length    @{arr}
    Should Be True    ${length} > 0    No elements found at path '${json_path}'.

    ${hit}=    Set Variable    ${False}
    FOR    ${i}    IN RANGE    0    ${length}
        ${el}=    Get From List    @{arr}    ${i}
        ${got}=    Run Keyword And Ignore Error    Get From Dictionary    ${el}    ${expected_property}
        ${status}=    Set Variable    ${got}[0]
        ${raw}=       Set Variable    ${got}[1]
        IF    '${status}' == 'PASS'
            ${act_conv}=    Run Keyword And Ignore Error    Convert To Number    ${raw}
            IF    '${act_conv}[0]' == 'PASS'
                ${actual}=    Set Variable    ${act_conv}[1]
            ELSE
                ${actual}=    Evaluate    float(${raw})
            END
            ${exp_conv}=    Run Keyword And Ignore Error    Convert To Number    ${expected_value}
            IF    '${exp_conv}[0]' == 'PASS'
                ${expected}=    Set Variable    ${exp_conv}[1]
            ELSE
                ${expected}=    Evaluate    float(${expected_value})
            END

            IF    ${actual} < ${expected}
                ${hit}=    Set Variable    ${True}
                Exit For Loop
            END
        END
    END
    Should Be True    ${hit}    No element at '${json_path}' has property '${expected_property}' less than '${expected_value}'.

Get company user id by customer reference:
    [Documentation]    This keyword sends the GET request to the ``/company-users?include=customers`` endpoint and returns company user id by customer reference. Sets variable : ``{companyUserId}``
    ...
    ...    *Example:*
    ...    ``Get company user id by customer reference:    ${yves_fifth_user.reference}``
    ...
    [Arguments]    ${customer_reference}
    I send a GET request:    /company-users?include=customers
    @{data}=    Get Value From Json    ${response_body}    [data]
    ${list_length}=    Get Length    @{data}
    # ${log_list}=    Log List    @{data}
    FOR    ${index}    IN RANGE    0    ${list_length}
        ${list_element}=    Get From List    @{data}    ${index}
        ${company_user_id}=    Get Value From Json    ${list_element}    id
        ${company_user_id}=    Convert To String    ${company_user_id}
        ${company_user_id}=    Replace String    ${company_user_id}    '   ${EMPTY}
        ${company_user_id}=    Replace String    ${company_user_id}    [   ${EMPTY}
        ${company_user_id}=    Replace String    ${company_user_id}    ]   ${EMPTY}
        Set Test Variable    ${companyUserId}    ${company_user_id}
        @{list_element2}=    Get Value From Json    ${list_element}    relationships
        ${company_user_customer_id}=    Get Value From Json    @{list_element2}    customers.data[0].id
        ${company_user_customer_id}=    Convert To String    ${company_user_customer_id}
        ${company_user_customer_id}=    Replace String    ${company_user_customer_id}    '   ${EMPTY}
        ${company_user_customer_id}=    Replace String    ${company_user_customer_id}    [   ${EMPTY}
        ${company_user_customer_id}=    Replace String    ${company_user_customer_id}    ]   ${EMPTY}
        IF    '${company_user_customer_id}' == '${customer_reference}'    BREAK
        IF    ${index} == ${list_length}-1
            Fail    expected customer reference '${customer_reference}' is not present in '@{data}' but should
        END
    END

Cleanup all existing shopping lists
    [Documentation]    This keyword deletes all customer shopping lists
        ...
        ...    Before using this method you should get customer token and set it into the headers with the help of ``I get access token for the customer:`` and ``I set Headers:``
        ...    This keyword does not accept any arguments.
        ...
        ...    *Example:*
        ...
        ...    ``Cleanup all existing shopping lists``
        Setup_api_host_if_undefined
        ${response}=    GET On Session    ${api_session}    ${current_url}/shopping-lists    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}  params=include=items,bundle-items     expected_status=200    verify=${verify_ssl}
        ${response.status_code}=    Set Variable    ${response.status_code}
        IF    ${response.status_code} != 204
            TRY
                ${response_body}=    Set Variable    ${response.json()}
            EXCEPT
                ${content_type}=    Get From Dictionary    ${response.headers}    content-type
                Fail    Got: '${response.status_code}' status code on: '${response.url}' with reason: '${response.reason}'. Response content type: '${content_type}'. Details: '${response.content}'
            END
        END
        IF    ${response.status_code} == 204
            ${response_body}=    Set Variable    ${EMPTY}
        END
        @{data}=    Get Value From Json    ${response_body}    [data]
        ${list_not_empty}=    Get length    ${data}
        IF    ${list_not_empty} > 0
            ${list_length}=    Get Length    @{data}
            FOR    ${index}    IN RANGE    0    ${list_length}
                    ${list_element}=    Get From List    @{data}    ${index}
                    ${shopping_list_uuid}=    Get Value From Json    ${list_element}    [id]
                    ${shopping_list_uuid}=    Convert To String    ${shopping_list_uuid}
                    ${shopping_list_uuid}=    Replace String    ${shopping_list_uuid}    '   ${EMPTY}
                    ${shopping_list_uuid}=    Replace String    ${shopping_list_uuid}    [   ${EMPTY}
                    ${shopping_list_uuid}=    Replace String    ${shopping_list_uuid}    ]   ${EMPTY}
                    ${response_delete}=    DELETE On Session    ${api_session}    ${current_url}/shopping-lists/${shopping_list_uuid}    headers=${headers}    timeout=${api_timeout}    allow_redirects=${default_allow_redirects}    auth=${default_auth}    expected_status=204
            END
        END

I get access token by user credentials:
    [Documentation]    This is a helper keyword which helps get access token for future use in the headers of the following requests.
    ...
    ...    It gets the token for the specified user ``{email}`` and saves it into the test variable ``{token}``, which can then be used within the scope of the test where this keyword was called.
    ...    After the test ends the ``{token}`` variable is cleared. This keyword needs to be called separately for each test where you expect to need a customer token.
    ...
    ...    The password in this case is not passed to the keyword and the default password stored in ``{default_password}`` will be used when getting token.
    ...
    ...    *Example:*
    ...
    ...    ``I get access token by user credentials:    ${zed_admin.email}``
    [Arguments]    ${email}    ${password}=${default_password}
    When I set Headers:    Content-Type=application/x-www-form-urlencoded
    And I send a POST request:    /token    {"grantType": "${grant_type.password}","username": "${email}","password": "${password}"}
    Save value to a variable:    [access_token]    token
    RETURN    ${token}

Switch to Glue
    Remove Tags    *
    Set Tags    glue
    Overwrite api variables
    Reset API Headers

Switch to BAPI
    Remove Tags    *
    Set Tags    bapi
    Overwrite api variables
    Reset API Headers

*** Keywords ***
Array Element Should Contain Nested Property With Value At Least Once
    [Arguments]    ${json_path}    ${nested_path}    ${property}    ${expected_value}
    ${matches}=    Get Value From Json     ${response_body}    ${json_path}
    ${exists}=    Evaluate
    ...    any(item.get('${nested_path}', {}).get('${property}', None) == ${expected_value} for item in ${matches})
    Should Be True    ${exists}    Expected property '${property}' with value '${expected_value}' not found in any array element.

Delete dynamic customer via API
    [Arguments]    ${customer_email}=${EMPTY}

    ${dynamic_customer_exists}=    Run Keyword And Return Status    Variable Should Exist    ${dynamic_customer}

    IF    '${customer_email}' == '${EMPTY}'
        IF    ${dynamic_customer_exists}
            VAR    ${customer_email}    ${dynamic_customer}
        ELSE
            Log    message=No dynamic (doesn't exist) or static customer was provided for deletion    level=INFO
            RETURN
        END
    END
    Set Tags    glue
    API_test_setup
    I get access token for the customer:    ${customer_email}
    I set Headers:    Authorization=${token}
    I send a GET request:    /customers
    Save value to a variable:    [data][0][id]    userId
    I send a DELETE request:    /customers/${userId}
    Response status code should be:    204
    Remove Tags    glue

To JSON Boolean
    [Arguments]    ${value}
    ${is_true}=    Run Keyword And Return Status    Should Be True    ${value}
    IF    ${is_true}
        RETURN    true
    ELSE
        RETURN    false
    END

Get Json Value
    [Arguments]    ${body}    ${path}
    ${value}=    Get Value    ${body}    ${path}
    RETURN    ${value}

Response body parameter should be either:
    [Arguments]    ${json_path_1}    ${json_path_2}    ${expected}
    ${status_1}=    Run Keyword And Return Status    Response body parameter should be:    ${json_path_1}    ${expected}
    ${status_2}=    Run Keyword And Return Status    Response body parameter should be:    ${json_path_2}    ${expected}
    IF    not ${status_1} and not ${status_2}
        Fail    Neither '${json_path_1}' nor '${json_path_2}' equals expected value ${expected}.
    END