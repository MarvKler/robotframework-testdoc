*** Settings ***
Resource    common_ui.robot
Resource    ../pages/yves/yves_overview_page.robot
Resource    ../pages/yves/yves_profile_page.robot
Resource    ../pages/yves/yves_overview_page.robot
Resource    ../pages/yves/yves_profile_page.robot
Resource    ../pages/yves/yves_catalog_page.robot
Resource    ../pages/yves/yves_product_details_page.robot
Resource    ../pages/yves/yves_company_users_page.robot
Resource    ../pages/yves/yves_shopping_lists_page.robot
Resource    ../pages/yves/yves_shopping_carts_page.robot
Resource    ../pages/yves/yves_shopping_cart_page.robot
Resource    ../pages/yves/yves_shopping_list_page.robot
Resource    ../pages/yves/yves_checkout_success_page.robot
Resource    ../pages/yves/yves_address_page.robot
Resource    ../pages/yves/yves_address_page.robot
Resource    ../pages/yves/yves_order_history_page.robot
Resource    ../pages/yves/yves_returns_page.robot
Resource    ../pages/yves/yves_newsletter_page.robot
Resource    ../pages/yves/yves_returns_page.robot
Resource    ../pages/yves/yves_newsletter_page.robot
Resource    ../pages/yves/yves_order_details_page.robot
Resource    ../pages/yves/yves_customer_account_page.robot
Resource    ../pages/yves/yves_quote_requests_page.robot
Resource    ../pages/yves/yves_quote_request_page.robot
Resource    ../pages/yves/yves_choose_bundle_to_configure_page.robot
Resource    ../pages/yves/yves_create_return_page.robot
Resource    ../pages/yves/yves_return_details_page.robot
Resource    ../pages/yves/yves_checkout_summary_page.robot
Resource    ../pages/yves/yves_checkout_cancel_payment_page.robot
Resource    ../steps/header_steps.robot
Resource    ../steps/checkout_steps.robot

*** Variables ***
${notification_area}    xpath=//section[@data-qa='component notification-area']
${footer_section}=    xpath=//*[@class='footer']

*** Keywords ***
Yves: login on Yves with provided credentials:
    [Arguments]    ${email}    ${password}=${default_password}    ${agent_assist}=${False}
    Set Browser Timeout    ${browser_timeout}
    ${currentURL}=    Get Url
    IF    '/login' not in '${currentURL}'
            Delete All Cookies
            TRY
                LocalStorage Clear
            EXCEPT
                Log    Failed to clear LocalStorage
            END
            IF    'agent' in '${currentURL}' or ${agent_assist}
                Yves: go to URL:    /agent/login
            ELSE
                Yves: go to URL:    /login
            END
    END
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    page is not fully loaded
    END
    Disable Automatic Screenshots on Failure
    ${is_login_page}=    Run Keyword And Ignore Error    Page Should Contain Element    locator=${email_field}    timeout=400ms
    Restore Automatic Screenshots on Failure
    IF    'FAIL' in $is_login_page
        Delete All Cookies
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        IF    'agent' in '${currentURL}' or ${agent_assist}
            Yves: go to URL:    /agent/login
        ELSE
            Yves: go to URL:    /login
        END
    END
    ${currentURL}=    Get Url
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    page is not fully loaded
    END
    Type Text    ${email_field}    ${email}
    Type Text    ${password_field}    ${password}
    Click    ${form_login_button}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    page is not fully loaded
    END
    # workaround for the issue with deadlocks on concurrent login attempts
    TRY
        IF    'agent' in '${currentURL}'
            Page Should Contain Element    ${customerSearchWidget}    Login Failed!    timeout=1s
        ELSE    
            Page Should Contain Element    ${user_header_logout_button}     Login Failed!    timeout=1s
        END
    EXCEPT
        Reload
        IF    'agent' in '${currentURL}'
            Page Should Contain Element    locator=${customerSearchWidget}    message=Yves: Login Failed    timeout=5s
        ELSE    
            Page Should Contain Element    locator=${user_header_logout_button}     message=Yves: Login Failed    timeout=5s
        END
    END
    Yves: remove flash messages

Yves: login on Yves with provided credentials and expect error:
    [Arguments]    ${email}    ${password}=${default_password}
    Set Browser Timeout    ${browser_timeout}
    ${currentURL}=    Get Url
    IF    '/login' not in '${currentURL}'
            Delete All Cookies
            Reload
            Yves: go to URL:    /login
    END
    Disable Automatic Screenshots on Failure
    ${is_login_page}=    Run Keyword And Ignore Error    Page Should Contain Element    locator=${email_field}    message=Login page is not displayed    timeout=400ms
    Restore Automatic Screenshots on Failure
    IF    'FAIL' in $is_login_page
        Delete All Cookies
        Yves: go to the 'Home' page
        Yves: go to URL:    /login
    END
    Type Text    ${email_field}    ${email}
    Type Text    ${password_field}    ${password}
    Click    ${form_login_button}

    Page Should Not Contain Element    ${user_header_logout_button}    message=Yves: logged in successfully but should not be

    Yves: flash message should be shown:    error    Please check that your E-mail address and password are correct and that you have confirmed your E-mail address by clicking the link in the registration message
    Yves: remove flash messages

