*** Settings ***
Resource    ../pages/yves/yves_checkout_address_page.robot
Resource    ../pages/yves/yves_checkout_login_page.robot
Resource    ../pages/yves/yves_checkout_payment_page.robot
Resource    ../pages/yves/yves_checkout_summary_page.robot
Resource    ../common/common_yves.robot
Resource    ../common/common.robot

*** Variables ***
${cancelRequestButton}    ${checkout_summary_cancel_request_button}
${alertWarning}    ${checkout_summary_alert_warning}
${quoteStatus}    ${checkout_summary_quote_status}
${selected address}

*** Keywords ***
Yves: billing address same as shipping address:
    [Arguments]    ${state}
    ${state}=    Convert To Lower Case    ${state}
    Wait Until Page Contains Element    xpath=//form[@name='addressesForm']
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']    Wait Until Page Contains Element    ${manage_your_addresses_link}
    ${checkboxState}=    Set Variable    ${EMPTY}
    ${checkboxState}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//input[@id='addressesForm_billingSameAsShipping'][@checked]    timeout=100ms
    IF    '${checkboxState}'=='False' and '${state}' == 'true'
        Click Element by xpath with JavaScript    //input[@id='addressesForm_billingSameAsShipping']
        TRY
            Repeat Keyword    3    Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Page is not loaded
        END
    END
    IF    '${checkboxState}'=='True' and '${state}' == 'false'
        Click Element by xpath with JavaScript    //input[@id='addressesForm_billingSameAsShipping']
        TRY
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
    END
    Sleep    1s
    IF    '${state}' == 'true'    Wait Until Element Is Not Visible    ${checkout_billing_address_first_name_field}
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

Yves: 'billing same as shipping' checkbox should be displayed:
    [Arguments]    ${expected_condition}
    ${expected_condition}=    Convert To Lower Case    ${expected_condition}
    IF    '${expected_condition}' == 'true'
        Element Should Be Visible    ${checkout_address_billing_same_as_shipping_checkbox}    message='billing same as shipping' checkbox is not displayed
    ELSE
        Element Should Not Be Visible    ${checkout_address_billing_same_as_shipping_checkbox}    message='billing same as shipping' checkbox is displayed but should NOT
    END

Yves: accept the terms and conditions:
    [Documentation]    ${state} can be true or false
    [Arguments]    ${state}    ${isGuest}=false
    ${state}=    Convert To Lower Case    ${state}
    ${is_invoice_dob_present}=    Run Keyword And Return Status    Element Should Not Be Visible    ${checkout_payment_invoice_date_of_birth_field}
    ${is_marketplace_invoice_dob_present}=    Run Keyword And Return Status    Element Should Not Be Visible    ${checkout_payment_marketplace_invoice_date_field}
    IF    not ${is_invoice_dob_present} or not ${is_marketplace_invoice_dob_present}
        IF    not ${is_invoice_dob_present}    Type Text    ${checkout_payment_invoice_date_of_birth_field}    11.11.2000
        IF    not ${is_marketplace_invoice_dob_present}    Type Text    ${checkout_payment_marketplace_invoice_date_field}    11.11.2000
        Click    ${submit_checkout_form_button}[${env}]
    END
    IF    '${state}' == 'true' and '${isGuest}'=='false'
        Run keywords
            Wait Until Page Contains Element    xpath=//input[@name='acceptTermsAndConditions']
            Run Keyword And Ignore Error    Click Element by xpath with JavaScript    //input[@name='acceptTermsAndConditions']
    ELSE IF    '${state}'=='true' and '${isGuest}'=='true'
        Run keywords
            Wait Until Page Contains Element    id=guestForm_customer_accept_terms
            Click Element by id with JavaScript    guestForm_customer_accept_terms
    END

