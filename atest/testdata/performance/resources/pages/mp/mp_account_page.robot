*** Variables ***
${mp_my_account_header_menu_item}    xpath=//spy-user-menu-link[@class='spy-user-menu-link'][normalize-space(text())='My Account']
${mp_account_first_name_field}    id=user-merchant-portal-gui_merchant-account_first_name
${mp_account_last_name_field}    id=user-merchant-portal-gui_merchant-account_last_name
${mp_account_email_field}    id=user-merchant-portal-gui_merchant-account_username
${mp_account_change_password_button}    xpath=//web-spy-button-action[@type='button'][contains(@action,'change-password')]//button
${mp_account_current_password_field}    id=security-merchant-portal-gui_change-password_current_password
${mp_account_new_password_field}    id=security-merchant-portal-gui_change-password_new_password_first
${mp_account_repeat_new_password_field}    id=security-merchant-portal-gui_change-password_new_password_second
${mp_account_save_password_button}    xpath=//web-spy-button[contains(@id,'change-password_save')]//button[@type='submit']
