*** Variables ***
${create_company_user_button}    xpath=//a[contains(@href,'company/user/create')]
${create_company_user_business_unit_dropdown}    xpath=//select[contains(@id,'company_business_unit')]
${create_company_user_email_field}    id=company_user_form_email
${create_company_user_first_name_field}    id=company_user_form_first_name
${create_company_user_last_name_field}    id=company_user_form_last_name
${create_company_user_submit_button}    xpath=//form[@name='company_user_form']//button[@data-qa='submit-button']