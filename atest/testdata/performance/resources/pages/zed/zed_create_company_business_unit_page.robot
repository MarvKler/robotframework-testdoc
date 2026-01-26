*** Variables ***
${zed_bu_company_dropdown_with_search_locator}    xpath=//span[@id='select2-company-business-unit_fk_company-container']
${zed_bu_company_dropdown_locator}    id=company-business-unit_fk_company
${zed_bu_parent_bu_dropdown_locator}    id=company-business-unit_fk_parent_company_business_unit
${zed_bu_company_search_field}    xpath=//input[@type='search'][contains(@aria-controls,'company-business-unit')]
${zed_bu_name_field}    id=company-business-unit_name
${zed_bu_iban_field}    id=company-business-unit_iban
${zed_bu_bic_field}     id=company-business-unit_bic
