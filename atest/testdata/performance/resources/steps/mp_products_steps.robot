*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_mp.robot
Resource    ../pages/mp/mp_product_drawer.robot

*** Keywords ***
MP: fill product price values:
    [Arguments]    @{args}
    ${priceData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{priceData}
        IF    '${key}'=='product type' and '${value}' == 'concrete'
            ${checkbox_state}=    Get Element Attribute    ${mp_use_abstract_price_checkbox}    class
            IF    'checked' in '${checkbox_state}'
                Click    ${mp_use_abstract_price_checkbox}
            END
            Wait Until Element Is Visible    ${mp_add_concrete_price_button}
            Click    ${mp_add_concrete_price_button}
        END
        IF    '${key}'=='product type' and '${value}' == 'abstract'    Run Keywords
        ...    Wait Until Element Is Visible    ${mp_add_price_button}
        ...    AND    Click    ${mp_add_price_button}
        IF    '${key}'=='row number' and '${value}' != '${EMPTY}'    
            Set Test Variable    ${rowNumber}    ${value}
        ELSE    
            Set Test Variable    ${rowNumber}    1
        END
        IF    '${env}' in ['ui_mp_b2b']
            IF    '${key}'=='customer' and '${value}' != '${EMPTY}'    Run Keywords
            ...    Click    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[1]//spy-select
            ...    AND    MP: select option in expanded dropdown:    ${value}
            IF    '${key}'=='store' and '${value}' != '${EMPTY}'    Run Keywords
            ...    Click    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[2]//spy-select
            ...    AND    MP: select option in expanded dropdown:    ${value}
            IF    '${key}'=='currency' and '${value}' != '${EMPTY}'    Run Keywords
            ...    Click    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[3]//spy-select
            ...    AND    MP: select option in expanded dropdown:    ${value}
            IF    '${key}'=='gross default' and '${value}' != '${EMPTY}'    Type Text    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[5]//input    ${value}
            IF    '${key}'=='gross original' and '${value}' != '${EMPTY}'    Type Text    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[7]//input    ${value}
            IF    '${key}'=='quantity' and '${value}' != '${EMPTY}'    Type Text    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[8]//input    ${value}
        END
        IF    '${env}' in ['ui_mp_b2c']
            IF    '${key}'=='store' and '${value}' != '${EMPTY}'    Run Keywords
            ...    Click    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[1]//spy-select
            ...    AND    MP: select option in expanded dropdown:    ${value}
            IF    '${key}'=='currency' and '${value}' != '${EMPTY}'    Run Keywords
            ...    Click    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[2]//spy-select
            ...    AND    MP: select option in expanded dropdown:    ${value}
            IF    '${key}'=='gross default' and '${value}' != '${EMPTY}'    Type Text    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[4]//input    ${value}
            IF    '${key}'=='gross original' and '${value}' != '${EMPTY}'    Type Text    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[6]//input    ${value}
            IF    '${key}'=='quantity' and '${value}' != '${EMPTY}'    Type Text    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[7]//input    ${value}
        END
        IF    '${env}' in ['ui_suite']
            IF    '${key}'=='customer' and '${value}' != '${EMPTY}'    Run Keywords
            ...    Click    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[1]//spy-select
            ...    AND    MP: select option in expanded dropdown:    ${value}
            IF    '${key}'=='store' and '${value}' != '${EMPTY}'    Run Keywords
            ...    Click    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[2]//spy-select
            ...    AND    MP: select option in expanded dropdown:    ${value}
            IF    '${key}'=='currency' and '${value}' != '${EMPTY}'    Run Keywords
            ...    Click    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[3]//spy-select
            ...    AND    MP: select option in expanded dropdown:    ${value}
            IF    '${key}'=='gross default' and '${value}' != '${EMPTY}'    Type Text    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[5]//input    ${value}
            IF    '${key}'=='gross original' and '${value}' != '${EMPTY}'    Type Text    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[7]//input    ${value}
            IF    '${key}'=='quantity' and '${value}' != '${EMPTY}'    Type Text    xpath=//web-spy-card[@spy-title='Price']//tbody/tr[${rowNumber}]/td[8]//input    ${value}
        END
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Page is not loaded
    END
    END  
    
MP: create multi sku product with following data:
    [Documentation]    Creates new abstract product with 2 variants    
    [Arguments]    @{args}
    ${productData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${mp_submit_button}
    FOR    ${key}    ${value}    IN    &{productData}
        IF    '${key}'=='product sku' and '${value}' != '${EMPTY}'    Type Text    ${new_product_sku_field}    ${value}
        IF    '${key}'=='product name' and '${value}' != '${EMPTY}'    
        Run keywords    
            Type Text    ${new_product_name_field}    ${value}
            Click    ${new_product_multiple_concretes_option}
            MP: click submit button
            Disable Automatic Screenshots on Failure
            ${is_form_submitted}=    Run Keyword And Ignore Error    Element Should Not Contain    ${mp_submit_button}    Next
            Restore Automatic Screenshots on Failure
            IF    'FAIL' in $is_form_submitted
                Sleep    0.5s
                MP: click submit button
            END
            MP: remove notification wrapper
        END
        IF    '${key}'=='first attribute name' and '${value}' != '${EMPTY}'    
        Run keywords    
            Click    ${new_product_super_attribute_first_row_name_selector}
            TRY
                Repeat Keyword    3    Wait For Load State
                Wait For Load State    domcontentloaded
                Wait For Load State    networkidle
            EXCEPT
                Log    Page is not loaded
            END
            MP: select option in expanded dropdown:    ${value}
            Click    ${new_product_super_attribute_first_row_values_selector}
            TRY
                Repeat Keyword    3    Wait For Load State
                Wait For Load State    domcontentloaded
                Wait For Load State    networkidle
            EXCEPT
                Log    Page is not loaded
            END
        END
        IF    '${key}'=='first attribute first value' and '${value}' != '${EMPTY}'    MP: select option in expanded dropdown:    ${value}
        IF    '${key}'=='first attribute second value' and '${value}' != '${EMPTY}'    
        Run Keywords
            MP: select option in expanded dropdown:    ${value}
            Click    ${new_product_add_super_attribute_button}
            TRY
                Repeat Keyword    3    Wait For Load State
                Wait For Load State    domcontentloaded
                Wait For Load State    networkidle
            EXCEPT
                Log    Page is not loaded
            END
            Click    ${new_product_super_attribute_second_row_name_selector}
            TRY
                Repeat Keyword    3    Wait For Load State
                Wait For Load State    domcontentloaded
                Wait For Load State    networkidle
            EXCEPT
                Log    Page is not loaded
            END
        END
        IF    '${key}'=='second attribute name' and '${value}' != '${EMPTY}'    
        Run Keywords
            MP: select option in expanded dropdown:    ${value}
            Click    ${new_product_super_attribute_second_row_values_selector}
            TRY
                Repeat Keyword    3    Wait For Load State
                Wait For Load State    domcontentloaded
                Wait For Load State    networkidle
            EXCEPT
                Log    Page is not loaded
            END
        END
        IF    '${key}'=='second attribute value' and '${value}' != '${EMPTY}'    MP: select option in expanded dropdown:    ${value}
    END
    Sleep    0.5s 
    Element Should Contain    ${new_product_concretes_preview_count}    2
    Click    ${new_product_submit_create_button}
    Sleep    0.5s
    Wait Until Element Is Visible    ${new_product_created_popup}
    MP: remove notification wrapper

MP: fill abstract product required fields:
    [Arguments]    @{args}
    ${productData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${product_name_de_field}
    FOR    ${key}    ${value}    IN    &{productData}
        IF    '${key}'=='product name' and '${value}' != '${EMPTY}'
            Click    ${mp_product_name_field_de_tab}
            Sleep    1s
            TRY
                Wait For Load State
            EXCEPT
                Log    Page is not loaded
            END
            Wait Until Element Is Visible    ${product_name_field}
            Type Text    ${product_name_field}    ${value}
            Click    ${mp_product_name_field_en_tab}
            Sleep    1s
            TRY
                Wait For Load State
            EXCEPT
                Log    Page is not loaded
            END
            Wait Until Element Is Visible    ${product_name_field}
            Type Text    ${product_name_field}    ${value}
        END
        IF    '${key}'=='product name DE' and '${value}' != '${EMPTY}'
            Click    ${mp_product_name_field_de_tab}
            Wait Until Element Is Visible    ${product_name_field}
            Type Text    ${product_name_field}    ${value}
        END
        IF    '${key}'=='product name EN' and '${value}' != '${EMPTY}'
            Click    ${mp_product_name_field_de_tab}
            Wait Until Element Is Visible    ${product_name_field}
            Type Text    ${product_name_field}    ${value}
        END
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'    Run Keywords
        ...    Click    ${product_store_selector}
        ...    AND    MP: select option in expanded dropdown:    ${value}
        ...    AND    Click    ${product_store_selector}
        IF    '${key}'=='store 2' and '${value}' != '${EMPTY}'    Run Keywords
        ...    Click    ${product_store_selector}
        ...    AND    MP: select option in expanded dropdown:    ${value}
        ...    AND    Click    ${product_store_selector}
        IF    '${key}'=='tax set' and '${value}' != '${EMPTY}'    Run Keywords
        ...    Click    ${product_tax_selector}
        ...    AND    MP: select option in expanded dropdown:    ${value}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Page is not loaded
    END
    END  

MP: save abstract product    
    MP: click submit button
    Wait Until Element Is Visible    ${product_updated_popup}
    MP: remove notification wrapper
    MP: Wait until loader is no longer visible
    
MP: fill concrete product fields:
    [Arguments]    @{args}
    ${productData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{productData}
        IF    '${key}'=='is active' and '${value}' != '${EMPTY}'    
            ${checkbox_state}=    Get Element Attribute    xpath=//span[contains(text(),'Concrete Product is active')]/../span[contains(@class,'checkbox')]    class
            IF    'checked' in '${checkbox_state}' and '${value}' == 'false'
                Click    ${product_concrete_active_checkbox}
            ELSE IF    'checked' not in '${checkbox_state}' and '${value}' == 'true'
                Click    ${product_concrete_active_checkbox}
            END
        END
        IF    '${key}'=='stock quantity' and '${value}' != '${EMPTY}'
            Type Text    ${product_concrete_stock_input}    ${value}
        END
        IF    '${key}'=='use abstract name' and '${value}' != '${EMPTY}'
            ${checkbox_state}=    Get Element Attribute    xpath=//span[contains(text(),'Use Abstract Product name')]/../../span[contains(@class,'checkbox')]    class
            IF    'checked' in '${checkbox_state}' and '${value}' == 'false'
                Click    ${product_concrete_use_abstract_name_checkbox}
            ELSE IF    'checked' not in '${checkbox_state}' and '${value}' == 'true'
                Click    ${product_concrete_use_abstract_name_checkbox}
            END
        END
        IF    '${key}'=='searchability' and '${value}' != '${EMPTY}'
            Click    ${product_concrete_searchability_selector}
            MP: select option in expanded dropdown:    ${value}
        END    
    END
    MP: save concrete product  

MP: save concrete product
    Click    ${product_concrete_submit_button}
    TRY
        Wait Until Element Is Visible    ${product_updated_popup}
    EXCEPT
        ${page_contains_submit_button}=    Run Keyword And Return Status    Page Should Contain Element    ${product_concrete_submit_button}    timeout=10ms
        IF    ${page_contains_submit_button}
            Click With Options    ${product_concrete_submit_button}    force=True
            Wait Until Element Is Visible    ${product_updated_popup}
        END
    END
    MP: remove notification wrapper
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Page is not loaded
    END
    MP: Wait until loader is no longer visible

MP: delete product price row that contains text:
    [Arguments]    ${rowContent}
    Scroll Element Into View    xpath=//spy-chips[contains(text(),'${rowContent}')]/ancestor::tr//td[@class='ng-star-inserted']/div
    Hover    xpath=//spy-chips[contains(text(),'${rowContent}')]/ancestor::tr//td[@class='ng-star-inserted']/div
    Click    ${product_delete_price_row_button}
    Wait Until Element Is Visible    ${product_price_deleted_popup}
    MP: remove notification wrapper
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Page is not loaded
    END

MP: open concrete drawer by SKU:
    [Arguments]    ${concreteSKU}
    Click    ${product_drawer_concretes_tab}    
    MP: click on a table row that contains:    ${concreteSKU}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Page is not loaded
    END
    MP: Wait until loader is no longer visible

MP: delete product price row that contains quantity:
    [Arguments]    ${quantity}
    IF    '${env}' in ['ui_mp_b2b','ui_suite']
        Scroll Element Into View    xpath=//web-spy-card[@spy-title='Price']//tbody/tr/td[8][contains(.,'${quantity}')]/ancestor::tr//td[@class='ng-star-inserted']/div
        Hover    xpath=//web-spy-card[@spy-title='Price']//tbody/tr/td[8][contains(.,'${quantity}')]/ancestor::tr//td[@class='ng-star-inserted']/div
        Click    ${product_delete_price_row_button}
        Wait Until Element Is Visible    ${product_price_deleted_popup}
        TRY
            Repeat Keyword    3    Wait For Load State
            Wait For Load State    domcontentloaded
            Wait For Load State    networkidle
        EXCEPT
            Log    Page is not loaded
        END
        MP: remove notification wrapper
    END
    IF    '${env}' in ['ui_mp_b2c']
        Scroll Element Into View    xpath=//web-spy-card[@spy-title='Price']//tbody/tr/td[7][contains(.,'${quantity}')]/ancestor::tr//td[@class='ng-star-inserted']/div
        Hover    xpath=//web-spy-card[@spy-title='Price']//tbody/tr/td[7][contains(.,'${quantity}')]/ancestor::tr//td[@class='ng-star-inserted']/div
        Click    ${product_delete_price_row_button}
        Wait Until Element Is Visible    ${product_price_deleted_popup}
        TRY
            Repeat Keyword    3    Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Page is not loaded
        END
        MP: remove notification wrapper
    END

MP: add new concrete product:
    [Arguments]    @{args}
    Click    ${product_drawer_concretes_tab}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Page is not loaded
    END
    Click    ${mp_add_concrete_products_button}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Page is not loaded
    END
    ${productData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{productData}
        IF    '${key}'=='first attribute' and '${value}' != '${EMPTY}'    
            Set Test Variable    ${firstAttributeName}    ${value}
        END
        IF    '${key}'=='first attribute value' and '${value}' != '${EMPTY}'
            Click    xpath=//mp-concrete-product-attributes-selector[@class='mp-concrete-product-attributes-selector']//spy-form-item//label[contains(text(),'${firstAttributeName}')]/../..//spy-select
            Sleep    0.5s
            TRY
                Repeat Keyword    3    Wait For Load State
                Wait For Load State    domcontentloaded
                Wait For Load State    networkidle
            EXCEPT
                Log    Page is not loaded
            END
            MP: select option in expanded dropdown:    ${value}
            Click    xpath=//mp-concrete-product-attributes-selector[@class='mp-concrete-product-attributes-selector']//spy-form-item//label[contains(text(),'${firstAttributeName}')]/../..//spy-select
            TRY
                Repeat Keyword    3    Wait For Load State
                Wait For Load State    domcontentloaded
                Wait For Load State    networkidle
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    0.5s
        END
        IF    '${key}'=='second attribute' and '${value}' != '${EMPTY}'    
            Set Test Variable    ${secondAttributeName}    ${value}
        END
        IF    '${key}'=='second attribute value' and '${value}' != '${EMPTY}'
            Click    xpath=//mp-concrete-product-attributes-selector[@class='mp-concrete-product-attributes-selector']//spy-form-item//label[contains(text(),'${secondAttributeName}')]/../..//spy-select
            TRY
                Repeat Keyword    3    Wait For Load State
                Wait For Load State    domcontentloaded
                Wait For Load State    networkidle
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    0.5s
            MP: select option in expanded dropdown:    ${value}
            Click    xpath=//mp-concrete-product-attributes-selector[@class='mp-concrete-product-attributes-selector']//spy-form-item//label[contains(text(),'${secondAttributeName}')]/../..//spy-select
            TRY
                Repeat Keyword    3    Wait For Load State
                Wait For Load State    domcontentloaded
                Wait For Load State    networkidle
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    0.5s
        END
    END
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Page is not loaded
    END
    Click    ${new_product_submit_create_button}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    ${is_form_submitted}=    Run Keyword And Return Status    Wait Until Element Is Not Visible    ${new_product_submit_create_button}
    IF    not ${is_form_submitted}    Click With Options    selector=${new_product_submit_create_button}    force=True
    MP: remove notification wrapper