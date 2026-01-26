*** Settings ***
Resource    ../pages/zed/zed_create_zed_user_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/yves/yves_agent_assist_page.robot

*** Keywords ***
Zed: create new Zed user with the following data:
    [Arguments]    ${zedUserEmail}    ${zedUserPassword}   ${zedUserFirstName}    ${zedUserLastName}    ${checkboxGroup}   ${checkboxAgent}    ${userInterfaceLanguage}
    ${currentURL}=    Get Location
    IF    '/user' not in '${currentURL}'    Zed: go to URL:    /user
    IF    '${env}' in ['ui_mp_b2b']
        Zed: click button in Header:    Add New User
    ELSE 
        Zed: click button in Header:    Add New User
    END
    Wait Until Element Is Visible    ${zed_user_email_field}
    Type Text    ${zed_user_email_field}    ${zedUserEmail}
    Type Text    ${zed_user_password_filed}    ${zedUserPassword}
    Type Text    ${zed_user_repeat_password_field}    ${zedUserPassword}
    Type Text    ${zed_user_first_name_field}    ${zedUserFirstName}
    Type Text    ${zed_user_last_name_field}    ${zedUserLastName}
    Zed: Check checkbox by Label:    ${checkboxGroup}
    Zed: Check checkbox by Label:    ${checkboxAgent}
    Select From List By Label    ${zed_user_interface_language}    ${userInterfaceLanguage}
    Zed: submit the form
    IF    '${env}' in ['ui_mp_b2b']
        Zed: wait for button in Header to be visible:    Add New User    ${browser_timeout}
    ELSE 
        Zed: wait for button in Header to be visible:    Add New User    ${browser_timeout}
    END
    Zed: table should contain:    ${zedUserEmail}

Yves: perform search by customer:
    [Arguments]    ${searchQuery}
    Type Text    ${agent_customer_search_widget}    ${searchQuery}    delay=10ms
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

Yves: agent widget contains:
    [Arguments]    ${searchQuery}
    Wait Until Element Is Visible    xpath=//ul[@data-qa='component customer-list']/li[@data-value='${searchQuery}']
    Page Should Contain Element    xpath=//ul[@data-qa='component customer-list']/li[@data-value='${searchQuery}']

Yves: as an agent login under the customer:
    [Arguments]    ${searchQuery}
    Fill Text    ${agent_customer_search_widget}    ${EMPTY}    force=True
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    Yves: perform search by customer:    ${searchQuery}
    Wait Until Element Is Visible    //ul[@data-qa='component customer-list']/li[@data-value='${searchQuery}']
    Click    xpath=//ul[@data-qa='component customer-list']/li[@data-value='${searchQuery}']
    Click    ${agent_confirm_login_button}

Yves: end customer assistance
    Click    ${end_customer_assistance}

Yves: logout as an agent
    Click    ${agent_logout}