Yves: go to PDP of the product with sku:
    [Arguments]    ${sku}    ${wait_for_p&s}=${False}    ${iterations}=26    ${delay}=5s
    Yves: go to URL:    /search?q=${sku}
    ### *** promise for P&S *** ####
    ${wait_for_p&s}=    Convert To String    ${wait_for_p&s}
    ${wait_for_p&s}=    Convert To Lower Case    ${wait_for_p&s}
    IF    '${wait_for_p&s}' == 'true'
        ${wait_for_p&s}=    Set Variable    ${True}
    END
    IF    '${wait_for_p&s}' == 'false'
        ${wait_for_p&s}=    Set Variable    ${False}
    END
    IF    ${wait_for_p&s}
        FOR    ${index}    IN RANGE    1    ${iterations}
        Disable Automatic Screenshots on Failure
        ${result}=    Run Keyword And Ignore Error    Page Should Contain Element    ${catalog_product_card_locator}    timeout=1s
        Restore Automatic Screenshots on Failure
            IF    ${index} == ${iterations}-1
                Take Screenshot    EMBED    fullPage=True
                Fail    Product '${sku}' is not displayed in the search results or its PDP is not accessible
            END
            IF    ${index} == 5 or ${index} == 10 or ${index} == 15
                Trigger multistore p&s
            END
            IF    'FAIL' in ${result}   
                Sleep    ${delay}
                Yves: go to URL:    /search?q=${sku}
                Continue For Loop
            ELSE
                ${pdp_url}=    Get Element Attribute    ${catalog_product_card_locator}    href
                ${currentURL}=    Get Location
                ${has_at_cur}=    Run Keyword And Return Status    Should Match Regexp    ${currentURL}    (?i)(?:\\.at\\.|/at/)
                ${has_at_pdp}=    Run Keyword And Return Status    Should Match Regexp    ${pdp_url}       (?i)(?:\\.at\\.|/at/)

                # Remove `.at.` in host and `/at/` path segment (case-insensitive)
                IF    ${has_at_cur} or ${has_at_pdp}
                    TRY
                        ${pdp_url}=    Replace String Using Regexp    ${pdp_url}    (?i)/at/        /
                    EXCEPT
                        Log    No /at/ in URL
                    END
                END
                
                Yves: go to URL:    ${pdp_url}?fake=${random}+${index}
                TRY
                    Repeat Keyword    3    Wait For Load State
                    Repeat Keyword    3    Wait For Load State    domcontentloaded
                EXCEPT
                    Log    Page is not loaded
                END
                Disable Automatic Screenshots on Failure
                ${pdp_available}=    Run Keyword And Ignore Error    Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]    timeout=0.5s
                Restore Automatic Screenshots on Failure
                IF    'PASS' in $pdp_available
                    Exit For Loop
                ELSE
                    Sleep    ${delay}
                    Yves: go to URL:    /search?q=${sku}
                    Continue For Loop
                END
            END
        END
    ELSE
        TRY
            Wait Until Page Contains Element    ${catalog_main_page_locator}[${env}]
            Wait Until Page Contains Element    ${catalog_product_card_locator}
            Click    ${catalog_product_card_locator}
            Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]
            TRY
                Repeat Keyword    3    Wait For Load State
            EXCEPT
                Log    Page is not loaded
            END
        EXCEPT    
            Repeat Keyword    3    Trigger multistore p&s
            Yves: go to URL:    /search?q=${sku}
            Reload
            TRY
                Repeat Keyword    3    Wait For Load State
                Wait For Load State    domcontentloaded
            EXCEPT
                Log    Page is not loaded
            END
            Wait Until Page Contains Element    ${catalog_main_page_locator}[${env}]
            Wait Until Page Contains Element    ${catalog_product_card_locator}
            ${pdp_url}=    Get Element Attribute    ${catalog_product_card_locator}    href
            ${currentURL}=    Get Location

            ${has_at_cur}=    Run Keyword And Return Status    Should Match Regexp    ${currentURL}    (?i)(?:\\.at\\.|/at/)
            ${has_at_pdp}=    Run Keyword And Return Status    Should Match Regexp    ${pdp_url}       (?i)(?:\\.at\\.|/at/)

            IF    ${has_at_cur} or ${has_at_pdp}
                TRY
                    ${pdp_url}=    Replace String Using Regexp    ${pdp_url}    (?i)/at/      /
                EXCEPT
                    Log    No /at/ in URL
                END
            END
            Yves: go to URL:    ${pdp_url}?fake=${random}+${random}
            TRY
                Repeat Keyword    3    Wait For Load State
            EXCEPT
                Log    Page is not loaded
            END
            Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]
        END
    END
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END

