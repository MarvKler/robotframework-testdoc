*** Settings ***
Resource    ../pages/zed/zed_customer_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_glossary_page.robot

*** Keywords ***
Zed: fill glossary form:
    [Documentation]    fill the input fields required for creating translation.
    [Arguments]    @{args}
    ${registrationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{registrationData}
        IF    '${key}'=='Name' and '${value}' != '${EMPTY}'   Type Text    ${zed_translation_name}    ${value}
        IF    '${key}'=='EN_US' and '${value}' != '${EMPTY}'   Type Text    ${zed_translation_EN_US}    ${value}
        IF    '${key}'=='DE_DE' and '${value}' != '${EMPTY}'   Type Text    ${zed_translation_DE_DE}     ${value}
    END

Zed: undo the changes in glossary translation:
    [Arguments]    ${glossaryName}    ${original_DE}    ${original_EN}    ${admin_email}=${zed_admin_email}
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
    Zed: go to URL:    /glossary
    Zed: click Action Button in a table for row that contains:    ${glossaryName}    Edit  
    Zed: fill glossary form:
    ...    || DE_DE          | EN_US          ||
    ...    || ${original_DE} | ${original_EN} ||
    Zed: submit the form