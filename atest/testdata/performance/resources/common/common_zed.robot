*** Settings ***
Resource    common_ui.robot
Resource    ../pages/zed/zed_login_page.robot
Resource    ../pages/zed/zed_edit_product_page.robot

*** Variables ***
${zed_log_out_button}   xpath=//ul[@class='nav navbar-top-links navbar-right']//a[contains(@href,'logout')]
${zed_save_button}      xpath=//input[contains(@class,'safe-submit')]
${zed_success_flash_message}    xpath=//div[@class='flash-messages']/div[@class='alert alert-success']
${zed_error_flash_message}    xpath=//div[@class='flash-messages']/div[@class='alert alert-danger']
${zed_info_flash_message}    xpath=//div[@class='flash-messages']/../div[@class='alert alert-info']
${zed_error_message}    xpath=//div[@class='alert alert-danger']
${zed_table_locator}    xpath=//table[contains(@class,'dataTable')]/tbody
${zed_search_field_locator}     xpath=//div[@class='dataTables_filter']//input[@type='search']
${zed_variant_search_field_locator}     xpath=//*[@id='product-variant-table_filter']//input[@type='search']
${zed_processing_block_locator}     xpath=//div[contains(@id,'processing')][contains(@class,'dataTables_processing')]
${zed_merchants_dropdown_locator}    xpath=//select[@name='id-merchant']
${zed_attribute_access_denied_header}    xpath=//div[@class='wrapper wrapper-content']//div[@class='flash-messages']//following-sibling::h1
${sweet_alert_js_error_popup}    xpath=//*[contains(@class,'sweet-alert')]


*** Keywords ***
Zed: login on Zed with provided credentials:
    [Arguments]    ${email}    ${password}=${default_password}
    Delete All Cookies
    TRY
        LocalStorage Clear
    EXCEPT
        Log    Failed to clear LocalStorage
    END
    Disable Automatic Screenshots on Failure
    ${is_zed_url_accessible}    Run Keyword And Ignore Error    Zed: go to URL:    /
    Restore Automatic Screenshots on Failure
    IF    'FAIL' in $is_zed_url_accessible
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        Delete All Cookies
        Zed: go to URL:    /
    END
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not fully loaded
    END
    Disable Automatic Screenshots on Failure
    ${is_login_page}=    Run Keyword And Ignore Error    Page Should Contain Element    ${zed_user_name_field}    timeout=10ms
    Restore Automatic Screenshots on Failure
    IF    'FAIL' in $is_login_page
        Delete All Cookies
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        Zed: go to URL:    /
    END
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not fully loaded
    END
    Wait Until Element Is Visible    ${zed_user_name_field}
    ${email_value}=    Convert To Lower Case   ${email}
    IF    '+merchant+' in '${email_value}'    VAR    ${password}    ${default_secure_password}
    Type Text    ${zed_user_name_field}    ${email}
    Type Text    ${zed_password_field}    ${password}
    # workaround for the issue with deadlocks on concurrent login attempts
    ${is_5xx}=    Click and return True if 5xx occurred:    ${zed_login_button}
    IF    ${is_5xx}
        Delete All Cookies
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        Zed: go to URL:    /
        TRY
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Page is not fully loaded
        END
        Wait Until Element Is Visible    ${zed_user_name_field}
        ${email_value}=    Convert To Lower Case   ${email}
        IF    '+merchant+' in '${email_value}'    VAR    ${password}    ${default_secure_password}
        Type Text    ${zed_user_name_field}    ${email}
        Type Text    ${zed_password_field}    ${password}
        Click    ${zed_login_button}
    END
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait Until Element Is Visible    ${zed_log_out_button}    Zed: Login failed!    timeout=15s
    EXCEPT
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        Delete All Cookies
        Zed: go to URL:    /
        TRY
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Page is not fully loaded
        END
        Wait Until Element Is Visible    ${zed_user_name_field}
        ${email_value}=    Convert To Lower Case   ${email}
        IF    '+merchant+' in '${email_value}'    VAR    ${password}    ${default_secure_password}
        Type Text    ${zed_user_name_field}    ${email}
        Type Text    ${zed_password_field}    ${password}
        Click    ${zed_login_button}
        Wait Until Element Is Visible    ${zed_log_out_button}    Zed: Login failed!    timeout=15s
    END

