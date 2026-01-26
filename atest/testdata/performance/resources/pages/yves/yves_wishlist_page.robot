*** Variables ***
&{wishlist_main_content_locator}    ui_b2b=xpath=//h1[contains(@class,'account-main')][contains(text(),'Wishlist')]    ui_b2c=xpath=//h1[contains(@class,'account-main')][contains(text(),'Wishlist')]    ui_mp_b2b=xpath=//h1[contains(@class,'account-main')][contains(text(),'Wishlist')]    ui_mp_b2c=xpath=//h1[contains(@class,'account-main')][contains(text(),'Wishlist')]    ui_suite=//*[@data-qa='component breadcrumb']/../*[contains(@class,'title')][contains(text(),'Wishlist')]
${wishlist_name_input_field}    id=wishlist_form_name
${wishlist_add_new_button}    xpath=//form[@name='wishlist_form']//*[@type='submit']
${wishlist_delete_button}    xpath=(//table//form[contains(@action,'wishlist/delete')]//button)
${wishlist_add_all_to_cart_button}    xpath=//form[@name='add_all_available_products_to_cart_form']/button