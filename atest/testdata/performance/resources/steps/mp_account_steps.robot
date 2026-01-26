*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_mp.robot
Resource    ../pages/mp/mp_account_page.robot
Resource    ../common/common_yves.robot

*** Keywords ***
MP: update merchant personal details with data:
    [Arguments]    @{args}
    Click    ${mp_user_menu_button}
    Wait Until Element Is Visible    ${mp_my_account_header_menu_item}
    Click    ${mp_my_account_header_menu_item}
    ${personalData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${mp_account_first_name_field}
    FOR    ${key}    ${value}    IN    &{personalData}
        IF    '${key}'=='firstName' and '${value}' != '${EMPTY}'    Type Text    ${mp_account_first_name_field}    ${value}
        IF    '${key}'=='lastName' and '${value}' != '${EMPTY}'    Type Text    ${mp_account_last_name_field}    ${value}
        IF    '${key}'=='email' and '${value}' != '${EMPTY}'    Type Text    ${mp_account_email_field}    ${value}
        IF    '${key}'=='currentPassword' and '${value}' != '${EMPTY}'    Set Test Variable    ${currentPassword}    ${value}
        IF    '${key}'=='newPassword' and '${value}' != '${EMPTY}'    
            Click    ${mp_account_change_password_button}
            Wait Until Page Contains Element    ${mp_account_current_password_field}
            Wait Until Element Is Visible    ${mp_account_current_password_field}    
            Type Text    ${mp_account_current_password_field}    ${currentPassword}
            Type Text    ${mp_account_new_password_field}    ${value}
            Type Text    ${mp_account_repeat_new_password_field}    ${value}
            Click    ${mp_account_save_password_button}
        END
    END