Yves: select the following existing address on the checkout as 'shipping' address and go next:
    [Arguments]    ${addressToUse}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    IF    '${is_ssp}' == 'true'
        Wait Until Element Is Visible    ${checkout_address_delivery_selector}[ssp_b2b]
    ELSE
        Wait Until Element Is Visible    ${checkout_address_delivery_selector}[${env}] 
    END
    WHILE  '${selected_address}' != '${addressToUse}'    limit=5
        IF    '${env}' in ['ui_b2c','ui_mp_b2c']
            Repeat Keyword    2    Select From List By Label    ${checkout_address_delivery_selector}[${env}]    ${addressToUse}
            TRY
                Repeat Keyword    3    Wait For Load State
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    200ms
            ${selected_address}=    Get Text    xpath=//select[contains(@name,'shippingAddress')][contains(@id,'addressesForm_shippingAddress_id')]/..//span[contains(@id,'shippingAddress_id')]
        ELSE IF    '${env}' in ['ui_b2b','ui_mp_b2b']
            IF    '${is_ssp}' == 'true'
                Repeat Keyword    2    Select From List By Label    ${checkout_address_delivery_selector}[ssp_b2b]    ${addressToUse}
            ELSE
                Repeat Keyword    2    Select From List By Label    ${checkout_address_delivery_selector}[${env}]    ${addressToUse}
            END
            TRY
                Repeat Keyword    3    Wait For Load State
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    200ms
            IF    '${is_ssp}' == 'true'
                ${selected_address}=    Get Text    xpath=(//address-item-form-field-list//select[@name='checkout-full-addresses' and not(ancestor::div[1][contains(@class, 'is-hidden')])]/..//span[contains(@id,'checkout-full-addresses')])[1]
            ELSE
                ${selected_address}=    Get Text    xpath=//div[contains(@class,'shippingAddress')]//select[@name='checkout-full-addresses'][contains(@class,'address__form')]/..//span[contains(@id,'checkout-full-address')]
            END
        ELSE
            Repeat Keyword    2    Select From List By Label    ${checkout_address_delivery_selector}[${env}]    ${addressToUse}
            TRY
                Repeat Keyword    3    Wait For Load State
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    200ms
            Exit For Loop
        END
    END
    IF    '${is_ssp}' == 'true'
        ${ssp_checkout_delivery_address_dropdowns_count}=    Get Element Count    xpath=//address-item-form-field-list//select[@name='checkout-full-addresses' and not(ancestor::div[1][contains(@class, 'is-hidden')])]
        IF    ${ssp_checkout_delivery_address_dropdowns_count} > 1
            FOR    ${index}    IN RANGE    1    ${ssp_checkout_delivery_address_dropdowns_count}
                Repeat Keyword    2    Select From List By Label    xpath=(//address-item-form-field-list//select[@name='checkout-full-addresses' and not(ancestor::div[1][contains(@class, 'is-hidden')])])[${index}+1]    ${addressToUse}
                IF    ${index} == ${ssp_checkout_delivery_address_dropdowns_count}    BREAK
            END
        END
        Repeat Keyword    3    Wait For Load State
        Sleep    500ms
    END
    Click    ${submit_checkout_form_button}[${env}]
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END

Yves: select the following existing address on the checkout as 'shipping':
    [Arguments]    ${addressToUse}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    IF    '${is_ssp}' == 'true'
        Wait Until Element Is Visible    ${checkout_address_delivery_selector}[ssp_b2b] 
    ELSE
        Wait Until Element Is Visible    ${checkout_address_delivery_selector}[${env}] 
    END
    WHILE  '${selected_address}' != '${addressToUse}'    limit=5
        IF    '${env}' in ['ui_b2c','ui_mp_b2c']
            Repeat Keyword    2    Select From List By Label    ${checkout_address_delivery_selector}[${env}]    ${addressToUse}
            TRY
                Repeat Keyword    3    Wait For Load State
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    1s
            ${selected_address}=    Get Text    xpath=//select[contains(@name,'shippingAddress')][contains(@id,'addressesForm_shippingAddress_id')]/..//span[contains(@id,'shippingAddress_id')]
        ELSE IF    '${env}' in ['ui_b2b','ui_mp_b2b']
            IF    '${is_ssp}' == 'true'
                Repeat Keyword    2    Select From List By Label    ${checkout_address_delivery_selector}[ssp_b2b]    ${addressToUse}
            ELSE
                Repeat Keyword    2    Select From List By Label    ${checkout_address_delivery_selector}[${env}]    ${addressToUse}
            END
            TRY
                Repeat Keyword    3    Wait For Load State
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    1s
            IF    '${is_ssp}' == 'true'
                ${selected_address}=    Get Text    xpath=//address-item-form-field-list//select[@name='checkout-full-addresses' and not(ancestor::div[1][contains(@class, 'is-hidden')])]/..//span[contains(@id,'checkout-full-addresses')]
            ELSE
                ${selected_address}=    Get Text    xpath=//div[contains(@class,'shippingAddress')]//select[@name='checkout-full-addresses'][contains(@class,'address__form')]/..//span[contains(@id,'checkout-full-address')]
            END
        ELSE
            Repeat Keyword    2    Select From List By Label    ${checkout_address_delivery_selector}[${env}]    ${addressToUse}
            TRY
                Repeat Keyword    3    Wait For Load State
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    1s
            Exit For Loop
        END
    END

Yves: fill in the following new shipping address:
    [Documentation]    Possible argument names: salutation, firstName, lastName, street, houseNumber, postCode, city, country, company, phone, additionalAddress
    [Arguments]    @{args}
    ${newAddressData}=    Set Up Keyword Arguments    @{args}
    IF    '${is_ssp}' == 'true'
        Select From List By Label    ${checkout_address_delivery_selector}[ssp_b2b]    Define new address
        Wait Until Element Is Visible    xpath=//*[contains(@data-qa,'address-item-form')]//div[contains(@class,'address-content')][@data-qa='component form']
    ELSE
        Select From List By Label    ${checkout_address_delivery_selector}[${env}]    Define new address
        Wait Until Element Is Visible    ${checkout_new_shipping_address_form}
    END
    IF    '${is_ssp}' == 'true'
        VAR    ${checkout_shipping_address_salutation_selector}    ${ssp_checkout_shipping_address_salutation_selector}
        VAR    ${checkout_shipping_address_last_name_field}    ${ssp_checkout_shipping_address_last_name_field}
        VAR    ${checkout_shipping_address_company_name_field}    ${ssp_checkout_shipping_address_company_name_field}
        VAR    ${checkout_shipping_address_street_field}    ${ssp_checkout_shipping_address_street_field}
        VAR    ${checkout_shipping_address_house_number_field}    ${ssp_checkout_shipping_address_house_number_field}
        VAR    ${checkout_shipping_address_additional_address_field}    ${ssp_checkout_shipping_address_additional_address_field}
        VAR    ${checkout_shipping_address_zip_code_field}    ${ssp_checkout_shipping_address_zip_code_field}
        VAR    ${checkout_shipping_address_city_field}    ${ssp_checkout_shipping_address_city_field}
        VAR    ${checkout_shipping_address_country_selector}    ${ssp_checkout_shipping_address_country_selector}
        VAR    ${checkout_shipping_address_phone_field}    ${ssp_checkout_shipping_address_phone_field}
        ${checkout_shipping_address_first_name_field}[${env}]=    Set Variable    ${ssp_checkout_shipping_address_first_name_field}
    END
    FOR    ${key}    ${value}    IN    &{newAddressData}
        IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    ${checkout_shipping_address_salutation_selector}    ${value}
        IF    '${key}'=='firstName' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_first_name_field}[${env}]    ${value}
        IF    '${key}'=='lastName' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_last_name_field}    ${value}
        IF    '${key}'=='street' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_street_field}    ${value}
        IF    '${key}'=='houseNumber' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_house_number_field}    ${value}
        IF    '${key}'=='postCode' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_zip_code_field}    ${value}
        IF    '${key}'=='city' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_city_field}    ${value}
        IF    '${key}'=='country' and '${value}' != '${EMPTY}'    Select From List By Label    ${checkout_shipping_address_country_selector}    ${value}
        IF    '${key}'=='company' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_company_name_field}    ${value}
        IF    '${key}'=='phone' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_phone_field}    ${value}
        IF    '${key}'=='additionalAddress' and '${value}' != '${EMPTY}'    Type Text    ${checkout_shipping_address_additional_address_field}    ${value}
    END
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    Sleep    1s

