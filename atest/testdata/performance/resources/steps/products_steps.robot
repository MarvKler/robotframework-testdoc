*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_edit_product_page.robot
Resource    ../pages/zed/zed_view_abstract_product_page.robot
Resource    ../pages/zed/zed_view_concrete_product_page.robot

*** Keywords ***
Zed: discontinue the following product:
    [Arguments]    ${productAbstract}    ${productConcrete}
    Wait Until Element Is Visible    ${zed_log_out_button}
    Zed: go to URL:    /product-management
    Zed: perform search by:    ${productAbstract}
    Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    TRY
        Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    EXCEPT
        Zed: go to URL:    /product-management
        Zed: perform search by:    ${productAbstract}
        Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    END
    Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    Zed: go to tab by link href that contains:   variants
    Zed: click Action Button in Variant table for row that contains:    ${productConcrete}    Edit
    Wait Until Element Is Visible    ${zed_pdp_concrete_main_content_locator}
    Zed: go to tab by link href that contains:   discontinue
    ${can_be_discontinued}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_pdp_discontinue_button}
    IF    '${can_be_discontinued}'=='True'    Click    ${zed_pdp_discontinue_button}

Zed: undo discontinue the following product:
    [Arguments]    ${productAbstract}    ${productConcrete}
    Zed: go to URL:    /product-management
    Zed: perform search by:    ${productAbstract}
    Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    TRY
        Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    EXCEPT
        Zed: go to URL:    /product-management
        Zed: perform search by:    ${productAbstract}
        Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    END
    Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    Zed: go to tab by link href that contains:   variants
    Zed: click Action Button in Variant table for row that contains:    ${productConcrete}    Edit
    Wait Until Element Is Visible    ${zed_pdp_concrete_main_content_locator}
    Zed: go to tab by link href that contains:   discontinue
    ${can_be_restored}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_pdp_restore_button}
    IF    '${can_be_restored}'=='True'    Click    ${zed_pdp_restore_button}

Zed: check if at least one price exists for concrete and add if doesn't:
    [Arguments]    ${price}
    ${currentURL}=    Get Location
    IF    'content-price' not in '${currentURL}'    Zed: go to tab by link href that contains:   content-price
    ${exists}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//table[@id='price-table-collection']//input[@id='product_concrete_form_edit_prices_1-93-DEFAULT-BOTH_moneyValue_gross_amount']
    IF        '${exists}'=='False'    Type Text    xpath=//table[@id='price-table-collection']//input[@id='product_concrete_form_edit_prices_1-93-DEFAULT-BOTH_moneyValue_gross_amount']    ${price}
    Click    ${zed_pdp_save_button}

