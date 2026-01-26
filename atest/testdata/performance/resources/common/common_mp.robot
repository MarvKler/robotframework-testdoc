*** Settings ***
Resource    common_ui.robot
Resource    ../pages/mp/mp_login_page.robot

*** Variables ***
${mp_user_menu_button}    xpath=//button[contains(@class,'spy-user-menu__action')]
${mp_navigation_slider_menu}    xpath=//spy-navigation
${mp_submit_button}    xpath=(//spy-drawer-wrapper)[position()=last()]//button[@type='submit' and not(.//text()[normalize-space()='Back'])] | //web-mp-form//button[@type='submit' and not(.//text()[normalize-space()='Back'])]
${mp_items_table}    xpath=//nz-table-inner-default//table
${mp_search_box}    xpath=//spy-table//input[contains(@placeholder,'Search')]
${mp_close_drawer_button}    xpath=(//button[contains(@class,'spy-drawer-wrapper__action--close')])[1]
${spinner_loader}    xpath=//span[contains(@class,'ant-spin-dot')]
${mp_success_flyout}    xpath=//span[contains(@class,'alert')][contains(@class,'icon')][contains(@class,'success')]
${mp_error_flyout}    xpath=//span[contains(@class,'alert')][contains(@class,'icon')][contains(@class,'error')]
${mp_notification_wrapper}    xpath=//spy-notification-wrapper
${mp_loading_icon}    xpath=//span[contains(@class,'spin-dot') and not(ancestor::div[contains(@style,'hidden')])]

*** Keywords ***
MP: login on MP with provided credentials:
    [Arguments]    ${email}    ${password}=${default_password}
    Delete All Cookies
    TRY
        LocalStorage Clear
    EXCEPT
        Log    Failed to clear LocalStorage
    END
    MP: go to URL:    /
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not fully loaded
    END
    Disable Automatic Screenshots on Failure
    ${is_login_page}=    Run Keyword And Ignore Error    Page Should Contain Element    ${mp_user_name_field}    timeout=10ms
    Restore Automatic Screenshots on Failure
    IF    'FAIL' in $is_login_page
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        Delete All Cookies
        MP: go to URL:    /
    END
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not fully loaded
    END
    Wait Until Element Is Visible    ${mp_user_name_field}
    ${email_value}=    Convert To Lower Case   ${email}
    IF    '+merchant+' in '${email_value}'    VAR    ${password}    ${default_secure_password}
    Type Text    ${mp_user_name_field}    ${email}
    Type Text    ${mp_password_field}    ${password}
    # workaround for the issue with deadlocks on concurrent login attempts
    ${is_5xx}=    Click and return True if 5xx occurred:    ${mp_login_button}
    IF    ${is_5xx}
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        Delete All Cookies
        MP: go to URL:    /
        TRY
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Page is not fully loaded
        END
        Wait Until Element Is Visible    ${mp_user_name_field}
        ${email_value}=    Convert To Lower Case   ${email}
        IF    '+merchant+' in '${email_value}'    VAR    ${password}    ${default_secure_password}
        Type Text    ${mp_user_name_field}    ${email}
        Type Text    ${mp_password_field}    ${password}
        Click    ${mp_login_button}
    END
    Disable Automatic Screenshots on Failure
    ${login_success}=    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${mp_user_menu_button}    MP: Login failed! Retrying...    timeout=15s
    Restore Automatic Screenshots on Failure
    IF    'FAIL' in $login_success
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        Delete All Cookies
        MP: go to URL:    /
        TRY
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Page is not fully loaded
        END
        Wait Until Element Is Visible    ${mp_user_name_field}
        Type Text    ${mp_user_name_field}    ${email}
        Type Text    ${mp_password_field}    ${password}
        Click    ${mp_login_button}
    END
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not fully loaded
    END
    Wait Until Element Is Visible    ${mp_user_menu_button}    MP: Login failed!    timeout=15s

MP: login on MP with provided credentials and expect error:
    [Arguments]    ${email}    ${password}=${default_password}
    Delete All Cookies
    MP: go to URL:    /
    Delete All Cookies
    Reload
    Wait Until Element Is Visible    ${mp_user_name_field}
    Type Text    ${mp_user_name_field}    ${email}
    Type Text    ${mp_password_field}    ${password}
    Click    ${mp_login_button}
    Wait Until Element Is Visible    ${mp_login_failed_message}
    Page Should Not Contain Element    ${mp_user_menu_button}

MP: open navigation menu tab:
    [Arguments]    ${tabName}
    Wait Until Element Is Visible    ${mp_navigation_slider_menu}
    Click Element by xpath with JavaScript    xpath=//spy-navigation//span[contains(@class,'spy-navigation__title-text')][text()='${tabName}']
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Navigation menu is not loaded
    END
    Wait Until Element Is Visible    //div[@class='mp-layout-main-cnt__main']//span[contains(@class,'headline__title')]//*[text()='${tabName}']

MP: Wait until loader is no longer visible
    Disable Automatic Screenshots on Failure
    ${loader_displayed}=    Run Keyword And Ignore Error    Element Should Be Visible    ${mp_loading_icon}    timeout=500ms
    Restore Automatic Screenshots on Failure
    IF    'PASS' in $loader_displayed
        TRY
            Wait Until Element Is Not Visible    ${mp_loading_icon}
        EXCEPT
            Take Screenshot    EMBED    fullPage=True
            Fail    Timeout exceeded. Loader is still displayed after ${browser_timeout}
        END
    ELSE
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${mp_loading_icon}    message=Timeout exceeded. Loader is still displayed after ${browser_timeout}
    END

MP: click submit button
    [Arguments]    ${timeout}=${browser_timeout}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Submit button is not loaded
    END
    Disable Automatic Screenshots on Failure
    ${mp_flash_message_is_displayed}=    Run Keyword And Return Status    Element Should Be Visible    ${mp_notification_wrapper}    timeout=10ms
    Restore Automatic Screenshots on Failure
    IF    ${mp_flash_message_is_displayed}
        TRY
            Set Browser Timeout    200ms
            Remove element from HTML with JavaScript    //spy-notification-wrapper
            Set Browser Timeout    ${browser_timeout}
        EXCEPT    
            Log    Flash message is not visible
            Set Browser Timeout    ${browser_timeout}
        END
    END
    Wait Until Element Is Visible    ${mp_submit_button}    timeout=${timeout}
    Set Browser Timeout    ${browser_timeout}
    Click    ${mp_submit_button}
    TRY
        Repeat Keyword    5    Wait For Load State
        Wait For Load State    domcontentloaded
        Repeat Keyword    5    Wait For Load State    networkidle
    EXCEPT
        Log    Form is not submitted
    END

MP: perform search by:
    [Arguments]    ${searchKey}
    Wait Until Element Is Visible    ${mp_search_box}
    Clear Text    ${mp_search_box}
    Type Text    ${mp_search_box}    ${searchKey}
    Keyboard Key    press    Enter
    TRY
        Wait For Response    timeout=10s
    EXCEPT
        Log    Search event is not fired
    END
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    networkidle
    EXCEPT
        Log    Search event is not fired
    END
    MP: Wait until loader is no longer visible

MP: click on a table row that contains:
    [Arguments]    ${rowContent}
    Wait Until Element Is Visible    xpath=//div[@class='spy-table-column-text'][contains(text(),'${rowContent}')]/ancestor::tr[contains(@class,'ant-table-row')]
    Click    xpath=//div[@class='spy-table-column-text'][contains(text(),'${rowContent}')]/ancestor::tr[contains(@class,'ant-table-row')]
    Wait Until Page Contains Element    ${mp_close_drawer_button}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Drawler is not loaded
    END
    MP: Wait until loader is no longer visible

MP: close drawer
    Wait Until Element Is Visible    ${mp_close_drawer_button}
    Click    ${mp_close_drawer_button}
    Wait Until Element Is Visible    ${mp_items_table}

MP: click on create new entity button:
    [Arguments]        ${buttonName}
    Wait Until Element Is Visible    xpath=//spy-headline//*[contains(text(),'${buttonName}')]
    Click    xpath=//spy-headline//*[contains(text(),'${buttonName}')]
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Page is not loaded
    END
    MP: Wait until loader is no longer visible

MP: select option in expanded dropdown:
    [Arguments]    ${optionName}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Dropdown is not loaded
    END
    Wait Until Element Is Visible    xpath=//nz-option-container[contains(@class,'ant-select-dropdown')]//span[contains(text(),'${optionName}')]
    Click    xpath=//nz-option-container[contains(@class,'ant-select-dropdown')]//span[contains(text(),'${optionName}')]
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Dropdown is not loaded
    END
    Sleep    0.5s

MP: switch to the tab:
    [Arguments]    ${tabName}
    Wait Until Element Is Visible    xpath=//web-spy-tabs[@class='spy-tabs']//div[@role='tablist'][contains(@class,'ant-tabs')]//div[contains(text(),'${tabName}')]
    Click    xpath=//web-spy-tabs[@class='spy-tabs']//div[@role='tablist'][contains(@class,'ant-tabs')]//div[contains(text(),'${tabName}')]
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Tab is not loaded
    END
    MP: Wait until loader is no longer visible

MP: remove notification wrapper
    TRY
        ${flash_massage_state}=    Page Should Contain Element    ${mp_notification_wrapper}    message=Notification wrapper message is not shown    timeout=50ms
        Remove element from HTML with JavaScript    //spy-notification-wrapper
        # Remove element from HTML with JavaScript    (//spy-notification-wrapper//div)[1]
    EXCEPT
        Log    Flash message is not shown
    END

MP: go to URL:
    [Arguments]    ${url}    ${expected_response_code}=${EMPTY}
    ${url}=    Get URL Without Starting Slash    ${url}
    Set Browser Timeout    ${browser_timeout}
    ${response_code}=    Go To    ${mp_url}${url}
    ${response_code}=    Convert To Integer    ${response_code}
    ${is_5xx}=    Evaluate    500 <= ${response_code} < 600
    ${page_title}=    Get Title
    ${page_title}=    Convert To Lower Case    ${page_title}
    Disable Automatic Screenshots on Failure
    ${no_exception}=    Run Keyword And Return Status    Should Not Contain    ${page_title}    error
    Restore Automatic Screenshots on Failure
    IF    ${is_5xx} or not ${no_exception}
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        ${response_code}=    Go To    ${mp_url}${url}
        ${response_code}=    Convert To Integer    ${response_code}
        ${is_5xx}=    Evaluate    500 <= ${response_code} < 600
        IF    ${is_5xx}
        # final attempt
            TRY
                LocalStorage Clear
                Reload
            EXCEPT
                Log    Failed to clear LocalStorage
            END
            ${response_code}=    Go To    ${mp_url}${url}
            ${response_code}=    Convert To Integer    ${response_code}
            ${is_5xx}=    Evaluate    500 <= ${response_code} < 600
            IF    ${is_5xx}
                Take Screenshot    EMBED    fullPage=True
                Fail    '${response_code}' error occurred on go to '${mp_url}${url}'
            END
        END
        ${page_title}=    Get Title
        ${page_title}=    Convert To Lower Case    ${page_title}
        Should Not Contain    ${page_title}    error    msg='${response_code}' error occurred on go to '${mp_url}${url}'
    END
    IF    '${expected_response_code}' != '${EMPTY}'
        ${expected_response_code}=    Convert To Integer    ${expected_response_code}
        Should Be Equal    ${response_code}    ${expected_response_code}    msg=Expected response code (${expected_response_code}) is not equal to the actual response code (${response_code}) on Go to: ${mp_url}${url}
    END
    RETURN    ${response_code}