Zed: login with deactivated user/invalid data:
   [Arguments]    ${email}    ${password}=${default_password}
    Delete All Cookies
    Zed: go to URL:    /
    Delete All Cookies
    Reload
    Wait Until Element Is Visible    ${zed_user_name_field}
    Type Text    ${zed_user_name_field}    ${email}
    Type Text    ${zed_password_field}    ${password}
    Click    ${zed_login_button}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not fully loaded
    END
    Wait Until Element Is Visible    xpath=//*[contains(text(), 'Authentication failed!')]    timeout=10s

Zed: go to first navigation item level:
    [Documentation]     example: "Zed: Go to First Navigation Item Level  Customers"
    [Arguments]     ${navigation_item}
    Wait Until Page Contains Element    xpath=//ul[@id='side-menu']/li/a/span[@class='nav-label'][contains(text(),'${navigation_item}')]/../../a
    Click Element by xpath with JavaScript    //ul[@id='side-menu']/li/a/span[@class='nav-label'][contains(text(),'${navigation_item}')]/../../a
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    # workaround for the issue with deadlocks on concurrent search attempts
    ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=500ms
    IF    not ${no_js_error}
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        Reload
        ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=500ms
        IF    not ${no_js_error}
            TRY
                LocalStorage Clear
            EXCEPT
                Log    Failed to clear LocalStorage
            END
            Reload
            ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=500ms
            IF    not ${no_js_error}    Log    ''sweet-alert' js error popup on the page '${zed_url}: ${navigation_item}'
        END
    END

