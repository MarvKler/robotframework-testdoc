*** Variables ***
${zed_new_cms_page_create_button}    xpath=//a[contains(@class,'btn-create') and contains(text(),'Create page')]
${zed_cms_page_general_DE_store_checkbox}    id=cms_page_storeRelation_id_stores_0
${zed_cms_page_general_AT_store_checkbox}    id=cms_page_storeRelation_id_stores_1
${zed_cms_page_general_US_store_checkbox}    id=cms_page_storeRelation_id_stores_2
${zed_cms_page_general_is_searchable_checkbox}    id=cms_page_isSearchable
${zed_cms_page_general_template_dropdown}    id=cms_page_fkTemplate
${zed_cms_page_general_valid_from_datapicker}    id=cms_page_validFrom
${zed_cms_page_general_valid_to_datapicker}    id=cms_page_validTo
${zed_cms_page_general_first_locale_name_field}    id=cms_page_pageAttributes_0_name
${zed_cms_page_general_first_locale_url_field}    id=cms_page_pageAttributes_0_url
${zed_cms_page_general_second_locale_collapsed_section}    xpath=(//div[@id='tab-content-general'][contains(@class,'active')]//*/ancestor::div[contains(@class,'ibox nested')])[2]//i[contains(@class,'plus')]
${zed_cms_page_general_second_locale_expanded_section}    xpath=(//div[@id='tab-content-general'][contains(@class,'active')]//*/ancestor::div[contains(@class,'ibox nested')])[2]//i[contains(@class,'minus')]
${zed_cms_page_content_second_locale_title_collapsed_section}    xpath=//div[@id='tab-content-title'][contains(@class,'active')]//ancestor::div[contains(@class,'ibox nested collapsed')][2]/div/a/*[@class='ibox-tools'][1]//i[contains(@class,'plus')]
${zed_cms_page_content_second_locale_content_collapsed_section}    xpath=//div[@id='tab-content-content'][contains(@class,'active')]//ancestor::div[contains(@class,'ibox nested collapsed')][2]/div/a/*[@class='ibox-tools'][1]//i[contains(@class,'plus')]
${zed_cms_page_general_second_locale_name_field}    id=cms_page_pageAttributes_1_name
${zed_cms_page_general_second_locale_url_field}    id=cms_page_pageAttributes_1_url
${zed_cms_page_save_button}    id=submit-cms
${zed_cms_block_save_button}    xpath=//input[@type='submit']
# Placeholders
${zed_cms_page_placeholder_title_enUS_field}    xpath=//*[@id='cms_glossary_glossaryAttributes_0_translations_0_translation']/following-sibling::div//div[@class='note-editing-area']//div[@role='textbox']
${zed_cms_page_placeholder_title_deDE_field}    xpath=//*[@id='cms_glossary_glossaryAttributes_0_translations_1_translation']/following-sibling::div//div[@class='note-editing-area']//div[@role='textbox']
${zed_cms_page_placeholder_content_enUS_field}    xpath=//*[@id='cms_glossary_glossaryAttributes_1_translations_0_translation']/following-sibling::div//div[@class='note-editing-area']//div[@role='textbox']
${zed_cms_page_placeholder_content_deDE_field}    xpath=//*[@id='cms_glossary_glossaryAttributes_1_translations_1_translation']/following-sibling::div//div[@class='note-editing-area']//div[@role='textbox']
# Action buttons
${zed_cms_page_publish_button}=    xpath=//button[@type='submit' and contains(.,'Publish')]
${zed_cms_page_activate_button}=    xpath=//button[contains(@class,'submit') and contains(.,'Activate')]