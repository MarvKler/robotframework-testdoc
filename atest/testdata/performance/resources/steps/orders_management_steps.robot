*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_zed.robot
Resource    ../pages/yves/yves_return_slip_page.robot
Resource    ../pages/zed/zed_create_return_page.robot
Resource    ../pages/zed/zed_return_details_page.robot
Resource    ../steps/order_history_steps.robot
Resource    ../pages/zed/zed_order_details_page.robot

*** Keywords ***
Zed: go to order page:
    [Arguments]    ${orderID}
    Zed: go to URL:    /sales
    Zed: click Action Button in a table for row that contains:    ${orderID}    View
    ${is_order_page_loaded}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_order_details_main_content_locator}
    IF    not ${is_order_page_loaded}
        Zed: go to URL:    /sales
        Zed: click Action Button in a table for row that contains:    ${orderID}    View
        Wait Until Page Contains Element    ${zed_order_details_main_content_locator}    message=Order details page is not loaded
    END

Zed: go to my order page:
    [Documentation]    Marketplace specific method, to see this page you should be logged in as zed_spryker_merchant_admin_email
    [Arguments]    ${orderID}    ${delay}=10s    ${iterations}=15
    Zed: go to URL:    /merchant-sales-order-merchant-user-gui
    Zed: perform search by:    ${orderID}
    FOR    ${index}    IN RANGE    1    ${iterations}
        Disable Automatic Screenshots on Failure
        ${merchant_order_is_created}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//table[contains(@class,'dataTable')]/tbody//td[contains(text(),'${orderID}')]/../td[contains(@class,'column-Action') or contains(@class,'column-action')]    timeout=1s
        Restore Automatic Screenshots on Failure
        IF    '${merchant_order_is_created}'=='False'
            Run Keywords    Sleep    ${delay}    AND    Reload
        ELSE
            Exit For Loop
        END
        IF    ${index} == 2 or ${index} == 5
            Trigger oms
        END
        IF    ${index} == ${iterations}-1
            Take Screenshot    EMBED    fullPage=True
            Fail    Expected merchant order with reference '${orderID}' is not available/was not created'. Check if OMS is functional
        END
    END
    Zed: click Action Button in a table for row that contains:    ${orderID}    View
    ${is_order_page_loaded}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_order_details_main_content_locator}
    IF    not ${is_order_page_loaded}
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        Zed: go to URL:    /merchant-sales-order-merchant-user-gui
        Zed: perform search by:    ${orderID}
        Zed: click Action Button in a table for row that contains:    ${orderID}    View
        Wait Until Page Contains Element    ${zed_order_details_main_content_locator}    message=Order details page is not loaded
    END

Zed: trigger all matching states inside xxx order:
    [Arguments]    ${orderID}    ${status}
    Zed: go to order page:    ${orderID}
    ${is_order_page_loaded}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_order_details_main_content_locator}
    IF    not ${is_order_page_loaded}
        Zed: go to order page:    ${orderID}
        Wait Until Page Contains Element    ${zed_order_details_main_content_locator}    message=Order details page is not loaded
    END
    Zed: trigger all matching states inside this order:    ${status}

