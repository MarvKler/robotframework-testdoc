*** Settings ***
Resource    ../common/common.robot
Resource    ../pages/yves/yves_quote_request_page.robot
Resource    ../common/common_yves.robot
Resource    ../steps/header_steps.robot
Resource    ../common/common.robot
Resource    ../../resources/pages/yves/yves_shopping_cart_page.robot

*** Keywords ***
Yves: go to 'Agent Quote Requests' page
    ${lang}=    Yves: get current lang
    Yves: go to URL:    ${lang}/agent/quote-request

Yves: go to 'Quote Requests' page
    ${lang}=    Yves: get current lang
    Yves: go to URL:    ${lang}/quote-request

Yves: convert a cart to a quote request
    Click    ${request_a_quote_button}
    Click    ${quote_request_convert_from_cart_confirm_button}

Yves: quote request with reference xxx should have status:
    [Arguments]    ${quoteReference}    ${expectedStatus}
    Page Should Contain Element    xpath=//div[contains(@data-qa,'component quote-request')]//td[contains(.,'${quoteReference}')]
    ${actualStatus}=    Get Text    xpath=//div[contains(@data-qa,'component quote-request')]//td[contains(.,'${quoteReference}')]/..//*[contains(@class,'request-status')]
    Should Be Equal    ${expectedStatus}    ${actualStatus}

