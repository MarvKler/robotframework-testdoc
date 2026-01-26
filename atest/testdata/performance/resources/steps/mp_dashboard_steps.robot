*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_mp.robot
Resource    ../../resources/pages/mp/mp_dashboard_page.robot

*** Keywords ***
MP: click button on dashboard page and check url:
    [Arguments]    ${button_name}    ${expected_rel_url}
    ${currentURL}=    Get Location
    IF    'dashboard' not in '${currentURL}'    MP: open navigation menu tab:    Dashboard
    ${button_name}=    Convert To Lower Case    ${button_name}
    IF    '${button_name}' == 'manage offers'
        Click    ${mp_dashboard_manage_offers_button}
        ${location}=    Get Url
        Should Contain    ${location}    ${expected_rel_url}
    ELSE IF    '${button_name}' == 'add offer'
        Click    ${mp_dashboard_add_offer_button}
        ${location}=    Get Url
        Should Contain    ${location}    ${expected_rel_url}
    ELSE IF    '${button_name}' == 'manage orders'
        Click    ${mp_dashboard_manage_orders_button}
        ${location}=    Get Url
        Should Contain    ${location}    ${expected_rel_url}
    END