Zed: trigger all matching states inside this order:
    [Arguments]    ${status}    ${delay}=3s    ${iterations}=21
    Trigger oms
    Reload
    Page Should Contain Element    ${zed_order_details_main_content_locator}    message=Order details page is not loaded
    FOR    ${index}    IN RANGE    1    ${iterations}
        Disable Automatic Screenshots on Failure
        ${order_state_reached}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']
        Restore Automatic Screenshots on Failure
        IF    '${order_state_reached}'=='False'
            Run Keywords    Sleep    ${delay}    AND    Reload
        ELSE
            Exit For Loop
        END
        IF    ${index} == 2 or ${index} == 5
            Trigger oms
        END
        IF    ${index} == ${iterations}-1
            Scroll Element Into View    xpath=(//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'])[1]
            Take Screenshot    EMBED    fullPage=True
            ${order_available_states}=    Set Variable    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']
            ${order_available_states_count}=    Get Element Count    ${order_available_states}
            ${order_available_states}=    Create List
            FOR    ${index}    IN RANGE    1    ${order_available_states_count}+1
                ${order_available_state}=    Get Text    xpath=(//div[@id='order-overview']//form[@name='oms_trigger_form'])[${index}]
                Append To List    ${order_available_states}    ${order_available_state}
            END
            Fail    Expected order state transition '${status}' is not available. Only '${order_available_states}' is/are available. Check if OMS is functional
        END
    END
    Click and retry if 5xx occurred:    xpath=//div[@id='order-overview']//form[@name='oms_trigger_form']//button[@id='oms_trigger_form_submit'][text()='${status}']

Zed: trigger matching state of xxx merchant's shipment:
    [Documentation]    Marketplace specific method, suitable for My Orders of merchant. Triggers action for whole shipment
    [Arguments]    ${shipment_number}    ${event}    ${delay}=4s    ${iterations}=20
    Trigger oms
    Reload
    ${elementSelector}=    Set Variable    xpath=//div[@id='items']//h3[contains(.,'Shipment ${shipment_number}')]/../../following-sibling::div[2]//form[@name='event_trigger_form']//button[@id='event_trigger_form_submit'][text()='${event}']
    ${shipment_available_transitions_count}=    Get Element Count    xpath=//div[@id='items']//h3[contains(.,'Shipment ${shipment_number}')]/../../following-sibling::div[2]//form[@name='event_trigger_form']//button[@id='event_trigger_form_submit']
    ${shipment_available_transitions}=    Create List
    Set Browser Timeout    1s
    FOR    ${index}    IN RANGE    1    ${shipment_available_transitions_count}+1
        ${shipment_available_transition}=    Get Text    xpath=(//div[@id='items']//h3[contains(.,'Shipment ${shipment_number}')]/../../following-sibling::div[2]//form[@name='event_trigger_form']//button[@id='event_trigger_form_submit'])[${index}]
        Append To List    ${shipment_available_transitions}    ${shipment_available_transition}
    END
    Set Browser Timeout    ${browser_timeout}
    ${shipment_available_transitions}=    Convert To String    ${shipment_available_transitions}
    FOR    ${index}    IN RANGE    1    ${iterations}
        Disable Automatic Screenshots on Failure
        ${expected_oms_transition_is_available}=    Run Keyword And Return Status    Page Should Contain Element    ${elementSelector}    timeout=1s
        Restore Automatic Screenshots on Failure
        IF    '${expected_oms_transition_is_available}'=='False'
            Run Keywords    Sleep    ${delay}    AND    Reload
        ELSE
            Exit For Loop
        END
        IF    ${index} == 2 or ${index} == 5
            Trigger oms
        END
        IF    ${index} == ${iterations}-1
            Take Screenshot    EMBED    fullPage=True
            Fail    Expected shipment state transition '${event}' for shipment# '${shipment_number}' is not available. Only '${shipment_available_transitions}' is/are available. Check if OMS is functional
        END
    END
    Click and retry if 5xx occurred:    ${elementSelector}

Zed: trigger matching state of order item inside xxx shipment:
    [Arguments]    ${sku}    ${event}    ${shipment}=1    ${delay}=4s    ${iterations}=20
    Trigger oms
    Reload
    IF    '${env}' in ['ui_mp_b2b','ui_mp_b2c']
        ${elementSelector}=    Set Variable    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr//td/form[@name='event_item_trigger_form']//button[contains(text(),'${event}')]
    ELSE
        ${elementSelector}=    Set Variable    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//td/div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr/td/form[@class='oms-trigger-form']//button[contains(text(),'${event}')] 
    END   
    IF    '${env}' in ['ui_mp_b2b','ui_mp_b2c']
        ${item_available_transition_selector}=    Set Variable    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr//td/form[@name='event_item_trigger_form']//button
    ELSE
        ${item_available_transition_selector}=    Set Variable    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//td/div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr/td/form[@class='oms-trigger-form']//button
    END   
    ${item_available_transitions_count}=    Get Element Count    ${item_available_transition_selector}
    ${item_available_transitions}=    Create List
    Set Browser Timeout    1s
    ${item_available_transition}=    Set Variable
    FOR    ${index}    IN RANGE    1    ${item_available_transitions_count}+1
        IF    '${env}' in ['ui_mp_b2b','ui_mp_b2c']
            ${item_available_transition}=    Get Text    xpath=(//table[@data-qa='order-item-list'][${shipment}]/tbody//td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr//td/form[@name='event_item_trigger_form']//button)[${index}]
        ELSE
            ${item_available_transition}=    Get Text    xpath=(//table[@data-qa='order-item-list'][${shipment}]/tbody//td/div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr/td/form[@class='oms-trigger-form']//button)[${index}]
        END
        Append To List    ${item_available_transitions}    ${item_available_transition}
    END
    Set Browser Timeout    ${browser_timeout}
    ${item_available_transition}=    Convert To String    ${item_available_transition}
    FOR    ${index}    IN RANGE    1    ${iterations}
        Disable Automatic Screenshots on Failure
        ${expected_oms_transition_is_available}=    Run Keyword And Return Status    Page Should Contain Element    ${elementSelector}    timeout=1s
        Restore Automatic Screenshots on Failure
        IF    '${expected_oms_transition_is_available}'=='False'
            Run Keywords    Sleep    ${delay}    AND    Reload
        ELSE
            Exit For Loop
        END
        IF    ${index} == 2 or ${index} == 5
            Trigger oms
        END
        IF    ${index} == ${iterations}-1
            Take Screenshot    EMBED    fullPage=True
            Fail    Expected item state transition '${event}' for item '${sku}' is not available. Only '${item_available_transitions}' is/are available. Check if OMS is functional
        END
    END
    Click and retry if 5xx occurred:    ${elementSelector}

Zed: trigger matching state of xxx order item inside xxx shipment:
    [Arguments]    ${event}    ${item_number}=1    ${shipment}=1    ${delay}=4s    ${iterations}=20
    Trigger oms
    Reload
    ${elementSelector}=    Set Variable    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//tr[${item_number}]//td//form[contains(@name,'trigger_form')]//button[contains(text(),'${event}')]
    ${item_available_transitions_count}=    Get Element Count    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//tr[${item_number}]//td//form[contains(@name,'trigger_form')]//button
    ${item_available_transitions}=    Create List
    Set Browser Timeout    1s
    FOR    ${index}    IN RANGE    1    ${item_available_transitions_count}+1
        ${item_available_transition}=    Get Text    xpath=(//table[@data-qa='order-item-list'][${shipment}]/tbody//tr[${item_number}]//td//form[contains(@name,'trigger_form')]//button)[${index}]
        Append To List    ${item_available_transitions}    ${item_available_transition}
    END
    Set Browser Timeout    ${browser_timeout}
    ${item_available_transitions}=    Convert To String    ${item_available_transitions}
    FOR    ${index}    IN RANGE    1    ${iterations}
        Disable Automatic Screenshots on Failure
        ${expected_oms_transition_is_available}=    Run Keyword And Return Status    Page Should Contain Element    ${elementSelector}    timeout=1s
        Restore Automatic Screenshots on Failure
        IF    '${expected_oms_transition_is_available}'=='False'
            Run Keywords    Sleep    ${delay}    AND    Reload
        ELSE
            Exit For Loop
        END
        IF    ${index} == 2 or ${index} == 5
            Trigger oms
        END
        IF    ${index} == ${iterations}-1
            Take Screenshot    EMBED    fullPage=True
            Fail    Expected item state transition '${event}' for item number '${item_number}' is not available in shipment# '${shipment}'. Only '${item_available_transitions}' is/are available. Check if OMS is functional
        END
    END
    Click and retry if 5xx occurred:    ${elementSelector}

Zed: wait for order item to be in state:
    [Arguments]    ${sku}    ${state}    ${shipment}=1    ${delay}=10s    ${iterations}=20
    FOR    ${index}    IN RANGE    1    ${iterations}
        Disable Automatic Screenshots on Failure
        ${order_item_state_reached}=    Run Keyword And Return Status    Page Should Contain Element    xpath=(//table[@data-qa='order-item-list'][${shipment}]/tbody//td/div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr/td[@class='state-history']//a[contains(text(),'${state}')])[1]    timeout=1s
        Restore Automatic Screenshots on Failure
        IF    '${order_item_state_reached}'=='False'
            Run Keywords    Sleep    ${delay}    AND    Reload
        ELSE
            Exit For Loop
        END
        IF    ${index} == 2 or ${index} == 5
            Trigger oms
        END
        IF    ${index} == ${iterations}-1
            Take Screenshot    EMBED    fullPage=True
            ${order_item_current_state}=    Get Text    xpath=(//table[@data-qa='order-item-list'][${shipment}]/tbody//td/div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr/td[@class='state-history'])//a[1][@href]
            Fail    Expected order item state '${state}' is not available for the item '${sku}'. Current order item state is '${order_item_current_state}'. Check if OMS is functional
        END
    END

Yves: create return for the following products:
    [Arguments]    @{sku_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        Click    xpath=(//form[@name='return_create_form']//div[@data-qa='component return-product-item']//*[contains(text(),'${sku_to_check}')]/ancestor::div[@data-qa='component return-product-item']/../div[contains(@class,'col')]//span[contains(@class,'checkbox')])[1]
    END
    Click    ${create_return_button}[${env}]
    Trigger oms

Yves: check that 'Print Slip' contains the following products:
    [Arguments]    @{sku_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    IF    'local' not in '${yves_url}' or 'false' in '${headless}'
        Click    ${return_details_print_slip_button}
        TRY
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
        ### Wait until new page (pop-up) is displayed ###
        Sleep    3s
        ${context}=    Get Browser Catalog
        ${page_count}=    Get Length    ${context[0]['contexts'][0]['pages']}
        IF    ${page_count}<2
            Sleep    7s
            ${context}=    Get Browser Catalog
        END
        ${print_slip_page_id}=    Evaluate    [page['id'] for page in ${context[0]['contexts'][0]['pages']} if '/return/slip-print/' in page['url']]
        ${print_slip_page_length}=    Get Length    ${print_slip_page_id}
        IF    ${print_slip_page_length}>0
            ${print_slip_page_url}=    Evaluate    [page['url'] for page in ${context[0]['contexts'][0]['pages']} if '/return/slip-print/' in page['url']]
            ${print_slip_page_url}=    Get From List    ${print_slip_page_url}    0
            Go To    ${print_slip_page_url}
            Wait Until Page Contains Element    ${return_slip_products_table}
            ${sku_list_count}=   get length  ${sku_list}
            FOR    ${index}    IN RANGE    0    ${sku_list_count}
                ${sku_to_check}=    Get From List    ${sku_list}    ${index}
                Table Should Contain    ${return_slip_products_table}    ${sku_to_check}
            END
        ELSE
            Log    New browser page did not open, there is nothing to switch to
        END
    END

Zed: create a return for the following order and product in it:
    [Arguments]    ${orderID}    @{sku_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    Zed: go to URL:    /sales
    Zed: click Action Button in a table for row that contains:    ${orderID}    View
    ${is_order_page_loaded}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_order_details_main_content_locator}
    IF    not ${is_order_page_loaded}
        Zed: go to URL:    /sales
        Zed: click Action Button in a table for row that contains:    ${orderID}    View
        Wait Until Page Contains Element    ${zed_order_details_main_content_locator}    message=Order details page is not loaded
    END
    Wait Until Page Contains Element    xpath=//div[@class='title-action']/a[contains(.,'Return')]
    Click Element by xpath with JavaScript    //div[@class='title-action']/a[contains(.,'Return')]
    Wait Until Page Contains Element    ${zed_create_return_main_content_locator}
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        Click    xpath=//table[@data-qa='order-item-list']//td/div[contains(@class,'sku')][contains(.,'${sku_to_check}')]/ancestor::tr//div[@class='form-check']//input
    END
    Click    ${zed_create_return_button}
    Wait Until Page Contains Element    ${zed_return_details_main_content_locator}
    Trigger oms

Zed: grand total for the order equals:
    [Arguments]    ${orderID}    ${grandTotal}
    Zed: go to URL:    /sales
    Zed: perform search by:    ${orderID}
    Table Should Contain    ${zed_table_locator}  ${grandTotal}

Zed: get the last placed order ID of the customer by email:
    [Documentation]    Returns orderID of the last order from the Backoffice by email
    [Arguments]    ${email}
    Zed: go to URL:    /sales
    Zed: perform search by:    ${email}
    ${zedLastPlacedOrder}=    Get Text    xpath=//table[contains(@data-ajax,'sales')][contains(@class,'dataTable')]/tbody/tr[1]/td[2]
    Set Suite Variable    ${zedLastPlacedOrder}    ${zedLastPlacedOrder}
    RETURN    ${zedLastPlacedOrder}

Zed: order has the following number of shipments:
    [Arguments]    ${orderID}    ${expectedShipments}    ${timeout}=5s
    Zed: go to URL:    /sales
    Zed: click Action Button in a table for row that contains:    ${orderID}    View
    ${is_order_page_loaded}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_order_details_main_content_locator}
    IF    not ${is_order_page_loaded}
        Zed: go to URL:    /sales
        Zed: click Action Button in a table for row that contains:    ${orderID}    View
        Wait Until Page Contains Element    ${zed_order_details_main_content_locator}    message=Order details page is not loaded
    END
    TRY
        Wait Until Element Is Visible    xpath=//table[@data-qa='order-item-list'][1]    timeout=${timeout}
    EXCEPT
        Reload
        Wait Until Element Is Visible    xpath=//table[@data-qa='order-item-list'][1]
    END
    ${actualShipments}=    Get Element Count    xpath=//table[@data-qa='order-item-list']
    Should Be Equal    '${expectedShipments}'    '${actualShipments}'    msg=Expected '${expectedShipments}' number of shipments inside the '${orderID}' order, but got '${actualShipments}'

Zed: return details page contains the following items:
    [Arguments]    @{sku_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    Wait Until Page Contains Element    ${zed_return_details_main_content_locator}
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        Page Should Contain Element    xpath=//table[@data-qa='return-items-table']//td//a[contains(@href,'view/variant')]/../div[@class='sku'][contains(.,'${sku_to_check}')]    message=Return details page doesn't contain '${sku_list}' but should.
    END

Zed: view the latest return from My Returns:
    [Arguments]    ${return_id}
    Zed: click Action Button in a table for row that contains:    ${return_id}    View
    Wait Until Page Contains Element    ${zed_return_details_main_content_locator}

Zed: billing address for the order should be:
    [Arguments]    ${expected_billing_address}
    Wait Until Page Contains Element    ${order_details_billing_address}
    Element Should Contain    ${order_details_billing_address}    ${expected_billing_address}

Zed: shipping address inside xxx shipment should be:
    [Arguments]    ${shipment}    ${expected_address}
    TRY
        Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/preceding-sibling::div[2]//p[1]    ${expected_address}    timeout=5s
    EXCEPT
        Reload
        Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/preceding-sibling::div[2]//p[1]    ${expected_address}
    END

Zed: create new shipment inside the order:
    [Arguments]    @{args}
    ${newShipmentData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${create_shipment_button}
    Click    ${create_shipment_button}
    Wait Until Element Is Visible    ${create_shipment_delivery_address_dropdown}
    FOR    ${key}    ${value}    IN    &{newShipmentData}
        IF    '${key}'=='delivery address' and '${value}' != '${EMPTY}'    Select From List By Label    ${create_shipment_delivery_address_dropdown}    ${value}
        IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    ${create_shipment_salutation_dropdown}    ${value}
        IF    '${key}'=='first name' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_first_name_field}    ${value}
        IF    '${key}'=='last name' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_last_name_field}    ${value}
        IF    '${key}'=='email' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_email_field}    ${value}
        IF    '${key}'=='country' and '${value}' != '${EMPTY}'    Select From List By Label    ${create_shipment_country_dropdown}    ${value}
        IF    '${key}'=='address 1' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_address_1_field}    ${value}
        IF    '${key}'=='address 2' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_address_2_field}    ${value}
        IF    '${key}'=='city' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_city_field}    ${value}
        IF    '${key}'=='zip code' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_zip_code_field}    ${value}
        IF    '${key}'=='shipment method' and '${value}' != '${EMPTY}'    Select From List By Label    ${create_shipment_shipment_method}    ${value}
        IF    '${key}'=='requested delivery date' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_requested_delivery_date}    ${value}
        IF    '${key}'=='sku' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
        IF    '${key}'=='sku 2' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
        IF    '${key}'=='sku 3' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
        IF    '${key}'=='sku 4' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
        IF    '${key}'=='sku 5' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
    END
    Zed: submit the form
    Wait Until Element Is Visible    ${order_details_billing_address}

Zed: edit xxx shipment inside the order:
    [Arguments]    @{args}
    ${newShipmentData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    xpath=(//div[@class='ibox-content']//a[contains(@href,'shipment-gui/edit')])[${shipmentN}]
    Click    ${create_shipment_button}
    Wait Until Element Is Visible    ${create_shipment_delivery_address_dropdown}
    FOR    ${key}    ${value}    IN    &{newShipmentData}
        IF    '${key}'=='delivery address' and '${value}' != '${EMPTY}'    Select From List By Label    ${create_shipment_delivery_address_dropdown}    ${value}
        IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    ${create_shipment_salutation_dropdown}    ${value}
        IF    '${key}'=='first name' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_first_name_field}    ${value}
        IF    '${key}'=='last name' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_last_name_field}    ${value}
        IF    '${key}'=='email' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_email_field}    ${value}
        IF    '${key}'=='country' and '${value}' != '${EMPTY}'    Select From List By Label    ${create_shipment_country_dropdown}    ${value}
        IF    '${key}'=='address 1' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_address_1_field}    ${value}
        IF    '${key}'=='address 2' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_address_2_field}    ${value}
        IF    '${key}'=='city' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_city_field}    ${value}
        IF    '${key}'=='zip code' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_zip_code_field}    ${value}
        IF    '${key}'=='shipment method' and '${value}' != '${EMPTY}'    Select From List By Label    ${create_shipment_shipment_method}    ${value}
        IF    '${key}'=='requested delivery date' and '${value}' != '${EMPTY}'    Type Text    ${create_shipment_requested_delivery_date}    ${value}
        IF    '${key}'=='sku' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
        IF    '${key}'=='sku 2' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
        IF    '${key}'=='sku 3' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
        IF    '${key}'=='sku 4' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
        IF    '${key}'=='sku 5' and '${value}' != '${EMPTY}'    Check Checkbox    xpath=//table[@data-qa='order-item-list']/tbody//td//div[@class='sku'][contains(.,'${value}')]/ancestor::tr/td[@class='item-checker']//input
    END
    Zed: submit the form
    Wait Until Element Is Visible    ${order_details_billing_address}

