*** Settings ***
Library    String
Resource    ../pages/zed/zed_payment_methods_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Keywords ***
Zed: wait for payment method:
    [Arguments]    ${provider}    ${name}
    Try reloading page until element is/not appear:    xpath=//table//tr/td[text()='${provider}']/../td[text()='${name}']/..//a[contains(@class,'btn-edit')]    true    20    10s

Zed: activate/deactivate payment method:
    [Arguments]    ${provider}    ${name}    ${activate}=true    ${stores}=DE,AT
    Zed: go to URL:    /payment-gui/payment-method
    Zed: wait for payment method:    ${provider}    ${name}
    ${activate}=    Convert To String    ${activate}
    ${activate}=    Convert To Lower Case    ${activate}
    Click    xpath=//table//tr/td[text()='${provider}']/../td[text()='${name}']/..//a[contains(@class,'btn-edit')]
    IF    '${activate}' == 'true' or '${activate}' == 'activate'
        Zed: check checkbox by label:    Is the Payment Method active?
    ELSE
        Zed: uncheck checkbox by label:    Is the Payment Method active?
    END
    Zed: go to tab by link href that contains:    store-relation
    ${storesList}=    split string    ${stores}    ,
    ${storesListLength}=    get length    ${storesList}
    FOR    ${index}    IN RANGE    0    ${storesListLength}
        ${store}=    get from list    ${storesList}    ${index}
        IF    '${activate}' == 'true' or '${activate}' == 'activate'
            Zed: check checkbox by label:    ${store}
        ELSE
            Zed: uncheck checkbox by label:    ${store}
        END
    END
    Zed: submit the form
    Zed: flash message should be shown:    success