Zed: change concrete product price on:
    [Arguments]    @{args}
    ${priceData}=    Set Up Keyword Arguments    @{args}
    Zed: go to URL:    /product-management
    Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    TRY
        Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    EXCEPT
        Zed: go to URL:    /product-management
        Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    END
    Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    Zed: go to tab by link href that contains:   variants
    Zed: click Action Button in Variant table for row that contains:    ${productConcrete}    Edit
    Wait Until Element Is Visible    ${zed_pdp_concrete_main_content_locator}
    Zed: go to tab by link href that contains:   content-price
    FOR    ${key}    ${value}    IN    &{priceData}
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'
            ${store}=    Set Variable    ${value}
        END
        IF    '${key}'=='mode' and '${value}' != '${EMPTY}'
            ${mode}=    Set Variable    ${value}_amount
        END
        IF    '${key}'=='type' and '${value}' == 'default'
            ${type}=    Set Variable    DEFAULT
        END
        IF    '${key}'=='type' and '${value}' == 'original'
            ${type}=    Set Variable    ORIGINAL
        END
        IF    '${key}'=='currency' and '${value}' == '€'
        ${inputField}=    Set Variable    xpath=//table[@id='price-table-collection']//td[1][contains(text(),'${store}')]/../following-sibling::tr[1]//input[contains(@id,'${mode}')][contains(@id,'${type}')]
        END
        IF    '${key}'=='currency' and '${value}' == 'CHF'
        ${inputField}=    Set Variable    xpath=//table[@id='price-table-collection']//td[1][contains(text(),'${store}')]/ancestor::tr//input[contains(@id,'${mode}')][contains(@id,'${type}')]
        END
        IF    '${key}'=='amount' and '${value}' != '${EMPTY}'
            Type Text    ${inputField}    ${value}
        END
    END
    Sleep    1s
    Click    ${zed_pdp_save_button}
    ### resave to apply changes
    Set Browser Timeout    1s
    TRY
        Click    ${zed_pdp_save_button}
    EXCEPT    
        Log    Form is already submitted
    END
    Set Browser Timeout    ${browser_timeout}
    ${is_success_message_displayed}=    Run Keyword And Ignore Error    Element Should Be Visible    ${zed_success_flash_message}    timeout=1s
    IF    'FAIL' in $is_success_message_displayed
        Trigger multistore p&s
        Reload
        Sleep    1s
        FOR    ${key}    ${value}    IN    &{priceData}
            IF    '${key}'=='store' and '${value}' != '${EMPTY}'
                ${store}=    Set Variable    ${value}
            END
            IF    '${key}'=='mode' and '${value}' != '${EMPTY}'
                ${mode}=    Set Variable    ${value}_amount
            END
            IF    '${key}'=='type' and '${value}' == 'default'
                ${type}=    Set Variable    DEFAULT
            END
            IF    '${key}'=='type' and '${value}' == 'original'
                ${type}=    Set Variable    ORIGINAL
            END
            IF    '${key}'=='currency' and '${value}' == '€'
            ${inputField}=    Set Variable    xpath=//table[@id='price-table-collection']//td[1][contains(text(),'${store}')]/../following-sibling::tr[1]//input[contains(@id,'${mode}')][contains(@id,'${type}')]
            END
            IF    '${key}'=='currency' and '${value}' == 'CHF'
            ${inputField}=    Set Variable    xpath=//table[@id='price-table-collection']//td[1][contains(text(),'${store}')]/ancestor::tr//input[contains(@id,'${mode}')][contains(@id,'${type}')]
            END
            IF    '${key}'=='amount' and '${value}' != '${EMPTY}'
                Type Text    ${inputField}    ${value}
            END
        END
        Sleep    1s
        Click    ${zed_pdp_save_button}
    END
    Page Should Contain Element    ${zed_success_flash_message}

Zed: add following alternative products to the concrete:
    [Arguments]    @{alternative_products_list}
    ${currentURL}=    Get Location
    IF    'content-alternatives' not in '${currentURL}'    Zed: go to tab by link href that contains:   alternatives
    ${alternative_products_list_count}=   get length  ${alternative_products_list}
    FOR    ${index}    IN RANGE    0    ${alternative_products_list_count}
        ${alternative_product_to_assign}=    Get From List    ${alternative_products_list}    ${index}
        Type Text    ${zed_pdp_add_products_alternative_input}    ${alternative_product_to_assign}
        Wait Until Element Is Visible    ${zed_pdp_alternative_products_suggestion}
        Click    xpath=//ul[@id='select2-product_concrete_form_edit_alternative_products-results']/li[contains(@class,'select2-results__option') and contains(text(),'(sku: ${alternative_product_to_assign})')]
    END
    Zed: submit the form

Zed: concrete product has the following alternative products:
    [Arguments]    @{alternative_products_list}
    ${currentURL}=    Get Location
    IF    'content-alternatives' not in '${currentURL}'    Zed: go to tab by link href that contains:   alternatives
    ${alternative_products_list_count}=   get length  ${alternative_products_list}
    FOR    ${index}    IN RANGE    0    ${alternative_products_list_count}
        ${alternative_product_to_check}=    Get From List    ${alternative_products_list}    ${index}
        Wait Until Element Is Visible    xpath=//div[@id='tab-content-alternatives']//table/tbody
        Table Should Contain    xpath=//div[@id='tab-content-alternatives']//table/tbody    ${alternative_product_to_check}
    END

Zed: switch to the tab on 'Edit product' page:
    [Arguments]    ${tabToUse}
    Click    xpath=//form[contains(@name,'form_edit')]/div[@class='tabs-container']/ul[contains(@class,'nav-tabs')]//li[@data-bs-toggle='tab']//*[text()='${tabToUse}']

