*** Settings ***
Resource    ../common/common_ui.robot
Resource    ../pages/yves/yves_merchant_profile.robot
Resource    ../pages/yves/yves_header_section.robot

*** Variables ***

*** Keywords ***
Yves: assert merchant profile fields:
    [Arguments]    @{args}
    ${profileData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${merchant_profile_main_content_locator}
    FOR    ${key}    ${value}    IN    &{profileData}
        IF    '${key}'=='email' and '${value}' != '${EMPTY}'    Run Keywords    
        ...    Try reloading page until element does/not contain text:    ${merchant_profile_email_locator}    ${value}    true    26    5s
        ...    AND    Element Text Should Be    ${merchant_profile_email_locator}    ${value}
        IF    '${key}'=='name' and '${value}' != '${EMPTY}'    Run Keywords    
            ...    Try reloading page until element does/not contain text:    ${merchant_profile_name_header_locator}[${env}]    ${value}    true    26    5s
        ...    AND    Element Text Should Be    ${merchant_profile_name_header_locator}[${env}]    ${value}
        IF    '${key}'=='phone' and '${value}' != '${EMPTY}'    Element Text Should Be    ${merchant_profile_phone_locator}    ${value}
        IF    '${key}'=='delivery time' and '${value}' != '${EMPTY}'    Element Text Should Be    ${merchant_profile_delivery_time_locator}    ${value}
        IF    '${key}'=='data privacy' and '${value}' != '${EMPTY}'     Element Text Should Be    ${merchant_profile_data_privacy_locator}    ${value}
    END  