Yves: '${pageName}' page is displayed
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    IF    '${pageName}' == 'Company Users'    Page Should Contain Element    ${company_users_main_content_locator}    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Login'    Page Should Contain Element    ${login_main_content_locator}    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Overview'    Page Should Contain Element    ${overview_main_content_locator}[${env}]    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Profile'    Page Should Contain Element    ${profile_main_content_locator}[${env}]    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Shopping Lists'    Page Should Contain Element    ${shopping_lists_page_form_locator}    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Shopping List'    Page Should Contain Element    ${shopping_list_main_content_locator}    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Shopping Cart'    Page Should Contain Element    ${shopping_cart_main_content_locator}[${env}]    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Shopping Carts'    Page Should Contain Element    ${shopping_carts_main_content_locator}    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Quick Order'    Page Should Contain Element    ${quick_order_main_content_locator}    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Thank you'    Page Should Contain Element    ${success_page_main_container_locator}[${env}]    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Addresses'    Page Should Contain Element    ${address_main_content_locator}[${env}]    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Order History'    Page Should Contain Element    ${order_history_main_content_locator}    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Returns'    Page Should Contain Element    ${returns_main_content_locator}[${env}]    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Newsletter'    Page Should Contain Element    ${newsletter_main_content_locator}[${env}]    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Order Details'    Page Should Contain Element    ${order_details_main_content_locator}    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Select Business Unit'    Page Should Contain Element    ${customer_account_business_unit_selector}    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Summary'    Page Should Contain Element    ${checkout_summary_main_content_locator}    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Quote Requests'    Page Should Contain Element    ${quote_requests_main_content_locator}    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Quote Request Details'    Page Should Contain Element    ${quote_request_main_content_locator}    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Choose Bundle to configure'    Page Should Contain Element    ${choose_bundle_main_content_locator}    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Create Return'    Page Should Contain Element    ${create_return_main_content_locator}    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Return Details'    Page Should Contain Element    ${return_details_main_content_locator}    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Payment cancellation'    Page Should Contain Element    ${cancel_payment_page_main_container_locator}    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Merchant Profile'    Page Should Contain Element    ${merchant_profile_main_content_locator}    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE IF    '${pageName}' == 'Wishlist'    Page Should Contain Element    ${wishlist_main_content_locator}[${env}]    ${pageName} page is not displayed    ${browser_timeout}
    ...    ELSE        Fail    '${pageName}' page is not displayed or the page name is incorrect

Yves: remove flash messages
    TRY
        ${flash_massage_state}=    Page Should Contain Element    ${notification_area}    message=Flash message is not shown    timeout=500ms
        Remove element from HTML with JavaScript    //section[@data-qa='component notification-area']
    EXCEPT    
        Log    Flash message is not shown
    END

Yves: flash message '${condition}' be shown
    IF    '${condition}' == 'should'
        Wait Until Element Is Visible    ${notification_area}
    ELSE
        Page Should Not Contain Element    ${notification_area}
    END

Yves: flash message should be shown:
    [Documentation]    ${type} can be: error, success
    [Arguments]    ${type}    ${text}    ${timeout}=${browser_timeout}
    IF    '${type}' == 'error'
        Element Should Be Visible    locator=xpath=//flash-message[contains(@class,'alert')]//div[contains(text(),'${text}')]    timeout=${timeout}
    ELSE
        IF  '${type}' == 'success'  Element Should Be Visible    locator=xpath=//flash-message[contains(@class,'success')]//div[contains(text(),'${text}')]    timeout=${timeout}
    END

Yves: logout on Yves as a customer
    Delete All Cookies
    Reload

Yves: go to the 'Home' page
    Set Browser Timeout    ${browser_timeout}
    ${currentURL}=    Get Location
    IF    '.at.' in '${currentURL}'
        Go To    ${yves_at_url}
    ELSE
        Go To    ${yves_url}
    END

Yves: go to AT store 'Home' page if other store not specified:
    [Arguments]    ${store}=AT
    Set Browser Timeout    ${browser_timeout}
    ${dms_state}=    Convert To String    ${dms}
    IF    '${dms_state}' != 'True'
        Go To    ${yves_at_url}
    ELSE
        Go To    ${yves_url}
        Wait Until Element Is Visible    ${store_switcher_header_menu_item}
        Select From List By Label Contains    ${store_switcher_header_menu_item}    ${store}
        Wait Until Element Contains    ${store_switcher_selected_option}    ${store}
        ${logoURL}=    Get Element Attribute    ${header_logo_link}    href
        Yves: go to URL:    ${logoURL}
    END

Yves: wait until store switcher contains:
    [Arguments]    ${store}    ${tries}=30    ${timeout}=3s    ${message}='Timeout exceeded while waiting for '${store}' store in the store switcher. Check P&S'
    Go To    ${yves_url}
    Wait Until Element Is Visible    ${store_switcher_header_menu_item}
    FOR    ${index}    IN RANGE    0    ${tries}
        Disable Automatic Screenshots on Failure
        ${storeAppears}=    Run Keyword And Return Status    Wait Until Element Contains    locator=${store_switcher_header_menu_item}    text=${store}    timeout=${timeout}
        Restore Automatic Screenshots on Failure
        IF    '${storeAppears}'=='False'
            Run Keywords    Sleep    ${timeout}    AND    Reload
        ELSE
            Exit For Loop
        END
    END
    IF    '${storeAppears}'=='False'
        Take Screenshot    EMBED    fullPage=True
        Fail    ${message}
    END

