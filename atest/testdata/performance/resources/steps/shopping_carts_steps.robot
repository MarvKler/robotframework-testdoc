*** Settings ***
Resource    ../pages/yves/yves_shopping_carts_page.robot
Resource    ../pages/yves/yves_shopping_cart_page.robot
Resource    ../pages/yves/yves_delete_shopping_cart_page.robot
Resource    ../common/common_yves.robot
Resource    ../common/common.robot

*** Variables ***
${upSellProducts}    ${shopping_cart_upp-sell_products_section}[${env}]
${lockedCart}    ${shopping_cart_locked_cart_form}

*** Keywords ***
Yves: 'Shopping Carts' widget contains:
    [Arguments]    ${shoppingCartName}    ${accessLevel}
    Wait Until Element Is Visible    ${shopping_car_icon_header_menu_item}[${env}]
    Mouse Over    ${shopping_car_icon_header_menu_item}[${env}]
    Wait Until Element Is Visible    ${shopping_cart_sub_navigation_widget}
    IF    '${env}' in ['ui_suite']
        Page Should Contain Element    xpath=//header//cart-counter//a[contains(@href,'/cart')]/ancestor::li//ul[contains(@class,'menu')][contains(@class,'wide')]//*[contains(@data-qa,'mini-cart-detail')]//a[contains(.,'${shoppingCartName}')]/ancestor::div[1]//*[@class='cart-permission'][contains(.,'${accessLevel}')] | //header//cart-counter//a[contains(@href,'/cart')]/ancestor::li//ul[contains(@class,'menu')][contains(@class,'wide')]//*[contains(@data-qa,'mini-cart-detail')]//button[contains(.,'${shoppingCartName}')]/ancestor::div[1]//*[@class='cart-permission'][contains(.,'${accessLevel}')]
    ELSE
        Page Should Contain Element    xpath=//*[contains(@class,'icon--cart')]/ancestor::li//div[contains(@class,'js-user-navigation__sub-nav-cart')]//span[text()[contains(.,'${accessLevel}')]]/ancestor::div[@class='mini-cart-detail']//*[contains(@class,'mini-cart-detail__title')]/*[text()='${shoppingCartName}']
    END

Yves: go to 'Shopping Carts' page
    ${lang}=    Yves: get current lang
    Yves: go to URL:    ${lang}/multi-cart

Yves: create new 'Shopping Cart' with name:
    [Arguments]    ${shoppingCartName}
    ${currentURL}=    Get Location
    IF    '/multi-cart' not in '${currentURL}'    
            IF    '.at.' in '${currentURL}'
                Go To    ${yves_at_url}multi-cart
            ELSE
                Go To    ${yves_url}multi-cart
            END    
    END
    Click    ${create_shopping_cart_button}
    Type Text    ${shopping_cart_name_input_field}    ${shoppingCartName}
    Click    ${create_new_cart_submit_button}

Yves: the following shopping cart is shown:
    [Arguments]    ${shoppingCartName}    ${shoppingCartAccess}
    IF    '${env}' in ['ui_suite']
        Page Should Contain Element    xpath=//*[contains(@data-qa,'quote-table')]//*[@class='cart-permission'][contains(.,'${shoppingCartAccess}')]/ancestor::tr/td[1][contains(.,'${shoppingCartName}')]
    ELSE
        Page Should Contain Element    xpath=//*[@data-qa='component quote-table']//table//td[@data-content='Access'][contains(.,'${shoppingCartAccess}')]/../td[@data-content='Name'][contains(.,'${shoppingCartName}')]
    END
Yves: share shopping cart with user:
    [Arguments]    ${shoppingCartName}    ${customerToShare}    ${accessLevel}
    Share shopping cart with name:    ${shoppingCartName}
    Select access level to share shopping cart with:    ${customerToShare}    ${accessLevel}
    Click    ${share_shopping_cart_confirm_button}
    Yves: 'Shopping Carts' page is displayed
    Yves: flash message 'should' be shown

