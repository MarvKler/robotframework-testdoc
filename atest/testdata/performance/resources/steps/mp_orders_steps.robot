*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_mp.robot
Resource    ../pages/mp/mp_order_drawer.robot

*** Keywords ***
MP: wait for order to appear:
    [Arguments]    ${orderReference}    ${tries}=20    ${timeout}=1s
    Trigger oms
    FOR    ${index}    IN RANGE    0    ${tries}
        MP: perform search by:    ${orderReference}
        Disable Automatic Screenshots on Failure
        ${elementAppears}=    Run Keyword And Return Status    Table Should Contain    ${mp_items_table}     ${orderReference}
        Restore Automatic Screenshots on Failure
        IF    '${elementAppears}'=='False'
            Sleep    ${timeout}
            Reload
        ELSE
            Exit For Loop
        END
    END
    IF    ${index} == ${tries}-1
        Take Screenshot    EMBED    fullPage=True
        Fail    'Timeout exceeded, merchant order was not created'
    END

MP: order grand total should be:
    [Arguments]    ${expectedTotal}
    Wait Until Element Is Visible    ${order_grand_total}
    Element Text Should Be    ${order_grand_total}    ${expectedTotal}

MP: order states on drawer should contain:
    [Arguments]    ${expectedState}
    Wait Until Element Is Visible    ${order_state_label_on_drawer}
    Element Should Contain    ${order_state_label_on_drawer}    ${expectedState}

MP: update order state using header button:
    [Arguments]    ${buttonName}
    Wait Until Element Is Enabled    xpath=//div[@class='mp-manage-order__transitions']//button[.//text()[normalize-space()='${buttonName}']]
    Click    xpath=//div[@class='mp-manage-order__transitions']//button[.//text()[normalize-space()='${buttonName}']]
    Wait For Response
    TRY
        Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    Wait Until Element Is Visible    ${mp_success_flyout}
    MP: remove notification wrapper
    Trigger oms

MP: change order item state on:
    [Arguments]    ${sku}    ${state}
    Wait Until Element Is Visible    xpath=//web-mp-order-items-table[@table-id='web-mp-order-items-table']//spy-table[@class='spy-table']//tbody
    Click    xpath=//web-mp-order-items-table[@table-id='web-mp-order-items-table']//spy-table[@class='spy-table']//tbody//td[contains(@class,'ant-table-cell')]//*[contains(text(),'${sku}')]/ancestor::tr/td//spy-checkbox
    Click    xpath=//*[contains(@class,'table-features')]//*[contains(@class,'batch-actions')]//button[.//text()[normalize-space()='${state}']]
    Wait For Response
    TRY
        Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    Wait Until Element Is Visible    ${mp_success_flyout}
    MP: remove notification wrapper
    Trigger oms

MP: order item state should be:
    [Arguments]    ${sku}    ${state}
    Wait Until Element Is Visible    xpath=//web-mp-order-items-table[@table-id='web-mp-order-items-table']//spy-table[@class='spy-table']//tbody
    Page Should Contain Element    xpath=//web-mp-order-items-table[@table-id='web-mp-order-items-table']//spy-table[@class='spy-table']//tbody//td[contains(@class,'ant-table-cell')]//*[contains(text(),'${sku}')]/ancestor::tr/td//spy-chips[contains(text(),'${state}')]