Yves: select currency Euro if other currency not specified
    [Arguments]    ${currency_name}=Euro    ${currency_code}=EUR
    Set Browser Timeout    ${browser_timeout}
    ${dms_state}=    Convert To String    ${dms}
    IF    '${dms_state}' != 'True'
        Go To    ${yves_at_url}
    ELSE
        Go To    ${yves_url}
        Wait Until Element Is visible    ${currency_switcher_header_menu_item}[${env}]
        Select From List By Value    ${currency_switcher_header_menu_item}[${env}]    ${currency_code}
        IF    '${env}' in ['ui_suite']  
            Wait Until Element Contains    //*[@data-qa='component header']//select[contains(@name,'currency')]/option[@selected='']    ${currency_name}  
        ELSE
            Wait Until Element Contains    //*[@data-qa='component header']//select[contains(@name,'currency')]/option[@selected='']    ${currency_code}  
        END
    END

Yves: get the last placed order ID by current customer
    [Documentation]    Returns orderID of the last order from customer account
    Set Browser Timeout    ${browser_timeout}
    Yves: go to URL:    /customer/order
    ${lastPlacedOrder}=    Get Text    xpath=//div[contains(@data-qa,'component order-table')]//tr[1]//td[1]
    Set Suite Variable    ${lastPlacedOrder}    ${lastPlacedOrder}
    RETURN    ${lastPlacedOrder}

Yves: go to URL:
    [Arguments]    ${url}    ${expected_response_code}=${EMPTY}
    ${url}=    Get URL Without Starting Slash    ${url}
    Set Browser Timeout    ${browser_timeout}
    ${currentURL}=    Get Location
    IF    '.at.' in '${currentURL}' or '/at/' in '${currentURL}' or '/AT/' in '${currentURL}'
        ${response_code}=    Go To    ${yves_at_url}${url}
    ELSE
        ${response_code}=    Go To    ${yves_url}${url}
    END    
    ${response_code}=    Convert To Integer    ${response_code}
    ${is_5xx}=    Evaluate    500 <= ${response_code} < 600
    ${page_title}=    Get Title
    ${page_title}=    Convert To Lower Case    ${page_title}
    ${no_exception}=    Run Keyword And Return Status    Should Not Contain    ${page_title}    error
    IF    ${is_5xx} or not ${no_exception}
        TRY
            LocalStorage Clear
        EXCEPT
            Log    Failed to clear LocalStorage
        END
        IF    '.at.' in '${currentURL}' or '/at/' in '${currentURL}' or '/AT/' in '${currentURL}'
            ${response_code}=    Go To    ${yves_at_url}${url}
        ELSE
            ${response_code}=    Go To    ${yves_url}${url}
        END
        ${response_code}=    Convert To Integer    ${response_code}
        ${is_5xx}=    Evaluate    500 <= ${response_code} < 600
        IF    ${is_5xx}
            IF    '.at.' in '${currentURL}' or '/at/' in '${currentURL}' or '/AT/' in '${currentURL}'
                Fail    '${response_code}' error occurred on Go to: ${yves_at_url}${url}
            ELSE
                Fail    '${response_code}' error occurred on Go to: ${yves_url}${url}
            END
        END
        ${page_title}=    Get Title
        ${page_title}=    Convert To Lower Case    ${page_title}
        Should Not Contain    ${page_title}    error    msg='${response_code}' error occurred on Go to: ${yves_url}${url}
    END
    IF    '${expected_response_code}' != '${EMPTY}'
        ${expected_response_code}=    Convert To Integer    ${expected_response_code}
        Should Be Equal    ${response_code}    ${expected_response_code}    msg=Expected response code (${expected_response_code}) is not equal to the actual response code (${response_code}) on Go to: ${url}
    END
    RETURN    ${response_code}

Yves: go to AT store URL if other store not specified:
    [Arguments]    ${url}    ${store}=AT
    Set Browser Timeout    ${browser_timeout}
    ${url}=    Get URL Without Starting Slash    ${url}
    ${dms_state}=    Convert To String    ${dms}
    IF   '${dms_state}' != 'True'
        Go To    ${yves_at_url}${url}
    ELSE
    Go To    ${yves_url}
        Wait Until Element Is Visible    ${store_switcher_header_menu_item}
        Select From List By Label Contains    ${store_switcher_header_menu_item}    ${store}
        Wait Until Element Contains    ${store_switcher_selected_option}    ${store}
    Go To    ${yves_url}${url}
    END

Yves: go to newly created page by URL:
    [Arguments]    ${url}    ${delay}=5s    ${iterations}=31
    FOR    ${index}    IN RANGE    1    ${iterations}
        Go To    ${yves_url}${url}?${index}
        Disable Automatic Screenshots on Failure
        ${page_not_published}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//main//*[contains(text(),'ERROR 404')]
        Restore Automatic Screenshots on Failure
        IF    '${page_not_published}'=='True'
            Sleep    ${delay}
        ELSE
            Exit For Loop
        END
        IF    ${index} == ${iterations}-1
            Take Screenshot    EMBED    fullPage=True
            Fail    Newly created URL is not accessible (404 error), check P&S
        END
    END