Zed: switch to the tab on 'Add product' page:
    [Arguments]    ${tabToUse}
    Click    xpath=//form[contains(@name,'form_add')]/div[@class='tabs-container']/ul[contains(@class,'nav-tabs')]//li[@data-bs-toggle='tab']//*[text()='${tabToUse}']

Zed: product is successfully discontinued
    ${currentURL}=    Get Location
    IF    'discontinue' not in '${currentURL}'    Zed: go to tab by link href that contains:   discontinue
    Page Should Contain Element    ${zed_pdp_restore_button}

Zed: view product page is displayed
    Wait Until Element Is Visible    ${zed_view_abstract_product_main_content_locator}

Zed: view abstract product page contains:
    [Arguments]    @{args}
    ${abstractProductData}=    Set Up Keyword Arguments    @{args}
    Disable Automatic Screenshots on Failure
    ${second_locale_section_expanded}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_view_abstract_general_second_locale_expanded_section}    timeout=1s
    Restore Automatic Screenshots on Failure
    IF    '${second_locale_section_expanded}'=='False'
        Scroll Element Into View    ${zed_view_abstract_general_second_locale_collapsed_section}
        Click    ${zed_view_abstract_general_second_locale_collapsed_section}
    END
    FOR    ${key}    ${value}    IN    &{abstractProductData}
        IF    '${key}'=='merchant' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_abstract_product_merchant}    ${value}
        END
        IF    '${key}'=='status' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_abstract_product_status}    ${value}
        END
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_abstract_product_store}[${env}]    ${value}
        END
        IF    '${key}'=='sku' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_abstract_product_sku}[${env}]    ${value}
        END
        IF    '${key}'=='name' and '${value}' != '${EMPTY}'    
            Element Should Contain    ${zed_view_abstract_product_name}[${env}]    ${value}
        END
        IF    '${key}'=='variants count' and '${value}' != '${EMPTY}'
            Clear Text    xpath=//div[@id='product-variant-table_filter']//input[@type='search']
            Wait Until Element Is Visible    xpath=//table[@id='product-variant-table']//tbody/tr[1]
            ${actualVariantsCount}=    Get Element Count    xpath=//table[@id='product-variant-table']//tbody/tr
            Should Be Equal    '${actualVariantsCount}'    '${value}'
        END
    END

Zed: update abstract product data:
    [Arguments]    @{args}
    ${abstractProductData}=    Set Up Keyword Arguments    @{args}
    Zed: go to URL:    /product-management 
    Zed: click Action Button in a table for row that contains:     ${productAbstract}     Edit
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    page is not fully loaded
    END
    TRY
        Page Should Contain Element    ${zed_pdp_save_button}
    EXCEPT
        Zed: go to URL:    /product-management 
        Zed: click Action Button in a table for row that contains:     ${productAbstract}     Edit
        TRY
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    page is not fully loaded
        END
        Page Should Contain Element    ${zed_pdp_save_button}
    END
    Disable Automatic Screenshots on Failure
    ${second_locale_section_expanded}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_product_general_second_locale_expanded_section}    100ms
    Restore Automatic Screenshots on Failure
    IF    '${second_locale_section_expanded}'=='False'
    Scroll Element Into View    ${zed_product_general_second_locale_collapsed_section}
    Click    ${zed_product_general_second_locale_collapsed_section}
    END  
    FOR    ${key}    ${value}    IN    &{abstractProductData}
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'    
            Zed: Check checkbox by Label:    ${value}
        END
        IF    '${key}'=='store 2' and '${value}' != '${EMPTY}'    
            Zed: Check checkbox by Label:    ${value}
        END
        IF    '${key}'=='unselect store' and '${value}' != '${EMPTY}'    
            Zed: Uncheck Checkbox by Label:    ${value}
        END
        IF    '${key}'=='name en' and '${value}' != '${EMPTY}'  
            Wait Until Element Is Visible    ${zed_product_edit_name_en_input}
            Type Text    ${zed_product_edit_name_en_input}    ${value}
        END
        IF    '${key}'=='name de' and '${value}' != '${EMPTY}'  
            Wait Until Element Is Visible    ${zed_product_edit_name_de_input}
            Type Text    ${zed_product_edit_name_de_input}    ${value}
        END
        IF    '${key}'=='new from' and '${value}' != '${EMPTY}'    
            Type Text    ${zed_product_edit_new_from}    ${value}
            Keyboard Key    press    Enter
        END
        IF    '${key}'=='new to' and '${value}' != '${EMPTY}'    
            Type Text    ${zed_product_edit_new_to}    ${value}
            Keyboard Key    press    Enter
        END
    END
    Click    ${zed_pdp_save_button}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT    
        Log    Load event was not fired
    END

