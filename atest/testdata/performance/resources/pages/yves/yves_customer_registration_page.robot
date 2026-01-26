*** Variables ***
${registration_page_title}    xpath=//h2[contains(@class,'title') and contains(text(),'Sign Up')]
${registration_first_name_field}    id=registerForm_first_name
${registration_last_name_field}    id=registerForm_last_name
${registration_email_field}    id=registerForm_email
${registration_password_field}    id=registerForm_password_pass
${registration_password_confirmation_field}    id=registerForm_password_confirm
${registration_accept_terms_checkbox}    id=registerForm_accept_terms
${registration_submit_button}    xpath=//form[@name='registerForm']//button[@data-qa='submit-button']
${registration_salutation_dropdown}    id=select2-registerForm_salutation-container