*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_mp.robot
Resource    ../pages/mp/mp_profile_page.robot


*** Keywords ***
MP: open profile tab:
    [Arguments]    ${profileTabName}
    Wait Until Element Is Visible    xpath=//div[@class='ant-tabs-nav-list']//div[contains(text(),'${profileTabName}')]
    Click    xpath=//div[@class='ant-tabs-nav-list']//div[contains(text(),'${profileTabName}')]
    TRY
        Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

MP: change store status to:
    [Arguments]    ${store_status}
    Wait Until Element Is Visible    ${store_status_checkbox}
    ${store_is_online}=    Get Element Attribute    ${store_status_checkbox}    checked
    IF    ('${store_status}' == 'true' or '${store_status}' == 'online') and '${store_is_online}' != 'true'
        Click    ${store_status_checkbox}
    ELSE IF    ('${store_status}' == 'false' or '${store_status}' == 'offline') and '${store_is_online}' == 'true'
        Click    ${store_status_checkbox}
    END
    MP: click submit button
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    page is not fully loaded
    END
    Wait Until Element Is Visible    ${mp_success_flyout}    timeout=5s
    Trigger multistore p&s

MP: update profile fields with following data:
    [Arguments]    @{args}
    ${profileData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${store_status_checkbox}
    FOR    ${key}    ${value}    IN    &{profileData}
        IF    '${key}'=='email' and '${value}' != '${EMPTY}'    Type Text    ${merchant_profile_email_field}    ${value}    delay=50ms
        IF    '${key}'=='phone' and '${value}' != '${EMPTY}'    Type Text    ${merchant_profile_phone_field}    ${value}    delay=50ms
        IF    '${key}'=='delivery time' and '${value}' != '${EMPTY}'    Type Text    ${merchant_profile_delivery_time_en_field}    ${value}    delay=50ms
        IF    '${key}'=='data privacy' and '${value}' != '${EMPTY}'     Type Text    ${merchant_profile_data_privacy_en_field}    ${value}    delay=50ms
        IF    '${key}'=='profile url en' and '${value}' != '${EMPTY}'     Type Text    ${merchant_profile_store_profile_url_en_field}    ${value}    delay=50ms
        IF    '${key}'=='profile url de' and '${value}' != '${EMPTY}'     Type Text    ${merchant_profile_store_profile_url_de_field}    ${value}    delay=50ms
    END  
    Sleep    0.5s
