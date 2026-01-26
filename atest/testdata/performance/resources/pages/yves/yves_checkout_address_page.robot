*** Variables ***
${checkout_address_billing_same_as_shipping_checkbox}    xpath=//input[@id='addressesForm_billingSameAsShipping']/ancestor::toggler-checkbox
&{checkout_address_delivery_dropdown}    ui_b2b=xpath=//span[@id='select2-checkout-full-addresses-ct-container']    ui_b2c=xpath=//span[@id='select2-addressesForm_shippingAddress_id_customer_address-container']    ui_mp_b2b=xpath=//span[@id='select2-checkout-full-addresses-ct-container']    ui_mp_b2c=xpath=//span[@id='select2-addressesForm_shippingAddress_id_customer_address-container']
&{checkout_address_delivery_selector}    ui_b2c=xpath=//select[@id='addressesForm_shippingAddress_id_customer_address']    ui_b2b=xpath=//div[contains(@class,'shippingAddress')]//select[@name='checkout-full-addresses'][contains(@class,'address__form')]    ui_suite=xpath=//div[contains(@class,'shippingAddress')]//select[contains(@name,'address')][contains(@class,'address__form')]    ui_mp_b2b=xpath=//div[contains(@class,'shippingAddress')]//select[@name='checkout-full-addresses'][contains(@class,'address__form')]    ui_mp_b2c=xpath=//select[@id='addressesForm_shippingAddress_id_customer_address']    ssp_b2b=xpath=(//address-item-form-field-list//select[@name='checkout-full-addresses' and not(ancestor::div[1][contains(@class, 'is-hidden')])])[1]
${checkout_address_multiple_addresses_toggler_button}    xpath=//multiple-shipment-toggler/button[contains(@class,'multiple-shipment-trigger')]
${checkout_shipping_address_item_form}    xpath=//div[@data-qa='component address-item-form']
${checkout_new_billing_address_form}    xpath=//div[contains(@class,'address__billing')][@data-qa='component form']
${checkout_new_shipping_address_form}    xpath=//div[contains(@class,'address__shipping')][@data-qa='component form']
&{checkout_shipping_address_first_name_field}    ui_b2b=id=addressesForm_shippingAddress_first_name    ui_b2c=id=addressesForm_shippingAddress_first_name    ui_suite=id=addressesForm_shippingAddress_first_name    ui_mp_b2b=id=addressesForm_shippingAddress_first_name    ui_mp_b2c=id=addressesForm_shippingAddress_first_name
${checkout_shipping_address_last_name_field}    id=addressesForm_shippingAddress_last_name
${checkout_shipping_address_company_name_field}    id=addressesForm_shippingAddress_company
${checkout_shipping_address_street_field}    id=addressesForm_shippingAddress_address1
${checkout_shipping_address_house_number_field}    id=addressesForm_shippingAddress_address2
${checkout_shipping_address_additional_address_field}    id=addressesForm_shippingAddress_address3
${checkout_shipping_address_zip_code_field}    id=addressesForm_shippingAddress_zip_code
${checkout_shipping_address_city_field}    id=addressesForm_shippingAddress_city
${checkout_shipping_address_phone_field}    id=addressesForm_shippingAddress_phone
${checkout_shipping_address_salutation_selector}    id=addressesForm_shippingAddress_salutation
${checkout_shipping_address_country_selector}    id=addressesForm_shippingAddress_iso2_code
${ssp_checkout_shipping_address_first_name_field}    xpath=//*[contains(@data-qa,'address-item-form')]//*[contains(@id,'shippingAddress_first_name')]
${ssp_checkout_shipping_address_last_name_field}    xpath=//*[contains(@data-qa,'address-item-form')]//*[contains(@id,'shippingAddress_last_name')]
${ssp_checkout_shipping_address_company_name_field}    xpath=//*[contains(@data-qa,'address-item-form')]//*[contains(@id,'shippingAddress_company')]
${ssp_checkout_shipping_address_street_field}    xpath=//*[contains(@data-qa,'address-item-form')]//*[contains(@id,'shippingAddress_address1')]
${ssp_checkout_shipping_address_house_number_field}    xpath=//*[contains(@data-qa,'address-item-form')]//*[contains(@id,'shippingAddress_address2')]
${ssp_checkout_shipping_address_additional_address_field}    xpath=//*[contains(@data-qa,'address-item-form')]//*[contains(@id,'shippingAddress_address3')]
${ssp_checkout_shipping_address_zip_code_field}    xpath=//*[contains(@data-qa,'address-item-form')]//*[contains(@id,'shippingAddress_zip_code')]
${ssp_checkout_shipping_address_city_field}    xpath=//*[contains(@data-qa,'address-item-form')]//*[contains(@id,'shippingAddress_city')]
${ssp_checkout_shipping_address_phone_field}    xpath=//*[contains(@data-qa,'address-item-form')]//*[contains(@id,'shippingAddress_phone')]
${ssp_checkout_shipping_address_salutation_selector}    xpath=//*[contains(@data-qa,'address-item-form')]//*[contains(@name,'[shippingAddress][salutation]')]
${ssp_checkout_shipping_address_country_selector}    xpath=//*[contains(@data-qa,'address-item-form')]//select[contains(@id,'shippingAddress_iso2_code')]
${checkout_address_submit_button}    xpath=//button[@data-qa='submit-button']
&{checkout_address_billing_selector}    ui_b2c=xpath=//select[@id='addressesForm_billingAddress_id_customer_address']    ui_b2b=xpath=//select[contains(@class,'form-select-billingAddress')]    ui_mp_b2b=xpath=//select[contains(@class,'form-select-billingAddress')]    ui_mp_b2c=xpath=//select[@id='addressesForm_billingAddress_id_customer_address']    ui_suite=xpath=//select[contains(@class,'form-select-billingAddress')]
${checkout_billing_address_salutation_selector}    xpath=//select[@id='addressesForm_billingAddress_salutation']
${checkout_billing_address_first_name_field}    id=addressesForm_billingAddress_first_name
${checkout_billing_address_last_name_field}    id=addressesForm_billingAddress_last_name
${checkout_billing_address_company_name_field}    id=addressesForm_billingAddress_company
${checkout_billing_address_street_field}    id=addressesForm_billingAddress_address1
${checkout_billing_address_house_number_field}    id=addressesForm_billingAddress_address2
${checkout_billing_address_additional_address_field}    id=addressesForm_billingAddress_address3
${checkout_billing_address_zip_code_field}    id=addressesForm_billingAddress_zip_code
${checkout_billing_address_city_field}    id=addressesForm_billingAddress_city
${checkout_billing_address_country_select}    id=addressesForm_billingAddress_iso2_code
${checkout_billing_address_phone_field}    id=addressesForm_billingAddress_phone
${manage_your_addresses_link}    xpath=//a[contains(@href,'customer/address')]
&{billing_address_section}    ui_b2b=xpath=//form[@name='addressesForm']//div[contains(@class,'billing-same-as-shipping')]    ui_b2c=xpath=//form[@name='addressesForm']//div[contains(@class,'billing-address')]    ui_suite=xpath=//form[@name='addressesForm']//div[contains(@class,'billing-form')]    ui_mp_b2b=xpath=//form[@name='addressesForm']//div[contains(@class,'billing-same-as-shipping')]    ui_mp_b2c=xpath=//form[@name='addressesForm']//div[contains(@class,'billing-address')]
