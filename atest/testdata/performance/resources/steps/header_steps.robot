*** Settings ***
Resource    ../common/common.robot
Resource    ../pages/yves/yves_header_section.robot
Resource    ../pages/yves/yves_catalog_page.robot
Resource    ../steps/request_for_quote_steps.robot
Resource    ../steps/shopping_carts_steps.robot
Resource    ../steps/shopping_lists_steps.robot
Resource    ../steps/quick_order_steps.robot
Resource    ../steps/request_for_quote_steps.robot
Resource    ../steps/wishlist_steps.robot

*** Variables ***
${priceModeSwitcher}    ${price_mode_switcher_header_menu_item}
${currencySwitcher}    ${currency_switcher_header_menu_item}
${languageSwitcher}    ${language_switcher_header_menu_item}
${quickOrderIcon}    ${quick_order_icon_header_menu_item}
${accountIcon}    ${user_navigation_icon_header_menu_item}[${env}]
${shoppingListIcon}    ${shopping_list_icon_header_menu_item}[${env}]
${shoppingCartIcon}    ${shopping_car_icon_header_menu_item}[${env}]
${customerSearchWidget}    ${agent_customer_search_widget}
${quoteRequestsWidget}    ${agent_quote_requests_header_item}
${wishlistIcon}    ${wishlist_icon_header_navigation_widget}

*** Keywords ***
Yves: perform search by:
    [Arguments]    ${searchTerm}
    IF    '${env}' in ['ui_b2c','ui_mp_b2c']    
        Run Keywords
            Wait Until Page Contains Element    ${search_form_open_menu_item}
            Click    ${search_form_open_menu_item}
    END
    Wait Until Page Contains Element    ${search_form_header_menu_item}
    Type Text    ${search_form_header_menu_item}    ${searchTerm}
    Keyboard Key    press    Enter
    Wait Until Page Contains Element    ${catalog_main_page_locator}[${env}]
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT    
        Log    Page is not loaded
    END

Yves: go to company menu item:
    [Arguments]    ${company_menu_item}
    wait until element is visible  ${company_name_icon_header_menu_item}
    mouse over  ${company_name_icon_header_menu_item}
    Click    //div[@class='header__top']//a[contains(@class,'navigation-top__company')]/..//nav[contains(@class,'navigation-list')]/ul//a[text()='${company_menu_item}']


Yves: company menu '${condition}' be available for logged in user
    IF    '${condition}' == 'should'    Run Keywords
    ...    wait until element is visible  ${company_name_icon_header_menu_item}
    ...    AND    mouse over  ${company_name_icon_header_menu_item}
    ...    ELSE    Page Should Not Contain Element    ${company_name_icon_header_menu_item}

Yves: header contains/doesn't contain:
    [Arguments]    ${condition}    @{header_elements_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${condition}=    Convert To Lower Case    ${condition}
    ${header_elements_list_count}=   get length  ${header_elements_list}
    FOR    ${index}    IN RANGE    0    ${header_elements_list_count}
        ${header_element_to_check}=    Get From List    ${header_elements_list}    ${index}
        IF    '${condition}' == 'true'
            Run Keywords
                Log    ${header_element_to_check}    #Left as an example of multiple actions in Condition
                Page Should Contain Element    ${header_element_to_check}    message=${header_element_to_check} is not displayed
        END
        IF    '${condition}' == 'false'
            Run Keywords
                Log    ${header_element_to_check}    #Left as an example of multiple actions in Condition
                Page Should Not Contain Element    ${header_element_to_check}    message=${header_element_to_check} should not be displayed
        END
    END

Yves: go to '${pageName}' page through the header
    IF    '${pageName}' == 'Shopping Lists'
        Yves: go to 'Shopping Lists' page
    ELSE IF    '${pageName}' == 'Shopping Carts'
        Yves: go to 'Shopping Carts' page
    ELSE IF    '${pageName}' == 'Quick Order'
        Yves: go to 'Quick Order' page
    ELSE IF    '${pageName}' == 'Quote Requests'
        Yves: go to 'Agent Quote Requests' page
    ELSE IF    '${pageName}' == 'Wishlist'
        Yves: go to 'Wishlist' page
    ELSE IF    '${pageName}' == 'Agent Quote Requests'
        Yves: go to 'Agent Quote Requests' page
    END

Yves: go to user menu item in header:
    [Arguments]    ${user_menu_item}
    Wait Until Element Is Visible  ${user_navigation_icon_header_menu_item}[${env}]
    Mouse Over  ${user_navigation_icon_header_menu_item}[${env}]
    Wait Until Element Is Visible    ${user_navigation_fly_out_header_menu_item}[${env}]
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']
        Click    xpath=//li[contains(@class,'user-navigation__item--user')]//nav[contains(@class,'user-navigation__sub-nav')]//ul[contains(@class,'list--secondary')]//a[text()='${user_menu_item}']
    ELSE
        Click    xpath=//a[contains(@class,'user-block') and contains(text(),'${user_menu_item}')]
    END

Yves: move mouse over header menu item:
    [Arguments]    @{header_elements_list}    ${element1}=${EMPTY}     ${element2}=${EMPTY}     ${element3}=${EMPTY}     ${element4}=${EMPTY}     ${element5}=${EMPTY}     ${element6}=${EMPTY}     ${element7}=${EMPTY}     ${element8}=${EMPTY}     ${element9}=${EMPTY}     ${element10}=${EMPTY}     ${element11}=${EMPTY}     ${element12}=${EMPTY}     ${element13}=${EMPTY}     ${element14}=${EMPTY}     ${element15}=${EMPTY}
    ${header_elements_list_count}=   get length  ${header_elements_list}
    FOR    ${index}    IN RANGE    0    ${header_elements_list_count}
        ${header_element_to_check}=    Get From List    ${header_elements_list}    ${index}
        Mouse Over    ${header_element_to_check}
        Sleep    1s
    END

Yves: '${headerItem}' widget is shown
    IF    '${headerItem}' == 'Quote Requests'
        Run Keywords
            Wait Until Element Is Visible    ${agent_quote_requests_widget}
            Page Should Contain Element    ${agent_quote_requests_widget}
    END
