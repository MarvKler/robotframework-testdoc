*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_yves.robot
Resource    ../common/common_zed.robot
Resource    ../pages/zed/zed_attach_to_business_unit_page.robot
Resource    ../pages/yves/yves_customer_account_page.robot
Resource    ../pages/zed/zed_delete_company_user_page.robot
Resource    ../pages/zed/zed_create_company_page.robot
Resource    ../pages/zed/zed_create_company_business_unit_page.robot
Resource    ../pages/zed/zed_create_company_role_page.robot
Resource    ../pages/zed/zed_create_company_user_page.robot
Resource    ../pages/yves/yves_company_role_page.robot
Resource    ../pages/yves/yves_company_business_unit_page.robot
Resource    ../pages/yves/yves_company_user_page.robot

*** Keywords ***
Zed: create new Company Business Unit for the following company:
    [Documentation]     Creates new company BU with provided BU Name and for provided company.
    [Arguments]    ${company_name}    ${business_unit_name}    ${company_id}=EMPTY    ${parent_business_unit}=parent
    Zed: go to URL:    /company-business-unit-gui/list-company-business-unit
    Zed: click button in Header:    Create Company Business Unit
    ${is_company_dropdown_with_search}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_bu_company_dropdown_with_search_locator}    timeout=0.5s
    IF    ${is_company_dropdown_with_search}
        Click    ${zed_bu_company_dropdown_with_search_locator}
        Type Text    ${zed_bu_company_search_field}    ${company_name}
        Wait Until Element Is Visible    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${company_name}') and contains(text(),'${company_id}')]
        Click    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${company_name}') and contains(text(),'${company_id}')]
        Wait Until Element Is Not Visible    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${company_name}') and contains(text(),'${company_id}')]
        Sleep    0.5s
    ELSE
        Click    ${zed_bu_company_dropdown_locator}
        Select From List By Label Contains    ${zed_bu_company_dropdown_locator}    ${company_name}
        TRY
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    page is not fully loaded
        END
        Select From List By Label Contains    ${zed_bu_parent_bu_dropdown_locator}    ${parent_business_unit}
    END
    VAR    ${created_business_unit}    ${business_unit_name}+${random}    scope=TEST
    Type Text    ${zed_bu_name_field}    ${created_business_unit}
    Type Text    ${zed_bu_iban_field}    testiban+${random}
    Type Text    ${zed_bu_bic_field}    testbic+${random}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    page is not fully loaded
    END
    Zed: submit the form
    Wait Until Element Is Visible    ${zed_success_flash_message}
    Wait Until Element Is Visible    ${zed_table_locator}
    Zed: perform search by:    ${created_business_unit}
    Table Should Contain    ${zed_table_locator}    ${created_business_unit}
    ${newly_created_business_unit_id}=      Get Text    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${created_business_unit}')]/../td[1]
    VAR    ${created_business_unit_id}    ${newly_created_business_unit_id}    scope=TEST

Zed: create new Company with provided name:
    [Arguments]    ${company_name}
    ${currentURL}=    Get Location
    IF    '/company-gui/list-company' not in '${currentURL}'    Zed: go to URL:    /company-gui/list-company
    Zed: click button in Header:    Create Company
    VAR    ${created_company}=    ${company_name}+${random}    scope=TEST
    Type Text    ${zed_company_name_input_field}    ${created_company}
    Zed: submit the form
    Wait Until Element Is Visible    ${zed_success_flash_message}
    Wait Until Element Is Visible    ${zed_table_locator}
    Table Should Contain    ${zed_table_locator}    ${created_company}
    ${newly_created_company_id}=      Get Text    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${created_company}')]/../td[1]
    VAR    ${created_company_id}    ${newly_created_company_id}    scope=TEST

