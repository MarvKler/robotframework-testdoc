*** Variables ***
${zed_pdp_abstract_main_content_locator}    css=*[name=product_form_edit]
${zed_pdp_concrete_main_content_locator}    css=*[name=product_concrete_form_edit]
${zed_pdp_add_concrete_main_content_locator}    css=*[name=product_concrete_form_add]
${zed_pdp_discontinue_button}    xpath=//form[@name='product_concrete_form_edit']//div[@id='tab-content-discontinue']//a[contains(@href,'discontinue')]
${zed_pdp_add_products_alternative_input}    xpath=//form[@name='product_concrete_form_edit']//div[@id='tab-content-alternatives']//input
${zed_pdp_alternative_products_suggestion}    xpath=//ul[@id='select2-product_concrete_form_edit_alternative_products-results']/li[contains(@class,'select2-results__option')]
${zed_pdp_restore_button}    xpath=//form[@name='product_concrete_form_edit']//div[@id='tab-content-discontinue']//a[contains(@href,'restore')]
${zed_pdp_save_button}    xpath=//input[@type='submit' and @value='Save']
${zed_product_variant_table_processing_locator}    xpath=//div[@id='product-variant-table_processing']
${zed_product_edit_name_en_input}    xpath=//input[@id='product_form_edit_general_en_US_name']
${zed_product_edit_name_de_input}    xpath=//input[@id='product_form_edit_general_de_DE_name']
${zed_product_edit_new_from}    xpath=//input[@id='product_form_edit_new_from']
${zed_product_edit_new_to}    xpath=//input[@id='product_form_edit_new_to']
${zed_product_general_second_locale_collapsed_section}    xpath=//div[@id='tab-content-general'][contains(@class,'active')]//ancestor::div[contains(@class,'ibox nested collapsed')]//i[contains(@class,'plus')]
${zed_product_general_second_locale_expanded_section}    xpath=//div[@id='tab-content-general'][contains(@class,'active')]//ancestor::div[contains(@class,'ibox nested collapsed')]//i[contains(@class,'minus')]
${zed_product_add_sku_input}    id=product_form_add_sku
${zed_product_add_name_en_input}    id=product_form_add_general_en_US_name
${zed_product_add_name_de_input}    id=product_form_add_general_de_DE_name
${zed_product_add_new_from}    id=product_form_add_new_from
${zed_product_add_new_to}    id=product_form_add_new_to
${zed_product_tax_set_select}    xpath=//select[contains(@id,'product_form')][contains(@id,'tax_rate')]
${zed_pdp_concrete_name_en_input}    id=product_concrete_form_edit_general_en_US_name
${zed_pdp_concrete_name_de_input}    id=product_concrete_form_edit_general_de_DE_name
${zed_pdp_concrete_valid_from}    id=product_concrete_form_edit_valid_from
${zed_pdp_concrete_valid_to}    id=product_concrete_form_edit_valid_to
${zed_pdp_concrete_searchable_en}    id=product_concrete_form_edit_general_en_US_is_searchable
${zed_pdp_concrete_searchable_de}    id=product_concrete_form_edit_general_de_DE_is_searchable
${zed_add_concrete_sku_field}    id=sku-input
${zed_add_concrete_name_en_input}    id=product_concrete_form_add_general_en_US_name
${zed_add_concrete_name_de_input}    id=product_concrete_form_add_general_de_DE_name
${zed_add_concrete_valid_from}    id=product_concrete_form_add_valid_from
${zed_add_concrete_valid_to}    id=product_concrete_form_add_valid_to
${zed_add_concrete_use_price_from_abstract}    id=price-source-checkbox
${zed_add_concrete_autogenerate_sku}    id=sku-autogenerate-checkbox-input