Zed: update abstract product price on:
    [Arguments]    @{args}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT    
        Log    Load event was not fired
    END
    ${priceData}=    Set Up Keyword Arguments    @{args}
    ${productAbstractIsProvided}=    Run Keyword And Return Status    Variable Should Exist    ${productAbstract}
    Disable Automatic Screenshots on Failure
    ${is_edit_abstract_price_tab_exists}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//*[contains(@data-bs-toggle,'tab')][contains(@data-bs-target,'content-price_and_tax')] | //*[contains(@data-bs-toggle,'tab')]//*[contains(@data-bs-target,'content-price_and_tax')]    timeout=100ms
    Restore Automatic Screenshots on Failure
    IF    '${is_edit_abstract_price_tab_exists}'=='False' and ${productAbstractIsProvided}
        Zed: go to URL:    /product-management
        Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
        Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
        Zed: go to tab by link href that contains:   content-price
    ELSE
        ${currentURL}=    Get Location
        IF    'content-price_and_tax' not in '${currentURL}'
            Zed: go to tab by link href that contains:   content-price_and_tax
        END
    END
    FOR    ${key}    ${value}    IN    &{priceData}
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'
            ${store}=    Set Variable    ${value}
        END
        IF    '${key}'=='mode' and '${value}' != '${EMPTY}'
            ${mode}=    Set Variable    ${value}_amount
        END
        IF    '${key}'=='type' and '${value}' == 'default'
            ${type}=    Set Variable    DEFAULT
        END
        IF    '${key}'=='type' and '${value}' == 'original'
            ${type}=    Set Variable    ORIGINAL
        END
        IF    '${key}'=='currency' and '${value}' == '€'
        ${inputField}=    Set Variable    xpath=//table[@id='price-table-collection']//td[1][contains(text(),'${store}')]/../following-sibling::tr[1]//input[contains(@id,'${mode}')][contains(@id,'${type}')]
        END
        IF    '${key}'=='currency' and '${value}' == 'CHF'
        ${inputField}=    Set Variable    xpath=//table[@id='price-table-collection']//td[1][contains(text(),'${store}')]/ancestor::tr//input[contains(@id,'${mode}')][contains(@id,'${type}')]
        END
        IF    '${key}'=='amount' and '${value}' != '${EMPTY}'
            Type Text    ${inputField}    ${value}
        END
        IF    '${key}'=='tax set' and '${value}' != '${EMPTY}'    Select From List By Label    ${zed_product_tax_set_select}    ${value}
    END
    Click and retry if 5xx occurred:    ${zed_pdp_save_button}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT    
        Log    Load event was not fired
    END

Zed: start new abstract product creation:
    [Arguments]    @{args}
    ${abstractProductData}=    Set Up Keyword Arguments    @{args}
    Zed: go to URL:    /product-management
    Zed: click button in Header:    Create Product
    TRY
        Page Should Contain Element    ${zed_pdp_save_button}
    EXCEPT
        Zed: go to URL:    /product-management
        Zed: click button in Header:    Create Product
        Page Should Contain Element    ${zed_pdp_save_button}
    END
    Disable Automatic Screenshots on Failure
    ${second_locale_section_expanded}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_product_general_second_locale_expanded_section}    timeout=1s
    Restore Automatic Screenshots on Failure
    IF    '${second_locale_section_expanded}'=='False'
        Scroll Element Into View    ${zed_product_general_second_locale_collapsed_section}
        Click    ${zed_product_general_second_locale_collapsed_section}
    END
    FOR    ${key}    ${value}    IN    &{abstractProductData}
        IF    '${key}'=='sku' and '${value}' != '${EMPTY}'    Type Text    ${zed_product_add_sku_input}    ${value}
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'    
            Zed: Check checkbox by Label:    ${value}
        END
        IF    '${key}'=='store 2' and '${value}' != '${EMPTY}'    
            Zed: Check checkbox by Label:    ${value}
        END
        IF    '${key}'=='unselect store' and '${value}' != '${EMPTY}'    
            Zed: Uncheck Checkbox by Label:    ${value}
        END
        IF    '${key}'=='name en' and '${value}' != '${EMPTY}'  
            Wait Until Element Is Visible    ${zed_product_add_name_en_input}
            Type Text    ${zed_product_add_name_en_input}    ${value}
        END
        IF    '${key}'=='name de' and '${value}' != '${EMPTY}'  
            Wait Until Element Is Visible    ${zed_product_add_name_de_input}
            Type Text    ${zed_product_add_name_de_input}    ${value}
        END
        IF    '${key}'=='new from' and '${value}' != '${EMPTY}'    
            Type Text    ${zed_product_add_new_from}    ${value}
            Keyboard Key    press    Enter
        END
        IF    '${key}'=='new to' and '${value}' != '${EMPTY}'    
            Type Text    ${zed_product_add_new_to}    ${value}
            Keyboard Key    press    Enter
        END
    END
    Click    ${zed_pdp_save_button}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT    
        Log    Load event was not fired
    END
    