Zed: create new Company Role with provided permissions:
    [Documentation]     Creates new company role with provided permission. Permissions are optional
    [Arguments]     ${company_name}    ${company_id}     ${role_name}    ${is_default}      @{permissions_list}    ${permission1}=${EMPTY}     ${permission2}=${EMPTY}     ${permission3}=${EMPTY}     ${permission4}=${EMPTY}     ${permission5}=${EMPTY}     ${permission6}=${EMPTY}     ${permission7}=${EMPTY}     ${permission8}=${EMPTY}     ${permission9}=${EMPTY}     ${permission10}=${EMPTY}     ${permission11}=${EMPTY}     ${permission12}=${EMPTY}     ${permission13}=${EMPTY}     ${permission14}=${EMPTY}     ${permission15}=${EMPTY}
    Zed: go to URL:    /company-role-gui/list-company-role
    Zed: click button in Header:    Add company user role
    ${new_list_of_permissions}=    Get Length    ${permissions_list}
    IF  '${is_default}'=='true'     Zed: Check checkbox by Label:  Is Default
    FOR    ${index}    IN RANGE    0    ${new_list_of_permissions}
        ${permission_to_set}=    Get From List    ${permissions_list}    ${index}
        Zed: Check checkbox by Label:   ${permission_to_set}
    END
    ${is_company_dropdown_with_search}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_role_company_dropdown_with_search_locator}    timeout=0.5s
    IF    ${is_company_dropdown_with_search}
        Click    ${zed_role_company_dropdown_with_search_locator}
        Type Text    ${zed_role_company_search_field}    ${company_name}
        Wait Until Element Is Visible    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${company_name}') and contains(text(),'${company_id}')]
        Click    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${company_name}') and contains(text(),'${company_id}')]
        Wait Until Element Is Not Visible    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${company_name}') and contains(text(),'${company_id}')]
        Sleep    0.5s
    ELSE
        Click    ${zed_role_company_dropdown_locator}
        Select From List By Label Contains    ${zed_role_company_dropdown_locator}    ${company_name}
    END
    VAR    ${created_company_role}    ${role_name}+${random}    scope=TEST
    Type Text    ${zed_role_name_field}    ${created_company_role}
    Zed: submit the form

Zed: Create new Company User with provided details:
    [Arguments]    @{args}
    ${company_user_data}=    Set Up Keyword Arguments    @{args}
    Zed: go to URL:    /company-user-gui/list-company-user
    Wait Until Element Is Visible    ${zed_table_locator}
    Zed: click button in Header:    Add User
    FOR    ${key}    ${value}    IN    &{company_user_data}
        ${key}=   Convert To Lower Case   ${key}
        IF    '${key}'=='email' and '${value}' != '${EMPTY}'   Type Text    ${zed_create_company_user_email_field}    ${value}
        IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'   Select From List By Value    ${zed_create__company_user_salutation_dropdown}    ${value}
        IF    '${key}'=='first_name' and '${value}' != '${EMPTY}'   Type Text    ${zed_create_company_user_first_name_field}    ${value}
        IF    '${key}'=='last_name' and '${value}' != '${EMPTY}'   Type Text    ${zed_create_company_user_last_name_field}    ${value}
        IF    '${key}'=='gender' and '${value}' != '${EMPTY}'   Select From List By Value    ${zed_create_company_user_gender_dropdown}    ${value}
        IF    '${key}'=='company' and '${value}' != '${EMPTY}'   
            Click    ${zed_create_company_user_company_name_dropdown}
            Type Text    ${zed_create_company_user_company_search_field}    ${value}
            Wait Until Element Is Visible    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${value}')]
            Click    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${value}')]
            Wait Until Element Is Not Visible    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${value}')]
            Sleep    0.5s
        END
        IF    '${key}'=='business_unit' and '${value}' != '${EMPTY}'   
            Click    ${zed_create_company_business_unit_dropdown}
            Type Text    ${zed_create_company_business_unit_search_field}    ${value}
            Wait Until Element Is Visible    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${value}')]
            Click    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${value}')]
            Wait Until Element Is Not Visible    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${value}')]
            Sleep    0.5s
        END
        IF    '${key}'=='role' and '${value}' != '${EMPTY}'   Zed: Check checkbox by Label:    ${value}
    END
    Zed: submit the form

