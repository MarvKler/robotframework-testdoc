*** Settings ***
Resource    ../common/common.robot
Resource    ../pages/yves/yves_product_sets_page.robot
Resource    ../common/common_yves.robot
Resource    ../common/common_zed.robot
Resource    ../pages/zed/zed_product_set_page.robot

*** Keywords ***
Yves: 'Product Sets' page contains the following sets:
    [Arguments]    @{product_set_list}
    ${product_set_list_count}=   get length  ${product_set_list}
    FOR    ${index}    IN RANGE    0    ${product_set_list_count}
        ${product_set_to_check}=    Get From List    ${product_set_list}    ${index}
        IF    '${env}' in ['ui_b2b','ui_mp_b2b']
            Page Should Contain Element    xpath=//*[contains(@class,'product-set-card__name')][text()="${product_set_to_check}"]/ancestor::article
        ELSE IF    '${env}' in ['ui_suite']
            Page Should Contain Element    xpath=//article//*[contains(@class,'box')][contains(.,'${product_set_to_check}')]/ancestor::article
        ELSE
            Page Should Contain Element    xpath=//*[contains(@class,'title')][text()="${product_set_to_check}"]/ancestor::article
        END
    END

Yves: view the following Product Set:
    [Arguments]    ${productSetName}
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']
        Click    xpath=//*[contains(@class,'product-set-card__name')][text()="${productSetName}"]/ancestor::article
    ELSE IF    '${env}' in ['ui_suite']
        Click    xpath=//article//*[contains(@class,'box')][contains(.,'${productSetName}')]/ancestor::article
    ELSE
        Click    xpath=//*[contains(@class,'title')][text()="${productSetName}"]/ancestor::article
    END
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END

Yves: 'Product Set' page contains the following products:
    [Arguments]    @{product_name_list}    ${productName1}=${EMPTY}     ${productName2}=${EMPTY}     ${productName3}=${EMPTY}     ${productName4}=${EMPTY}     ${productName5}=${EMPTY}     ${productName6}=${EMPTY}     ${productName7}=${EMPTY}     ${productName8}=${EMPTY}     ${productName9}=${EMPTY}     ${productName10}=${EMPTY}     ${productName11}=${EMPTY}     ${productName12}=${EMPTY}     ${productName13}=${EMPTY}     ${productName14}=${EMPTY}     ${productName15}=${EMPTY}
    ${product_name_list_count}=   get length  ${product_name_list}
    FOR    ${index}    IN RANGE    0    ${product_name_list_count}
        ${product_name_to_check}=    Get From List    ${product_name_list}    ${index}
        Page Should Contain Element    xpath=//product-item[@data-qa='component product-item']//*[@itemprop='name'][contains(.,'${product_name_to_check}')]
    END

Yves: change variant of the product on CMS page on:
    [Arguments]    ${productName}    ${variantToSet}
    IF    '${env}' in ['ui_suite']
        Set Browser Timeout    1s
        Run Keyword And Ignore Error    Select From List By Value    xpath=//product-item//a//*[@itemprop='name'][contains(.,'${productName}')]/ancestor::product-item//select    ${variantToSet}
        Set Browser Timeout    ${browser_timeout}
    ELSE
        Mouse Over    xpath=//*[contains(@class,'product-item__container') and descendant::a[contains(.,'${productName}')]]
        Click    xpath=//*[contains(@class,'product-item__container') and descendant::a[contains(.,'${productName}')]]/ancestor::product-item//span[contains(@class,'selection--single')]
        Wait Until Element Is Visible    xpath=//span[contains(@class,'select2-results')]//li[contains(text(),'${variantToSet}')]
        Click    xpath=//span[contains(@class,'select2-results')]//li[contains(text(),'${variantToSet}')]
    END
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END

Yves: add all products to the shopping cart from Product Set
    Wait Until Element Is Enabled    ${add_all_product_to_the_shopping_cart}
    Click    ${add_all_product_to_the_shopping_cart}
    Yves: remove flash messages