Yves: go to newly created page by URL on AT store if other store not specified:
    [Arguments]    ${url}    ${delay}=5s    ${iterations}=31    ${store}=AT
    ${dms_state}=    Convert To String    ${dms}
    Set Browser Timeout    ${browser_timeout}    
    FOR    ${index}    IN RANGE    1    ${iterations}
        IF   '${dms_state}' != 'True'
            Go To    ${yves_at_url}${url}?${index}
        ELSE
            Go To    ${yves_url}
            Wait Until Element Is Visible    ${store_switcher_header_menu_item}
            Select From List By Label Contains    ${store_switcher_header_menu_item}    ${store}
            Wait Until Element Contains    ${store_switcher_selected_option}    ${store}
            ${logoURL}=    Get Element Attribute    ${header_logo_link}    href
            Yves: go to URL:    ${logoURL}
            Go To    ${yves_url}${url}?${index}
        END
        Disable Automatic Screenshots on Failure
        ${page_not_published}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//main//*[contains(text(),'ERROR 404')]
        Restore Automatic Screenshots on Failure
        IF    '${page_not_published}'=='True'
            Sleep    ${delay}
        ELSE
            Exit For Loop
        END
        IF    ${index} == ${iterations}-1
            Take Screenshot    EMBED    fullPage=True
            Fail    Newly created CMS page is not accessible (404 error), check P&S
        END
    END

Yves: navigate to specified AT store URL if no other store is specified and refresh until 404 occurs:
    [Arguments]    ${url}    ${delay}=5s    ${iterations}=31    ${store}=AT
    ${dms_state}=    Convert To String    ${dms}
    Set Browser Timeout    ${browser_timeout}
    FOR    ${index}    IN RANGE    1    ${iterations}
        IF   '${dms_state}' != 'True'
            Go To    ${url}
        ELSE
            Go To    ${yves_url}
            Wait Until Element Is Visible    ${store_switcher_header_menu_item}
            Select From List By Label Contains    ${store_switcher_header_menu_item}    ${store}
            Wait Until Element Contains    ${store_switcher_selected_option}    ${store}
            ${logoURL}=    Get Element Attribute    ${header_logo_link}    href
            Yves: go to URL:    ${logoURL}
            Go To    ${url}
        END
        Disable Automatic Screenshots on Failure
        ${page_not_published}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//main//*[contains(text(),'ERROR 404')]
        Restore Automatic Screenshots on Failure
        IF    '${page_not_published}'=='False'
            Run Keyword    Sleep    ${delay}
        ELSE
            Exit For Loop
        END
        IF    ${index} == ${iterations}-1
            Take Screenshot    EMBED    fullPage=True
            Fail    URL is still accessible but should not, check P&S
        END
    END
    
Yves: go to URL and refresh until 404 occurs:
    [Arguments]    ${url}    ${delay}=5s    ${iterations}=31
    FOR    ${index}    IN RANGE    1    ${iterations}
        Go To    ${url}
        Disable Automatic Screenshots on Failure
        ${page_not_published}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//main//*[contains(text(),'ERROR 404')]
        Restore Automatic Screenshots on Failure
        IF    '${page_not_published}'=='False'
            Run Keyword    Sleep    ${delay}
        ELSE
            Exit For Loop
        END
        IF    ${index} == ${iterations}-1
            Take Screenshot    EMBED    fullPage=True
            Fail    URL is still accessible but should not, check P&S
        END
    END
    
Yves: go to external URL:
    [Arguments]    ${url}
    Set Browser Timeout    ${browser_timeout}
    Go To    ${url}

Yves: go to second navigation item level:
    [Arguments]     ${navigation_item_level1}   ${navigation_item_level2}
    ${nodeClass}=    Get Element Attribute    xpath=//div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li    class
    ${nodeClass}=    Replace String    ${nodeClass}    \n    ${EMPTY}
    ${nodeShownClass}=    Set Variable    is-shown
    ${nodeUpdatedClass}=    Set Variable    ${nodeClass} ${nodeShownClass}
    ${1LevelXpath}=    Set Variable    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li
    Add/Edit element attribute with JavaScript:    ${1LevelXpath}    class    ${nodeUpdatedClass}
    Wait Until Element Is Visible    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'menu--lvl-1')]
    Click Element by xpath with JavaScript    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'menu--lvl-1')]//li[contains(@class,'menu__item--lvl-1')]/span/*[contains(@class,'lvl-1')][1][text()='${navigation_item_level2}']
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