Yves: view quote request with reference:
    [Arguments]    ${quoteReference}
    IF    '${env}' in ['ui_suite']
        Click    xpath=(//div[contains(@data-qa,'component quote-request')]//td[contains(.,'${quoteReference}')]/ancestor::tr/td[last()]//a[contains(@href,'details')])[1]
    ELSE
        Click    xpath=//div[contains(@data-qa,'component quote-request')]//td[contains(.,'${quoteReference}')]/..//*[text()='View']/ancestor::a[contains(@class,'table-action-link')]
    END

Yves: click '${buttonName}' button on the 'Quote Request Details' page

    IF    '${buttonName}' == 'Back to List'
        Click    ${quote_request_back_to_list_button}
    ELSE IF    '${buttonName}' == 'Cancel'
        Click    ${quote_request_cancel_button}
    ELSE IF    '${buttonName}' == 'Revise'
        Click    ${quote_request_revise_button}
    ELSE IF    '${buttonName}' == 'Convert to Cart'
        Click    ${quote_request_convert_to_cart_button}
    ELSE IF    '${buttonName}' == 'Send to Customer'
        Click    ${quote_request_send_to_customer_button}
    ELSE IF    '${buttonName}' == 'Edit'
        Click    ${quote_request_edit_button}
    ELSE IF    '${buttonName}' == 'Edit Items'
        Click    ${quote_request_edit_items_button}
    ELSE IF    '${buttonName}' == 'Save'
        Click    ${quote_request_save_button}
    ELSE IF    '${buttonName}' == 'Save and Back to Edit'
        Click    ${quote_request_save_and_back_to_edit_button}
    ELSE IF    '${buttonName}' == 'Send to Agent'
        Click    ${quote_request_send_to_agent_button}
    END

    Yves: remove flash messages

Yves: change price for the product in the quote request with sku xxx on:
    [Arguments]    ${sku}    ${priceToSet}
    Wait Until Element Is Visible    ${quote_request_save_button}
    ${use_default_price_state}=    Set Variable    ${EMPTY}
    IF    '${env}' in ['ui_suite']
        Disable Automatic Screenshots on Failure
        ${use_default_price_state}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//product-item[contains(@data-qa,'product-cart-item')]//*[@itemprop='sku' and (text()='${sku}' or @content='${sku}')]/ancestor::product-item//input[@type='checkbox'][@checked]
        Restore Automatic Screenshots on Failure
        IF    '${use_default_price_state}'=='True'    Uncheck Checkbox    xpath=//product-item[contains(@data-qa,'product-cart-item')]//*[@itemprop='sku' and (text()='${sku}' or @content='${sku}')]/ancestor::product-item//input[@type='checkbox']    force=True
        TRY
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Page is not loaded
        END
        Sleep    1s
        TRY
            Wait Until Element Is Visible    xpath=//product-item[contains(@data-qa,'product-cart-item')]//*[@itemprop='sku' and (text()='${sku}' or @content='${sku}')]/ancestor::product-item//input[contains(@id,'UnitGrossPrice')]    timeout=5s
        EXCEPT
            Reload
            Disable Automatic Screenshots on Failure
            ${use_default_price_state}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//product-item[contains(@data-qa,'product-cart-item')]//*[@itemprop='sku' and (text()='${sku}' or @content='${sku}')]/ancestor::product-item//input[@type='checkbox'][@checked]
            Restore Automatic Screenshots on Failure
            IF    '${use_default_price_state}'=='True'    Uncheck Checkbox    xpath=//product-item[contains(@data-qa,'product-cart-item')]//*[@itemprop='sku' and (text()='${sku}' or @content='${sku}')]/ancestor::product-item//input[@type='checkbox']    force=True
            TRY
                Wait For Load State
                Wait For Load State    domcontentloaded
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    1s
        END
        Wait Until Element Is Visible    xpath=//product-item[contains(@data-qa,'product-cart-item')]//*[@itemprop='sku' and (text()='${sku}' or @content='${sku}')]/ancestor::product-item//input[contains(@id,'UnitGrossPrice')]
        Type Text    xpath=//product-item[contains(@data-qa,'product-cart-item')]//*[@itemprop='sku' and (text()='${sku}' or @content='${sku}')]/ancestor::product-item//input[contains(@id,'UnitGrossPrice')]    ${priceToSet}
    ELSE
        Disable Automatic Screenshots on Failure
        ${use_default_price_state}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//article[@data-qa='component quote-request-cart-item']//div[contains(@class,'quote-request-cart-item__column--content')][contains(.,'${sku}')]/ancestor::article//*[contains(@class,'quote-request-cart-item__column--total')]//input[@type='checkbox'][@checked]
        Restore Automatic Screenshots on Failure
        IF    '${use_default_price_state}'=='True'    Click    xpath=//article[@data-qa='component quote-request-cart-item']//div[contains(@class,'quote-request-cart-item__column--content')][contains(.,'${sku}')]/ancestor::article//*[contains(@class,'quote-request-cart-item__column--total')]//span[@data-qa='component checkbox use_default_price']
        TRY
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Page is not loaded
        END
        Sleep    1s
        TRY
            Wait Until Element Is Visible    xpath=//article[@data-qa='component quote-request-cart-item']//div[contains(@class,'quote-request-cart-item__column--content')][contains(.,'${sku}')]/ancestor::article//*[contains(@class,'quote-request-cart-item__column--total')]//input[@id]//ancestor::div[contains(@id,'quote_request_agent_form')]    timeout=5s
        EXCEPT
            Reload
            Disable Automatic Screenshots on Failure
            ${use_default_price_state}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//article[@data-qa='component quote-request-cart-item']//div[contains(@class,'quote-request-cart-item__column--content')][contains(.,'${sku}')]/ancestor::article//*[contains(@class,'quote-request-cart-item__column--total')]//input[@type='checkbox'][@checked]
            Restore Automatic Screenshots on Failure
            IF    '${use_default_price_state}'=='True'    Click    xpath=//article[@data-qa='component quote-request-cart-item']//div[contains(@class,'quote-request-cart-item__column--content')][contains(.,'${sku}')]/ancestor::article//*[contains(@class,'quote-request-cart-item__column--total')]//span[@data-qa='component checkbox use_default_price']
            TRY
                Wait For Load State
                Wait For Load State    domcontentloaded
            EXCEPT
                Log    Page is not loaded
            END
            Sleep    1s
        END
        Wait Until Element Is Visible    xpath=//article[@data-qa='component quote-request-cart-item']//div[contains(@class,'quote-request-cart-item__column--content')][contains(.,'${sku}')]/ancestor::article//*[contains(@class,'quote-request-cart-item__column--total')]//input[@id]//ancestor::div[contains(@id,'quote_request_agent_form')]
        Type Text    xpath=//article[@data-qa='component quote-request-cart-item']//div[contains(@class,'quote-request-cart-item__column--content')][contains(.,'${sku}')]/ancestor::article//*[contains(@class,'quote-request-cart-item__column--total')]//input[@id]    ${priceToSet}
    END

Yves: add the following note to the quote request:
    [Arguments]    ${noteToSet}
    Type Text    ${quote_request_notes_text_area}    ${noteToSet}

Yves: go to the quote request through the header with reference:
    [Arguments]    ${quoteReference}
    # *** OBSOLETE ***
    # Yves: move mouse over header menu item:    ${quoteRequestsWidget}
    # Wait Until Element Is Visible    ${agent_quote_requests_widget}
    # Click    xpath=//agent-control-bar//a[contains(@href,'quote-request')]/ancestor::li[contains(@class,'menu__item--has-children')]//a[contains(@class,'quote-request-detail')][contains(.,'${quoteReference}')]
    ${lang}=    Yves: get current lang
    Yves: go to URL:    ${lang}/agent/quote-request/details/${quoteReference}

Yves: 'Quote Request Details' page contains the following note:
    [Arguments]    ${noteToCheck}
    IF    '${env}' in ['ui_suite']
        ${actualNote}=    Get Text    xpath=//*[contains(@data-qa,'quote-request-information')]/ancestor::main/div[position()=1]/div[position()=1]//p
    ELSE
        ${actualNote}=    Get Text    xpath=//main[contains(@class,'request-for-quote')]//label[@class='label'][contains(text(),'Notes')]//following-sibling::p[1]
    END
    Should Be Equal    ${actualNote}    ${noteToCheck}

Yves: set 'Valid Till' date for the quote request, today +:
    [Arguments]    ${daysToAdd}
    ${currentDate}=    Get Current Date
    ${dateToSet}=    Add Time To Date    ${currentDate}    ${daysToAdd}
    Add/Edit element attribute with JavaScript:    //input[@id='quote_request_agent_form_validUntil']    value    ${dateToSet}

Yves: set 'Valid Till' date in the past for the quote request:
    Add/Edit element attribute with JavaScript:    //input[@id='quote_request_agent_form_validUntil']    value    2019-07-15 02:47:55.432

Yves: submit new request for quote
    [Documentation]    Returns ID of the RfQ
    Yves: click on the 'Request a Quote' button in the shopping cart
    Click    ${quote_request_convert_from_cart_confirm_button}
    IF    '${env}' in ['ui_suite']
        ${lastCreatedRfQ}=    Get Text    xpath=//*[@data-qa='component breadcrumb']//li[last()]
    ELSE
        ${lastCreatedRfQ}=    Get Text    xpath=//div[@class='page-info']//*[contains(@class,'page-info__title')]
    END
    ${lastCreatedRfQ}=    Replace String    ${lastCreatedRfQ}    \#    ${EMPTY}
    ${lastCreatedRfQ}=    Replace String    ${lastCreatedRfQ}    ${SPACE}    ${EMPTY}
    Set Suite Variable    ${lastCreatedRfQ}    ${lastCreatedRfQ}
    RETURN    ${lastCreatedRfQ}