Zed: go to second navigation item level:
    [Documentation]     example: "Zed: Go to Second Navigation Item Level    Customers    Customer Access"
    [Arguments]     ${navigation_item_level1}   ${navigation_item_level2}
    ${node_state}=    Get Element Attribute  xpath=(//span[contains(@class,'nav-label')][text()='${navigation_item_level1}']/ancestor::li)[1]    class
    IF    'active' in '${node_state}'
        wait until element is visible  xpath=(//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}'])[1]
        Click Element by xpath with JavaScript    (//span[contains(@class,'nav-label')][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}'])[1]
        TRY
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
    ELSE
        Scroll Element Into View    xpath=//ul[@id='side-menu']/li/a/span[@class='nav-label'][contains(text(),'${navigation_item_level1}')]/../../a
        Click Element by xpath with JavaScript    //ul[@id='side-menu']/li/a/span[@class='nav-label'][contains(text(),'${navigation_item_level1}')]/../../a
        TRY
            Repeat Keyword    3    Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Page is not loaded
        END
        Disable Automatic Screenshots on Failure
        ${node_expanded}=    Run Keyword And Return Status    Element Should Be Visible    xpath=//span[contains(@class,'nav-label')][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}']    timeout=500ms
        Restore Automatic Screenshots on Failure
        IF    '${node_expanded}'=='False'
            Reload
            Click    xpath=//ul[@id='side-menu']/li/a/span[@class='nav-label'][contains(text(),'${navigation_item_level1}')]/../../a
            TRY
                Repeat Keyword    3    Wait For Load State
            EXCEPT
                Log    Page is not loaded
            END
        END
        wait until element is visible  xpath=(//span[contains(@class,'nav-label')][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}'])[1]
        Click Element by xpath with JavaScript    (//span[contains(@class,'nav-label')][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'nav-second-level')]//a/span[text()='${navigation_item_level2}'])[1]
        TRY
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
    END
    # workaround for the issue with deadlocks on concurrent search attempts
    ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=100ms
    IF    not ${no_js_error}
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        Reload
        ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=100ms
        IF    not ${no_js_error}
            TRY
                LocalStorage Clear
            EXCEPT
                Log    Failed to clear LocalStorage
            END
            Reload
            ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=100ms
            IF    not ${no_js_error}    Log    ''sweet-alert' js error popup on the page '${zed_url}: ${navigation_item_level1}->${navigation_item_level2}'
        END
    END

Zed: click button in Header:
    [Arguments]    ${button_name}
    Wait Until Element Is Visible    xpath=//div[@class='title-action']/a[contains(.,'${button_name}')]
    Click and retry if 5xx occurred:    xpath=//div[@class='title-action']/a[contains(.,'${button_name}')]

Zed: wait for button in Header to be visible:
    [Arguments]    ${button_name}    ${timeout}
    Wait until element is visible    xpath=//div[@class='title-action']/a[contains(.,'${button_name}')]

Zed: click Action Button in a table for row that contains:
    [Arguments]    ${row_content}    ${zed_table_action_button_locator}
    Zed: perform search by:    ${row_content}
    Wait until element is visible    xpath=(//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}') and not(contains(text(),'service'))]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')])[1]
    Click and retry if 5xx occurred:    xpath=(//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}') and not(contains(text(),'service'))]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')])[1]
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END

Zed: save abstract product:
    [Arguments]    ${productAbstract}    ${admin_email}=${zed_admin_email}
    ${currentURL}=    Get Location
    ${dynamic_admin_user_exists}=    Run Keyword And Return Status    Variable Should Exist    ${dynamic_admin_user}
    IF    ${dynamic_admin_user_exists} and '${admin_email}' == '${zed_admin_email}'
        VAR    ${admin_email}    ${dynamic_admin_user}
    ELSE IF    not ${dynamic_admin_user_exists}
        VAR    ${admin_email}    ${zed_admin_email}
    END
    IF    '${zed_url}' not in '${currentURL}' or '${zed_url}security-gui/login' in '${currentURL}'
        Zed: login on Zed with provided credentials:    ${admin_email}
    END
    Zed: go to URL:    /product-management
    Zed: click Action Button in a table for row that contains:     ${productAbstract}     Edit
    Wait until element is visible    ${zed_save_button}
    Zed: submit the form

Zed: click Action Button in Variant table for row that contains:
    [Arguments]    ${row_content}    ${zed_table_action_button_locator}
    Zed: perform variant search by:    ${row_content}
    wait until element is visible    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')]
    # workaround for the issue with deadlocks on concurrent search attempts
    Click and retry if 5xx occurred:    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')]
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

Zed: Check checkbox by Label:
    [Arguments]    ${checkbox_label}
    wait until element is visible   xpath=(//label[contains(., '${checkbox_label}')]//input[@type='checkbox'])[1]
    Check checkbox  xpath=(//label[contains(., '${checkbox_label}')]//input[@type='checkbox'])[1]

Zed: Check checkbox by Value:
    [Arguments]    ${checkbox_value}
    wait until element is visible    xpath=//input[@type='checkbox' and contains(@value, '${checkbox_value}')]
    Check checkbox    xpath=//input[@type='checkbox' and contains(@value, '${checkbox_value}')]

Zed: Uncheck Checkbox by Label:
    [Arguments]    ${checkbox_label}
    wait until element is visible    xpath=(//label[contains(., '${checkbox_label}')]//input[@type='checkbox'])[1]
    Uncheck Checkbox    xpath=(//label[contains(., '${checkbox_label}')]//input[@type='checkbox'])[1]

Zed: submit the form
    Wait until element is visible    ${zed_save_button}
    Click    ${zed_save_button}
    # workaround for the issue with deadlocks on concurrent search attempts
    ${got_response}=    Run Keyword And Ignore Error    Wait For Response
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    Wait Until Element Is Visible    ${zed_log_out_button}
    ${error_flash_message}=    Run Keyword And Ignore Error    Page Should Not Contain Element    ${zed_error_flash_message}    1s
    IF    'FAIL' in $got_response
        ${page_contains_target_element}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_save_button}    timeout=10ms
        IF    ${page_contains_target_element}
            Click    ${zed_save_button}
        END
        TRY
            Repeat Keyword    3    Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Page is not loaded
        END
        Wait Until Element Is Visible    ${zed_log_out_button}
    END
    IF    'FAIL' in $error_flash_message
        Click    ${zed_save_button}
        TRY
            Repeat Keyword    3    Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Page is not loaded
        END
        Wait Until Element Is Visible    ${zed_log_out_button}
    END
    Disable Automatic Screenshots on Failure
    ${error_message}=    Run Keyword And Ignore Error    Page Should Not Contain Element    ${zed_error_message}    1s
    Restore Automatic Screenshots on Failure
    IF    'FAIL' in $error_message
        Click    ${zed_save_button}
        TRY
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
        Wait Until Element Is Visible    ${zed_log_out_button}
    END
    Page Should Not Contain Element    ${zed_error_message}    1s
    Page Should Not Contain Element    ${zed_error_flash_message}    1s

Zed: perform search by:
    [Arguments]    ${search_key}
    # Build two safe regex fragments for the search value:
    # - enc1: percent-encoded, spaces -> %20
    # - enc2: form-encoded, spaces -> +
    ${enc1}=    Evaluate    re.escape(urllib.parse.quote("""${search_key}"""))    modules=re,urllib.parse
    ${enc2}=    Evaluate    re.escape(urllib.parse.quote_plus("""${search_key}"""))    modules=re,urllib.parse

    # Table-agnostic JS RegExp literal; match full search[value] (case-insensitive)
    ${search_matcher}=    Set Variable    /[?&]search%5Bvalue%5D=(?:${enc1}|${enc2})(?:&|$)/i
    Zed: clear search field
    # --- main attempt ---
    TRY
        ${promise}=    Promise To    Wait For Response    matcher=${search_matcher}    timeout=5s
        Type Text    ${zed_search_field_locator}    ${search_key}
        ${result}=    Run Keyword And Ignore Error    Wait For    ${promise}
        TRY
            Repeat Keyword    3    Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Search event is not fired
        END
        IF    '${result}[0]'=='FAIL'
            Log    Search event failed    level=WARN
            VAR    ${is_5xx}    ${False}
        ELSE
            ${response}=    Set Variable    ${result}[1]
            ${status}=    Get From Dictionary    ${response}    status
            ${is_5xx}=    Evaluate    ${status} >= 500
            IF    ${is_5xx}
                TRY
                    LocalStorage Clear
                EXCEPT
                    Log    Failed to clear LocalStorage
                END
                Reload
                Zed: clear search field
                ${promise}=    Promise To    Wait For Response    matcher=${search_matcher}    timeout=5s
                Type Text    ${zed_search_field_locator}    ${search_key}
                TRY
                    Wait For    ${promise}
                    Wait For Load State
                    Wait For Load State    domcontentloaded
                EXCEPT
                    Log    Search event is not fired
                END
            END
        END
    EXCEPT
        # --- recovery path if exception thrown ---
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        Reload
        Zed: clear search field
        ${promise}=    Promise To    Wait For Response    matcher=${search_matcher}    timeout=5s
        Type Text    ${zed_search_field_locator}    ${search_key}
        TRY
            Wait For    ${promise}
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Search event is not fired
        END
    END
    # Final settle
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Search event is not fired
    END
    # Handle any SweetAlert JS error popup with a re-attempt
    ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=500ms
    IF    not ${no_js_error}
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        Reload
        Zed: clear search field
        ${promise}=    Promise To    Wait For Response    matcher=${search_matcher}    timeout=5s
        Type Text    ${zed_search_field_locator}    ${search_key}
        TRY
            Wait For    ${promise}
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Search event is not fired
        END
        ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=500ms
        IF    not ${no_js_error}    Fail    ''sweet-alert' js error popup occurred'
    END

Zed: clear search field
    Clear Text    ${zed_search_field_locator}
    # workaround for the issue with deadlocks on concurrent search attempts
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Search event is not fired
    END
    ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=500ms
    IF    not ${no_js_error}
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        Reload
        Clear Text    ${zed_search_field_locator}
        TRY
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Search event is not fired
        END
        ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=500ms
        IF    not ${no_js_error}    Fail    ''sweet-alert' js error popup occurred'
    END

Zed: perform variant search by:
    [Arguments]    ${search_key}
    # Two safe regex fragments for the full search term:
    # enc1: percent-encoded (spaces -> %20)
    # enc2: form-encoded   (spaces -> +)
    ${enc1}=    Evaluate    re.escape(urllib.parse.quote("""${search_key}"""))    modules=re,urllib.parse
    ${enc2}=    Evaluate    re.escape(urllib.parse.quote_plus("""${search_key}"""))    modules=re,urllib.parse

    # Table-agnostic JS RegExp literal; matches full search[value] in URL (case-insensitive)
    ${search_matcher}=     Set Variable    /[?&]search%5Bvalue%5D=(?:${enc1}|${enc2})(?:&|$)/i
    Clear Text    ${zed_variant_search_field_locator}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Search event is not fired
    END

    # Main attempt: promise BEFORE typing to avoid race conditions
    TRY
        ${promise}=    Promise To    Wait For Response    matcher=${search_matcher}    timeout=5s
        Type Text    ${zed_variant_search_field_locator}    ${search_key}
        ${result}=    Run Keyword And Ignore Error    Wait For    ${promise}
        TRY
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Search event is not fired
        END

        IF    '${result}[0]'=='FAIL'
            Log    Search by concrete event failed    level=WARN
            VAR    ${is_5xx}    ${False}
        ELSE
            ${response}=    Set Variable    ${result}[1]
            ${status}=    Get From Dictionary    ${response}    status
            ${is_5xx}=    Evaluate    ${status} >= 500
            IF    ${is_5xx}
                TRY
                    LocalStorage Clear
                EXCEPT
                    Log    Failed to clear LocalStorage
                END
                Reload
                Clear Text    ${zed_variant_search_field_locator}
                TRY
                    Wait For Load State
                    Wait For Load State    domcontentloaded
                EXCEPT
                    Log    Search event is not fired
                END
                ${promise}=    Promise To    Wait For Response    matcher=${search_matcher}    timeout=5s
                Type Text    ${zed_variant_search_field_locator}    ${search_key}
                TRY
                    Wait For    ${promise}
                    Wait For Load State
                    Wait For Load State    domcontentloaded
                EXCEPT
                    Log    Search event is not fired
                END
            END
        END
    EXCEPT
        # Recovery path
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        Reload
        Clear Text    ${zed_variant_search_field_locator}
        TRY
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Search event is not fired
        END
        ${promise}=    Promise To    Wait For Response    matcher=${search_matcher}    timeout=5s
        Type Text    ${zed_variant_search_field_locator}    ${search_key}
        TRY
            Wait For    ${promise}
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Search event is not fired
        END
    END
    # Final settle
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Search event is not fired
    END
    # JS error popup handling
    ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=500ms
    IF    not ${no_js_error}
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        Reload
        Clear Text    ${zed_variant_search_field_locator}
        TRY
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Search event is not fired
        END
        ${promise}=    Promise To    Wait For Response    matcher=${search_matcher}    timeout=5s
        Type Text    ${zed_variant_search_field_locator}    ${search_key}
        TRY
            Wait For    ${promise}
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Search event is not fired
        END
        ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=500ms
        IF    not ${no_js_error}    Fail    ''sweet-alert' js error popup occurred'
    END

Zed: table should contain:
    [Arguments]    ${search_key}    ${error_message}=Table doesn't contain expected '${search_key}' record
    Zed: perform search by:    ${search_key}
    Table Should Contain    locator=${zed_table_locator}    expected=${search_key}    message=${error_message}

Zed: table should contain non-searchable value:
    [Arguments]    ${search_key}
    Wait Until Element Is Visible    ${zed_table_locator}
    Table Should Contain    ${zed_table_locator}  ${search_key}

Zed: table should contain xxx N times:
    [Arguments]    ${search_key}    ${expected_count}
    Wait Until Element Is Visible    ${zed_table_locator}
    Zed: perform search by:    ${search_key}
    ${actual_count}=    Get Element Count    xpath=//table[contains(@class,'dataTable')]/tbody//*[contains(text(),'${search_key}')]
    Should Be Equal    '${actual_count}'    '${expected_count}'

Zed: go to tab:
    [Arguments]    ${tabName}
    ${is_5xx}=    Click and return True if 5xx occurred:    xpath=//*[contains(@data-bs-toggle,'tab') and contains(text(),'${tabName}')]
    # workaround for the issue with deadlocks on concurrent click attempts
    IF    ${is_5xx}
        Reload
        Click With Options    xpath=//*[contains(@data-bs-toggle,'tab') and contains(text(),'${tabName}')]    force=True    noWaitAfter=True
    END
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    page is not fully loaded
    END

Zed: go to tab by link href that contains:
    [Arguments]    ${href}
    ${is_5xx}=    Click and return True if 5xx occurred:    xpath=//*[contains(@data-bs-toggle,'tab')][contains(@data-bs-target,'${href}')] | //*[contains(@data-bs-toggle,'tab')]//li[contains(@data-bs-target,'${href}')]
    # workaround for the issue with deadlocks on concurrent click attempts
    IF    ${is_5xx}
        Reload
        Click With Options    xpath=//*[contains(@data-bs-toggle,'tab')][contains(@data-bs-target,'${href}')] | //*[contains(@data-bs-toggle,'tab')]//li[contains(@data-bs-target,'${href}')]    force=True    noWaitAfter=True
    END
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    page is not fully loaded
    END

Zed: message should be shown:
    [Arguments]    ${text}
    Wait Until Element Is Visible    xpath=//div[contains(@class,'alert alert-success')]//*[contains(text(),'${text}')]    message=Success message is not shown

Zed: flash message should be shown:
    [Documentation]    Possible values: 'success', 'info' and 'danger'
    [Arguments]    ${type}=success
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'flash-messages')]//div[contains(@class,'alert-${type}')]    message=Flash message is not shown

Zed: click Action Button(without search) in a table for row that contains:
    [Arguments]    ${row_content}    ${zed_table_action_button_locator}
    wait until element is visible    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')]
    Click    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${row_content}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]/*[contains(.,'${zed_table_action_button_locator}')]
    TRY
        Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

Zed: filter by merchant:
    [Arguments]    ${merchant}
    Wait Until Element Is Visible    ${zed_merchants_dropdown_locator}
    Select From List By Label    ${zed_merchants_dropdown_locator}    ${merchant}

Zed: is admin user is logged in
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    page is not loaded
    END
    ${adminIsLoggedIn}=    Run Keyword And Return Status    Page Should Contain Element    locator=${zed_log_out_button}    timeout=0.1s
    RETURN    ${adminIsLoggedIn}

Zed: go to URL:
    [Arguments]    ${url}    ${expected_response_code}=${EMPTY}
    ${url}=    Get URL Without Starting Slash    ${url}
    Set Browser Timeout    ${browser_timeout}
    ${response_code}=    Go To    ${zed_url}${url}
    ${response_code}=    Convert To Integer    ${response_code}
    # workaround for the issue with deadlocks on concurrent search attempts
    ${is_5xx}=    Evaluate    500 <= ${response_code} < 600
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    ${page_title}=    Get Title
    ${page_title}=    Convert To Lower Case    ${page_title}
    ${no_exception}=    Run Keyword And Return Status    Should Not Contain    ${page_title}    error
    IF    ${is_5xx} or not ${no_exception}
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        ${response_code}=    Go To    ${zed_url}${url}
        ${response_code}=    Convert To Integer    ${response_code}
        ${is_5xx}=    Evaluate    500 <= ${response_code} < 600
        IF    ${is_5xx}    Fail    '${response_code}' error occurred on go to '${zed_url}${url}'
        TRY
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Page is not loaded
        END
        ${page_title}=    Get Title
        ${page_title}=    Convert To Lower Case    ${page_title}
        Should Not Contain    ${page_title}    error    msg='${response_code}' error occurred on go to '${zed_url}${url}'
    END
    IF    '${expected_response_code}' != '${EMPTY}'
        ${expected_response_code}=    Convert To Integer    ${expected_response_code}
        Should Be Equal    ${response_code}    ${expected_response_code}    msg=Expected response code (${expected_response_code}) is not equal to the actual response code (${response_code}) on Go to: ${zed_url}${url}
    END
    ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=3s
    IF    not ${no_js_error}
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        ${response_code}=    Go To    ${zed_url}${url}
        ${response_code}=    Convert To Integer    ${response_code}
        ${is_5xx}=    Evaluate    500 <= ${response_code} < 600
        TRY
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Page is not loaded
        END
        IF    ${is_5xx}    Fail    '${response_code}' error occurred on go to '${zed_url}${url}'
        ${error_message}=    Run Keyword And Return Status    Page Should Not Contain Element    ${zed_error_message}    timeout=1s
        ${error_flash_message}=    Run Keyword And Return Status    Page Should Not Contain Element    ${zed_error_flash_message}    timeout=1s
        IF    not ${error_message} or not ${error_flash_message}
            TRY
                LocalStorage Clear
            EXCEPT
                Log    Failed to clear LocalStorage
            END
            ${response_code}=    Go To    ${zed_url}${url}
            TRY
                Wait For Load State
                Wait For Load State    domcontentloaded
            EXCEPT
                Log    Page is not loaded
            END
        END
        ${no_js_error}=    Run Keyword And Return Status    Element Should Not Be Visible    ${sweet_alert_js_error_popup}    timeout=3s
        IF    not ${no_js_error}
            Take Screenshot    EMBED    fullPage=True
            Log    ''sweet-alert' js error popup on the page '${zed_url}${url}'    level=WARN
        END
    END
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    RETURN    ${response_code}