Yves: fill in the following new billing address:
    [Documentation]    Possible argument names: salutation, firstName, lastName, street, houseNumber, postCode, city, country, company, phone, additionalAddress
    [Arguments]    @{args}
    ${newAddressData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Enabled    ${checkout_address_billing_selector}[${env}]
    Select From List By Label    ${checkout_address_billing_selector}[${env}]    Define new address
    Wait Until Element Is Visible    ${checkout_new_billing_address_form}
    FOR    ${key}    ${value}    IN    &{newAddressData}
        IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    ${checkout_billing_address_salutation_selector}    ${value}
        IF    '${key}'=='firstName' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_first_name_field}    ${value}
        IF    '${key}'=='lastName' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_last_name_field}    ${value}
        IF    '${key}'=='street' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_street_field}    ${value}
        IF    '${key}'=='houseNumber' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_house_number_field}    ${value}
        IF    '${key}'=='postCode' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_zip_code_field}    ${value}
        IF    '${key}'=='city' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_city_field}    ${value}
        IF    '${key}'=='country' and '${value}' != '${EMPTY}'    Select From List By Label    ${checkout_billing_address_country_select}    ${value}
        IF    '${key}'=='company' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_company_name_field}    ${value}
        IF    '${key}'=='phone' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_phone_field}    ${value}
        IF    '${key}'=='additionalAddress' and '${value}' != '${EMPTY}'    Type Text    ${checkout_billing_address_additional_address_field}    ${value}
    END
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    Sleep    1s

Yves: select delivery to multiple addresses
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    IF    '${is_ssp}' == 'true'
        VAR    ${single_address_per_shipment_type_checkbox_locator}    xpath=//toggler-checkbox[contains(@name,'isSingleAddressPerShipmentType')][1]
        Wait Until Page Contains Element    ${single_address_per_shipment_type_checkbox_locator}
        ${single_address_per_shipment_type_checkbox_is_checked}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//toggler-checkbox[contains(@name,'isSingleAddressPerShipmentType')][1][@checked]    timeout=100ms
        IF    '${single_address_per_shipment_type_checkbox_is_checked}'=='True'
            Click    ${single_address_per_shipment_type_checkbox_locator}
        END
    ELSE
        Select From List By Label    ${checkout_address_delivery_selector}[${env}]    Deliver to multiple addresses
    END

Yves: select multiple addresses from toggler
    Wait Until Element Is Visible    ${checkout_address_multiple_addresses_toggler_button}
    Click    ${checkout_address_multiple_addresses_toggler_button}

Yves: click checkout button:
    [Arguments]    ${buttonName}
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    Click    xpath=//button[@type='submit' and contains(text(),'${buttonName}')]
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

