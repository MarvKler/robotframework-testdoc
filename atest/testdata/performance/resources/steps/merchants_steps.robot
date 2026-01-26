*** Settings ***
Resource    ../common/common_ui.robot
Resource    ../common/common_zed.robot
Resource    product_set_steps.robot
Resource    ../pages/zed/zed_product_list_page.robot

*** Keywords ***
Zed: assign product list to merchant relation:
    [Arguments]    ${business_unit_owner}    ${merchant_relation}    ${product_list}
    ${currentURL}=    Get Url
    IF    '/list-merchant-relationship' not in '${currentURL}'    Go To    ${zed_url}merchant-relationship-gui/list-merchant-relationship
    Zed: perform search by:    ${business_unit_owner}
    Zed: click Action Button(without search) in a table for row that contains:    ${merchant_relation}    Edit
    ${is_list_already_selected}=    Run Keyword And Ignore Error    Page Should Contain Element    xpath=//*[@id='merchant-relationship_productListIds']//option[contains(.,'${product_list}')][@selected]    timeout=0.5s
    IF    'FAIL' in $is_list_already_selected
        Type Text    xpath=//select[@id="merchant-relationship_productListIds"]/following-sibling::*//input[contains(@class,'select2-search')]    ${product_list}    delay=50ms
        Wait Until Element Is Visible    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${product_list}')]
        Click    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${product_list}')]
        Wait Until Element Is Not Visible    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${product_list}')]
        Sleep    1s
        Zed: submit the form
    END

Zed: unassign all product lists from merchant relation:
    [Arguments]    ${business_unit_owner}    ${merchant_relation}
    ${currentURL}=    Get Url
    IF    '/list-merchant-relationship' not in '${currentURL}'    Go To    ${zed_url}merchant-relationship-gui/list-merchant-relationship
    Zed: perform search by:    ${business_unit_owner}
    Zed: click Action Button(without search) in a table for row that contains:    ${merchant_relation}    Edit
    ${are_lists_already_selected}=    Run Keyword And Ignore Error    Page Should Contain Element    xpath=(//select[@id="merchant-relationship_productListIds"]/following-sibling::*//*[contains(@class,'remove')][contains(@class,'choice')])[1]    timeout=0.5s
    IF    'PASS' in $are_lists_already_selected
        ${iterations}=    Get Element Count    xpath=//select[@id="merchant-relationship_productListIds"]/following-sibling::*//*[contains(@class,'remove')][contains(@class,'choice')]
        FOR    ${index}    IN RANGE    1    ${iterations}+1
            Click    xpath=(//select[@id="merchant-relationship_productListIds"]/following-sibling::*//*[contains(@class,'remove')][contains(@class,'choice')])[${index}]
            Wait Until Element Is Not Visible    xpath=(//select[@id="merchant-relationship_productListIds"]/following-sibling::*//*[contains(@class,'remove')][contains(@class,'choice')])[${index}]
            Click    xpath=//select[@id="merchant-relationship_productListIds"]/following-sibling::*//input[contains(@class,'select2-search')]
        END
        Sleep    1s
        Zed: submit the form
    END


Zed: create product list with the following assigned category:
    [Arguments]    ${list_name}    ${list_type}    ${category}
    Go To    ${zed_url}product-list-gui/create
    Wait Until Element Is Visible    ${zed_product_list_title_field}
    Type Text    ${zed_product_list_title_field}    ${list_name}
    ${list_type}=    Convert To Lower Case    ${list_type}
    IF    '${list_type}' == 'whitelist' or '${list_type}' == 'white'    Click    ${zed_product_list_type_whitelist_radio}
    IF    '${list_type}' == 'blacklist' or '${list_type}' == 'black'    Click    ${zed_product_list_type_blacklist_radio}
    Zed: switch to tab in product list:    Assign Categories
    Wait Until Page Contains Element    ${zed_product_list_categories_search_field}
    Type Text    ${zed_product_list_categories_search_field}    ${category}
    Wait Until Element Is Visible    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${category}')]
    Click    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${category}')]
    Wait Until Element Is Not Visible    xpath=//*[contains(@class,'select2-results')][contains(@class,'options')]//li[contains(text(),'${category}')]
    Zed: submit the form

Zed: switch to tab in product list:
    [Arguments]    ${tab_name}
    Click    xpath=//form[@name='productListAggregate']//div[@class='tabs-container']/ul[contains(@class,'nav-tabs')]//li[@data-tab-content-id]//a[contains(.,'${tab_name}')]

Zed: remove product list with title:
    [Arguments]    ${product_list_title}
    Go To    ${zed_url}product-list-gui
    Zed: perform search by:    ${product_list_title}
    ${is_product_list_exists}=    Run Keyword And Ignore Error    Zed: table should contain non-searchable value:    ${product_list_title}
    IF    'PASS' in $is_product_list_exists
        Zed: click Action Button(without search) in a table for row that contains:    ${product_list_title}    Remove List
        Wait Until Element Is Visible    ${zed_product_list_confirm_removal_button}
        Click    ${zed_product_list_confirm_removal_button}
    END