Zed: create new product set:
    [Arguments]    @{args}
    Zed: go to URL:    /product-set-gui
    Zed: click button in Header:    Create Product Set
    Wait Until Element Is Visible    ${zed_product_set_name_en_field}
    ${setData}=    Set Up Keyword Arguments    @{args}
    Disable Automatic Screenshots on Failure
    ${second_locale_section_expanded}=    Run Keyword And Return Status    Page Should Contain Element    ${zed_product_set_general_second_locale_expanded_section}    timeout=3s
    Restore Automatic Screenshots on Failure
    IF    '${second_locale_section_expanded}'=='False'
        Scroll Element Into View    ${zed_product_set_general_second_locale_collapsed_section}
        Click    ${zed_product_set_general_second_locale_collapsed_section}
    END
    FOR    ${key}    ${value}    IN    &{setData}
        ${key}=    Convert To Lower Case    ${key}
        IF    '${key}'=='name en' and '${value}' != '${EMPTY}'    Type Text    ${zed_product_set_name_en_field}    ${value}
        IF    '${key}'=='name de' and '${value}' != '${EMPTY}'    Type Text    ${zed_product_set_name_de_field}    ${value}
        IF    '${key}'=='url en' and '${value}' != '${EMPTY}'    Type Text    ${zed_product_set_url_en_field}    ${value}
        IF    '${key}'=='url de' and '${value}' != '${EMPTY}'    Type Text    ${zed_product_set_url_de_field}    ${value}
        IF    '${key}'=='set key' and '${value}' != '${EMPTY}'    Type Text    ${zed_product_set_key_field}    ${value}
        IF    '${key}'=='active' and '${value}' != '${EMPTY}'
            IF    '${value}'=='true'
                Check Checkbox    ${zed_product_set_is_active_checkbox}
            END
            IF    '${value}'=='false'
                Uncheck Checkbox    ${zed_product_set_is_active_checkbox}
            END
        END
        IF    '${key}'=='product' and '${value}' != '${EMPTY}'
            Zed: switch to tab in product set:    Products
            Wait Until Element Is Visible    ${zed_product_set_search_product_table_field}
            Input Text    ${zed_product_set_search_product_table_field}    ${value}
            TRY
                Wait For Load State
                Wait For Load State    domcontentloaded
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    3s
            Check Checkbox    ${zed_product_set_search_product_table_select_first_checkbox}
            TRY
                Wait For Load State
                Wait For Load State    domcontentloaded
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    1s
        END
        IF    '${key}'=='product 2' and '${value}' != '${EMPTY}'
            Wait Until Element Is Visible    ${zed_product_set_search_product_table_field}
            Input Text    ${zed_product_set_search_product_table_field}    ${value}
            TRY
                Wait For Load State
                Wait For Load State    domcontentloaded
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    3s
            Check Checkbox    ${zed_product_set_search_product_table_select_first_checkbox}
            TRY
                Wait For Load State
                Wait For Load State    domcontentloaded
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    1s
        END
        IF    '${key}'=='product 3' and '${value}' != '${EMPTY}'
            Wait Until Element Is Visible    ${zed_product_set_search_product_table_field}
            Input Text    ${zed_product_set_search_product_table_field}    ${value}
            TRY
                Wait For Load State
                Wait For Load State    domcontentloaded
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    3s
            Check Checkbox    ${zed_product_set_search_product_table_select_first_checkbox}
            TRY
                Wait For Load State
                Wait For Load State    domcontentloaded
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    1s
        END
    END
    Zed: submit the form
    Wait Until Element Is Not Visible    ${zed_save_button}
    Trigger multistore p&s

Zed: switch to tab in product set:
    [Arguments]    ${tab_name}
    Click    xpath=//form[@name='product_set_form']//div[@class='tabs-container']/ul[contains(@class,'nav-tabs')]//li[@data-tab-content-id]//a[contains(.,'${tab_name}')]

Zed: delete product set:
    [Arguments]    ${set_name}
    Zed: go to URL:    /product-set-gui
    Zed: click Action Button in a table for row that contains:    ${set_name}    Delete