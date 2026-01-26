*** Variables ***
${merchant_profile_main_content_locator}    xpath=//div[@data-qa='component merchant-profile']
&{merchant_profile_name_header_locator}     ui_mp_b2b=xpath=//div[@class='page-info']//h3    ui_mp_b2c=xpath=//h2[contains(@class,'spacing-top')]    ui_suite=xpath=//*[contains(@data-qa,'breadcrumb')]//following-sibling::h3
${merchant_profile_email_locator}    xpath=//div[contains(@class,'merchant-profile')]//*[text()='Email Address']/../div
${merchant_profile_phone_locator}    xpath=//div[contains(@class,'merchant-profile')]//*[text()='Phone']/../div
${merchant_profile_delivery_time_locator}    xpath=//div[contains(@class,'merchant-profile')]//*[text()='Delivery Time']/../div
${merchant_profile_data_privacy_locator}    xpath=//div[contains(@class,'merchant-profile')]//*[text()='Data Privacy']/following-sibling::*
