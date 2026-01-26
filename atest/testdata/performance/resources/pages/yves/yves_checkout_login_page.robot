*** Variables ***
${yves_checkout_login_guest_firstName_field}    id=guestForm_customer_first_name
${yves_checkout_login_guest_lastName_field}    id=guestForm_customer_last_name
${yves_checkout_login_guest_email_field}    id=guestForm_customer_email
${yves_checkout_login_buy_as_guest_submit_button}    xpath=//form[@name='guestForm']//button[contains(@data-qa,"submit-button")]
${yves_checkout_signup_button}    xpath=//toggler-radio[contains(@data-qa,'checkoutProceedAs register')]
${yves_checkout_signup_first_name}    id=registerForm_customer_first_name
${yves_checkout_signup_last_name}    id=registerForm_customer_last_name
${yves_checkout_signup_email}        id=registerForm_customer_email
${yves_checkout_signup_password}    id=registerForm_customer_password_pass
${yves_checkout_signup_confirm_password}    id=registerForm_customer_password_confirm
${yves_checkout_signup_accept_terms}    xpath=(//span[@class='checkbox__box'])[1]
${yves_checkout_signup_tab}    xpath=//form[contains(@name,'registerForm')]//button[contains(@type,'submit')]
${yves_checkout_login_tab}    xpath=//toggler-radio[contains(@data-qa,'checkoutProceedAs login')]