*** Variables ***
${quick_order_main_content_locator}    css=*[name=quick_order_form]
${quick_order_add_articles_text_area}    id=text_order_form_textOrder
${quick_order_verify_button}    css=*[name=textOrder]
${quick_order_add_to_cart_button}    css=*[name=addToCart]
${quick_order_create_order_button}    css=*[name=createOrder]
${quick_order_add_to_shopping_list_button}    css=*[name=addToShoppingList]
${quick_order_shopping_list_selector}    css=*[name=idShoppingList]
${quick_order_first_empty_row}    xpath=(//div[contains(@data-qa,'component quick-order-rows')]//input[contains(@class,'autocomplete')][@value=''])[1]
${quick_order_add_more_rows}    xpath=//a[contains(@href,'#add-more')] | //form[@name="quick_order_form"]//button[contains(@class,'add-row')]
${quick_order_row_search_results}    xpath=(//div[contains(@data-qa,'component quick-order-rows')]//*[contains(@class,'autocomplete')][@value=''])[1]/ancestor::quick-order-row//ul[@data-qa='component products-list']
${quick_order_row_merchant_selector}    xpath=(//select[contains(@id,'quick_order_form[items]')][contains(@id,'product_offer_reference')])[last()]