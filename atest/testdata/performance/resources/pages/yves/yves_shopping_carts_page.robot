*** Settings ***
Resource    ../../common/common_ui.robot
*** Variables ***
${shopping_carts_main_content_locator}    xpath=//*[@data-qa='component quote-table']
${create_shopping_cart_button}    xpath=//main//a[contains(@href,'multi-cart/create')]
${shopping_cart_name_input_field}    id=quoteForm_name
${create_new_cart_submit_button}    xpath=//form[@name='quoteForm']//button[@data-qa='submit-button']
${share_shopping_cart_confirm_button}    xpath=//form[@name='shareCartForm']//button[@type='submit']
${delete_first_shopping_cart_button}    xpath=//*[@data-qa='component quote-table']//table/tbody/tr[1]//a[contains(.,'Delete')]


*** Keywords ***
Edit shopping cart with name:
    [Arguments]    ${shoppingCartName}
    IF    '${env}' in ['ui_suite']
        Click    xpath=//*[contains(@data-qa,'quote-table')]//tr/td[1][contains(.,'${shoppingCartName}')]/ancestor::tr/td[last()]//a[contains(@href,'update')]
    ELSE
        Click    xpath=//*[@data-qa='component quote-table']//table//td[@data-content='Name'][contains(.,'${shoppingCartName}')]/..//a[contains(.,'Edit')]
    END
    
Duplicate shopping cart with name:
    [Arguments]    ${shoppingCartName}
    Click    xpath=//*[@data-qa='component quote-table']//table//td[@data-content='Name'][contains(.,'${shoppingCartName}')]/..//a[contains(.,'Duplicate')]

Add to list shopping cart with name:
    [Arguments]    ${shoppingCartName}
    IF    '${env}' in ['ui_suite']
        Click    xpath=//*[contains(@data-qa,'quote-table')]//tr/td[1][contains(.,'${shoppingCartName}')]/ancestor::tr/td[last()]//a[contains(@href,'shopping-list')]
    ELSE
        Click    xpath=//*[@data-qa='component quote-table']//table//td[@data-content='Name'][contains(.,'${shoppingCartName}')]/..//a[contains(.,'Add to list')]
    END

Dismiss shopping cart with name:
    [Arguments]    ${shoppingCartName}
    Click    xpath=//*[@data-qa='component quote-table']//table//td[@data-content='Name'][contains(.,'${shoppingCartName}')]/..//a[contains(.,'Dismiss')]

Delete shopping cart with name:
    [Arguments]    ${shoppingCartName}
    IF    '${env}' in ['ui_suite']
        Click    xpath=//*[contains(@data-qa,'quote-table')]//tr/td[1][contains(.,'${shoppingCartName}')]/ancestor::tr/td[last()]//a[contains(@href,'delete')]
    ELSE
        Click    xpath=//*[@data-qa='component quote-table']//table//td[@data-content='Name'][contains(.,'${shoppingCartName}')]/..//a[contains(.,'Delete')]
    END

Share shopping cart with name:
    [Arguments]    ${shoppingCartName}
    IF    '${env}' in ['ui_suite']
        Click    xpath=//*[contains(@data-qa,'quote-table')]//tr/td[1][contains(.,'${shoppingCartName}')]/ancestor::tr/td[last()]//a[contains(@href,'share')]
    ELSE
        Click    xpath=//*[@data-qa='component quote-table']//table//td[@data-content='Name'][contains(.,'${shoppingCartName}')]/..//a[contains(.,'Share')]
    END
Select access level to share shopping cart with:
    [Arguments]    ${customerToShareWith}    ${accessLevel}
    IF    '${env}' in ['ui_suite']
        Select From List By Label    xpath=//form[@name='shareCartForm']//div[contains(@data-qa,'user-share-list')]//li[contains(.,'${customerToShareWith}')]//select    ${accessLevel}
    ELSE
        Select From List By Label    xpath=//div[@data-qa="share-cart-table"]//*[text()='Users']/../../div[@data-qa='component user-share-list']//li[contains(.,'${customerToShareWith}')]//select    ${accessLevel}
    END
Delete first available shopping cart
    ${can_be_deleted}=    Run Keyword And Return Status    Page Should Contain Element    ${delete_first_shopping_cart_button}    timeout=1s
    IF    '${can_be_deleted}'=='True'    Click    ${delete_first_shopping_cart_button}