Zed: select abstract product variants:
    [Arguments]    @{args}
    ${abstractProductData}=    Set Up Keyword Arguments    @{args}
    Zed: go to tab by link href that contains:   variants
    FOR    ${key}    ${value}    IN    &{abstractProductData}
        IF    '${key}'=='attribute 1' and '${value}' != '${EMPTY}'
            ${attribute_1}=    Set Variable    ${value}
        END
        IF    '${key}'=='attribute value 1' and '${value}' != '${EMPTY}'
            Check Checkbox    xpath=//input[@id='product_form_add_attribute_super_${attribute_1}_name']
            Click    xpath=//input[@id='product_form_add_attribute_super_${attribute_1}_name']/ancestor::div[contains(@class,'input-group')]//span[@role='combobox']
            Wait Until Element Is Visible    xpath=//li[contains(@id,'select2-product_form_add_attribute_super')][contains(text(),'${value}')]
            Click    xpath=//li[contains(@id,'select2-product_form_add_attribute_super')][contains(text(),'${value}')]
        END
        IF    '${key}'=='attribute 2' and '${value}' != '${EMPTY}'
            ${attribute_2}=    Set Variable    ${value}
        END
        IF    '${key}'=='attribute value 2' and '${value}' != '${EMPTY}'
            Check Checkbox    xpath=//input[@id='product_form_add_attribute_super_${attribute_2}_name']
            Click    xpath=//input[@id='product_form_add_attribute_super_${attribute_2}_name']/ancestor::div[contains(@class,'input-group')]//span[@role='combobox']
            Wait Until Element Is Visible    xpath=//li[contains(@id,'select2-product_form_add_attribute_super')][contains(text(),'${value}')]
            Click    xpath=//li[contains(@id,'select2-product_form_add_attribute_super')][contains(text(),'${value}')]
        END
                IF    '${key}'=='attribute 3' and '${value}' != '${EMPTY}'
            ${attribute_1}=    Set Variable    ${value}
        END
        IF    '${key}'=='attribute value 3' and '${value}' != '${EMPTY}'
            Check Checkbox    xpath=//input[@id='product_form_add_attribute_super_${attribute_3}_name']
            Click    xpath=//input[@id='product_form_add_attribute_super_${attribute_3}_name']/ancestor::div[contains(@class,'input-group')]//span[@role='combobox']
            Wait Until Element Is Visible    xpath=//li[contains(@id,'select2-product_form_add_attribute_super')][contains(text(),'${value}')]
            Click    xpath=//li[contains(@id,'select2-product_form_add_attribute_super')][contains(text(),'${value}')]
        END
    END
    Click    ${zed_pdp_save_button}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT    
        Log    Load event was not fired
    END

