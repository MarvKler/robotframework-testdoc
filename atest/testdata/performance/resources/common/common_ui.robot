*** Settings ***
Library    Browser    run_on_failure=Take Screenshot \ EMBED \ fullPage=True
Resource    common.robot
Resource    ../pages/yves/yves_header_section.robot
Resource    ../pages/yves/yves_login_page.robot
Resource    ../pages/yves/yves_catalog_page.robot
Resource    common_api.robot

*** Variables ***
# *** UI SUITE VARIABLES ***
${env}                 ui_suite
${headless}            true
${browser}             chromium
${browser_timeout}     60 seconds
${email_domain}        @spryker.com
${default_password}    change123
${default_secure_password}    qweRTY_123456
${admin_email}         admin@spryker.com
${device}
# ${device}              Desktop Chrome

# *** PYZ VARIABLES ***
${yves_env}
${yves_at_env}
${zed_env}
${mp_env}
${mp_root_env}
${glue_env}

*** Keywords ***
Overwrite pyz variables
    IF    '${yves_env}' == '${EMPTY}'
        IF    ${dms}
            Set Suite Variable    ${yves_url}    ${yves_dms_url}
        ELSE
            Set Suite Variable    ${yves_url}    ${yves_url}
        END
    ELSE
            Set Suite Variable    ${yves_url}    ${yves_env}
    END
    IF    '${yves_at_env}' == '${EMPTY}'
        IF    ${dms}
            Set Suite Variable    ${yves_at_url}    ${yves_at_dms_url}
        ELSE
            Set Suite Variable    ${yves_at_url}    ${yves_at_url}
        END
    ELSE
            Set Suite Variable    ${yves_at_url}    ${yves_at_env}
    END
    IF    '${zed_env}' == '${EMPTY}'
        IF    ${dms}
            Set Suite Variable    ${zed_url}   ${zed_dms_url}
        ELSE
            Set Suite Variable    ${zed_url}   ${zed_url}
        END
    ELSE
            Set Suite Variable    ${zed_url}   ${zed_env}
    END
    IF    '${mp_env}' == '${EMPTY}'
        IF    ${dms}
            Set Suite Variable    ${mp_url}    ${mp_dms_url}
        ELSE
            Set Suite Variable    ${mp_url}    ${mp_url}
        END
    ELSE
            Set Suite Variable    ${mp_url}   ${mp_env}
    END
    IF    '${mp_root_env}' == '${EMPTY}'
        IF    ${dms}
            Set Suite Variable    ${mp_root_url}    ${mp_root_dms_url}
        ELSE
            Set Suite Variable    ${mp_root_url}    ${mp_root_url}
        END
    ELSE
            Set Suite Variable    ${mp_root_url}   ${mp_root_env}
    END
    IF    '${glue_env}' == '${EMPTY}'
        IF    ${dms}
            Set Suite Variable    ${glue_url}    ${glue_dms_url}
        ELSE
            Set Suite Variable    ${glue_url}    ${glue_url}
        END
    ELSE
            Set Suite Variable    ${glue_url}   ${glue_env}
    END
    &{urls}=    Create Dictionary    yves_url    ${yves_url}    yves_at_url    ${yves_at_url}    zed_url    ${zed_url}    mp_url    ${mp_url}    glue_url    ${glue_url}
    FOR    ${key}    ${url}    IN    &{urls}
        ${url_last_character}=    Get Regexp Matches    ${url}    .$    flags=IGNORECASE
        ${url_last_character}=    Convert To String    ${url_last_character}
        ${url_last_character}=    Replace String    ${url_last_character}    '   ${EMPTY}
        ${url_last_character}=    Replace String    ${url_last_character}    [   ${EMPTY}
        ${url_last_character}=    Replace String    ${url_last_character}    ]   ${EMPTY}
        IF    '${url_last_character}' != '/' and '${key}' != 'glue_url'
            ${url}=    Set Variable    ${url}${/}
        END
        ${var_url}=   Set Variable    ${url}
        Set Suite Variable    ${${key}}    ${var_url}
    END

Create default Main Context
    Log    ${device}
    IF    '${device}' == '${EMPTY}'
        ${main_context}=    New Context    viewport={'width': 1440, 'height': 1080}    acceptDownloads=True
    ELSE
        ${device}=    Get Device    ${device}
        ${main_context}=    New Context    &{device}
    END
    Set Suite Variable    ${main_context}