Yves: fill in new delivery address for a product:
    [Documentation]    Possible argument names: product (SKU or Name), salutation, firstName, lastName, street, houseNumber, postCode, city, country, company, phone, additionalAddress
    [Arguments]    @{args}
    ${newAddressData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{newAddressData}
        ${item}=    Set Variable If    '${key}'=='product'    ${value}    ${item}
        IF    '${key}'=='product' and '${value}' != '${EMPTY}'
            IF    '${env}' in ['ui_mp_b2c']    Yves: select xxx shipment type for item xxx:    shipment_type=Delivery    item=${item}
            IF    '${env}' not in ['ui_suite']    Select From List By Label    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]//select    Define new address
            IF    '${env}' in ['ui_suite']
                Click    xpath=//*[contains(@data-qa,'address-item-form-field-list')]/div//strong[contains(.,'${item}')]/ancestor::div[contains(@class,'item-shipping')]//shipment-type-toggler//span[contains(@class,'label')][contains(.,'Delivery')]
                Select From List By Label    xpath=//*[contains(@data-qa,'address-item-form-field-list')]/div//strong[contains(.,'${item}')]/ancestor::div[contains(@class,'item-shipping')]//select[contains(@name,'id_customer_address')]    Define new address
            END
        END
        IF    '${env}' in ['ui_mp_b2c']
            IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::article/following-sibling::div[contains(@class,'address-item-form')]//select[contains(@name,'[salutation]')]    ${value}
            IF    '${key}'=='firstName' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::article/following-sibling::div[contains(@class,'address-item-form')]//input[contains(@name,'[first_name]')]    ${value}
            IF    '${key}'=='lastName' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::article/following-sibling::div[contains(@class,'address-item-form')]//input[contains(@name,'[last_name]')]    ${value}
            IF    '${key}'=='street' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::article/following-sibling::div[contains(@class,'address-item-form')]//input[contains(@name,'[address1]')]    ${value}
            IF    '${key}'=='houseNumber' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::article/following-sibling::div[contains(@class,'address-item-form')]//input[contains(@name,'[address2]')]    ${value}
            IF    '${key}'=='postCode' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::article/following-sibling::div[contains(@class,'address-item-form')]//input[contains(@name,'[zip_code]')]    ${value}
            IF    '${key}'=='city' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::article/following-sibling::div[contains(@class,'address-item-form')]//*[self::input or self::textarea][contains(@name,'[city]')]    ${value}
            IF    '${key}'=='country' and '${value}' != '${EMPTY}'    Select From List By Label    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::article/following-sibling::div[contains(@class,'address-item-form')]//select[contains(@name,'[iso2_code]')]    ${value}
            IF    '${key}'=='company' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::article/following-sibling::div[contains(@class,'address-item-form')]//input[contains(@name,'[company]')]    ${value}
            IF    '${key}'=='phone' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::article/following-sibling::div[contains(@class,'address-item-form')]//input[contains(@name,'[phone]')]    ${value}
            IF    '${key}'=='additionalAddress' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::article/following-sibling::div[contains(@class,'address-item-form')]//input[contains(@name,'[address3]')]    ${value}
        ELSE IF    '${env}' in ['ui_suite']
            IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    xpath=//*[contains(@data-qa,'address-item-form-field-list')]/div//strong[contains(.,'${item}')]/ancestor::div[contains(@class,'item-shipping')]//div[@data-qa='component form']//select[contains(@name,'[salutation]')]    ${value}
            IF    '${key}'=='firstName' and '${value}' != '${EMPTY}'    Type Text    xpath=//*[contains(@data-qa,'address-item-form-field-list')]/div//strong[contains(.,'${item}')]/ancestor::div[contains(@class,'item-shipping')]//div[@data-qa='component form']//input[contains(@name,'[first_name]')]    ${value}
            IF    '${key}'=='lastName' and '${value}' != '${EMPTY}'    Type Text    xpath=//*[contains(@data-qa,'address-item-form-field-list')]/div//strong[contains(.,'${item}')]/ancestor::div[contains(@class,'item-shipping')]//div[@data-qa='component form']//input[contains(@name,'[last_name]')]    ${value}
            IF    '${key}'=='street' and '${value}' != '${EMPTY}'    Type Text    xpath=//*[contains(@data-qa,'address-item-form-field-list')]/div//strong[contains(.,'${item}')]/ancestor::div[contains(@class,'item-shipping')]//div[@data-qa='component form']//input[contains(@name,'[address1]')]    ${value}
            IF    '${key}'=='houseNumber' and '${value}' != '${EMPTY}'    Type Text    xpath=//*[contains(@data-qa,'address-item-form-field-list')]/div//strong[contains(.,'${item}')]/ancestor::div[contains(@class,'item-shipping')]//div[@data-qa='component form']//input[contains(@name,'[address2]')]    ${value}
            IF    '${key}'=='postCode' and '${value}' != '${EMPTY}'    Type Text    xpath=//*[contains(@data-qa,'address-item-form-field-list')]/div//strong[contains(.,'${item}')]/ancestor::div[contains(@class,'item-shipping')]//div[@data-qa='component form']//input[contains(@name,'[zip_code]')]    ${value}
            IF    '${key}'=='city' and '${value}' != '${EMPTY}'    Type Text    xpath=//*[contains(@data-qa,'address-item-form-field-list')]/div//strong[contains(.,'${item}')]/ancestor::div[contains(@class,'item-shipping')]//div[@data-qa='component form']//*[self::input or self::textarea][contains(@name,'[city]')]    ${value}
            IF    '${key}'=='country' and '${value}' != '${EMPTY}'    Select From List By Label    xpath=//*[contains(@data-qa,'address-item-form-field-list')]/div//strong[contains(.,'${item}')]/ancestor::div[contains(@class,'item-shipping')]//div[@data-qa='component form']//select[contains(@name,'[iso2_code]')]    ${value}
            IF    '${key}'=='company' and '${value}' != '${EMPTY}'    Type Text    xpath=//*[contains(@data-qa,'address-item-form-field-list')]/div//strong[contains(.,'${item}')]/ancestor::div[contains(@class,'item-shipping')]//div[@data-qa='component form']//input[contains(@name,'[company]')]    ${value}
            IF    '${key}'=='phone' and '${value}' != '${EMPTY}'    Type Text    xpath=//*[contains(@data-qa,'address-item-form-field-list')]/div//strong[contains(.,'${item}')]/ancestor::div[contains(@class,'item-shipping')]//div[@data-qa='component form']//input[contains(@name,'[phone]')]    ${value}
            IF    '${key}'=='additionalAddress' and '${value}' != '${EMPTY}'    Type Text    xpath=//*[contains(@data-qa,'address-item-form-field-list')]/div//strong[contains(.,'${item}')]/ancestor::div[contains(@class,'item-shipping')]//div[@data-qa='component form']//input[contains(@name,'[address3]')]    ${value}
        ELSE
            IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//select[contains(@name,'[salutation]')]    ${value}
            IF    '${key}'=='firstName' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[first_name]')]    ${value}
            IF    '${key}'=='lastName' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[last_name]')]    ${value}
            IF    '${key}'=='street' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[address1]')]    ${value}
            IF    '${key}'=='houseNumber' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[address2]')]    ${value}
            IF    '${key}'=='postCode' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[zip_code]')]    ${value}
            IF    '${key}'=='city' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//*[self::input or self::textarea][contains(@name,'[city]')]    ${value}
            IF    '${key}'=='country' and '${value}' != '${EMPTY}'    Select From List By Label    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//select[contains(@name,'[iso2_code]')]    ${value}
            IF    '${key}'=='company' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[company]')]    ${value}
            IF    '${key}'=='phone' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[phone]')]    ${value}
            IF    '${key}'=='additionalAddress' and '${value}' != '${EMPTY}'    Type Text    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]/ancestor::div[contains(@class,'address-item-form')][1]//input[contains(@name,'[address3]')]    ${value}
        END
    END
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    Sleep    1s

Yves: select the following shipping method on the checkout and go next:
    [Arguments]    ${shippingMethod}
    IF    '${env}'=='ui_suite'
        Click With Options    xpath=//input[contains(@id,'shipmentSelection')]/following-sibling::span[contains(@class,'label')][contains(.,'${shippingMethod}')]/../span[contains(@class,'radio__box')]    force=True
    ELSE
        Click    xpath=//div[@data-qa='component shipment-sidebar']//*[contains(.,'Shipping Method')]/../ul//label[contains(.,'${shippingMethod}')]/span[contains(@class,'radio__box')]
    END
    Click    ${submit_checkout_form_button}[${env}]
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