Zed: change concrete product data:
    [Arguments]    @{args}
    ${priceData}=    Set Up Keyword Arguments    @{args}
    Zed: go to URL:    /product-management
    Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    TRY
        Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    EXCEPT
        Zed: go to URL:    /product-management
        Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    END
    Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    Zed: go to tab by link href that contains:   variants
    Zed: click Action Button in Variant table for row that contains:    ${productConcrete}    Edit
    Wait Until Element Is Visible    ${zed_pdp_concrete_main_content_locator}
    Disable Automatic Screenshots on Failure
    ${second_locale_section_expanded}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_product_general_second_locale_expanded_section}    timeout=1s
    Restore Automatic Screenshots on Failure
    IF    '${second_locale_section_expanded}'=='False'
        Scroll Element Into View    ${zed_product_general_second_locale_collapsed_section}
        Click    ${zed_product_general_second_locale_collapsed_section}
    END
    FOR    ${key}    ${value}    IN    &{priceData}
        IF    '${key}'=='name en' and '${value}' != '${EMPTY}'  
            Wait Until Element Is Visible    ${zed_pdp_concrete_name_en_input}
            Type Text    ${zed_pdp_concrete_name_en_input}    ${value}
        END
        IF    '${key}'=='name de' and '${value}' != '${EMPTY}'  
            Wait Until Element Is Visible    ${zed_pdp_concrete_name_de_input}
            Type Text    ${zed_pdp_concrete_name_de_input}    ${value}
        END
        IF    '${key}'=='active' and '${value}' != '${EMPTY}'
            Disable Automatic Screenshots on Failure
            ${is_active}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//div[@class='title-action']/a[contains(.,'Activate')]    timeout=1s
            Restore Automatic Screenshots on Failure
            IF    '${is_active}'=='True' and '${value}'=='true'
                Zed: click button in Header:    Activate
                Disable Automatic Screenshots on Failure
                ${second_locale_section_expanded}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_product_general_second_locale_expanded_section}    timeout=1s
                Restore Automatic Screenshots on Failure
                IF    '${second_locale_section_expanded}'=='False'
                    Scroll Element Into View    ${zed_product_general_second_locale_collapsed_section}
                    Click    ${zed_product_general_second_locale_collapsed_section}
                END
            END
            IF    '${is_active}'=='False' and '${value}'=='false'
                Zed: click button in Header:    Deactivate
                Disable Automatic Screenshots on Failure
                ${second_locale_section_expanded}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_product_general_second_locale_expanded_section}    timeout=1s
                Restore Automatic Screenshots on Failure
                IF    '${second_locale_section_expanded}'=='False'
                    Scroll Element Into View    ${zed_product_general_second_locale_collapsed_section}
                    Click    ${zed_product_general_second_locale_collapsed_section}
                END
            END
        END
        IF    '${key}'=='searchable en' and '${value}' != '${EMPTY}'  
            IF    '${value}'=='true'
                Check Checkbox    ${zed_pdp_concrete_searchable_en}
            END
            IF    '${value}'=='false'
                Uncheck Checkbox    ${zed_pdp_concrete_searchable_en}
            END
        END
        IF    '${key}'=='searchable de' and '${value}' != '${EMPTY}'
            IF    '${value}'=='true'
                Check Checkbox    ${zed_pdp_concrete_searchable_de}
            END
            IF    '${value}'=='false'
                Uncheck Checkbox    ${zed_pdp_concrete_searchable_de}
            END
        END
    END
    Click    ${zed_pdp_save_button}