UI_suite_setup
    Common_suite_setup
    Overwrite pyz variables
    IF    ${verify_ssl}
        New Browser    ${browser}    headless=${headless}    
    ELSE
        New Browser    ${browser}    headless=${headless}    args=['--ignore-certificate-errors']
    END
    Set Browser Timeout    ${browser_timeout}
    Create default Main Context
    New Page    ${yves_url}
    Register Keyword To Run On Failure    Take Screenshot  EMBED  fullPage=True

UI_suite_teardown
    Close Browser    ALL

UI_test_setup
    Should Test Run
    Register Keyword To Run On Failure    Take Screenshot  EMBED  fullPage=True
    Delete All Cookies
    Set Browser Timeout    ${browser_timeout}
    Go To    ${yves_url}

UI_test_teardown
    # Run Keyword If Test Failed    Pause Execution
    Delete All Cookies
    Set Browser Timeout    ${browser_timeout}
    Register Keyword To Run On Failure    Take Screenshot  EMBED  fullPage=True

Select Random Option From List
    [Arguments]    ${dropDownLocator}    ${dropDownOptionsLocator}
    ${getOptionsCount}=    Get Element Count    ${dropDownOptionsLocator}
    ${index}=    Evaluate    random.randint(0, ${getOptionsCount}-1)    random
    ${index}=    Convert To String    ${index}
    Select From List By Index    ${dropDownLocator}    ${index}

