*** Variables ***
${zed_product_list_title_field}    id=productListAggregate_productList_title
${zed_product_list_type_whitelist_radio}    xpath=//input[@id='productListAggregate_productList_type_0']
${zed_product_list_type_blacklist_radio}    xpath=//input[@id='productListAggregate_productList_type_1']
${zed_product_list_categories_search_field}    xpath=//input[contains(@class,'select2-search')]
${zed_product_list_confirm_removal_button}    xpath=//form[@name='delete_product_list_form']//input[@type='submit']