*** Settings ***
Resource    ../pages/zed/zed_customer_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Keywords ***
Zed: delete customer:
    [Documentation]    Possible argument names: email
        [Arguments]    ${email}    ${admin_email}=${zed_admin_email}
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
        Zed: go to URL:    /customer        
        Zed: perform search by:    ${email}
        Disable Automatic Screenshots on Failure
        ${customerExists}=    Run Keyword And Return Status    Element Text Should Be    xpath=//tbody//td[contains(@class,' column-email') and contains(text(),'${email}')]     ${email}
        Restore Automatic Screenshots on Failure
        IF    '${customerExists}'=='True'
            Zed: click Action Button in a table for row that contains:    ${email}    Edit
            Wait Until Element Is Visible    ${zed_customer_edit_page_title}
            Click    ${zed_customer_delete_button}
            Wait Until Element Is Visible     ${zed_customer_delete_confirm_button}
            Click    ${zed_customer_delete_confirm_button}                    
            Zed: message should be shown:    Customer successfully deleted
        END

Zed: update company customer data:
    [Arguments]    @{args}
    ${registrationData}=    Set Up Keyword Arguments    @{args}
    Zed: perform search by:    ${first_name}
    Disable Automatic Screenshots on Failure
    ${customerExists}=    Run Keyword And Return Status    Zed: table should contain non-searchable value:    ${first_name}
    Restore Automatic Screenshots on Failure
    IF    '${customerExists}'=='True'
        Zed: click Action Button in a table for row that contains:    ${first_name}    Edit
        FOR    ${key}    ${value}    IN    &{registrationData}
            IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'
                Select From List By Label    ${zed_edit_company_user_salutation}    ${value}
            END
            IF    '${key}'=='first_name' and '${value}' != '${EMPTY}'
                Type Text    ${zed_edit_company_user_first_name}    ${value}
            END
            IF    '${key}'=='last_name' and '${value}' != '${EMPTY}'
                Type Text    ${zed_edit_company_user_last_name}    ${value}
            END
            IF    '${key}'=='company' and '${value}' != '${EMPTY}'
                Click    ${zed_edit_company_user_company_span}
                Wait Until Element Is Visible    ${zed_edit_company_user_search_select_field}
                Type Text    ${zed_edit_company_user_search_select_field}    ${value}
                Click    xpath=(//input[@type='search']/../..//ul[contains(.,'${value}')])[1]
            END
            IF    '${key}'=='business_unit' and '${value}' != '${EMPTY}'
                Click    ${zed_edit_company_user_business_unit_span}
                Wait Until Element Is Visible    ${zed_edit_company_user_search_select_field}
                Type Text    ${zed_edit_company_user_search_select_field}    ${value}
                Click    xpath=(//input[@type='search']/../..//ul[contains(.,'${value}')])[1]
            END
        END
        Zed: submit the form
    ELSE
        Log    ${email} customer doesn't exist
    END