Click Element by xpath with JavaScript
    [Arguments]    ${xpath}
    Evaluate Javascript     ${None}     document.evaluate("${xpath}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click()

Click Element with JavaScript:
    [Documentation]    This keyword force clicks on web element using native JavaScript inside the browser. *Note*: it doesn't automatically wait until action is finished.
    ...
    ...    *Examples:*
    ...
    ...    `Click Element with JavaScript    id=w3loginbtn`
    ...
    ...    `Click Element with JavaScript    xpath=//a[@id='w3loginbtn']`
    ...
    ...    `Click Element with JavaScript    css=#w3loginbtn`
    ...
    ...    `Click Element with JavaScript    name=w3loginname`
    ...
    [Arguments]    ${locator}
    ${element}=    Get Element    ${locator}
    Evaluate JavaScript    ${element}    (e) => e.click({force:true})

Click Element by id with JavaScript
    [Arguments]    ${id}
    Evaluate Javascript     ${None}    document.getElementById("${id}").click()

Remove element from HTML with JavaScript
    [Arguments]    ${xpath}
    Evaluate Javascript     ${None}    var element=document.evaluate("${xpath}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;element.parentNode.removeChild(element);

Add/Edit element attribute with JavaScript:
    [Arguments]    ${xpath}    ${attribute}    ${attributeValue}
    Evaluate Javascript     ${None}    (document.evaluate("${xpath}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue).setAttribute("${attribute}", "${attributeValue}");

Remove element attribute with JavaScript:
    [Arguments]    ${xpath}    ${attribute}
    Evaluate Javascript     ${None}    var element=document.evaluate("${xpath}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;element.removeAttribute("${attribute}"");

### Helper keywords for migration from Selenium Library to Browser Library ###
Wait Until Element Is Visible
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=${browser_timeout}
    Wait For Elements State    ${locator}    visible    ${timeout}    ${message}

Wait Until Page Contains Element
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=${browser_timeout}
    Wait For Elements State    ${locator}    attached    ${timeout}    ${message}

Wait Until Page Does Not Contain Element
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=${browser_timeout}
    Wait For Elements State    ${locator}    detached    ${timeout}    ${message}

Wait Until Element Is Enabled
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=${browser_timeout}
    Wait For Elements State    ${locator}    enabled    ${timeout}    ${message}

Wait Until Element Is Disabled
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=${browser_timeout}
    Wait For Elements State    ${locator}    disabled    ${timeout}    ${message}

Element Should Be Visible
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=0:00:05
    Wait For Elements State    ${locator}    visible    ${timeout}    ${message}

Page Should Contain Element
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=0:00:05
    Wait For Elements State    ${locator}    attached    ${timeout}    ${message}

Get Location
    ${current_location}=    Get URL
    ${location}=    Set Variable    ${current_location}
    Set Test Variable    ${location}    ${location}
    RETURN    ${location}

Save current URL
    ${current_url}=    Get URL
    ${url}=    Set Variable    ${current_url}
    Set Test Variable    ${url}    ${url}
    RETURN    ${url}

Wait Until Element Is Not Visible
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=${browser_timeout}
    Wait For Elements State    ${locator}    hidden    ${timeout}    ${message}

Page Should Contain Link
    [Arguments]    ${url}    ${message}=${EMPTY}
    ${hrefs}=    Evaluate Javascript     ${None}    Array.from(document.querySelectorAll('a')).map(e => e.getAttribute('href'))
    Should Contain    ${hrefs}    ${url}

Scroll Element Into View
    [Arguments]    ${locator}
    Hover    ${locator}

Input Text
    [Arguments]    ${locator}    ${text}
    Type Text    ${locator}    ${text}    delay=10ms

Table Should Contain
    [Arguments]    ${locator}    ${expected}    ${message}=${EMPTY}    ${ignore_case}=${EMPTY}
    Get Text    ${locator}    contains    ${expected}    ${message}

Table Should Not Contain
    [Arguments]    ${locator}    ${expected}    ${message}=${EMPTY}    ${ignore_case}=${EMPTY}
    Get Text    ${locator}    not contains    ${expected}    ${message}

Element Should Contain
    [Arguments]    ${locator}    ${expected}    ${message}=${EMPTY}    ${ignore_case}=${EMPTY}    ${timeout}=${browser_timeout}
    Set Browser Timeout    ${timeout}
    Get Text    ${locator}    contains    ${expected}    ${message}
    Set Browser Timeout    ${browser_timeout}

Element Text Should Be
    [Arguments]    ${locator}    ${expected}    ${message}=${EMPTY}    ${ignore_case}=${EMPTY}
    Get Text    ${locator}    equal    ${expected}    ${message}

Wait Until Element Contains
    [Arguments]    ${locator}    ${text}    ${timeout}=${browser_timeout}    ${message}=${EMPTY}
    Get Text    ${locator}    contains    ${text}    ${message}

Page Should Not Contain Element
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=0:00:05
    Wait For Elements State    ${locator}    detached    ${timeout}    ${message}

Element Should Not Contain
    [Arguments]    ${locator}    ${text}
    Get Text    ${locator}    validate    "${text}" not in value

Checkbox Should Be Selected
    [Arguments]    ${locator}
    Get Checkbox State    ${locator}    ==    checked

Checkbox Should Not Be Selected
    [Arguments]    ${locator}
    Get Checkbox State    ${locator}    ==    unchecked

Mouse Over
    [Arguments]    ${locator}
    Hover    ${locator}

Element Should Not Be Visible
    [Arguments]    ${locator}    ${message}=${EMPTY}    ${timeout}=0:00:05
    Wait For Elements State    ${locator}    hidden    ${timeout}    ${message}

Get Element Attribute
    [Arguments]    ${locator}    ${attribute}
    ${element_attribute}=    Get Attribute    ${locator}    ${attribute}
    RETURN    ${element_attribute}

Select From List By Label
    [Arguments]    ${locator}    ${value}
    Select Options By    ${locator}    label    ${value}

Select From List By Value
    [Arguments]    ${locator}    ${value}
    Select Options By    ${locator}    value    ${value}

Select From List By Index
    [Arguments]    ${locator}    ${value}
    Select Options By    ${locator}    index    ${value}

Select From List By Text
    [Arguments]    ${locator}    ${value}
    Select Options By    ${locator}    text    ${value}

Select From List By Value Contains
    [Arguments]    ${selector}    ${substring}
    ${options}=    Get Select Options    ${selector}
    ${matching_values}=    Evaluate    [option["value"] for option in ${options} if "${substring}" in option["value"]]
    IF    ${matching_values}    
        Select Options By    ${selector}    value    ${matching_values}[0]
    ELSE    
        Fail    No option with substring '${substring}' found in ${selector}
    END

Select From List By Label Contains
    [Arguments]    ${selector}    ${substring}
    ${options}=    Get Select Options    ${selector}
    ${matching_values}=    Evaluate    [option["label"] for option in ${options} if "${substring}" in option["label"]]
    IF    ${matching_values}    
        Select Options By    ${selector}    label    ${matching_values}[0]
    ELSE    
        Fail    No option with substring '${substring}' found in ${selector}
    END

Create New Context
    ${new_context}=    New Context
    New Page    ${yves_url}

Close Current Context
    ${context_ids}=    Get Context Ids
    ${count_context_ids}=    Get Length    ${context_ids}
    IF    ${count_context_ids}>1    Close Context    CURRENT

Switch back to the Main Context
    Switch Context    ${main_context}

Verify the src attribute of the image is accessible:
    [Arguments]    @{image_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${image_list_count}=   get length  ${image_list}
    FOR    ${index}    IN RANGE    0    ${image_list_count}
        ${image_to_check}=    Get From List    ${image_list}    ${index}
        ${image_src}=    Get Element Attribute    ${image_to_check}    src
        ${response}=    GET    ${image_src}
        Should Be Equal    '${response.status_code}'    '200'
    END

Try reloading page until element is/not appear:
    [Documentation]    will reload the page until an element is shown or disappears. The second argument is the expected condition (true[shown]/false[disappeared]) for the element.
    [Arguments]    ${element}    ${shouldBeDisplayed}    ${tries}=20    ${timeout}=1s    ${message}=Timeout exceeded, element state doesn't match the expected. Check screenshot in logs
    ${shouldBeDisplayed}=    Convert To Lower Case    ${shouldBeDisplayed}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    page is not fully loaded
    END
    FOR    ${index}    IN RANGE    0    ${tries}
        IF    (${index} == 5 or ${index} == 10 or ${index} == 15) and $element == $catalog_product_card_locator
            Trigger multistore p&s
        END
        Disable Automatic Screenshots on Failure
        ${elementAppears}=    Run Keyword And Return Status    Page Should Contain Element    ${element}
        Restore Automatic Screenshots on Failure
        IF    '${shouldBeDisplayed}'=='true' and '${elementAppears}'=='False'
            Sleep    ${timeout}    
            Reload
            TRY
                Wait For Load State
                Wait For Load State    domcontentloaded
            EXCEPT
                Log    page is not fully loaded
            END
        ELSE IF     '${shouldBeDisplayed}'=='false' and '${elementAppears}'=='True'
            Sleep    ${timeout}
            Reload
            TRY
                Wait For Load State
                Wait For Load State    domcontentloaded
            EXCEPT
                Log    page is not fully loaded
            END
        ELSE
            Exit For Loop
        END
    END
    IF    ('${shouldBeDisplayed}'=='true' and '${elementAppears}'=='False') or ('${shouldBeDisplayed}'=='false' and '${elementAppears}'=='True')
        TRY
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    page is not fully loaded
        END
        Take Screenshot    EMBED    fullPage=True
        Fail    ${message}
    END

Try reloading page until element does/not contain text:
    [Documentation]    will reload the page until an element text will be updated. The second argument is the expected condition (true[contains]/false[doesn't contain]) for the element text.
    [Arguments]    ${element}    ${expectedText}    ${shouldContain}    ${tries}=20    ${timeout}=1s
    ${shouldContain}=    Convert To Lower Case    ${shouldContain}
    FOR    ${index}    IN RANGE    0    ${tries}
        Disable Automatic Screenshots on Failure
        ${textAppears}=    Run Keyword And Return Status    Element Text Should Be    ${element}    ${expectedText}    timeout=${timeout} 
        Restore Automatic Screenshots on Failure
        IF    '${shouldContain}'=='true' and '${textAppears}'=='False'
            Run Keywords    Sleep    ${timeout}    AND    Reload
        ELSE IF     '${shouldContain}'=='false' and '${textAppears}'=='True'
            Run Keywords    Sleep    ${timeout}    AND    Reload
        ELSE
            Exit For Loop
        END
    END
    IF    ('${shouldContain}'=='true' and '${textAppears}'=='False') or ('${shouldContain}'=='false' and '${textAppears}'=='True')
        Take Screenshot    EMBED    fullPage=True
        Fail    'Timeout exceeded, element text doesn't match the expected'
    END

Type Text When Element Is Visible
    [Arguments]    ${selector}    ${text}
        Wait Until Element Is Visible    ${selector}
        Type Text    ${selector}     ${text}

Select From List By Value When Element Is Visible
    [Arguments]    ${selector}    ${value}
        Wait Until Element Is Visible    ${selector}
        Select From List By Value    ${selector}     ${value}

Ping and go to URL:
    [Arguments]    ${url}    ${timeout}=${EMPTY}
    ${accessible}=    Run Keyword And Ignore Error    Send GET request and return status code:    ${url}    ${timeout}
    ${successful}=    Run Keyword And Ignore Error    Should Contain Any    '${response.status_code}'    '200'    '201'    '202'    '301'    '302'
    IF    'PASS' in $accessible and 'PASS' in $successful
        Go To    ${url}
    ELSE
        Fail    '${url}' URL is not accessible or throws an error
    END

Click and retry if 5xx occurred:
    [Arguments]    ${selector}    ${timeout}=300ms
    Disable Automatic Screenshots on Failure
    ${current_url}=    Get URL
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    page is not fully loaded
    END
    VAR    ${sweet_alert_js_error_popup}    xpath=//*[contains(@class,'sweet-alert')]
    ${page_title}=    Get Title
    ${page_title}=    Convert To Lower Case    ${page_title}
    ${page_has_title}=    Run Keyword And Return Status    Should Not Be Empty    ${page_title}
    ${no_exception}=    Run Keyword And Return Status    Should Not Contain    ${page_title}    error
    ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=500ms
    IF    not ${no_js_error} and not ${page_has_title} and not ${no_exception}
        Take Screenshot    EMBED    fullPage=True
        Log    'Error on page '${current_url}' Retrying ...'    level=WARN
        Go to    ${current_url}
    END
    ${page_contains_target_element}=    Run Keyword And Return Status    Page Should Contain Element    ${selector}
    IF    not ${page_contains_target_element}
        Take Screenshot    EMBED    fullPage=True
        Log    'Expected element '${selector}' is not present on the page'    level=WARN
        RETURN
    END
    TRY
        ${promise}=    Promise To    Wait For Response    matcher=**    timeout=${timeout}
        Click    ${selector}
        ${result}=    Run Keyword And Ignore Error    Wait For    ${promise}
    EXCEPT
        Log    No requests were fired
    END
    IF    '${result}[0]'=='FAIL'
        VAR    ${is_5xx}    ${False}
    ELSE
        ${response}=    Set Variable    ${result}[1]
        ${status}=    Get From Dictionary    ${response}    status
        ${is_5xx}=    Evaluate    ${status} >= 500
        IF    ${is_5xx}    Take Screenshot    EMBED    fullPage=True
    END
    ${statuses}=    Create List
    Set Browser Timeout    ${timeout}
    FOR    ${i}    IN RANGE    10
        ${result}=    Run Keyword And Ignore Error    Wait For Response    matcher=**    timeout=${timeout}
        IF    '${result}[0]'=='FAIL'
            Exit For Loop
        END
        ${response}=    Set Variable    ${result}[1]
        ${status}=    Get From Dictionary    ${response}    status
        Append To List    ${statuses}    ${status}
    END
    Set Browser Timeout    ${browser_timeout}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    page is not fully loaded
    END
    ${is_5xx_in_page_load}=    Evaluate    any(status >= 500 for status in ${statuses})
    ${page_title}=    Get Title
    ${page_title}=    Convert To Lower Case    ${page_title}
    ${no_exception}=    Run Keyword And Return Status    Should Not Contain    ${page_title}    error
    ${page_has_title}=    Run Keyword And Return Status    Should Not Be Empty    ${page_title}
    ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=500ms
    IF    not ${is_5xx} and not ${is_5xx_in_page_load} and ${no_exception} and ${no_js_error} and ${page_has_title}
        Restore Automatic Screenshots on Failure
        RETURN
    END
    # Retry click if 5xx occurred or exception
    Log    message=Clicking '${selector}' triggered a 5xx error. Retrying ...    level=WARN
    Log    ${is_5xx}
    Log    ${is_5xx_in_page_load}
    Log    ${no_exception}
    Log    ${no_js_error}
    Log    ${page_has_title}
    Go to    ${current_url}
    Reload
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    page is not fully loaded
    END
    ${page_contains_target_element}=    Run Keyword And Return Status    Page Should Contain Element    ${selector}    timeout=10ms
    IF    not ${page_contains_target_element}
        Take Screenshot    EMBED    fullPage=True
        Log    'Expected element '${selector}' is not present on the page on retry attempt, might be already processed'    level=WARN
        Restore Automatic Screenshots on Failure
        RETURN
    END
    Restore Automatic Screenshots on Failure
    Click With Options    ${selector}    force=True
    ${statuses_retry}=    Create List
    Set Browser Timeout    ${timeout}
    Disable Automatic Screenshots on Failure
    FOR    ${i}    IN RANGE    10
        ${result}=    Run Keyword And Ignore Error    Wait For Response    matcher=**    timeout=100ms
        IF    '${result}[0]'=='FAIL'
            Exit For Loop
        END
        ${response}=    Set Variable    ${result}[1]
        ${status}=    Get From Dictionary    ${response}    status
        Append To List    ${statuses_retry}    ${status}
    END
    Set Browser Timeout    ${browser_timeout}
    ${second_5xx_error_in_page_load}=    Evaluate    any(status >= 500 for status in ${statuses_retry})
    Should Not Be True    ${second_5xx_error_in_page_load}    msg=Clicking '${selector}' triggered a 5xx error.
    ${page_title}=    Get Title
    ${page_title}=    Convert To Lower Case    ${page_title}
    ${no_exception}=    Run Keyword And Return Status    Should Not Contain    ${page_title}    error
    ${page_has_title}=    Run Keyword And Return Status    Should Not Be Empty    ${page_title}
    ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=500ms
    Restore Automatic Screenshots on Failure
    Should Not Contain    ${page_title}    error    msg=Clicking '${selector}' triggered a 5xx error.
    IF     not ${no_js_error} and not ${page_has_title} and not ${no_exception}
        Take Screenshot    EMBED    fullPage=True
        Fail    Clicking '${selector}' triggered a 5xx error.
    END

Click and return True if 5xx occurred:
    [Arguments]    ${locator}    ${timeout}=300ms
    Disable Automatic Screenshots on Failure
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Restore Automatic Screenshots on Failure
        Log    page is not fully loaded
    END
    VAR    ${sweet_alert_js_error_popup}    xpath=//*[contains(@class,'sweet-alert')]
    TRY
        Disable Automatic Screenshots on Failure
        ${promise}=    Promise To    Wait For Response    matcher=**    timeout=${timeout}
        Click    ${locator}
        ${result}=    Run Keyword And Ignore Error    Wait For    ${promise}
        Restore Automatic Screenshots on Failure
    EXCEPT
        Restore Automatic Screenshots on Failure
        Log    No requests were fired
    END
    IF    '${result}[0]'=='FAIL'
        VAR    ${is_5xx}    ${False}
    ELSE
        ${response}=    Set Variable    ${result}[1]
        ${status}=    Get From Dictionary    ${response}    status
        ${is_5xx}=    Evaluate    ${status} >= 500
        IF    ${is_5xx}    Take Screenshot    EMBED    fullPage=True
    END
    ${page_load_statuses}=    Create List
    Disable Automatic Screenshots on Failure
    FOR    ${i}    IN RANGE    10
        ${result}=    Run Keyword And Ignore Error    Wait For Response    matcher=**    timeout=${timeout}
        IF    '${result}[0]'=='FAIL'
            Exit For Loop
        END
        ${response}=    Set Variable    ${result}[1]
        ${status}=    Get From Dictionary    ${response}    status
        Append To List    ${page_load_statuses}    ${status}
    END
    ${is_5xx_in_page_load}=    Evaluate    any(status >= 500 for status in ${page_load_statuses})
    ${page_title}=    Get Title
    ${page_title}=    Convert To Lower Case    ${page_title}
    ${no_exception}=    Run Keyword And Return Status    Should Not Contain    ${page_title}    error
    ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=500ms
    Restore Automatic Screenshots on Failure
    IF    ${is_5xx} or ${is_5xx_in_page_load} or not ${no_exception} or not ${no_js_error}
        RETURN    ${True}
    ELSE
        RETURN    ${False}
    END

Disable Automatic Screenshots on Failure
    # Save the current run-on-failure handler and disable it
    ${prev}=    Register Keyword To Run On Failure    None
    VAR    ${PREV_RUN_ON_FAILURE}    ${prev}    scope=SUITE

Restore Automatic Screenshots on Failure
    # Restore the saved run-on-failure handler
    Register Keyword To Run On Failure    Take Screenshot    EMBED    fullPage=True

# *** Example of intercepting the network request ***
#     [Arguments]    ${eventName}    ${timeout}=30s
#     ${response}=    Wait for response    matcher=bazaarvoice\\.com\\/\\w+\\.gif\\?.*type=${eventName}    timeout=${timeout}
#     Should be true    ${response}[ok]
# ** OR **
#    [Arguments]    ${timeout}=30s
#    ${response}=    Wait for response    matcher=usercentrics.*?graphql     timeout=${timeout}
#    Should be true    ${response}[ok]

