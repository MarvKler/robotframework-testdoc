*** Variables ***
${zed_create_merchant_name_field}    id=merchant_name
${zed_create_merchant_reference_field}    id=merchant_merchant_reference
${zed_create_merchant_email_field}    id=merchant_email
${zed_create_merchant_url_en_locale_field}    id=merchant_urlCollection_0_url
${zed_create_merchant_url_de_locale_field}    id=merchant_urlCollection_1_url
${zed_create_merchant_contact_first_name}    id=merchant_merchantProfile_contact_person_first_name
${zed_create_merchant_contact_last_name}    id=merchant_merchantProfile_contact_person_last_name

${zed_create_merchant_user_email_field}    id=merchant-user_username
${zed_create_merchant_user_first_name_field}    id=merchant-user_firstName
${zed_create_merchant_user_last_name_field}    id=merchant-user_lastName
${zed_add_merchant_user_button}    xpath=//a[contains(@class,'btn-create')][contains(text(),'User')]

${zed_merchant_user_search_field_locator}     xpath=//div[@class='dataTables_filter']//input[@type='search']