Zed: change concrete product stock:
    [Arguments]    @{args}
    ${stockData}=    Set Up Keyword Arguments    @{args}
    Zed: go to URL:    /product-management
    Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    TRY
        Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    EXCEPT
        Zed: go to URL:    /product-management
        Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    END
    Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    Zed: go to tab by link href that contains:   variants
    Zed: click Action Button in Variant table for row that contains:    ${productConcrete}    Edit
    Wait Until Element Is Visible    ${zed_pdp_concrete_main_content_locator}
    Zed: go to tab by link href that contains:   content-price
    FOR    ${key}    ${value}    IN    &{stockData}
        IF    '${key}'=='warehouse n1' and '${value}' != '${EMPTY}'    
            ${warehouse1}=    Set Variable    ${value}
        END
        IF    '${key}'=='warehouse n2' and '${value}' != '${EMPTY}'    
            ${warehouse2}=    Set Variable    ${value}
        END
        IF    '${key}'=='warehouse n3' and '${value}' != '${EMPTY}'    
            ${warehouse3}=    Set Variable    ${value}
        END
        IF    '${key}'=='warehouse n4' and '${value}' != '${EMPTY}'    
            ${warehouse4}=    Set Variable    ${value}
        END
        IF    '${key}'=='warehouse n5' and '${value}' != '${EMPTY}'    
            ${warehouse5}=    Set Variable    ${value}
        END
        IF    '${key}'=='warehouse n1 qty' and '${value}' != '${EMPTY}'    Type Text    xpath=//*[@id="tab-content-price"]//input[@value='${warehouse1}']/../following-sibling::div[1]//input[@id]    ${value}
        IF    '${key}'=='warehouse n2 qty' and '${value}' != '${EMPTY}'    Type Text    xpath=//*[@id="tab-content-price"]//input[@value='${warehouse2}']/../following-sibling::div[1]//input[@id]    ${value}
        IF    '${key}'=='warehouse n3 qty' and '${value}' != '${EMPTY}'    Type Text    xpath=//*[@id="tab-content-price"]//input[@value='${warehouse3}']/../following-sibling::div[1]//input[@id]    ${value}
        IF    '${key}'=='warehouse n4 qty' and '${value}' != '${EMPTY}'    Type Text    xpath=//*[@id="tab-content-price"]//input[@value='${warehouse4}']/../following-sibling::div[1]//input[@id]    ${value}
        IF    '${key}'=='warehouse n5 qty' and '${value}' != '${EMPTY}'    Type Text    xpath=//*[@id="tab-content-price"]//input[@value='${warehouse5}']/../following-sibling::div[1]//input[@id]    ${value}
        IF    '${key}'=='warehouse n1 never out of stock' and '${value}' != '${EMPTY}'    
            IF    '${value}'=='true'
                Check Checkbox    xpath=//*[@id="tab-content-price"]//input[@value='${warehouse1}']/../following-sibling::div[2]//input[@type='checkbox']
            END
            IF    '${value}'=='false'
                Uncheck Checkbox    xpath=//*[@id="tab-content-price"]//input[@value='${warehouse1}']/../following-sibling::div[2]//input[@type='checkbox']
            END
        END
        IF    '${key}'=='warehouse n2 never out of stock' and '${value}' != '${EMPTY}'    
            IF    '${value}'=='true'
                Check Checkbox    xpath=//*[@id="tab-content-price"]//input[@value='${warehouse2}']/../following-sibling::div[2]//input[@type='checkbox']
            END
            IF    '${value}'=='false'
                Uncheck Checkbox    xpath=//*[@id="tab-content-price"]//input[@value='${warehouse2}']/../following-sibling::div[2]//input[@type='checkbox']
            END
        END
        IF    '${key}'=='warehouse n3 never out of stock' and '${value}' != '${EMPTY}'    
            IF    '${value}'=='true'
                Check Checkbox    xpath=//*[@id="tab-content-price"]//input[@value='${warehouse3}']/../following-sibling::div[2]//input[@type='checkbox']
            END
            IF    '${value}'=='false'
                Uncheck Checkbox    xpath=//*[@id="tab-content-price"]//input[@value='${warehouse3}']/../following-sibling::div[2]//input[@type='checkbox']
            END
        END
        IF    '${key}'=='warehouse n4 never out of stock' and '${value}' != '${EMPTY}'    
            IF    '${value}'=='true'
                Check Checkbox    xpath=//*[@id="tab-content-price"]//input[@value='${warehouse4}']/../following-sibling::div[2]//input[@type='checkbox']
            END
            IF    '${value}'=='false'
                Uncheck Checkbox    xpath=//*[@id="tab-content-price"]//input[@value='${warehouse4}']/../following-sibling::div[2]//input[@type='checkbox']
            END
        END
        IF    '${key}'=='warehouse n5 never out of stock' and '${value}' != '${EMPTY}'    
            IF    '${value}'=='true'
                Check Checkbox    xpath=//*[@id="tab-content-price"]//input[@value='${warehouse5}']/../following-sibling::div[2]//input[@type='checkbox']
            END
            IF    '${value}'=='false'
                Uncheck Checkbox    xpath=//*[@id="tab-content-price"]//input[@value='${warehouse5}']/../following-sibling::div[2]//input[@type='checkbox']
            END
        END
    END
    Click    ${zed_pdp_save_button}

