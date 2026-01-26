*** Variables ***
${zed_discount_add_new_discount_button}    xpath=//a[contains(@class,'btn') and contains(text(),'Create new discount')]
${zed_discount_create_discount_page}    xpath=//form[contains(@id,'discount-form')]/ancestor::div//*[contains(text(),'Create new discount')]
${zed_discount_type_dropdown}    id=discount_discountGeneral_discount_type
${zed_discount_name_field}    id=discount_discountGeneral_display_name
${zed_discount_description_field}    id=discount_discountGeneral_description
${zed_discount_valid_from_field}    id=discount_discountGeneral_valid_from
${zed_discount_valid_to_field}    id=discount_discountGeneral_valid_to
${zed_discount_calculator_type_drop_down}    id=discount_discountCalculator_calculator_plugin
${zed_discount_percentage_value_field}    id=discount_discountCalculator_amount
${zed_discount_euro_gross_field}    id=discount_discountCalculator_moneyValueCollection_1_gross_amount
${zed_discount_plain_query_apply_to__button}    id=btn-calculation-get
${zed_discount_plain_query_apply_to_field}    id=discount_discountCalculator_collector_query_string
${zed_discount_query_builder_first_calculation_group}    id=builder_calculation_group_0
${zed_discount_query_builder_first_condition_group}    id=builder_condition_group_0
${zed_discount_promotional_product_radio}    id=discount_discountCalculator_collectorStrategyType_1
${zed_discount_promotional_product_abstract_sku_field}    id=discount_discountCalculator_discountPromotion_abstractSkus
${zed_discount_promotional_product_abstract_quantity_field}    id=discount_discountCalculator_discountPromotion_quantity
${zed_discount_activate_button}    xpath=//button[contains(@type,'submit') and contains(.,'Activate')]
${zed_discount_voucher_quantity_field}    id=discount_voucher_quantity
${zed_discount_voucher_custom_code_field}    id=discount_voucher_custom_code
${zed_discount_voucher_max_usages_field}    id=discount_voucher_max_number_of_uses
${zed_discount_random_length_dropdown}    id=discount_voucher_random_generated_code_length
${zed_discount_voucher_code_generate_button}    id=discount_voucher_generate
${zed_discount_save_button}    xpath=//input[@type='button' and contains(@class,'create')]
${zed_discount_plain_query_apply_when__button}    id=btn-condition-get
${zed_discount_plain_query_apply_when_field}    id=discount_discountCondition_decision_rule_query_string
