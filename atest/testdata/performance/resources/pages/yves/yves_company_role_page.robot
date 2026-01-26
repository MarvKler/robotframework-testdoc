*** Variables ***
${create_company_role_button}    xpath=//a[contains(@href,'company-role/create')]
${company_roles_table_locator}    xpath=//*[contains(@data-qa,'role-table')]//table
${create_company_role_name_field}    id=company_role_form_name
${create_company_role_submit_button}    xpath=//form[@name='company_role_form']//button[@data-qa='submit-button']
