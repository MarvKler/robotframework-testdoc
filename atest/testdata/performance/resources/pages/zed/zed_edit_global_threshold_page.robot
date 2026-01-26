*** Variables ***
${zed_global_threshold_store_currency_select}    id=global-threshold_storeCurrency
${zed_global_threshold_store_currency_span}    id=select2-global-threshold_storeCurrency-container
${zed_global_threshold_minimum_hard_value_input}    id=global-threshold_hardThreshold_threshold
${zed_global_threshold_minimum_hard_en_message_input}    id=global-threshold_hardThreshold_en_US_message
${zed_global_threshold_minimum_hard_de_message_input}    id=global-threshold_hardThreshold_de_DE_message
${zed_global_threshold_minimum_hard_second_locale_collapce_section}    xpath=//input[@id='global-threshold_hardThreshold_threshold']/../../div[contains(@class,'ibox nested collapsed')]//i[contains(@class,'plus')]
${zed_global_threshold_maximum_hard_value_input}    id=global-threshold_hardMaximumThreshold_threshold
${zed_global_threshold_maximum_hard_en_message_input}    id=global-threshold_hardMaximumThreshold_en_US_message
${zed_global_threshold_maximum_hard_de_message_input}    id=global-threshold_hardMaximumThreshold_de_DE_message
${zed_global_threshold_maximum_hard_second_locale_collapce_section}    xpath=//input[@id='global-threshold_hardMaximumThreshold_threshold']/../../div[contains(@class,'ibox nested collapsed')]//i[contains(@class,'plus')]
${zed_global_threshold_soft_value_input}    id=global-threshold_softThreshold_threshold
${zed_global_threshold_soft_en_message_input}    id=global-threshold_softThreshold_en_US_message
${zed_global_threshold_soft_de_message_input}    id=global-threshold_softThreshold_de_DE_message
${zed_global_threshold_soft_second_locale_collapce_section}    xpath=//input[@id='global-threshold_softThreshold_de_DE_message']/../../../../div[contains(@class,'ibox nested collapsed')]//i[contains(@class,'plus')]
${zed_global_threshold_soft_fixed_fee_value_input}    id=global-threshold_softThreshold_fixedFee
${zed_global_threshold_soft_flexible_fee_value_input}    id=global-threshold_softThreshold_flexibleFee