Yves: go to first navigation item level:
    [Arguments]     ${navigation_item_level1}
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']
        Wait Until Element Is Visible    xpath=//div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']
        Click Element by xpath with JavaScript    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']
        TRY
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
    ELSE IF    '${env}' in ['ui_suite']
        Wait Until Element Is Visible    xpath=(//header//nav[contains(@data-qa,'navigation-multilevel')]/ul/li[contains(.,'${navigation_item_level1}')])[1]
        Click    xpath=(//header//nav[contains(@data-qa,'navigation-multilevel')]/ul/li[contains(.,'${navigation_item_level1}')])[1]
        TRY
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
    ELSE
        Wait Until Element Is Visible    xpath=//*[contains(@class,'header') and @data-qa='component header']//*[contains(@data-qa,'navigation-multilevel')]/*[contains(@class,'navigation-multilevel-node__link--lvl-1') and contains(text(),'${navigation_item_level1}')]
        Click Element by xpath with JavaScript    //*[contains(@class,'header') and @data-qa='component header']//*[contains(@data-qa,'navigation-multilevel')]/*[contains(@class,'navigation-multilevel-node__link--lvl-1') and contains(text(),'${navigation_item_level1}')]
        TRY
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
    END

Yves: go to third navigation item level:
    [Arguments]     ${navigation_item_level1}   ${navigation_item_level3}
    ${nodeClass}=    Get Element Attribute    xpath=//div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li    class
    ${nodeClass}=    Replace String    ${nodeClass}    \n    ${EMPTY}
    ${nodeShownClass}=    Set Variable    is-shown
    ${nodeUpdatedClass}=    Set Variable    ${nodeClass} ${nodeShownClass}
    ${1LevelXpath}=    Set Variable    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li
    Add/Edit element attribute with JavaScript:    ${1LevelXpath}    class    ${nodeUpdatedClass}
    Wait Until Element Is Visible    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'menu--lvl-1')]
    Click Element by xpath with JavaScript    //div[@class='header__navigation']//navigation-multilevel[@data-qa='component navigation-multilevel']/ul[@class='menu menu--lvl-0']//li[contains(@class,'menu__item--lvl-0')]/span/*[contains(@class,'lvl-0')][1][text()='${navigation_item_level1}']/ancestor::li//ul[contains(@class,'menu--lvl-2')]//li[contains(@class,'menu__item--lvl-2')]/span/*[contains(@class,'lvl-2')][1][text()='${navigation_item_level3}']
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

