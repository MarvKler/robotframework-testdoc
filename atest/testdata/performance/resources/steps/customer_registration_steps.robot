*** Settings ***
Resource    ../common/common.robot
Resource    ../steps/quick_order_steps.robot
Resource    ../pages/yves/yves_customer_account_page.robot
Resource    ../../resources/common/common.robot
Resource    ../pages/yves/yves_customer_registration_page.robot
Resource    ../steps/customer_account_steps.robot

*** Keywords ***
Register a new customer with data:
    [Documentation]    Possible argument names: e-mail, salutation, first name, last name, password
    [Arguments]    @{args}
    ${registrationData}=    Set Up Keyword Arguments    @{args}
    Yves: go to user menu:    Sign Up
    FOR    ${key}    ${value}    IN    &{registrationData}
        IF    '${key}'=='first name'    Type Text    ${registration_first_name_field}    ${value}
        IF    '${key}'=='last name'    Type Text    ${registration_last_name_field}    ${value}
        IF    '${key}'=='e-mail'    Type Text    ${registration_email_field}     ${value}
        IF    '${key}'=='password'    Run keywords
            Type Text    ${registration_password_field}     ${value}
            Type Text    ${registration_password_confirmation_field}     ${value}
#        Run keyword if    '${key}'=='salutation'    Type Text    ${checkout_shipping_address_company_name_field}     ${company}
    END
    Click Element by id with JavaScript    registerForm_accept_terms
    Click    ${registration_submit_button}
