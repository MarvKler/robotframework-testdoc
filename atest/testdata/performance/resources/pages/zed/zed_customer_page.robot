*** Variables ***
${zed_customer_edit_page_title}    xpath=//h5[contains(text(),'Edit Customer')]
${zed_customer_delete_button}    xpath=//a[contains(@class,'btn btn-sm btn-outline safe-submit btn-remove')]
${zed_customer_delete_confirm_button}     xpath=//button[contains(@class,'btn btn-danger safe-submit')]
${zed_customer_edit_salutation_select}    id=customer_salutation
${zed_customer_edit_first_name_field}    id=customer_first_name
${zed_customer_edit_last_name_field}    id=customer_last_name
${zed_customer_edit_address_salutation_select}    id=customer_address_salutation
${zed_customer_edit_address_first_name_field}    id=customer_address_first_name
${zed_customer_edit_address_last_name_field}    id=customer_address_last_name
${zed_customer_edit_address_address_1_field}    id=customer_address_address1
${zed_customer_edit_address_address_2_field}    id=customer_address_address2
${zed_customer_edit_address_address_3_field}    id=customer_address_address3
${zed_customer_edit_address_city_field}    id=customer_address_city
${zed_customer_edit_address_zip_code_field}    id=customer_address_zip_code
${zed_customer_edit_address_country_select}    id=customer_address_fk_country
${zed_customer_edit_address_phone_field}    id=customer_address_phone
${zed_customer_edit_address_company_field}    id=customer_address_company
${zed_customer_edit_address_submit_button}    xpath=//form[@name='customer_address']//*[@type='submit']
${zed_edit_company_user_salutation}    id=company-user_customer_salutation
${zed_edit_company_user_first_name}    id=company-user_customer_first_name
${zed_edit_company_user_last_name}    id=company-user_customer_last_name
${zed_edit_company_user_company_select}    id=company-user_fk_company
${zed_edit_company_user_company_span}    id=select2-company-user_fk_company-container
${zed_edit_company_user_business_unit_select}    id=company-user_fk_company_business_unit
${zed_edit_company_user_business_unit_span}    id=select2-company-user_fk_company_business_unit-container
${zed_edit_company_user_search_select_field}    xpath=//input[@type='search']
${zed_attach_customer_to_bu_business_unit_span}    id=select2-customer_business_unit_attach_fk_company_business_unit-container