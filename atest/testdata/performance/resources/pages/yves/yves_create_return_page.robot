*** Variables ***
${create_return_main_content_locator}    css=*[name=return_create_form]
&{create_return_button}    ui_b2b=xpath=//form[@name='return_create_form']//button[contains(@class,'return-create')]    ui_b2c=xpath=//button[contains(@class,'return')]    ui_suite=xpath=//div[@data-qa='component return-create-form']//button    ui_mp_b2b=xpath=//form[@name='return_create_form']//button[contains(@class,'return-create')]    ui_mp_b2c=xpath=//button[contains(@class,'return')]
