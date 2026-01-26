*** Settings ***
Resource    ../../common/common_ui.robot

*** Variables ***
${shopping_lists_main_content_locator}    xpath=//div[@data-qa='component shopping-list-overview-table']
${shopping_lists_page_form_locator}    xpath=//form[@name='shopping_list_form']
${shopping_list_name_input_field}    id=shopping_list_form_name
${create_shopping_list_button}    xpath=//form[@name='shopping_list_form']//button[@data-qa='submit-button']
${share_shopping_list_customers_section}    xpath=//div[@data-qa="component company-dashbord-item"]//*[text()='Customer']/../../div[@data-qa='component share-list']
${share_shopping_list_business_unit_section}    xpath=//div[@data-qa="component company-dashbord-item"]//*[text()='Business Unit']/../../div[@data-qa='component share-list']
${share_shopping_list_confirm_button}    xpath=//form[@name='share_shopping_list_form']//button[@data-qa='submit-button']


*** Keywords ***
Select access level to share shopping list with:
    [Arguments]    ${customerToShareWith}    ${accessLevel}
    IF    '${env}' in ['ui_suite']
        Select From List By Label    xpath=//form[@name='share_shopping_list_form']//div[contains(@class,'field')][contains(@class,'col')][last()]//div[contains(@data-qa,'share-list')]//li[contains(@data-qa,'list-item')][contains(.,'${customerToShareWith}')]//select    ${accessLevel}
    ELSE
        Select From List By Label    xpath=//div[@data-qa="component company-dashbord-item"]//*[text()='Customer']/../../div[@data-qa='component share-list']//li[contains(.,'${customerToShareWith}')]//select    ${accessLevel}  
    END

Edit shopping list with name:
    [Arguments]    ${shoppingListName}       
    IF    '${env}' in ['ui_suite']
        Click    xpath=//*[contains(@data-qa,"shopping-list-overview")]//table//td[contains(@class,'name')][contains(.,'${shoppingListName}')]/ancestor::tr/td/*[contains(@data-qa,'action')]//a[contains(@href,'update')]
    ELSE
        Click    xpath=//*[@data-qa="component shopping-list-overview-table"]//table//td[@data-content='Name'][contains(.,'${shoppingListName}')]/..//div[@data-qa='component table-action-list']//a[contains(.,'Edit')]
    END
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

Share shopping list with name:
    [Arguments]    ${shoppingListName}       
    IF    '${env}' in ['ui_suite']
        Click    xpath=//*[contains(@data-qa,"shopping-list-overview")]//table//td[contains(@class,'name')][contains(.,'${shoppingListName}')]/ancestor::tr/td/*[contains(@data-qa,'action')]//a[contains(@href,'share')]
    ELSE
        Click    xpath=//*[@data-qa="component shopping-list-overview-table"]//table//td[@data-content='Name'][contains(.,'${shoppingListName}')]/..//div[@data-qa='component table-action-list']//a[contains(.,'Share')]
    END    
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

Print shopping list with name:
    [Arguments]    ${shoppingListName}    
    IF    '${env}' in ['ui_suite']
        Click    xpath=//*[contains(@data-qa,"shopping-list-overview")]//table//td[contains(@class,'name')][contains(.,'${shoppingListName}')]/ancestor::tr/td/*[contains(@data-qa,'action')]//a[contains(@href,'print')]
    ELSE   
        Click    xpath=//*[@data-qa="component shopping-list-overview-table"]//table//td[@data-content='Name'][contains(.,'${shoppingListName}')]/..//div[@data-qa='component table-action-list']//a[contains(.,'Print')]
    END
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

Delete shopping list with name:
    [Arguments]    ${shoppingListName} 
    IF    '${env}' in ['ui_suite']
        Click    xpath=//*[contains(@data-qa,"shopping-list-overview")]//table//td[contains(@class,'name')][contains(.,'${shoppingListName}')]/ancestor::tr/td/*[contains(@data-qa,'action')]//a[contains(@href,'delete')]
    ELSE         
        Click    xpath=//*[@data-qa="component shopping-list-overview-table"]//table//td[@data-content='Name'][contains(.,'${shoppingListName}')]/..//div[@data-qa='component table-action-list']//a[contains(.,'Delete')]
    END
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

Dismiss shopping list with name:
    [Arguments]    ${shoppingListName}   
    IF    '${env}' in ['ui_suite']
        Click    xpath=//*[contains(@data-qa,"shopping-list-overview")]//table//td[contains(@class,'name')][contains(.,'${shoppingListName}')]/ancestor::tr/td/*[contains(@data-qa,'action')]//a[contains(@href,'dismiss')]
    ELSE      
        Click    xpath=//*[@data-qa="component shopping-list-overview-table"]//table//td[@data-content='Name'][contains(.,'${shoppingListName}')]/..//div[@data-qa='component table-action-list']//a[contains(.,'Dismiss')]
    END
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

View shopping list with name:
    [Arguments]    ${shoppingListName}  
    IF    '${env}' in ['ui_suite']
        Click    xpath=//*[contains(@data-qa,"shopping-list-overview")]//table//td[contains(@class,'name')][contains(.,'${shoppingListName}')]//a
    ELSE          
        Click    xpath=//*[@data-qa="component shopping-list-overview-table"]//table//td[@data-content='Name'][contains(.,'${shoppingListName}')]//a[contains(@href,'details')]
    END
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
