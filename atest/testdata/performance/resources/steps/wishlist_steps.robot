*** Settings ***
Resource    ../common/common.robot
Resource    ../../resources/common/common_yves.robot
Resource    ../pages/yves/yves_wishlist_page.robot

*** Keywords ***
Yves: go to 'Wishlist' page
    ${lang}=    Yves: get current lang
    Yves: go to URL:    ${lang}/wishlist

Yves: go to wishlist with name:
    [Arguments]    ${wishlistName}
    Yves: go to 'Wishlist' page
    Click    xpath=//*[contains(@data-qa,'wishlist-overview')]//table//a[contains(text(),'${wishlistName}')]
    Element Should Be Visible    xpath=//main//*[contains(@class,'title')][contains(text(),'${wishlistName}')]

Yves: product with sku is marked as discontinued in wishlist:
    [Arguments]    ${productSku}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    page is not fully loaded
    END
    FOR    ${index}    IN RANGE    0    21
        Disable Automatic Screenshots on Failure
        ${discontinue_applied}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//li[contains(text(),'${productSku}')]/ancestor::td/following-sibling::td/span[contains(text(),'Discontinued')]
        Restore Automatic Screenshots on Failure
        IF    '${discontinue_applied}'=='False'
            Run Keywords
                Sleep    1s
                Reload
                TRY
                    Wait For Load State
                    Wait For Load State    domcontentloaded
                EXCEPT
                    Log    page is not fully loaded
                END
        ELSE
            Exit For Loop
        END
        IF    ${index} == 2 or ${index} == 5
            Trigger p&s
        END
    END
    Element Should Be Visible    xpath=//li[contains(text(),'${productSku}')]/ancestor::td/following-sibling::td/span[contains(text(),'Discontinued')]

Yves: product with sku is marked as alternative in wishlist:
    [Arguments]    ${productSku}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    page is not fully loaded
    END
    FOR    ${index}    IN RANGE    0    21
        Disable Automatic Screenshots on Failure
        IF    '${env}' in ['ui_suite']
            ${alternative_applied}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//*[contains(@data-qa,'wishlist-table')]//td//a/../*[contains(.,'${productSku}')]/following-sibling::*[contains(text(),'Alternative for')]
        ELSE
            ${alternative_applied}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//li[contains(text(),'${productSku}')]/ancestor::tr/preceding-sibling::tr//*[contains(text(),'Alternative for')]
        END
        Restore Automatic Screenshots on Failure
        IF    '${alternative_applied}'=='False'
            Sleep    1s
            Reload
            TRY
                Wait For Load State
                Wait For Load State    domcontentloaded
            EXCEPT
                Log    page is not fully loaded
            END
        ELSE
            Exit For Loop
       END
       IF    ${index} == 2 or ${index} == 5
           Trigger p&s
       END
    END
    IF    '${env}' in ['ui_suite']
        Element Should Be Visible    xpath=//*[contains(@data-qa,'wishlist-table')]//td//a/../*[contains(.,'${productSku}')]/following-sibling::*[contains(text(),'Alternative for')]
    ELSE
        Element Should Be Visible    xpath=//li[contains(text(),'${productSku}')]/ancestor::tr/preceding-sibling::tr//*[contains(text(),'Alternative for')]
    END

Yves: create wishlist with name:
    [Arguments]    ${wishlistName}
    ${currentURL}=    Get Location
    IF    '/wishlist/detail' in '${currentURL}' or '/wishlist' not in '${currentURL}'
            IF    '.at.' in '${currentURL}'
                Go To    ${yves_at_url}wishlist
            ELSE
                Go To    ${yves_url}wishlist
            END    
    END
    Type Text    ${wishlist_name_input_field}    ${wishlistName}
    Click    ${wishlist_add_new_button}
    Yves: flash message should be shown:    success    Wishlist created successfully.
    Yves: remove flash messages

Yves: wishlist contains product with sku:
    [Arguments]    ${productSku}
    Element Should Be Visible    xpath=//*[contains(@data-qa,'wishlist')][contains(@data-qa,'table')]//li[contains(text(),'${productSku}')]    message=Product with ${productSku} sku is not found in wishlist

Yves: delete all wishlists
    Yves: go to 'Wishlist' page
    ${wishlists_list_count}=   Get Element Count    ${wishlist_delete_button}
    FOR    ${index}    IN RANGE    0    ${wishlists_list_count}
        Click    ${wishlist_delete_button}\[1\]
        Yves: flash message should be shown:    success    Wishlist deleted successfully
        Yves: remove flash messages
    END

Yves: assert merchant of product in wishlist:
    [Documentation]    Method for MP which asserts value in 'Sold by' label of item in wishlist. Requires concrete SKU
    [Arguments]    ${sku}    ${merchant_name_expected}
    IF    '${env}' in ['ui_suite']
        Page Should Contain Element    xpath=(//*[contains(@data-qa,'wishlist-table')]//td[contains(.,'${sku}')]//a[contains(@href,'merchant')][contains(text(),'${merchant_name_expected}')])[1]
    ELSE
        Page Should Contain Element    xpath=//ul[@class='menu menu--inline menu--middle']//li[contains(text(),'${sku}')]/../li/p[@data-qa='component sold-by-merchant']//a[text()='${merchant_name_expected}']
    END

Yves: add all available products from wishlist to cart
    Wait Until Element Is Visible    ${wishlist_add_all_to_cart_button}
    Click    ${wishlist_add_all_to_cart_button}

Yves: create new 'Wishlist' with name:
    [Arguments]    ${wishlistName}
    ${currentURL}=    Get Location
    IF    '/wishlist/detail' in '${currentURL}' or '/wishlist' not in '${currentURL}'
            IF    '.at.' in '${currentURL}'
                Go To    ${yves_at_url}wishlist
            ELSE
                Go To    ${yves_url}wishlist
            END    
    END
    Type Text    ${wishlist_name_input_field}    ${wishlistName}
    Click    ${wishlist_add_new_button}
    Yves: remove flash messages