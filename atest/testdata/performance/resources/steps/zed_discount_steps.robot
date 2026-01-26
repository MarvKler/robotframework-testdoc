*** Settings ***
Resource    ../pages/zed/zed_discount_page.robot
Resource    ../../resources/common/common_yves.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Keywords ***
Zed: create a discount and activate it:
    [Arguments]    ${discountType}    ${valueType}    ${discountValue}    ${applyToQuery}=    ${voucherCode}=    ${promotionalProductDiscount}=False    ${promotionalProductAbstractSku}=    ${promotionalProductQuantity}=    ${applyWhenQuery}=    ${discountName}=Test Discount    ${discountDescription}='Test Description'
    ${currentURL}=    Get Location
    IF    '/discount' not in '${currentURL}'    Zed: go to URL:    /discount/index/list
    ### General information
    Zed: go to URL:    /discount/index/list
    Click    ${zed_discount_add_new_discount_button}
    Wait Until Element Is Visible    ${zed_discount_create_discount_page}
    IF    '${discountType}'=='voucher'
        Select From List By Label    ${zed_discount_type_dropdown}    Voucher codes
    ELSE IF    '${discountType}'=='cart rule'
        Select From List By Label    ${zed_discount_type_dropdown}    Cart rule
    END
    Type Text    ${zed_discount_name_field}     ${discountName}
    Type Text    ${zed_discount_description_field}     ${discountDescription}
    Evaluate Javascript    ${None}  document.getElementById("discount_discountGeneral_valid_from").setAttribute("value", "01.01.2021 01:00")
    Evaluate JavaScript    ${None}   document.getElementById("discount_discountGeneral_valid_to").setAttribute("value", "01.01.2030 01:00")
    ### Discount calculation
    Zed: go to tab by link href that contains:    discount
    TRY
        Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    Wait For Elements State    ${zed_discount_query_builder_first_calculation_group}    visible    ${browser_timeout}
    IF    '${valueType}'=='Percentage'    Run Keywords    Select From List By Label    ${zed_discount_calculator_type_drop_down}    Percentage
    ...    AND    Type Text    ${zed_discount_percentage_value_field}     ${discountValue}
    ...    ELSE   Run keywords    '${valueType}'=='Fixed amount'    Select From List By Label    ${zed_discount_calculator_type_drop_down}    Fixed amount
    ...    AND    Type Text    ${zed_discount_euro_gross_field}    ${discountValue}
    IF    '${promotionalProductDiscount}'=='False'
        Run keywords
    ...    Click    ${zed_discount_plain_query_apply_to__button}
    ...    AND    Wait Until Element Is Visible    ${zed_discount_plain_query_apply_to_field}
    ...    AND    Type Text    ${zed_discount_plain_query_apply_to_field}     ${applyToQuery}
    ELSE IF    '${promotionalProductDiscount}'=='True'
        Run keywords
    ...    Click    ${zed_discount_promotional_product_radio}
    ...    AND    Wait Until Element Is Visible    ${zed_discount_promotional_product_abstract_sku_field}
    ...    AND    Type Text    ${zed_discount_promotional_product_abstract_sku_field}     ${promotionalProductAbstractSku}
    ...    AND    Type Text    ${zed_discount_promotional_product_abstract_quantity_field}     ${promotionalProductQuantity}
    END
    ### Discount condition
    Zed: go to tab by link href that contains:    conditions
    TRY
        Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    Wait For Elements State    ${zed_discount_query_builder_first_condition_group}    visible    ${browser_timeout}
    Click    ${zed_discount_plain_query_apply_when__button}
    Wait Until Element Is Visible    ${zed_discount_plain_query_apply_when_field}
    IF    '${applyWhenQuery}' != '${EMPTY}'
        Type Text    ${zed_discount_plain_query_apply_when_field}     ${applyWhenQuery}
    END
    Click    ${zed_discount_save_button}
    Wait Until Element Is Visible    ${zed_discount_activate_button}
    Click    ${zed_discount_activate_button}
    ### Voucher codes
    IF    '${discountType}'=='voucher'    Zed: generate vouchers:    1    ${voucherCode}
    ### Check discount in Zed
    Zed: go to URL:    /discount/index/list
    Zed: perform search by:    ${discountName}
    Element Should Be Visible    xpath=//td[contains(@class,'name') and contains(text(),'${discountName}')]/ancestor::tr//span[contains(@class,'label') and contains(text(),'Active')]    message=None