Zed: attach company user to the following BU with role:
    [Arguments]    ${business_unit}    ${role_checkbox}
    Wait Until Element Is Visible    ${zed_business_unit_selector}
    IF    '${env}' in ['ui_suite']
        Click    ${zed_attach_customer_to_bu_business_unit_span}
        Wait Until Element Is Visible    ${zed_edit_company_user_search_select_field}
        Type Text    ${zed_edit_company_user_search_select_field}    ${business_unit}
        Click    xpath=(//input[@type='search']/../..//ul[contains(.,'${business_unit}')])[1]
    ELSE
        Select From List By Label Contains    ${zed_business_unit_selector}    ${business_unit}
    END
    Zed: Check checkbox by Label:    ${role_checkbox}
    Zed: submit the form


Yves: 'Business Unit' dropdown contains:
    [Arguments]    @{business_units_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${business_units_list_count}=   get length  ${business_units_list}
    FOR    ${index}    IN RANGE    0    ${business_units_list_count}
        ${business_unit_to_check}=    Get From List    ${business_units_list}    ${index}
        Page Should Contain Element    //select[@id='company_user_account_selector_form_companyUserAccount']/option[contains(.,'${business_unit_to_check}')]
    END

Zed: delete company user xxx withing xxx company business unit:
    [Documentation]    Possible argument names: company user name
    [Arguments]    ${companyUserName}    ${companyBusinessUnit}    ${admin_email}=${zed_admin_email}
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
    Zed: go to URL:    /company-user-gui/list-company-user
    Zed: perform search by:    ${companyUserName}
    ${customerExists}=    Run Keyword And Return Status    Table should contain    ${zed_table_locator}    ${companyBusinessUnit}
    IF    '${customerExists}'=='True'
        Run keywords
            Zed: click Action Button(without search) in a table for row that contains:    ${companyBusinessUnit}    Delete
            Click    ${zed_confirm_delete_company_user_button}
    END

Yves: create new company role:
    [Arguments]    ${role_name}
    Yves: go to URL:    /company/company-role
    Click    ${create_company_role_button}
    Type Text    ${create_company_role_name_field}    ${role_name}
    Click    ${create_company_role_submit_button}

Yves: assign the following permissions to the company role:
    [Arguments]    ${company_role}    @{permissions_list}
    Yves: go to URL:    /company/company-role
    Page Should Contain Element    ${company_roles_table_locator}
    Click    xpath=//*[contains(@data-qa,'role-table')]//table//td[contains(.,'${company_role}')]/ancestor::tr//td//a[contains(@href,'update')]
    Page Should Contain Element    ${create_company_role_name_field}
    ${list_of_permissions}=    Get Length    ${permissions_list}
    FOR    ${index}    IN RANGE    0    ${list_of_permissions}
        ${permission_to_set}=    Get From List    ${permissions_list}    ${index}
        Click    xpath=//*[contains(@data-qa,'permission-table')]//table//td[contains(.,'${permission_to_set}')]/ancestor::tr//td//button
        Sleep    0.5s
    END
    Click    ${create_company_role_submit_button}

Yves: create new company business unit:
    [Arguments]    ${business_unit_name}    ${business_unit_email}
    Yves: go to URL:    /company/business-unit
    Click    ${create_company_business_unit_button}
    Type Text    ${create_company_business_unit_name_field}    ${business_unit_name}
    Type Text    ${create_company_business_unit_email_field}    ${business_unit_email}
    Click    ${create_company_business_unit_submit_button}
    Page Should Contain Element    ${company_business_unit_delete_button}

Yves: create new company user:
    [Arguments]    ${business_unit}    ${role}    ${email}    ${first_name}    ${last_name}
    Yves: go to URL:    /company/user
    Click    ${create_company_user_button}
    Select From List By Label Contains    ${create_company_user_business_unit_dropdown}    ${business_unit}
    Click    //input[contains(@id,'company_role_collection')]/ancestor::label[contains(.,'${role}')]
    Sleep    0.5s
    Type Text    ${create_company_user_email_field}     ${email}
    Type Text    ${create_company_user_first_name_field}     ${first_name}
    Type Text    ${create_company_user_last_name_field}     ${last_name}
    Click    ${create_company_user_submit_button}
    Page Should Not Contain Element    ${create_company_user_email_field}    message=Failed to create a new company user