Yves: go to the shopping cart through the header with name:
    [Arguments]    ${shoppingCartName}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    Yves: remove flash messages
    Wait Until Element Is Visible    ${shopping_car_icon_header_menu_item}[${env}]
    Mouse Over    ${shopping_car_icon_header_menu_item}[${env}]
    Wait Until Element Is Visible    ${shopping_cart_sub_navigation_widget}
    IF    '${env}' in ['ui_suite']
        Click    xpath=//header//cart-counter//a[contains(@href,'/cart')]/ancestor::li//ul[contains(@class,'menu')][contains(@class,'wide')]//*[contains(@data-qa,'mini-cart-detail')]//a[contains(.,'${shoppingCartName}')] | //header//cart-counter//a[contains(@href,'/cart')]/ancestor::li//ul[contains(@class,'menu')][contains(@class,'wide')]//*[contains(@data-qa,'mini-cart-detail')]//button[contains(.,'${shoppingCartName}')]
    ELSE
        Click    xpath=//*[contains(@class,'icon--cart')]/ancestor::li//div[contains(@class,'js-user-navigation__sub-nav-cart')]//div[@class='mini-cart-detail']//*[contains(@class,'mini-cart-detail__title')]/*[text()='${shoppingCartName}']
    END
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Page is not loaded
    END

Yves: go to shopping cart page through the header
    Yves: remove flash messages
    Wait Until Element Is Visible    ${shopping_car_icon_header_menu_item}[${env}]
    Click     ${shopping_car_icon_header_menu_item}[${env}]
    Wait Until Element Is Visible    ${shopping_cart_main_content_locator}[${env}]
    Reload
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    Wait Until Element Is Visible    ${shopping_cart_main_content_locator}[${env}]

Yves: go to shopping cart page
    Yves: go to URL:    /cart
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
        Wait Until Element Is Not Visible    ${shopping_cart_ajax_loader}
    EXCEPT
        Log    Page is not loaded
    END