Zed: shipment data inside xxx shipment should be:
    [Arguments]    @{args}
    ${shipmentData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{shipmentData}
        IF    '${key}'=='shipment n' and '${value}' != '${EMPTY}'    
        ${shipment}=    Set Variable    ${value}
        END
        IF    '${key}'=='shipment n' and '${value}' == '${EMPTY}'    
        ${shipment}=    Set Variable    1
        END
        IF    '${key}'=='delivery method' and '${value}' != '${EMPTY}'    Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/preceding-sibling::div[2]//p[2]    ${value}
        IF    '${key}'=='shipping method' and '${value}' != '${EMPTY}'    Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/preceding-sibling::div[2]//p[3]    ${value}
        IF    '${key}'=='shipping costs' and '${value}' != '${EMPTY}'    Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/preceding-sibling::div[2]//p[4]    ${value}
        IF    '${key}'=='requested delivery date' and '${value}' != '${EMPTY}'    Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/preceding-sibling::div[2]//p[5]    ${value}
    END

Zed: xxx shipment should/not contain the following products:
    [Arguments]    ${shipment}    ${condition}    @{sku_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${condition}=    Convert To Lower Case    ${condition}
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        IF    '${condition}' == 'true'
            Table Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]    ${sku_to_check}
        END
        IF    '${condition}' == 'false'
            Table Should Not Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]    ${sku_to_check}
        END
    END

Yves: cancel the order:
    [Arguments]    ${order_id}
    Trigger oms
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${order_id}
    Yves: try reloading page if element is/not appear:    ${order_details_cancel_button_locator}    true
    Wait Until Element Is Visible    ${order_details_cancel_button_locator}
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    Click    ${order_details_cancel_button_locator}
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    Wait Until Element Is Not Visible    ${order_details_cancel_button_locator}
    Yves: go to 'Order History' page
    Yves: 'Order History' page contains the following order with a status:    ${order_id}    Canceled
    Trigger oms