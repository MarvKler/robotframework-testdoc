*** Settings ***
Resource    ../pages/zed/zed_delete_user_confirmation_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_create_zed_user_page.robot
Resource    ../pages/zed/zed_user_role_page.robot
Resource    ../pages/zed/zed_user_group_page.robot

*** Keywords ***
Zed: delete Zed user with the following email:
    [Arguments]    ${zed_email}
    Reload
    ${currentURL}=    Get Location
    IF    '/user' not in '${currentURL}'    Zed: go to URL:    /user
    Zed: click Action Button in a table for row that contains:    ${zed_email}    Delete
    Wait Until Page Contains Element    ${zed_confirm_delete_user_button}
    Click    ${zed_confirm_delete_user_button}

Zed: update Zed user:
    [Arguments]    @{args}
    ${newUserData}=    Set Up Keyword Arguments    @{args}
    Reload
    ${currentURL}=    Get Location
    IF    '/user' not in '${currentURL}'    Zed: go to URL:    /user
    ${variable_exists}=    Run Keyword And Return Status    Variable Should Exist    ${oldEmail}
    IF    ${variable_exists}
        Zed: click Action Button in a table for row that contains:    ${oldEmail}    Edit
    ELSE
        Zed: click Action Button in a table for row that contains:    ${email}    Edit
    END
    ${currentURL}=    Get Location
    TRY
        Wait Until Element Is Visible    ${zed_user_email_field}
    EXCEPT
        Go To    ${currentURL}
        Wait For Load State
        Wait For Load State    domcontentloaded
        IF    ${variable_exists}
            Zed: click Action Button in a table for row that contains:    ${oldEmail}    Edit
        ELSE
            Zed: click Action Button in a table for row that contains:    ${email}    Edit
        END
    END
    Wait Until Element Is Visible    ${zed_user_email_field}
    ${currentURL}=    Get Location
    FOR    ${key}    ${value}    IN    &{newUserData}
        IF    '${key}'=='newEmail' and '${value}' != '${EMPTY}'    Type Text    ${zed_user_email_field}    ${value}
        IF    '${key}'=='password' and '${value}' != '${EMPTY}'
            Type Text    ${zed_user_password_filed}    ${value}
            Type Text    ${zed_user_repeat_password_field}    ${value}
        END
        IF    '${key}'=='firstName' and '${value}' != '${EMPTY}'    Type Text    ${zed_user_first_name_field}    ${value}
        IF    '${key}'=='lastName' and '${value}' != '${EMPTY}'    Type Text    ${zed_user_last_name_field}    ${value}
        IF    '${key}'=='user_is_warehouse_user' and '${value}' != '${EMPTY}'
            ${value}=    Convert To Lower Case    ${value}
        END
        IF    '${key}'=='user_is_warehouse_user' and '${value}' == 'true'   
            Zed: Check checkbox by Label:     This user is a warehouse user
        END
        IF    '${key}'=='user_is_warehouse_user' and '${value}' == 'false'   
            Zed: Uncheck Checkbox by Label:    This user is a warehouse user
        END
        IF    '${key}'=='group' and '${value}' != '${EMPTY}'
            Zed: Check checkbox by Label:    ${value}
        END
        IF    '${key}'=='remove group' and '${value}' != '${EMPTY}'
            Zed: Uncheck Checkbox by Label:    ${value}
        END
    END
    Zed: submit the form
    Disable Automatic Screenshots on Failure
    ${saved_successfully}    Run Keyword And Return Status    Page Should Not Contain Element    ${zed_user_first_name_field}    timeout=1s
    Restore Automatic Screenshots on Failure
    IF    not ${saved_successfully}
        Go To    ${currentURL}
        Wait Until Element Is Visible    ${zed_user_email_field}
        FOR    ${key}    ${value}    IN    &{newUserData}
            IF    '${key}'=='newEmail' and '${value}' != '${EMPTY}'    Type Text    ${zed_user_email_field}    ${value}
            IF    '${key}'=='password' and '${value}' != '${EMPTY}'
                Type Text    ${zed_user_password_filed}    ${value}
                Type Text    ${zed_user_repeat_password_field}    ${value}
            END
            IF    '${key}'=='firstName' and '${value}' != '${EMPTY}'    Type Text    ${zed_user_first_name_field}    ${value}
            IF    '${key}'=='lastName' and '${value}' != '${EMPTY}'    Type Text    ${zed_user_last_name_field}    ${value}
            IF    '${key}'=='user_is_warehouse_user' and '${value}' != '${EMPTY}'
                ${value}=    Convert To Lower Case    ${value}
            END
            IF    '${key}'=='user_is_warehouse_user' and '${value}' == 'true'   
                Zed: Check checkbox by Label:     This user is a warehouse user
            END
            IF    '${key}'=='user_is_warehouse_user' and '${value}' == 'false'   
                Zed: Uncheck Checkbox by Label:    This user is a warehouse user
            END
            IF    '${key}'=='group' and '${value}' != '${EMPTY}'
                Zed: Check checkbox by Label:    ${value}
            END
            IF    '${key}'=='remove group' and '${value}' != '${EMPTY}'
                Zed: Uncheck Checkbox by Label:    ${value}
            END
        END
        Zed: submit the form
    END
    Page Should Not Contain Element    ${zed_user_first_name_field}    message=The user was not updated, check logs for details    timeout=1s


Zed: create new role with name:
    [Documentation]    Create a new role.
    [Arguments]    ${name}
    Zed: go to URL:    /acl/role
    Zed: click button in Header:    Add new Role
    Type Text    ${zed_user_role_name}      ${name}
    Zed: submit the form
    Wait Until Element Is Visible    ${zed_success_flash_message}

Zed: apply access permissions for user role:
    [Arguments]    ${zed_user_role_bundle_access}    ${zed_user_role_controller_access}    ${zed_user_role_action_access}    ${permission_access}
    Select From List By Value    ${zed_user_role_bundle_locator}     ${zed_user_role_bundle_access}
    Select From List By Value    ${zed_user_role_controller_locator}    ${zed_user_role_controller_access}
    Select From List By Value    ${zed_user_role_action_locator}    ${zed_user_role_action_access}
    Select From List By Label    ${zed_user_role_permission}    ${permission_access}
    Click    ${zed_user_add_rule_button}

Zed: create new group with role assigned:
    [Arguments]    ${group_name}    ${role_name}
    Zed: go to URL:    /acl/group
    Zed: click button in Header:    Create Group
    Type Text   ${zed_user_group_title}      ${group_name}
    Type Text     ${zed_user_group_assigned_role_textbox}      ${role_name}
    Keyboard Key    Press    Enter
    Zed: submit the form   
    Wait Until Element Is Visible    ${zed_success_flash_message}

Zed: validate the message when permission is restricted:
    [Arguments]    ${message}
    Element Text Should Be    ${zed_attribute_access_denied_header}    ${message}   

Zed: deactivate the created user:
    [Arguments]    ${email}
    Zed: go to URL:    /user
    Zed: click Action Button in a table for row that contains:    ${email}    Deactivate
    Wait Until Element Is Visible    ${zed_success_flash_message}

 Zed: assign warehouse to user:
    [Arguments]    ${email}
    Zed: go to URL:    /user   