Zed: generate vouchers:
    [Arguments]    ${quantity}    ${customCode}    ${addRandomLength}=    ${maxNumberOfUsages}=0
    ${currentURL}=    Get Location
    IF    'tab-content-general' not in '${currentURL}'  Zed: go to tab by link href that contains:    voucher
    Type Text    ${zed_discount_voucher_quantity_field}     ${quantity}
    Type Text    ${zed_discount_voucher_custom_code_field}     ${customCode}
    Type Text    ${zed_discount_voucher_max_usages_field}     ${maxNumberOfUsages}
    Click    ${zed_discount_voucher_code_generate_button}

Zed: deactivate following discounts from Overview page:
    [Arguments]    @{discountNames}
    ${items_list_count}=   get length  ${discountNames}
    Zed: go to URL:    /discount/index/list
    FOR    ${name}    IN    @{discountNames}
        Zed: clear search field
        Zed: perform search by:    ${name}
        ${isDiscountActive}=    Set Variable    ${EMPTY}
        Disable Automatic Screenshots on Failure
        ${isDiscountActive}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//td[contains(text(),'${name}')]/following-sibling::td[contains(@class,'Action')]//button[contains(.,'Deactivate')]    timeout=1s
        Restore Automatic Screenshots on Failure
        IF    '${isDiscountActive}'=='True'    
            Click    xpath=//td[contains(text(),'${name}')]/following-sibling::td[contains(@class,'Action')]//button[contains(.,'Deactivate')]
            Wait Until Element Is Visible    xpath=/descendant::button[@type='submit'][contains(.,'Activate')][1]
        END
    END

Zed: deactivate all discounts from Overview page
    Zed: go to URL:    /discount/index/list
    Wait Until Element Is Visible    xpath=/descendant::a[contains(.,'View')][1]
    Zed: clear search field
    Save the result of a SELECT DB query to a variable:    select COUNT(id_discount) from spy_discount    DiscountPagesCount
    ${DiscountPagesCount}=    Evaluate    ${DiscountPagesCount} / 10
    ${DiscountPagesCount}=    Evaluate    math.ceil(${DiscountPagesCount})    math
    ${DiscountPagesCount}=    Convert To Integer    ${DiscountPagesCount}
    FOR    ${PagesCounter}    IN RANGE    0    ${DiscountPagesCount}+1
        ${DiscountActiveCount}=    Get Element Count    xpath=//button[@type='submit'][contains(.,'Deactivate')]
        IF    ${DiscountActiveCount} > 0
            FOR    ${DiscountCounter}    IN RANGE    0    ${DiscountActiveCount}
                Click    xpath=/descendant::button[@type='submit'][contains(.,'Deactivate')][1]
                Wait Until Element Is Visible    xpath=/descendant::button[@type='submit'][contains(.,'Activate')][1]
            END
        END
        Exit For Loop If    ${PagesCounter} == ${DiscountPagesCount}
        Click    xpath=//li[contains(@class,'paginate_button')][contains(@id,'next')]
        Sleep    2s
    END

Zed: activate following discounts from Overview page:
    [Arguments]    @{discountNames}
    ${items_list_count}=   get length  ${discountNames}
    Zed: go to URL:    /discount/index/list
    FOR    ${name}    IN    @{discountNames}
        Zed: clear search field
        Zed: perform search by:    ${name}
        ${isDiscountInactive}=    Set Variable    ${EMPTY}
        Disable Automatic Screenshots on Failure
        ${isDiscountInactive}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//td[contains(text(),'${name}')]/following-sibling::td[contains(@class,'Action')]//button[contains(.,'Activate')]
        Restore Automatic Screenshots on Failure
        IF    '${isDiscountInactive}'=='True'   
            Click    xpath=//td[contains(text(),'${name}')]/following-sibling::td[contains(@class,'Action')]//button[contains(.,'Activate')]
            Wait Until Element Is Visible    xpath=/descendant::button[@type='submit'][contains(.,'Deactivate')][1]
        END
    END