Zed: add new concrete product to abstract:
    [Arguments]    @{args}
    ${productData}=    Set Up Keyword Arguments    @{args}
    Zed: go to URL:    /product-management
    Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    TRY
        Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    EXCEPT
        Zed: go to URL:    /product-management
        Zed: click Action Button in a table for row that contains:    ${productAbstract}    Edit
    END
    Wait Until Element Is Visible    ${zed_pdp_abstract_main_content_locator}
    Zed: click button in Header:    Add Variant
    Wait Until Element Is Visible    ${zed_pdp_add_concrete_main_content_locator}
    Disable Automatic Screenshots on Failure
    ${second_locale_section_expanded}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_product_general_second_locale_expanded_section}    timeout=1s
    Restore Automatic Screenshots on Failure
    IF    '${second_locale_section_expanded}'=='False'
        Scroll Element Into View    ${zed_product_general_second_locale_collapsed_section}
        Click    ${zed_product_general_second_locale_collapsed_section}
    END
    FOR    ${key}    ${value}    IN    &{productData}
        IF    '${key}'=='sku' and '${value}' != '${EMPTY}'    Type Text    ${zed_add_concrete_sku_field}    ${value}
        IF    '${key}'=='autogenerate sku' and '${value}' != '${EMPTY}'
            IF    '${value}'=='true'
                Check Checkbox    ${zed_add_concrete_autogenerate_sku}
            END
            IF    '${value}'=='false'
                Uncheck Checkbox    ${zed_add_concrete_autogenerate_sku}
            END
        END
        IF    '${key}'=='attribute 1' and '${value}' != '${EMPTY}'
            Click    (//span[@class='select2-selection select2-selection--single'])[1]
            Wait Until Element Is Visible    xpath=//li[contains(@id,'select2-product_concrete_form_add_container_product_concrete_super_attributes_form_product_concrete_super_attributes')][contains(@id,'${value}')]
            Click    xpath=//li[contains(@id,'select2-product_concrete_form_add_container_product_concrete_super_attributes_form_product_concrete_super_attributes')][contains(@id,'${value}')]
        END
        IF    '${key}'=='attribute 2' and '${value}' != '${EMPTY}'
            Click    (//span[@class='select2-selection select2-selection--single'])[2]
            Wait Until Element Is Visible    xpath=//li[contains(@id,'select2-product_concrete_form_add_container_product_concrete_super_attributes_form_product_concrete_super_attributes')][contains(@id,'${value}')]
            Click    xpath=//li[contains(@id,'select2-product_concrete_form_add_container_product_concrete_super_attributes_form_product_concrete_super_attributes')][contains(@id,'${value}')]
        END
        IF    '${key}'=='attribute 3' and '${value}' != '${EMPTY}'
            Click    (//span[@class='select2-selection select2-selection--single'])[3]
            Wait Until Element Is Visible    xpath=//li[contains(@id,'select2-product_concrete_form_add_container_product_concrete_super_attributes_form_product_concrete_super_attributes')][contains(@id,'${value}')]
            Click    xpath=//li[contains(@id,'select2-product_concrete_form_add_container_product_concrete_super_attributes_form_product_concrete_super_attributes')][contains(@id,'${value}')]
        END
        IF    '${key}'=='name en' and '${value}' != '${EMPTY}'  
            Wait Until Element Is Visible    ${zed_add_concrete_name_en_input}
            Type Text    ${zed_add_concrete_name_en_input}    ${value}
        END
        IF    '${key}'=='name de' and '${value}' != '${EMPTY}'  
                Wait Until Element Is Visible    ${zed_add_concrete_name_de_input}
                Type Text    ${zed_add_concrete_name_de_input}    ${value}
        END
        IF    '${key}'=='use prices from abstract' and '${value}' != '${EMPTY}'  
            Zed: go to tab by link href that contains:   content-price
            Wait Until Element Is Visible    ${zed_add_concrete_use_price_from_abstract}
            IF    '${value}'=='true'
                Check Checkbox    ${zed_add_concrete_use_price_from_abstract}
            END
            IF    '${value}'=='false'
                Uncheck Checkbox    ${zed_add_concrete_use_price_from_abstract}
            END
        END
    END
    Click    ${zed_pdp_save_button}