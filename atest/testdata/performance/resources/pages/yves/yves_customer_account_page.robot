*** Variables ***
${customer_account_business_unit_selector}    id=company_user_account_selector_form_companyUserAccount
${customer_account_address_form}    css=*[name=addressForm]
${customer_account_address_salutation_select}    id=addressForm_salutation
${customer_account_address_salutation_dropdown_field}    id=select2-addressForm_salutation-container
${customer_account_address_salutation_list}    xpath=//li[@class='select2-results__option']
${customer_account_address_first_name_field}    id=addressForm_first_name
${customer_account_address_last_name_field}    id=addressForm_last_name
${customer_account_address_company_name_field}    id=addressForm_company
${customer_account_address_street_field}    id=addressForm_address1
${customer_account_address_house_number_field}    id=addressForm_address2
${customer_account_address_additional_address_field}    id=addressForm_address3
${customer_account_address_zip_code_field}    id=addressForm_zip_code
${customer_account_address_city_field}    id=addressForm_city
${customer_account_address_country_drop_down_field}    id=select2-addressForm_iso2_code-container
${customer_account_address_phone_field}    id=addressForm_phone
${customer_account_address_is_default_shipping_checkbox}    id=addressForm_is_default_shipping
${customer_account_address_is_default_billing_checkbox}    id=addressForm_is_default_billing
${customer_account_address_submit_button}    xpath=//main//button[@data-qa='submit-button']
&{customer_account_add_new_address_button}     ui_b2c=xpath=//a[@data-qa='customer-add-new-address']    ui_b2b=xpath=//a[contains(@href,'address/new')]    ui_mp_b2b=xpath=//a[contains(@href,'address/new')]    ui_mp_b2c=xpath=//a[@data-qa='customer-add-new-address']    ui_suite=xpath=//a[@data-qa='customer-add-new-address']
&{customer_account_profile_salutation_span}    ui_b2c=id=select2-profileForm_salutation-container    ui_b2b=id=select2-profileForm_salutation-container    ui_mp_b2c=id=select2-profileForm_salutation-container    ui_mp_b2b=id=select2-profileForm_salutation-container    ui_suite=xpath=//*[@id='profileForm_salutation']/option[@selected]
${customer_account_profile_salutation_selector}    id=profileForm_salutation
${customer_account_profile_first_name_field}    id=profileForm_first_name
${customer_account_profile_last_name_field}    id=profileForm_last_name
${customer_account_profile_email_field}    id=profileForm_email
${customer_account_address_country}    xpath=//select[contains(@id, 'addressForm_iso2_code')]
${customer_account_profile_submit_profile_button}    xpath=//form[@name='profileForm']//button[@type='submit']