*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_mp.robot
Resource    ../pages/mp/mp_offer_drawer.robot
Resource    ../pages/mp/mp_product_drawer.robot
Resource    ../pages/zed/zed_view_offer_page.robot

*** Keywords ***    
MP: fill offer fields:
    [Arguments]    @{args}
    ${productData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${offer_active_checkbox}
    FOR    ${key}    ${value}    IN    &{productData}
        IF    '${key}'=='is active' and '${value}' != '${EMPTY}'    
            ${checkbox_state}=    Get Element Attribute    xpath=//web-spy-checkbox[@spy-id='productOffer_isActive']//span[@class='ant-checkbox-inner']/../../span[contains(@class,'checkbox')]    class
            IF    'checked' in '${checkbox_state}' and '${value}' == 'false'
                Click    ${offer_active_checkbox}
            ELSE IF    'checked' not in '${checkbox_state}' and '${value}' == 'true'
                Click    ${offer_active_checkbox}
            END
        END
        IF    '${key}'=='merchant sku' and '${value}' != '${EMPTY}'
            Type Text    ${offer_merchant_sku}    ${value}
        END
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'
            Click    ${stores_list_selector}
            MP: select option in expanded dropdown:    ${value}
            Click    ${stores_list_selector}
        END
        IF    '${key}'=='store 2' and '${value}' != '${EMPTY}'
            Click    ${stores_list_selector}
            MP: select option in expanded dropdown:    ${value}
            Click    ${stores_list_selector}
        END
        IF    '${key}'=='stock quantity' and '${value}' != '${EMPTY}'
            Type Text    ${offer_stock_input}    ${value}
        END
        IF    '${key}'=='unselect store' and '${value}' != '${EMPTY}'
            Click    ${stores_list_selector}
            MP: select option in expanded dropdown:    ${value}
            Click    ${stores_list_selector}
        END
        IF    '${key}'=='service point' and '${value}' != '${EMPTY}'
            Click    ${offer_service_point_selector}
            Input Text    ${offer_service_point_search_field}    ${value}
            MP: select option in expanded dropdown:    ${value}
            Click    ${offer_service_point_selector}
        END
        IF    '${key}'=='services' and '${value}' != '${EMPTY}'
            FOR    ${index}    IN RANGE    30
            ${services_dropdown_is_disabled}=    Get Element Attribute    ${offer_services_selector}    class
                IF    'disabled' in '${services_dropdown_is_disabled}'
                    Sleep    1s
                ELSE
                    BREAK
                END
            END
            Click    ${offer_services_selector}
            MP: select option in expanded dropdown:    ${value}
            Click    ${offer_services_selector}
        END
        IF    '${key}'=='shipment types' and '${value}' != '${EMPTY}'
            Click    ${offer_shipment_types_selector}
            MP: select option in expanded dropdown:    ${value}
            Click    ${offer_shipment_types_selector}
        END
    END
            
MP: add offer price:
    [Arguments]    @{args}
    Wait Until Element Is Visible    ${mp_add_price_button}
    Click    ${mp_add_price_button}
    ${priceData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{priceData}
        IF    '${key}'=='row number' and '${value}' != '${EMPTY}'    
            Set Test Variable    ${rowNumber}    ${value}
        ELSE    
            Set Test Variable    ${rowNumber}    1
        END
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'    
            Click    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[1]//spy-select
            MP: select option in expanded dropdown:    ${value}
        END
        IF    '${key}'=='currency' and '${value}' != '${EMPTY}'    
            Click    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[2]//spy-select
            MP: select option in expanded dropdown:    ${value}
        END
        IF    '${key}'=='gross default' and '${value}' != '${EMPTY}'    
            Type Text    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[4]//input    ${value}
        END
        IF    '${key}'=='quantity' and '${value}' != '${EMPTY}'    
            Type Text    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[7]//input    ${value}
        END
    END

MP: save offer    
    MP: click submit button
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    page is not fully loaded
    END
    Disable Automatic Screenshots on Failure
    ${offerSaved}=    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${offer_saved_popup}    timeout=1s
    Restore Automatic Screenshots on Failure
    ### resave in case of error
    IF    'FAIL' in $offerSaved
        TRY
            MP: click submit button    timeout=1s
            Wait Until Element Is Visible    ${offer_saved_popup}    timeout=1s
        EXCEPT    
            Log    Offer is already saved
        END

    END
    MP: remove notification wrapper
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT    
        Log    Page is not loaded
    END
    MP: Wait until loader is no longer visible

MP: change offer stock:
    [Arguments]    @{args}
    MP: open navigation menu tab:    Offers
    ${stockData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{stockData}
        IF    '${key}'=='offer' and '${value}' != '${EMPTY}'
                MP: perform search by:    ${value}
                MP: click on a table row that contains:    ${value}
                Wait Until Element Is Visible    ${offer_active_checkbox}
        END
        IF    '${key}'=='stock quantity' and '${value}' != '${EMPTY}'
            Type Text    ${offer_stock_input}    ${value}
        END
        IF    '${key}'=='is never out of stock' and '${value}' != '${EMPTY}'    
            ${checkbox_state}=    Get Element Attribute    ${offer_always_in_stock_checkbox}    class
            IF    'checked' in '${checkbox_state}' and '${value}' == 'false'
                Click    ${offer_always_in_stock_checkbox}
            ELSE IF    'checked' not in '${checkbox_state}' and '${value}' == 'true'
                Click    ${offer_always_in_stock_checkbox}
            END
        END
    END
    MP: save offer

MP: delete offer price row that contains quantity:
    [Arguments]    ${quantity}
    Scroll Element Into View    xpath=//web-spy-card[@spy-title='Price']//tbody/tr/td[7][contains(.,'${quantity}')]/ancestor::tr//td[@class='ng-star-inserted']/div
    Hover    xpath=//web-spy-card[@spy-title='Price']//tbody/tr/td[7][contains(.,'${quantity}')]/ancestor::tr//td[@class='ng-star-inserted']/div
    Click    ${product_delete_price_row_button}
    Wait Until Element Is Visible    ${product_price_deleted_popup}
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT    
        Log    Page is not loaded
    END
    MP: remove notification wrapper

Zed: view offer page is displayed
    Wait Until Element Is Visible    ${zed_view_offer_page_main_content_locator}

Zed: view offer product page contains:
    [Arguments]    @{args}
    ${offerData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{offerData}
        IF    '${key}'=='approval status' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_offer_approval_status}    ${value}
        END
        IF    '${key}'=='status' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_offer_status}    ${value}
        END
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_offer_store}    ${value}
        END
        IF    '${key}'=='sku' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_offer_sku}    ${value}
        END
        IF    '${key}'=='name' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_offer_name}    ${value}
        END
        IF    '${key}'=='merchant' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_offer_merchant}    ${value}
        END
        IF    '${key}'=='merchant sku' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_offer_merchant_sku}    ${value}
        END
        IF    '${key}'=='services' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_offer_services}    ${value}
        END
        IF    '${key}'=='shipment types' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_offer_shipment_types}    ${value}
        END

    END