*** Variables ***
${create_company_business_unit_button}    xpath=//a[contains(@href,'business-unit/create')]
${create_company_business_unit_name_field}    id=company_business_unit_form_name
${create_company_business_unit_email_field}    id=company_business_unit_form_email
${create_company_business_unit_submit_button}    xpath=//form[@name='company_business_unit_form']//button[@data-qa='submit-button']
${company_business_unit_delete_button}    xpath=(//a[contains(@href,'delete-confirmation')])[1]