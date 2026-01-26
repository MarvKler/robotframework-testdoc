*** Variables ***
${configurator_back_button}    xpath=//a[contains(@class,'header__back')]
${configurator_save_button}    xpath=//button[@type='submit' or contains(text(),' Save configurations')]
${configurator_store}    xpath=//div[@class='header__bottom']//li[contains(.,'Store')]/span
${configurator_locale}    xpath=//div[@class='header__bottom']//li[contains(.,'Locale')]/span
${configurator_price_mode}    xpath=//div[@class='header__bottom']//li[contains(.,'Price')]/span
${configurator_currency}    xpath=//div[@class='header__bottom']//li[contains(.,'Currency')]/span
${configurator_sku}    xpath=//app-product-details//div[contains(@class,'details')]/span[@data-qa='product-details-sku']
${unsaved_product_configurations_leave_button}    xpath=//app-header//div[@data-qa='header-guard-modal']//div/button[@data-qa='header-guard-leave-button']