Yves: submit form on the checkout
    Click    ${submit_checkout_form_button}[${env}]
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END

Yves: select the following shipping method for the shipment:
    [Arguments]    ${shipment}    ${shippingProvider}    ${shippingMethod}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    IF    '${env}' in ['ui_suite']
        Click    //form[@name='shipmentCollectionForm']/descendant::article[contains(@class,'grid')][${shipment}]/div[last()]//h5[contains(.,'${shippingProvider}')]/following-sibling::ul[1]//label[contains(.,'${shippingMethod}')]/span[contains(@class,'radio__box')]
    ELSE
        Click    xpath=//form[@name='shipmentCollectionForm']/descendant::article[contains(@class,'grid')][${shipment}]//div[@data-qa='component shipment-sidebar']//*[contains(@class,'title')]/*[contains(text(),'${shippingProvider}')]/..//following-sibling::ul[1]//label[contains(.,'${shippingMethod}')]/span[contains(@class,'radio__box')]
    END

Yves: select the following payment method on the checkout and go next:
    [Arguments]    ${paymentMethod}    ${paymentProvider}=${EMPTY}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    IF    '${env}'=='ui_b2b' and '${paymentMethod}'=='Invoice'
        Click    //form[@id='payment-form']//li[@class='checkout-list__item'][contains(.,'${paymentMethod}')]//span[contains(@class,'toggler-radio__box')]
        Disable Automatic Screenshots on Failure
        ${date_of_birth_present}=    Run Keyword And Ignore Error    Page Should Contain Element    ${checkout_payment_invoice_date_of_birth_field}    timeout=400ms
        Restore Automatic Screenshots on Failure
        IF    'PASS' in $date_of_birth_present    Type Text    ${checkout_payment_invoice_date_of_birth_field}    11.11.2000
        Click    ${submit_checkout_form_button}[${env}]
    ELSE IF    '${env}' in ['ui_mp_b2b'] and '${paymentMethod}'=='Invoice'
        Click    //form[@id='payment-form']//li[@class='checkout-list__item'][contains(.,'${paymentMethod}')]//span[contains(@class,'toggler-radio__box')]
        Disable Automatic Screenshots on Failure
        ${date_of_birth_present}=    Run Keyword And Ignore Error    Page Should Contain Element    ${checkout_payment_marketplace_invoice_date_field}    timeout=400ms
        Restore Automatic Screenshots on Failure
        IF    'PASS' in $date_of_birth_present    Type Text    ${checkout_payment_marketplace_invoice_date_field}    11.11.2000
        Click    ${submit_checkout_form_button}[${env}]
    ELSE IF    '${env}' in ['ui_mp_b2b'] and '${paymentMethod}'=='Invoice (Marketplace)'
        Click    //form[@id='payment-form']//li[@class='checkout-list__item'][contains(.,'${paymentMethod}')]//span[contains(@class,'toggler-radio__box')]
        Disable Automatic Screenshots on Failure
        ${date_of_birth_present}=    Run Keyword And Ignore Error    Page Should Contain Element    ${checkout_payment_marketplace_invoice_date_field}    timeout=400ms
        Restore Automatic Screenshots on Failure
        IF    'PASS' in $date_of_birth_present    Type Text    ${checkout_payment_marketplace_invoice_date_field}    11.11.2000
        Click    ${submit_checkout_form_button}[${env}]
    ELSE IF    '${env}' in ['ui_mp_b2b'] and '${paymentMethod}'=='Marketplace Invoice'
        Click    //form[@id='payment-form']//li[@class='checkout-list__item'][contains(.,'${paymentMethod}')]//span[contains(@class,'toggler-radio__box')]
        Disable Automatic Screenshots on Failure
        ${date_of_birth_present}=    Run Keyword And Ignore Error    Page Should Contain Element    ${checkout_payment_marketplace_invoice_date_field}    timeout=400ms
        Restore Automatic Screenshots on Failure
        IF    'PASS' in $date_of_birth_present    Type Text    ${checkout_payment_marketplace_invoice_date_field}    11.11.2000
        Click    ${submit_checkout_form_button}[${env}]
    ELSE IF    ('${env}'=='ui_suite' and '${paymentProvider}'!='${EMPTY}')
        Click    //form[@name='paymentForm']//h5[contains(text(), '${paymentProvider}')]/following-sibling::ul//label/span[contains(text(), '${paymentMethod}')]
        Click    ${submit_checkout_form_button}[${env}]
    ELSE IF    '${env}'=='ui_mp_b2c' and '${paymentMethod}'=='Credit Card'
        Click    //form[@name='paymentForm']//toggler-radio[contains(.,'${paymentMethod}')]//span[contains(@class,'toggler-radio__box')]
        Type Text    ${checkout_payment_card_number_field}    4111111111111111
        Type Text    ${checkout_payment_name_on_card_field}    First Last
        Select From List By Value    ${checkout_payment_card_expires_month_select}    01
        Select From List By Value    ${checkout_payment_card_expires_year_select}    2025
        Type Text    ${checkout_payment_card_security_code_field}    123
        Click    ${submit_checkout_form_button}[${env}]
    ELSE IF    '${env}' in ['ui_mp_b2c'] and '${paymentMethod}'=='Invoice'
        Click    //form[@name='paymentForm']//toggler-radio[contains(.,'${paymentMethod}')]//span[contains(@class,'toggler-radio__box')]
        Disable Automatic Screenshots on Failure
        ${date_of_birth_present}=    Run Keyword And Ignore Error    Page Should Contain Element    ${checkout_payment_invoice_date_of_birth_field}    timeout=400ms
        Restore Automatic Screenshots on Failure
        IF    'PASS' in $date_of_birth_present    Type Text    ${checkout_payment_invoice_date_of_birth_field}    11.11.2000
        Click    ${submit_checkout_form_button}[${env}]    
    ELSE IF    '${env}' in ['ui_mp_b2c'] and '${paymentMethod}'=='Invoice (Marketplace)'
        Click    //form[@name='paymentForm']//toggler-radio[contains(.,'${paymentMethod}')]//span[contains(@class,'toggler-radio__box')]
        Disable Automatic Screenshots on Failure
        ${date_of_birth_present}=    Run Keyword And Ignore Error    Page Should Contain Element    ${checkout_payment_marketplace_invoice_date_field}    timeout=400ms
        Restore Automatic Screenshots on Failure
        IF    'PASS' in $date_of_birth_present    Type Text    ${checkout_payment_marketplace_invoice_date_field}    11.11.2000
        Click    ${submit_checkout_form_button}[${env}]    
    ELSE IF    '${env}' in ['ui_mp_b2c'] and '${paymentMethod}'=='Marketplace Invoice'
        Click    //form[@name='paymentForm']//toggler-radio[contains(.,'${paymentMethod}')]//span[contains(@class,'toggler-radio__box')]
        Disable Automatic Screenshots on Failure
        ${date_of_birth_present}=    Run Keyword And Ignore Error    Page Should Contain Element    ${checkout_payment_marketplace_invoice_date_field}    timeout=400ms
        Restore Automatic Screenshots on Failure
        IF    'PASS' in $date_of_birth_present    Type Text    ${checkout_payment_marketplace_invoice_date_field}    11.11.2000
        Click    ${submit_checkout_form_button}[${env}]    
    ELSE
        IF    '${paymentMethod}' == 'Invoice' or '${paymentMethod}' == 'invoice'
            ${payment_method_index}=    Set Variable    last()
            Click    xpath=(//form[@name='paymentForm']//span[contains(@class,'toggler') and contains(text(),'${paymentMethod}')]/preceding-sibling::span[@class='toggler-radio__box'])[${payment_method_index}]
            Disable Automatic Screenshots on Failure
            ${date_of_birth_present}=    Run Keyword And Ignore Error    Page Should Contain Element    ${checkout_payment_invoice_date_of_birth_field}    timeout=400ms
            Restore Automatic Screenshots on Failure
            IF    'PASS' in $date_of_birth_present    Type Text    ${checkout_payment_invoice_date_of_birth_field}    11.11.2000
        ELSE
            ${payment_method_index}=    Set Variable    position()=1
            Click    xpath=(//form[@name='paymentForm']//span[contains(@class,'toggler') and contains(text(),'Invoice')]/preceding-sibling::span[@class='toggler-radio__box'])[${payment_method_index}]
            Disable Automatic Screenshots on Failure
            ${date_of_birth_present}=    Run Keyword And Ignore Error    Page Should Contain Element    ${checkout_payment_marketplace_invoice_date_field}    timeout=400ms
            Restore Automatic Screenshots on Failure
            IF    'PASS' in $date_of_birth_present    Type Text    ${checkout_payment_marketplace_invoice_date_field}    11.11.2000
        END
        Click    ${submit_checkout_form_button}[${env}]
    END
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END

Yves: '${checkoutAction}' on the summary page
    [Documentation]    Possible supported actions: 'submit the order', 'send the request' and 'approve the cart'
    IF    '${checkoutAction}' == 'submit the order'
        Click    ${checkout_summary_submit_order_button}
    ELSE IF    '${checkoutAction}' == 'send the request'
        Click    ${checkout_summary_send_request_button}
    ELSE IF    '${checkoutAction}' == 'approve the cart'
        Click    ${checkout_summary_approve_request_button}
    END
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END

Yves: select approver on the 'Summary' page:
    [Arguments]    ${approver}
    Wait Until Element Is Visible    ${checkout_summary_approver_dropdown}
    Select From List By Label    ${checkout_summary_approver_dropdown}    ${approver}

Yves: 'Summary' page contains/doesn't contain:
    [Arguments]    ${condition}    @{checkout_summary_elements_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${checkout_summary_elements_list_count}=   get length    ${checkout_summary_elements_list}
    FOR    ${index}    IN RANGE    0    ${checkout_summary_elements_list_count}
        ${checkout_summary_element_to_check}=    Get From List    ${checkout_summary_elements_list}     ${index}
        IF    '${condition}' == 'true'
            Run Keywords
                Log    ${checkout_summary_element_to_check}    #Left as an example of multiple actions in Condition
                Page Should Contain Element    ${checkout_summary_element_to_check}    message=${checkout_summary_element_to_check} is not displayed
        END
        IF    '${condition}' == 'false'
                Run Keywords
                    Log    ${checkout_summary_element_to_check}    #Left as an example of multiple actions in Condition
                    Page Should Not Contain Element    ${checkout_summary_element_to_check}    message=${checkout_summary_element_to_check} should not be displayed
        END
    END

Yves: proceed with checkout as guest:
    [Arguments]    ${salutation}    ${firstName}    ${lastName}    ${email}
    Wait Until Page Contains Element    xpath=//toggler-radio[contains(@data-qa,'checkoutProceedAs')][contains(@data-qa,'guest')]//input
    Click Element by xpath with JavaScript    //toggler-radio[contains(@data-qa,'checkoutProceedAs')][contains(@data-qa,'guest')]//input
    Wait Until Element Is Visible    ${yves_checkout_login_guest_firstName_field}
    Type Text    ${yves_checkout_login_guest_firstName_field}     ${firstName}
    Type Text    ${yves_checkout_login_guest_lastName_field}     ${lastName}
    Type Text    ${yves_checkout_login_guest_email_field}     ${email}
    Yves: accept the terms and conditions:    true    isGuest=true
    Click    ${yves_checkout_login_buy_as_guest_submit_button}

Yves: assert merchant of product in cart or list:
    [Documentation]    Method for MP which asserts value in 'Sold by' label of item in cart or list. Requires concrete SKU
    [Arguments]    ${sku}    ${merchant_name_expected}
    Page Should Contain Element    xpath=(//*[@itemprop='sku' and (text()='${sku}' or @content='${sku}')]/ancestor::*[self::article or self::tr or self::product-item][contains(@itemtype,'Product')]//a[contains(@href,'merchant')][contains(text(),'${merchant_name_expected}')])[1]    timeout=${browser_timeout}

Yves: save new delivery address to address book:
    [Arguments]    ${state}
    ${state}=    Convert To Lower Case    ${state}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']    Wait Until Page Contains Element    ${manage_your_addresses_link}
    ${checkboxState}=    Set Variable    ${EMPTY}
    IF    '${is_ssp}' == 'true'
        ${checkboxState}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//*[contains(@data-qa,'address-item-form')]//input[contains(@name,'[shippingAddress][isAddressSavingSkipped]')][@checked]    timeout=100ms
    ELSE
        ${checkboxState}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//input[@id='addressesForm_shippingAddress_isAddressSavingSkipped'][@checked]    timeout=100ms
    END
    IF    '${checkboxState}'=='False' and '${state}' == 'true'
        IF    '${is_ssp}' == 'true'
            Click    xpath=//*[contains(@data-qa,'address-item-form')]//input[contains(@name,'[shippingAddress][isAddressSavingSkipped]')]/ancestor::span[contains(@data-qa,'checkbox')]
        ELSE
            Click    xpath=//input[@id='addressesForm_shippingAddress_isAddressSavingSkipped']/ancestor::span[contains(@data-qa,'checkbox')]
        END
        TRY
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
    END
    IF    '${checkboxState}'=='True' and '${state}' == 'false'
        IF    '${is_ssp}' == 'true'
            Click    xpath=//*[contains(@data-qa,'address-item-form')]//input[contains(@name,'[shippingAddress][isAddressSavingSkipped]')]/ancestor::span[contains(@data-qa,'checkbox')]
        ELSE
            Click    xpath=//input[@id='addressesForm_shippingAddress_isAddressSavingSkipped']/ancestor::span[contains(@data-qa,'checkbox')]
        END
        
        TRY
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
    END

Yves: save new billing address to address book:
    [Arguments]    ${state}
    ${state}=    Convert To Lower Case    ${state}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']    Wait Until Page Contains Element    ${manage_your_addresses_link}
    ${checkboxState}=    Set Variable    ${EMPTY}
    ${checkboxState}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//input[@id='addressesForm_billingAddress_isAddressSavingSkipped'][@checked]    timeout=100ms
    IF    '${checkboxState}'=='False' and '${state}' == 'true'
        Click    xpath=//input[@id='addressesForm_billingAddress_isAddressSavingSkipped']/ancestor::span[contains(@data-qa,'checkbox')]
        TRY
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
    END
    IF    '${checkboxState}'=='True' and '${state}' == 'false'
        Click    xpath=//input[@id='addressesForm_billingAddress_isAddressSavingSkipped']/ancestor::span[contains(@data-qa,'checkbox')]
        TRY
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
    END

Yves: return to the previous checkout step:
    [Arguments]    ${checkoutStep}
    ${checkoutStep}=    Convert To Lower Case    ${checkoutStep}
    Click    //ul[@data-qa='component breadcrumb']//a[contains(@href,'${checkoutStep}')]
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    
Yves: check that the payment method is/not present in the checkout process:
    [Arguments]    ${payment_method_locator}    ${condition}
    ${condition}=    Convert To Lower Case    ${condition}
    IF    '${condition}' == 'true'
        Page Should Contain Element    ${payment_method_locator}
    ELSE IF    '${condition}' == 'false'
        Page Should not Contain Element    ${payment_method_locator}
    END

 Yves: proceed as a guest user and login during checkout:
    [Arguments]    ${email}    ${password}=${default_password}
    IF    '${env}' in ['ui_suite']
        Wait Until Page Contains Element    ${email_field}
        Type Text    ${email_field}    ${email}
        Type Text    ${password_field}    ${password}
        Click    ${form_login_button}
        TRY
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
    ELSE
        Wait Until Page Contains Element    ${yves_checkout_login_tab}
        Click    ${yves_checkout_login_tab}
        Type Text    ${email_field}    ${email}
        Type Text    ${password_field}    ${password}
        Click    ${form_login_button}
        TRY
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
    END

Yves: signup guest user during checkout:
    [Arguments]      ${firstName}    ${lastName}    ${email}     ${password}      ${confirmpassword}
    Wait Until Page Contains Element    ${yves_checkout_signup_button}
    Click    ${yves_checkout_signup_button}
    Type Text    ${yves_checkout_signup_first_name}    ${firstname}
    Type Text    ${yves_checkout_signup_last_name}    ${lastname}
    Type Text    ${yves_checkout_signup_email}    ${email}
    Type Text    ${yves_checkout_signup_password}    ${password}
    Type Text    ${yves_checkout_signup_confirm_password}    ${confirmpassword}
    Wait Until Element Is Visible   ${yves_checkout_signup_accept_terms}
    Check Checkbox  ${yves_checkout_signup_accept_terms}
    Click    ${yves_checkout_signup_tab}

Yves: select xxx shipment type for item number xxx:
    [Arguments]    ${shipment_type}    ${item_number}
    ${item_number}=    Evaluate    ${item_number}-1
    Wait Until Element Is Visible    xpath=//input[contains(@id,'addressesForm_multiShippingAddresses_${item_number}')]/following-sibling::span[contains(text(), '${shipment_type}')]
    Click    xpath=//input[contains(@id,'addressesForm_multiShippingAddresses_${item_number}')]/following-sibling::span[contains(text(), '${shipment_type}')]
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

Yves: select xxx shipment type for item xxx:
    [Arguments]    ${shipment_type}    ${item}
    Click    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${item}')]//shipment-type-toggler//span[contains(@data-qa,'shipmentType')]//span[contains(text(), '${shipment_type}')]
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

Yves: select xxx shipment type on checkout:
    [Arguments]    ${shipment_type}
    Click With Options    xpath=(//form[@name='addressesForm']//shipment-type-toggler//span[contains(@data-qa,'shipmentType')]//span[contains(text(), '${shipment_type}')])[1]    force=True
    TRY
        Repeat Keyword    2    Wait For Load State
        Repeat Keyword    2    Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END

Yves: check store availability for item number xxx:
    [Arguments]    @{args}
    ${availabilityData}=    Set Up Keyword Arguments    @{args}
    ${item_number}=    Set Variable    1
    FOR    ${key}    ${value}    IN    &{availabilityData}
        IF    '${key}'=='item_number' and '${value}' != '${EMPTY}'
            ${item_number}=    Set Variable    ${value}
        END
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'
            IF    '${env}' in ['ui_suite']
                Click    xpath=(//*[contains(@data-qa,'address-item-form')][contains(@class,'list')]/div)[${item_number}]//shipment-type-toggler//service-point-selector[contains(@data-qa,'service-point-selector')]/div[contains(@class,'no-location')]/button
                Sleep    2s
                Fill Text    xpath=((//div[contains(@id,'service-point-selector')])[${item_number}]//input[contains(@class,'search')])[1]    ${value}    force=True
            ELSE
                Click    xpath=(//article)[${item_number}]//shipment-type-toggler//service-point-selector[contains(@data-qa,'service-point-selector')]
                Sleep    2s
                Fill Text    xpath=((//div[contains(@id,'service-point-selector')])[${item_number}]//input[contains(@class,'search')])[1]    ${value}    force=True
            END
            Keyboard Key    press    Enter
            Sleep    2s
            TRY
                Repeat Keyword    5    Wait For Load State
            EXCEPT
                Log    Page is not loaded
            END
        END
        IF    '${key}'=='availability' and '${value}' != '${EMPTY}'
            ${value}=    Convert To Lower Case    ${value}
            IF    '${value}' == 'green'
                Page Should Contain Element    xpath=((//div[contains(@id,'service-point-selector')])[${item_number}]//*[contains(@data-qa,'service-point-availability-status')]//span[contains(@class,'all-items-available')])[1]
            # ELSE IF    '${value}' == 'yellow'
            #     Page Should Contain Element    xpath=
            # ELSE IF    '${value}' == 'red'
            #     Page Should Contain Element    xpath=
            END
        END
    END
    Click With Options    xpath=((//div[contains(@id,'service-point-selector')])[${item_number}]//button[contains(@class,'close')][contains(@class,'main-popup')])[1]    force=True
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

Yves: select pickup service point store for item number xxx:
    [Arguments]    @{args}
    ${servicePointData}=    Set Up Keyword Arguments    @{args}
    ${item_number}=    Set Variable    1
    FOR    ${key}    ${value}    IN    &{servicePointData}
        IF    '${key}'=='item_number' and '${value}' != '${EMPTY}'
            ${item_number}=    Set Variable    ${value}
        END
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'
            IF    '${env}' in ['ui_suite']
                Click    xpath=(//*[contains(@data-qa,'address-item-form')][contains(@class,'list')]/div)[${item_number}]//shipment-type-toggler//service-point-selector[contains(@data-qa,'service-point-selector')]/div[contains(@class,'no-location')]/button
                Sleep    2s
                Fill Text    xpath=((//div[contains(@id,'service-point-selector')])[${item_number}]//input[contains(@class,'search')])[1]    ${value}    force=True
            ELSE
                Click    xpath=(//article)[${item_number}]//shipment-type-toggler//service-point-selector[contains(@data-qa,'service-point-selector')]
                Sleep    2s
                Fill Text    xpath=((//div[contains(@id,'service-point-selector')])[${item_number}]//input[contains(@class,'search')])[1]    ${value}    force=True
            END
            Keyboard Key    press    Enter
            Sleep    2s
            TRY
                Repeat Keyword    5    Wait For Load State
            EXCEPT
                Log    Page is not loaded
            END
            Click With Options    xpath=((//div[contains(@id,'service-point-selector')])[${item_number}]//button[contains(@class,'select-button')])[position()=1]    force=true
            TRY
                Repeat Keyword    3    Wait For Load State
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    1s
        END
    END

Yves: checkout summary page contains product with unit price:
    [Arguments]    ${sku}    ${productName}    ${productPrice}
    Reload
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']
        TRY
            Page Should Contain Element    xpath=//div[contains(@class,'product-card-item__col--description')]//div[contains(.,'SKU: ${sku}')]/ancestor::article//*[contains(@class,'product-card-item__col--description')]/div[1]//*[contains(@class,'money-price__amount')][contains(.,'${productPrice}')]    timeout=100ms
        EXCEPT
            Page Should Contain Element    xpath=//div[contains(@class,'product-cart-item__col--description')]//div[contains(.,'SKU: ${sku}')]/ancestor::article//*[contains(@class,'product-cart-item__col--description')]/div[1]//*[contains(@class,'money-price__amount')][contains(.,'${productPrice}')]    timeout=100ms
        END
    ELSE IF    '${env}' in ['ui_suite']
        Page Should Contain Element    xpath=//*[contains(@data-qa,'summary-node')]//div[contains(.,'${productName}')]/ancestor::*[contains(@data-qa,'summary-node')]//strong[contains(.,'${productPrice}')]
    ELSE
        Page Should Contain Element    xpath=//article[contains(@data-qa,'component product-card-item')]//*[contains(text(),'${productName}')]/following-sibling::span/span[contains(@class,'money-price__amount') and contains(.,'${productPrice}')]    timeout=1s
    END

Yves: checkout summary step contains product with unit price:
    [Arguments]    ${productName}    ${productPrice}
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    Page Should Contain Element    xpath=(//*[contains(@data-qa,'summary-node')]//div[contains(.,'${productName}')]/ancestor::*[contains(@data-qa,'summary-node')]//strong[contains(.,'${productPrice}')])[1]
