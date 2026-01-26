*** Variables ***
${zed_availability_product_availability_label}    xpath=//td[contains(@class,'availability')]//span[contains(@class,'label')]
${zed_availability_never_out_of_stock_checkbox}    xpath=//*[@type='checkbox' and contains(@id,'is_never_out_of_stock')]