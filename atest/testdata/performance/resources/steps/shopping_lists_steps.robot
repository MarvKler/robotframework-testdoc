*** Settings ***
Resource    ../common/common.robot
Resource    ../pages/yves/yves_shopping_lists_page.robot
Resource    ../common/common_yves.robot
Resource    ../pages/yves/yves_delete_shopping_list_page.robot
Resource    customer_account_steps.robot
Resource    order_history_steps.robot

*** Keywords ***
Yves: 'Shopping List' widget contains:
    [Arguments]    ${shoppingListName}    ${accessLevel}
    Wait Until Element Is Visible    ${shopping_list_icon_header_menu_item}[${env}]
    Mouse Over    ${shopping_list_icon_header_menu_item}[${env}]
    Wait Until Element Is Visible    ${shopping_list_sub_navigation_widget}[${env}]
    IF    '${env}' in ['ui_suite']
    Page Should Contain Element    xpath=//header//li[contains(@class,'item')]//a[contains(@href,'shopping-list')]/ancestor::li//*[contains(@class,'list')]//li//a[contains(.,'${shoppingListName}')]/ancestor::li/div[contains(@class,'list-item')]//*[contains(@class,'access')][contains(.,'${accessLevel}')]
    ELSE
    Page Should Contain Element    xpath=//header//li[contains(@class,'item')]/span[contains(@class,'item-inner')]//a[contains(@href,'shopping-list')]/ancestor::span/*[contains(@class,'list')]//li//a[contains(.,'${shoppingListName}')]/ancestor::li/div[contains(@class,'list-item')]//*[contains(@class,'access')][contains(.,'${accessLevel}')]
    END

Yves: go to 'Shopping Lists' page
    ${lang}=    Yves: get current lang
    Yves: go to URL:    ${lang}/shopping-list

Yves: create new 'Shopping List' with name:
    [Arguments]    ${shoppingListName}
    ${currentURL}=    Get Location
    IF    '/shopping-list' not in '${currentURL}'    
            IF    '.at.' in '${currentURL}'
                Go To    ${yves_at_url}shopping-list
            ELSE
                Go To    ${yves_url}shopping-list
            END    
    END
    Type Text    ${shopping_list_name_input_field}    ${shoppingListName}
    Click    ${create_shopping_list_button}

Yves: the following shopping list is shown:
    [Arguments]    ${shoppingListName}    ${shoppingListOwner}    ${shoppingListAccess}
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    IF    '${env}' in ['ui_suite']
        Page Should Contain Element    xpath=//*[contains(@data-qa,"shopping-list-overview")]//table//td//span[contains(@data-qa,'shopping-list-permission')][contains(.,'${shoppingListAccess}')]/ancestor::tr/td[contains(.,'${shoppingListOwner}')]/ancestor::tr/td[contains(@class,'name')][contains(.,'${shoppingListName}')]
    ELSE
        Page Should Contain Element    xpath=//*[@data-qa="component shopping-list-overview-table"]//table//td[@data-content='Access'][contains(.,'${shoppingListAccess}')]/../td[@data-content='Owner'][contains(.,'${shoppingListOwner}')]/../td[@data-content='Name'][contains(.,'${shoppingListName}')]
    END

Yves: share shopping list with user:
    [Arguments]    ${shoppingListName}    ${customer}    ${accessLevel}
    Share shopping list with name:    ${shoppingListName}
    Select access level to share shopping list with:    ${customer}    ${accessLevel}
    Click    ${share_shopping_list_confirm_button}
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    Yves: 'Shopping Lists' page is displayed
    Yves: flash message 'should' be shown

Yves: shopping list contains the following products:
    [Arguments]    @{sku_list}    ${sku1}=${EMPTY}     ${sku2}=${EMPTY}     ${sku3}=${EMPTY}     ${sku4}=${EMPTY}     ${sku5}=${EMPTY}     ${sku6}=${EMPTY}     ${sku7}=${EMPTY}     ${sku8}=${EMPTY}     ${sku9}=${EMPTY}     ${sku10}=${EMPTY}     ${sku11}=${EMPTY}     ${sku12}=${EMPTY}     ${sku13}=${EMPTY}     ${sku14}=${EMPTY}     ${sku15}=${EMPTY}
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        IF    '${env}' in ['ui_suite']
            Page Should Contain Element    xpath=(//table[contains(@data-qa,'shopping-list')]/tbody/tr//*[@itemprop='sku'][contains(.,'${sku_to_check}')])[1]
        ELSE
            Page Should Contain Element    xpath=(//*[@data-qa='component shopping-list-table']//div[contains(@class,'product-card-item__col--description')]//div[contains(.,'SKU: ${sku_to_check}')]/ancestor::article)[1]
        END
    END

Yves: delete 'Shopping List' with name:
    [Arguments]    ${shoppingListName}
    ${currentURL}=    Get Location
    IF    '.at.' in '${currentURL}'
        Go To    ${yves_at_url}shopping-list
    ELSE
        Go To    ${yves_url}shopping-list
    END    
    Delete shopping list with name:    ${shoppingListName}
    Wait Until Element Is Visible    ${delete_shopping_list_button}
    Click    ${delete_shopping_list_button}
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

Yves: view shopping list with name:
    [Arguments]    ${shoppingListName}
    ${currentURL}=    Get Location
    IF    '/shopping-list' not in '${currentURL}'    
            IF    '.at.' in '${currentURL}'
                Go To    ${yves_at_url}shopping-list
            ELSE
                Go To    ${yves_url}shopping-list
            END    
    END
    View shopping list with name:   ${shoppingListName}

Yves: add all available products from list to cart
    Wait Until Element Is Visible    ${shopping_list_main_content_locator}
    Click    ${add_all_available_products_to_cart_locator} 
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END