Yves: shopping cart contains the following products:
    [Documentation]    For item listing you can use sku or name of the product
    [Arguments]    @{items_list}
    ${items_list_count}=   get length  ${items_list}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    FOR    ${index}    IN RANGE    0    ${items_list_count}
        ${item_to_check}=    Get From List    ${items_list}    ${index}
        IF    '${env}' in ['ui_suite']
            Page Should Contain Element    locator=xpath=(//main//cart-items-list//product-item[contains(@data-qa,'component product-cart-item')]//*[@data-qa='cart-item-sku'][contains(text(),'${item_to_check}')])[1]    timeout=${browser_timeout}
        ELSE
            Page Should Contain Element    locator=xpath=(//main[contains(@class,'cart')]//article[(contains(@data-qa,'product-cart-item') or contains(@data-qa,'product-card-item'))]//*[contains(.,'${item_to_check}')]/ancestor::article)[1]    timeout=${browser_timeout}
        END
    END

Yves: preview shopping cart contains the following products:
    [Documentation]    For item listing you can use sku or name of the product
    [Arguments]    @{items_list}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    ${items_list_count}=   get length  ${items_list}
    FOR    ${index}    IN RANGE    0    ${items_list_count}
        ${item_to_check}=    Get From List    ${items_list}    ${index}
        IF    '${env}' in ['ui_suite']
            Page Should Contain Element    xpath=(//main//product-item[contains(@data-qa,'component product-cart-item')]//*[@data-qa='cart-item-sku'][contains(text(),'${item_to_check}')])[1]
        ELSE
            Page Should Contain Element    xpath=(//main[contains(@class,'cart')]//article[(contains(@data-qa,'product-cart-item') or contains(@data-qa,'product-card-item'))]//*[contains(.,'${item_to_check}')]/ancestor::article)[1]
        END
    END

Yves: click on the '${buttonName}' button in the shopping cart
    Yves: remove flash messages
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Page is not loaded
    END
    IF    '${buttonName}' == 'Checkout'
        Click    ${shopping_cart_checkout_button}
        Wait Until Page Does Not Contain Element    ${shopping_cart_checkout_button}
    ELSE IF    '${buttonName}' == 'Request a Quote'
        Click    ${shopping_cart_request_quote_button}
        Wait Until Page Does Not Contain Element    ${shopping_cart_request_quote_button}
    END
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END

Yves: shopping cart contains product with unit price:
    [Arguments]    ${sku}    ${productName}    ${productPrice}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Page is not loaded
    END
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']
        TRY
            Page Should Contain Element    xpath=//div[contains(@class,'product-card-item__col--description')]//div[contains(.,'SKU: ${sku}')]/ancestor::article//*[contains(@class,'product-card-item__col--description')]/div[1]//*[contains(@class,'money-price__amount')][contains(.,'${productPrice}')]    timeout=300ms
        EXCEPT
            Page Should Contain Element    xpath=//div[contains(@class,'product-cart-item__col--description')]//div[contains(.,'SKU: ${sku}')]/ancestor::article//*[contains(@class,'product-cart-item__col--description')]/div[1]//*[contains(@class,'money-price__amount')][contains(.,'${productPrice}')]    timeout=300ms
        END  
    ELSE IF    '${env}' in ['ui_suite']
        Page Should Contain Element    xpath=//main//cart-items-list//product-item[contains(@data-qa,'component product-cart-item')]//*[@data-qa='cart-item-sku'][contains(text(),'${sku}')]/ancestor::product-item//*[contains(@data-qa,'cart-item-summary')]//span[contains(.,'${productPrice}')]    timeout=300ms
    ELSE
        Page Should Contain Element    xpath=//main[@class='page-layout-cart']//article[contains(@data-qa,'component product-card-item')]//a[contains(text(),'${productName}')]/following-sibling::span/span[contains(@class,'money-price__amount') and contains(.,'${productPrice}')]    timeout=300ms
    END

Yves: shopping cart contains/doesn't contain the following elements:
    [Arguments]    ${condition}    @{shopping_cart_elements_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Page is not loaded
    END
    ${condition}=    Convert To Lower Case    ${condition}
    ${shopping_cart_elements_list_count}=   get length  ${shopping_cart_elements_list}
    FOR    ${index}    IN RANGE    0    ${shopping_cart_elements_list_count}
        ${shopping_cart_element_to_check}=    Get From List    ${shopping_cart_elements_list}    ${index}
        IF    '${condition}' == 'true'
            Run Keywords
                Log    ${shopping_cart_element_to_check}    #Left as an example of multiple actions in Condition
                Page Should Contain Element    ${shopping_cart_element_to_check}    message=${shopping_cart_element_to_check} is not displayed
        END
        IF    '${condition}' == 'false'
            Run Keywords
                Log    ${shopping_cart_element_to_check}    #Left as an example of multiple actions in Condition
                Page Should Not Contain Element    ${shopping_cart_element_to_check}    message=${shopping_cart_element_to_check} should not be displayed
        END
    END

Yves: shopping cart with name xxx has the following status:
    [Arguments]    ${cartName}    ${status}
    Page Should Contain Element    //*[@data-qa='component quote-table']//table//td[@data-content='Name'][contains(.,'${cartName}')]/../td//*[contains(@data-qa,'component quote-status')][contains(.,'${status}')]

Yves: delete product from the shopping cart with sku:
    [Arguments]    ${sku}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Page is not loaded
    END
    Click    xpath=//form[contains(@name,'removeFromCartForm_${sku}')]//button
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Page is not loaded
    END
    Yves: remove flash messages

Yves: delete product from the shopping cart with name:
    [Arguments]    ${productName}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Page is not loaded
    END
    Click    //main[@class='page-layout-cart']//article[contains(@data-qa,'component product-card-item')]//a[contains(text(),'${productName}')]/ancestor::article//form[contains(@name,'removeFromCartForm')]//button | //div[contains(@class,'box cart-items-list')]//a[contains(text(),'${productName}')]//ancestor::*[@data-qa='component product-cart-item']//button[contains(text(),'remove')]
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
        Wait For Load State    networkidle
    EXCEPT
        Log    Page is not loaded
    END
    Yves: remove flash messages

Yves: shopping cart doesn't contain the following products:
    [Arguments]    @{sku_list}    ${sku1}=${EMPTY}     ${sku2}=${EMPTY}     ${sku3}=${EMPTY}     ${sku4}=${EMPTY}     ${sku5}=${EMPTY}     ${sku6}=${EMPTY}     ${sku7}=${EMPTY}     ${sku8}=${EMPTY}     ${sku9}=${EMPTY}     ${sku10}=${EMPTY}     ${sku11}=${EMPTY}     ${sku12}=${EMPTY}     ${sku13}=${EMPTY}     ${sku14}=${EMPTY}     ${sku15}=${EMPTY}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    ${sku_list_count}=   get length  ${sku_list}
    FOR    ${index}    IN RANGE    0    ${sku_list_count}
        ${sku_to_check}=    Get From List    ${sku_list}    ${index}
        Page Should Not Contain Element    xpath=//form[contains(@name,'removeFromCartForm_${sku_to_check}')]
    END

Yves: get link for external cart sharing
    Reload
    IF    '${env}' in ['ui_suite']
        Click    xpath=//input[@name='cart-share'][contains(@target-class-name,'external')]/ancestor::label
    ELSE
        Click    xpath=//div[@data-qa='component cart-sidebar']//*[contains(@data-qa,'url-mask-generator')]//ancestor::*[contains(@data-qa,'cart-sidebar-item')]//*[@data-toggle-target]
        Click    xpath=//input[@name='cart-share'][contains(@target-class-name,'external')]/ancestor::label    
    END
    Wait Until Element Is Visible    xpath=//input[@id='PREVIEW']
    ${externalURL}=    Get Element Attribute    xpath=//input[@id='PREVIEW']    value
    ${externalURL}=    Replace String Using Regexp    ${externalURL}    ${EMPTY}.*.com/    ${EMPTY}
    Set Suite Variable    ${externalURL}

Yves: Expand shopping cart accordion:
     [Arguments]    ${accordionTitle}
     ${accordionState}=    Get Element Attribute    xpath=//div[@data-qa='component cart-sidebar']//*[contains(@class,'cart-sidebar-item__title')][contains(.,'${accordionTitle}')]    class
     ${accordionState}=    Replace String    ${accordionState}    ${SPACE}    ${EMPTY}
     ${accordionState}=    Replace String    ${accordionState}    _    ${SPACE}
     ${accordionState}=    Replace String    ${accordionState}    -    ${SPACE}
     ${accordionState}=    Replace String    ${accordionState}    \r    ${EMPTY}
     ${accordionState}=    Replace String    ${accordionState}    \n    ${EMPTY}
     IF    'active' not in '${accordionState}'
         Run Keywords
            Click With Options    xpath=//div[@data-qa='component cart-sidebar']//*[contains(@class,'cart-sidebar-item__title')][contains(.,'${accordionTitle}')]    delay=1s    force=True
            Wait Until Element Is Visible    xpath=//div[@data-qa='component cart-sidebar']//*[contains(@class,'cart-sidebar-item__title')][contains(.,'${accordionTitle}')]/../div[contains(@class,'cart-sidebar-item__content')]
     END

Yves: Shopping Cart title should be equal:
    [Arguments]    ${expectedCartTitle}
    ${actualCartTitle}=    Get Text    ${shopping_cart_cart_title}[${env}]
    Should Be Equal    ${actualCartTitle}    ${expectedCartTitle}

Yves: change quantity of the configurable bundle in the shopping cart on:
    [Documentation]    In case of multiple matches, changes quantity for the first product in the shopping cart
    [Arguments]    ${confBundleTitle}    ${quantity}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    IF    '${env}' in ['ui_b2b','ui_mp_b2b','ui_suite']
        Type Text    xpath=//main//article[contains(@data-qa,'configured-bundle')][1]//a[text()='${confBundleTitle}']/ancestor::article//input[contains(@class, 'formatted-number-input__input')]    ${quantity}
    ELSE
        Type Text    xpath=//article[contains(@data-qa,'configured-bundle-secondary')][1]//ancestor::*[contains(@data-qa, 'component formatted-number-input')]//input[contains(@class,'formatted-number-input')][contains(@data-min-quantity,'1')]    ${quantity}
    END
    IF    '${env}' in ['ui_suite']
        Click    //main//article[contains(@data-qa,'configured-bundle')][1]//a[text()='${confBundleTitle}']/ancestor::article//input[contains(@class, 'formatted-number-input__input')]/ancestor::article//button[@data-qa='quantity-input-submit']
    END
    Click With Options    xpath=//main//article[contains(@data-qa,'configured-bundle')][1]//a[text()='${confBundleTitle}']/ancestor::article    delay=1s
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    Yves: remove flash messages

Yves: delete all shopping carts
    Yves: create new 'Shopping Cart' with name:    Y
    #create new empty cart that will be the last one in the list
    ${currentURL}=    Get Location
    IF    '/multi-cart' not in '${currentURL}'    
            IF    '.at.' in '${currentURL}'
                Go To    ${yves_at_url}multi-cart
            ELSE
                Go To    ${yves_url}multi-cart
            END    
    END
    ${shoppingCartsCount}=    Get Element Count    xpath=//*[@data-qa='component quote-table']//table/tbody/tr//a[contains(.,'Delete')]
    FOR    ${index}    IN RANGE    0    ${shoppingCartsCount}-1
        Delete first available shopping cart
        Wait Until Element Is Visible    ${delete_shopping_cart_button}
        Click    ${delete_shopping_cart_button}
    END

Yves: delete 'Shopping Cart' with name:
    [Arguments]    ${shoppingCartName}
    ${currentURL}=    Get Location
    IF    '/multi-cart' not in '${currentURL}'    
            IF    '.at.' in '${currentURL}'
                Go To    ${yves_at_url}multi-cart
            ELSE
                Go To    ${yves_url}multi-cart
            END    
    END
    Delete shopping cart with name:    ${shoppingCartName}
    Wait Until Element Is Visible    ${delete_shopping_cart_button}
    Click    ${delete_shopping_cart_button}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END

Yves: delete from b2c cart products with name:
    [Arguments]    @{productNameList}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    FOR    ${product}    IN    @{productNameList}
        Click    xpath=//div[@class='page-layout-cart__items-wrap']//a[contains(text(),'${product}')]/ancestor::div/following-sibling::div//form[contains(@name,'removeFromCart')]//button[text()='Remove']
        Yves: flash message should be shown:    success    Products were removed successfully
        Yves: remove flash messages
        IF    '${env}' in ['ui_b2b','ui_mp_b2b']
            Page Should Not Contain Element    xpath=//div[contains(@class,'product-card-item__col--description')]//div[contains(.,'${product}')]
        ELSE
            Page Should Not Contain Element    xpath=//main[@class='page-layout-cart']//article[contains(@data-qa,'component product-card-item')]//a[contains(text(),'${product}')]
        END
    END

Yves: apply discount voucher to cart:
    [Arguments]    ${voucherCode}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    ${expanded}=    Set Variable    ${EMPTY}
    Disable Automatic Screenshots on Failure
    ${expanded}=    IF    '${env}' in ['ui_b2c','ui_mp_b2c']    Run Keyword And Return Status    Get Element States    ${shopping_cart_voucher_code_field}    ==    hidden    return_names=False
    Restore Automatic Screenshots on Failure
    IF    '${env}' in ['ui_b2c','ui_mp_b2c'] and '${expanded}'=='False'    Click    ${shopping_cart_voucher_code_section_toggler}
    Type Text    ${shopping_cart_voucher_code_field}    ${voucherCode}
    Click    ${shopping_cart_voucher_code_redeem_button}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    Yves: remove flash messages

Yves: discount is applied:
#TODO: make from this method smth real, because Sum is not used
    [Arguments]    ${discountType}    ${discountName}    ${expectedDiscountSum}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    IF    '${env}' in ['ui_b2c','ui_mp_b2c'] and '${discountType}'=='voucher'
        Element should be visible    locator=xpath=//span[contains(text(),'${expectedDiscountSum}')]/preceding-sibling::span[contains(text(),'${discountName}')]/ancestor::*[contains(@data-qa,'cart-discount-summary')]/*[contains(.,'Vouchers')]    timeout=${browser_timeout}
    ELSE IF    '${env}' in ['ui_b2c','ui_mp_b2c'] and '${discountType}'=='cart rule'
        Element should be visible    locator=xpath=//span[contains(text(),'${expectedDiscountSum}')]/preceding-sibling::span[contains(text(),'${discountName}')]/ancestor::*[contains(@data-qa,'cart-discount-summary')]/*[contains(.,'Discounts')]    timeout=${browser_timeout}
    ELSE IF     '${env}' in ['ui_b2b','ui_mp_b2b'] and '${discountType}'=='voucher'
        Element should be visible    locator=xpath=//span[contains(text(),'${expectedDiscountSum}')]/preceding-sibling::span[contains(text(),'${discountName}')]/ancestor::*[contains(@data-qa,'cart-code-summary')]/*[contains(.,'Vouchers')]    timeout=${browser_timeout}
    ELSE IF    '${env}' in ['ui_b2b','ui_mp_b2b'] and '${discountType}'=='cart rule'
        Element should be visible    locator=xpath=//span[contains(text(),'${expectedDiscountSum}')]/preceding-sibling::span[contains(text(),'${discountName}')]/ancestor::*[contains(@data-qa,'cart-code-summary')]/*[contains(.,'Discounts')]    timeout=${browser_timeout}
    END

Yves: promotional product offer is/not shown in cart:
    [Arguments]    ${isShown}
    ${isShown}=    Convert To Lower Case    ${isShown}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    IF    '${isShown}'=='true'
        Try reloading page until element is/not appear:    ${shopping_cart_promotional_product_section}    true    5
        Element Should Be Visible    ${shopping_cart_promotional_product_section}    message=Promotional products are not displayed but should be    timeout=${browser_timeout}
    ELSE IF    '${isShown}'=='false'
        Try reloading page until element is/not appear:    ${shopping_cart_promotional_product_section}    false    5
        Element Should Not Be Visible    ${shopping_cart_promotional_product_section}    message=Promotional products are displayed but should not    timeout=${browser_timeout}
    END
    
Yves: change quantity of promotional product and add to cart:
    [Documentation]    set ${action} to + or - to change quantity. ${clickCount} indicates how many times to click
    [Arguments]    ${action}    ${clicksCount}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    FOR    ${index}    IN RANGE    0    ${clicksCount}
        IF    '${action}' == '+'
            Click    ${shopping_cart_promotional_product_increase_quantity_button}[${env}]
        ELSE IF    '${action}' == '-'
            Click    ${shopping_cart_promotional_product_decrease_quantity_button}[${env}]
        END
    END
    Click    ${shopping_cart_promotional_product_add_to_cart_button}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    Yves: flash message should be shown:    success    Items added successfully
    Yves: remove flash messages

Yves: add promotional product to the cart
    [Documentation]    
    Click    ${shopping_cart_promotional_product_add_to_cart_button}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    Yves: flash message should be shown:    success    Items added successfully
    Yves: remove flash messages

Yves: assert merchant of product in b2c cart:
    [Documentation]    Method for MP which asserts value in 'Sold by' label of item in cart or list. Requires concrete SKU
    [Arguments]    ${product_name}    ${merchant_name_expected}
    Page Should Contain Element    xpath=//main[contains(@class,'cart')]//article[contains(@data-qa,'component product-card-item')]//*[contains(.,'${product_name}')]/ancestor::article//*[@data-qa='component sold-by-merchant']/a[text()='${merchant_name_expected}']