Yves: get index of the first available product
    [Documentation]    For B2B this keyword should be used only for logged in customers, otherwise add to cart buttons are absent and it returns wrong index
    Yves: perform search by:    ${EMPTY}
    Wait Until Page Contains Element    ${catalog_main_page_locator}[${env}]
    ${productsCount}=    Get Element Count    xpath=//product-item[@data-qa='component product-item']
    FOR    ${index}    IN RANGE    1    ${productsCount}+1
        Disable Automatic Screenshots on Failure
        ${status}=    IF    '${env}'=='ui_b2b'    Run Keyword And Ignore Error     Page should contain element    xpath=(//product-item[@data-qa='component product-item'])[${index}]//*[@class='product-item__actions']//ajax-add-to-cart//button[@disabled='']    timeout=10ms
        ${status}=    IF    '${env}'=='ui_suite'    Run Keyword And Ignore Error     Page should contain element    xpath=(//product-item[@data-qa='component product-item'])[${index}]//*[@class='product-item__actions']//ajax-add-to-cart//button[@disabled='']    timeout=10ms
        ...    ELSE IF    '${env}' in ['ui_b2c','ui_mp_b2c']    Run Keyword And Ignore Error    Page should contain element    xpath=(//product-item[@data-qa='component product-item'])[${index}]//ajax-add-to-cart//button    Add to cart button is missing    timeout=10ms
        Restore Automatic Screenshots on Failure
        ${pdp_url}=    IF    '${env}' in ['ui_b2b','ui_suite']    Get Element Attribute    xpath=(//product-item[@data-qa='component product-item'])[${index}]//a[@itemprop='url']    href
        IF    'PASS' in $status and '${env}' in ['ui_b2b','ui_suite']    Continue For Loop
        IF    'bundle' in '${pdp_url}' and '${env}' in ['ui_b2b','ui_suite']    Continue For Loop
        IF    'FAIL' in $status and '${env}' in ['ui_b2b','ui_suite']
            Return From Keyword  ${index}
            Log    ${index}
            Exit For Loop
        END
        ${pdp_url}=    IF    '${env}' in ['ui_b2c','ui_mp_b2c']    Get Element Attribute    xpath=(//product-item[@data-qa='component product-item'])[${index}]//div[contains(@class,'product-item__image')]//a[contains(@class,'link-detail-page')]    href
        IF    'FAIL' in $status and '${env}' in ['ui_b2c','ui_mp_b2c']    Continue For Loop
        IF    'bundle' in '${pdp_url}' and '${env}' in ['ui_b2c','ui_mp_b2c']    Continue For Loop
        IF    'PASS' in $status and '${env}' in ['ui_b2c','ui_mp_b2c']
            Return From Keyword    ${index}
            Log    ${index}
            Exit For Loop
        END
    END
        ${productIndex}=    Set Variable    ${index}
        Return From Keyword    ${productIndex}

Yves: get index of the first available product on marketplace
    Yves: perform search by:    ${EMPTY}
    Wait Until Page Contains Element    ${catalog_main_page_locator}[${env}]
    ${currentURL}=    Get Location
    ${productsCount}=    Get Element Count    xpath=//product-item[@data-qa='component product-item']
    FOR    ${index}    IN RANGE    1    ${productsCount}+1
        Click    xpath=(//product-item[@data-qa='component product-item'])[${index}]//a[contains(@class,'link-detail-page') and (contains(@class,'info')) or (contains(@class,'name'))]
        TRY
            Wait For Load State
        EXCEPT    
            Log    Page is not loaded
        END
        Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]
        Disable Automatic Screenshots on Failure
        ${status}=    Run Keyword And Ignore Error     Page should contain element    ${pdp_add_to_cart_disabled_button}[${env}]    timeout=10ms
        Restore Automatic Screenshots on Failure
        IF    'PASS' in $status    
            Go to    ${currentURL}
            Continue For Loop
        END
        IF    'FAIL' in $status
            Run Keywords
                Return From Keyword  ${index}
                Log    ${index}
                Exit For Loop
        END
    END
        ${productIndex}=    Set Variable    ${index}
        Return From Keyword    ${productIndex}

Yves: go to the PDP of the first available product
    IF    '${env}' in ['ui_mp_b2b','ui_mp_b2c']    
        ${index}=    Yves: get index of the first available product on marketplace
    ELSE    
        ${index}=    Yves: get index of the first available product
        Click    xpath=(//product-item[@data-qa='component product-item'])[${index}]//a[contains(@class,'link-detail-page') and (contains(@class,'info')) or (contains(@class,'name'))]
    END
    Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]

Yves: go to the PDP of the first product on open catalog page
    Click    xpath=(//product-item[@data-qa='component product-item'][1]//a[contains(@class,'link-detail-page') and (contains(@class,'info')) or (contains(@class,'name'))])[1]
    Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]

Yves: go to the PDP of the first available product on current catalog page
    Wait Until Page Contains Element    ${catalog_main_page_locator}[${env}]
    IF    '${env}' in ['ui_mp_b2b','ui_mp_b2c']
        ${productsCount}=    Get Element Count    xpath=//product-item[@data-qa='component product-item']
        ${currentURL}=    Get Location
        FOR    ${index}    IN RANGE    1    ${productsCount}+1
            Click    xpath=(//product-item[@data-qa='component product-item'])[${index}]//a[contains(@class,'link-detail-page') and (contains(@class,'info')) or (contains(@class,'name'))]
            TRY
                Wait For Load State
                Wait For Load State    domcontentloaded
            EXCEPT    
                Log    Page is not loaded
            END
            Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]
            Disable Automatic Screenshots on Failure
            ${status}=    Run Keyword And Ignore Error     Page should contain element    ${pdp_add_to_cart_disabled_button}[${env}]    timeout=10ms
            Restore Automatic Screenshots on Failure
            IF    'PASS' in $status    
                Go to    ${currentURL}
                Continue For Loop
            END
            IF    'FAIL' in $status
                VAR    ${index_of_first_available_product}    ${index}
                BREAK
            END
    END
    ELSE
        ${productsCount}=    Get Element Count    xpath=//product-item[@data-qa='component product-item']
        FOR    ${index}    IN RANGE    1    ${productsCount}+1
            Disable Automatic Screenshots on Failure
            ${status}=    IF    '${env}'=='ui_b2b'    Run Keyword And Ignore Error     Page should contain element    xpath=(//product-item[@data-qa='component product-item'])[${index}]//*[@class='product-item__actions']//ajax-add-to-cart//button[@disabled='']    timeout=10ms
            ${status}=    IF    '${env}'=='ui_suite'    Run Keyword And Ignore Error     Page should contain element    xpath=(//product-item[@data-qa='component product-item'])[${index}]//*[@class='product-item__actions']//ajax-add-to-cart//button[@disabled='']    timeout=10ms
            ...    ELSE IF    '${env}' in ['ui_b2c']    Run Keyword And Ignore Error    Page should contain element    xpath=(//product-item[@data-qa='component product-item'])[${index}]//ajax-add-to-cart//button    Add to cart button is missing    timeout=10ms
            ${pdp_url}=    IF    '${env}' in ['ui_b2b','ui_suite']    Get Element Attribute    xpath=(//product-item[@data-qa='component product-item'])[${index}]//a[@itemprop='url']    href
            IF    'PASS' in $status and '${env}' in ['ui_b2b','ui_suite']    Continue For Loop
            IF    'bundle' in '${pdp_url}' and '${env}' in ['ui_b2b','ui_suite']    Continue For Loop
            IF    'FAIL' in $status and '${env}' in ['ui_b2b','ui_suite']
                VAR    ${index_of_first_available_product}    ${index}
                BREAK
            END
            ${pdp_url}=    IF    '${env}' in ['ui_b2c']    Get Element Attribute    xpath=(//product-item[@data-qa='component product-item'])[${index}]//div[contains(@class,'product-item__image')]//a[contains(@class,'link-detail-page')]    href
            IF    'FAIL' in $status and '${env}' in ['ui_b2c']    Continue For Loop
            IF    'bundle' in '${pdp_url}' and '${env}' in ['ui_b2c']    Continue For Loop
            IF    'PASS' in $status and '${env}' in ['ui_b2c']
                VAR    ${index_of_first_available_product}    ${index}
                BREAK
            END
        END
        Restore Automatic Screenshots on Failure
        Click    xpath=(//product-item[@data-qa='component product-item'])[${index_of_first_available_product}]//a[contains(@class,'link-detail-page') and (contains(@class,'info')) or (contains(@class,'name'))]
        Wait Until Page Contains Element    ${pdp_main_container_locator}[${env}]
    END
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END

Yves: check if cart is not empty and clear it
    Yves: go to the 'Home' page
    Yves: go to shopping cart page
    ${productsInCart}=    Get Element Count    xpath=//main//form[contains(@name,'removeFromCartForm')]//button | //main//form[contains(@action,'bundle/async/remove')]//button
    IF    ${productsInCart} > 0    Helper: delete all items in cart

Helper: delete all items in cart
    ${productsInCart}=    Get Element Count    xpath=//main//form[contains(@name,'removeFromCartForm')]//button | //main//form[contains(@action,'bundle/async/remove')]//button
    IF    ${productsInCart} == 0    Log    Shopping cart is empty
    FOR    ${index}    IN RANGE    0    ${productsInCart}
        Click    xpath=(//main//form[contains(@name,'removeFromCartForm')]//button | //main//form[contains(@action,'bundle/async/remove')]//button)[1]
        Yves: remove flash messages     
        TRY
            Repeat Keyword    3    Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Page is not loaded
        END
    END

Yves: try reloading page if element is/not appear:
    [Arguments]    ${element}    ${isDisplayed}    ${iterations}=26    ${sleep}=5s    ${message}=expected element state is not reached after ${iterations} iterations. Locator: ${element}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    page is not fully loaded
    END
    ${isDisplayed}=    Convert To Lower Case    ${isDisplayed}
    FOR    ${index}    IN RANGE    1    ${iterations}
        Disable Automatic Screenshots on Failure
        ${elementAppears}=    Run Keyword And Return Status    Element Should Be Visible    ${element}
        Restore Automatic Screenshots on Failure
        IF    '${isDisplayed}'=='true' and '${elementAppears}'=='False'
            Sleep    ${sleep}
            Reload
            TRY
                Wait For Load State
                Wait For Load State    domcontentloaded
            EXCEPT
                Log    page is not fully loaded
            END
        ELSE IF    '${isDisplayed}'=='false' and '${elementAppears}'=='True'
            Sleep    ${sleep}
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
        
        IF    ${index} == ${iterations}-1
            Take Screenshot    EMBED    fullPage=True
            Fail    ${message}
        END
    END

Yves: get current lang
    ${lang}=    get attribute    xpath=//html    lang
    return from keyword   ${lang}

Yves: page should contain script with attribute:
    [Arguments]    ${attribute}    ${value}
    Try reloading page until element is/not appear:    xpath=//head//script[@${attribute}='${value}']    true
    Page Should Contain Element    xpath=//head//script[@${attribute}='${value}']

Yves: page should contain script with id:
    [Arguments]    ${scriptId}
    Yves: page should contain script with attribute:    id    ${scriptId}

Yves: validate the page title:
    [Arguments]    ${title}
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']
        Yves: try reloading page if element is/not appear:    element=xpath=//h3[contains(text(),'${title}')]     isDisplayed=True    message=Updated Glossary value was not applied, check P&S
    ELSE
        Yves: try reloading page if element is/not appear:    element=xpath=//h1[contains(@class,'title')][contains(text(),'${title}')]     isDisplayed=True    message=Updated Glossary value was not applied, check P&S
    END
    
Yves: login after signup during checkout:
    [Arguments]    ${email}    ${password}
    Type Text    ${email_field}     ${email}
    Type Text    ${password_field}     ${password}
    Click    ${form_login_button}
    Page Should Not Contain Element    locator=${form_login_button}    timeout=10s

Yves: checkout is blocked with the following message:
    [Arguments]    ${expectedMessage}
    ${currentURL}=    Get Url
    IF    '/cart' in '${currentURL}'
        ${checkout_button_state}=    Get Element Attribute    ${shopping_cart_checkout_button}    class
        Should Contain    ${checkout_button_state}    disabled
        Get Text    ${shopping_cart_checkout_error_message_locator}    contains    ${expectedMessage}
    ELSE
        TRY
            Element Should Be Visible    ${checkout_summary_alert_message}[${env}]
            Page Should Not Contain Element    ${checkout_summary_submit_order_button}
            ${actualAlertMessage}=    Get Text    ${checkout_summary_alert_message}[${env}]
            Should Be Equal    ${actualAlertMessage}    ${expectedMessage}
        EXCEPT    
            Yves: accept the terms and conditions:    true
            Click    ${checkout_summary_submit_order_button}
            Yves: flash message should be shown:    error    ${expectedMessage}
        END
    END