*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_yves.robot
Resource    ../steps/header_steps.robot
Resource    ../steps/quick_order_steps.robot
Resource    ../pages/yves/yves_customer_account_page.robot
Resource    ../common/common_zed.robot
Resource    ../pages/zed/zed_customer_page.robot

*** Keywords ***
Yves: go to 'Customer Account' page
    ${lang}=    Yves: get current lang
    Yves: go to URL:    ${lang}/customer/overview

Yves: go to user menu item in the left bar:
    [Documentation]    Case sensitive, accepts: Overview, Profile, Addresses, Order History, Newsletter, Shopping lists, Shopping carts, Quote Requests
    [Arguments]    ${left_navigation_node}
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']
        Run Keywords
            Wait Until Element Is Visible    xpath=//ul[@class='navigation-sidebar__list']//*[contains(.,'${left_navigation_node}')]/a
            Click    xpath=//ul[@class='navigation-sidebar__list']//*[contains(.,'${left_navigation_node}')]/a
    ELSE IF    '${env}'=='ui_suite'
        Run Keywords
            Wait Until Element Is Visible    xpath=//nav[contains(@class,'customer-navigation')]//a[contains(text(),'${left_navigation_node}')]
            Click    xpath=//nav[contains(@class,'customer-navigation')]//a[contains(text(),'${left_navigation_node}')]
    ELSE
        Run Keywords
            Wait Until Element Is Visible    xpath=//a[contains(@class,'menu__link menu__link--customer-navigation') and contains(text(),'${left_navigation_node}')]
            Click    xpath=//a[contains(@class,'menu__link menu__link--customer-navigation') and contains(text(),'${left_navigation_node}')]
    END

Yves: create a new customer address in profile:
    [Documentation]
    [Arguments]    ${salutation}    ${firstName}    ${lastName}    ${street}    ${houseNumber}    ${postCode}    ${city}    ${country}    ${isDefaultShipping}=True     ${isDefaultBilling}=True       ${company}=    ${phone}=    ${additionalAddress}=
    Yves: remove flash messages
    ${currentURL}=    Get Location
    IF    'customer/address' not in '${currentURL}'    
            IF    '.at.' in '${currentURL}'
                Go To    ${yves_at_url}customer/address
            ELSE
                Go To    ${yves_url}customer/address
            END    
    END
    Wait Until Element Is Visible    ${customer_account_add_new_address_button}[${env}]
    Click    ${customer_account_add_new_address_button}[${env}]
    Wait Until Element Is Visible    ${customer_account_address_form}
    Select From List By Value    ${customer_account_address_salutation_select}    ${salutation}
    Type Text    ${customer_account_address_first_name_field}     ${firstName}
    Type Text    ${customer_account_address_last_name_field}     ${lastName}
    Type Text    ${customer_account_address_company_name_field}     ${company}
    Type Text    ${customer_account_address_street_field}     ${street}
    Type Text    ${customer_account_address_house_number_field}     ${houseNumber}
    Type Text    ${customer_account_address_additional_address_field}     ${additionalAddress}
    Type Text    ${customer_account_address_zip_code_field}     ${postCode}
    Type Text    ${customer_account_address_city_field}     ${city}
    Type Text    ${customer_account_address_phone_field}     ${phone}
    Select From List By Text    ${customer_account_address_country}    ${country}
    Click    ${customer_account_address_submit_button}
    Wait Until Element Is Visible    ${customer_account_add_new_address_button}[${env}]

Yves: create new default customer address in profile
    [Arguments]    ${salutation}=${default_address.salutation}    ${firstName}=${default_address.first_name}    ${lastName}=${default_address.last_name}    ${street}=${default_address.street}    ${houseNumber}=${default_address.house_number}    ${postCode}=${default_address.post_code}    ${city}=${default_address.city}    ${country}=${default_address.country}    ${isDefaultShipping}=True     ${isDefaultBilling}=True       ${company}=${EMPTY}    ${phone}=${EMPTY}    ${additionalAddress}=${EMPTY}
    Yves: remove flash messages
    ${currentURL}=    Get Location
    IF    'customer/address' not in '${currentURL}'    
            IF    '.at.' in '${currentURL}'
                Go To    ${yves_at_url}customer/address
            ELSE
                Go To    ${yves_url}customer/address
            END    
    END
    Wait Until Element Is Visible    ${customer_account_add_new_address_button}[${env}]
    Click    ${customer_account_add_new_address_button}[${env}]
    Wait Until Element Is Visible    ${customer_account_address_form}
    Select From List By Value    ${customer_account_address_salutation_select}    ${salutation}
    Type Text    ${customer_account_address_first_name_field}     ${firstName}
    Type Text    ${customer_account_address_last_name_field}     ${lastName}
    Type Text    ${customer_account_address_company_name_field}     ${company}
    Type Text    ${customer_account_address_street_field}     ${street}
    Type Text    ${customer_account_address_house_number_field}     ${houseNumber}
    Type Text    ${customer_account_address_additional_address_field}     ${additionalAddress}
    Type Text    ${customer_account_address_zip_code_field}     ${postCode}
    Type Text    ${customer_account_address_city_field}     ${city}
    Type Text    ${customer_account_address_phone_field}     ${phone}
    Select From List By Text    ${customer_account_address_country}    ${country}
    Click    ${customer_account_address_submit_button}
    Wait Until Element Is Visible    ${customer_account_add_new_address_button}[${env}]

Yves: check that user has address exists/doesn't exist:
    Yves: remove flash messages
    [Arguments]    ${exists}    ${firstName}    ${lastName}    ${street}    ${houseNumber}    ${postCode}    ${city}    ${country}    ${isDefaultShipping}=True     ${isDefaultBilling}=True       ${company}=NUll    ${phone}=NUll    ${additionalAddress}=NUll
    ${exists}=    Convert To Lower Case    ${exists}
    ${currentURL}=    Get Location
    IF    'customer/address' not in '${currentURL}'    
            IF    '.at.' in '${currentURL}'
                Go To    ${yves_at_url}customer/address
            ELSE
                Go To    ${yves_url}customer/address
            END    
    END
    Wait Until Element Is Visible    ${customer_account_add_new_address_button}[${env}]
    IF    '${exists}'=='true'
        Run keywords
            Element Should Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${firstName} ${lastName}')]
            Element Should Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${street} ${houseNumber}')]
            Element Should Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${postCode} ${city}, ${country}')]
    ELSE
        Run keywords
            Element Should Not Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${firstName} ${lastName}')]
            Element Should Not Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${street} ${houseNumber}')]
            Element Should Not Be Visible    xpath=//ul[contains(@class,'display-address')]//*[contains(text(),'${postCode} ${city}, ${country}')]
    END

Yves: delete user address:
    [Arguments]    ${street}
    Yves: remove flash messages
    IF    '${env}' in ['ui_b2c','ui_mp_b2c']
        Yves: go to user menu:    My Profile
    ELSE IF    '${env}' in ['ui_b2b','ui_mp_b2b']
        Yves: go to user menu:    Profile
    END
    Yves: go to user menu item in the left bar:    Addresses
    IF    '${env}' in ['ui_b2c','ui_mp_b2c']
        Click    xpath=//li[contains(text(),'${street}')]/ancestor::div/div[@data-qa='component title-box']//form[contains(@action,'address/delete')]//button
        Page Should Not Contain Element    xpath=//li[contains(text(),'${street}')]/ancestor::div/div[@data-qa='component title-box']//form[contains(@action,'address/delete')]//button
    ELSE IF    '${env}' in ['ui_b2b','ui_mp_b2b']
        Click    xpath=//li[contains(text(),'${street}')]/ancestor::div[@data-qa="component action-card"]//form[contains(@action,'address/delete')]//button
        Page Should Not Contain Element    xpath=//li[contains(text(),'${street}')]/ancestor::div[@data-qa="component action-card"]//form[contains(@action,'address/delete')]//button
    ELSE
        Click    xpath=//li[contains(text(),'${street}')]/ancestor::div[1]//form[contains(@action,'delete')]//button
        Page Should Not Contain Element    xpath=//li[contains(text(),'${street}')]/ancestor::div[1]//form[contains(@action,'delete')]//button
    END

Yves: delete all user addresses
    ${currentURL}=    Get Location
    IF    '/customer/address' not in '${currentURL}'    
            IF    '.at.' in '${currentURL}'
                Go To    ${yves_at_url}customer/address
            ELSE
                Go To    ${yves_url}customer/address
            END    
    END
    ${userAddresses}=    Get Element Count    xpath=//form[contains(@action,'address/delete')]//button
    IF    ${userAddresses} != 0
        FOR    ${index}    IN RANGE    0    ${userAddresses}
            IF    '${env}' in ['ui_b2c','ui_mp_b2c']
                Click    xpath=//main//div[contains(@class,'col--md')]/div[contains(@class,'grid')]/div[1]//div[@data-qa='component title-box']//form[contains(@action,'address/delete')]//button
            ELSE IF    '${env}' in ['ui_b2b','ui_mp_b2b']
                Click    xpath=//div[@data-qa='component action-card-grid']/div[1]/div[@data-qa="component action-card"]//form[contains(@action,'address/delete')]//button
            ELSE
                Click    xpath=(//div//form[contains(@action,'delete')]//button)[1]
            END
        END   
    END
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END

Yves: assert customer profile data:
    [Arguments]    @{args}
    Wait Until Element Is Visible    ${customer_account_profile_first_name_field}
    ${profileData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{profileData}
        IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Get Text    ${customer_account_profile_salutation_span}[${env}]    contains    ${value}
        IF    '${key}'=='first name' and '${value}' != '${EMPTY}'    Get Text    ${customer_account_profile_first_name_field}    contains    ${value}
        IF    '${key}'=='last name' and '${value}' != '${EMPTY}'    Get Text    ${customer_account_profile_last_name_field}    contains    ${value}
        IF    '${key}'=='email' and '${value}' != '${EMPTY}'    Get Text    ${customer_account_profile_email_field}    contains    ${value}
    END

Yves: update customer profile data:
    [Arguments]    @{args}
    Wait Until Element Is Visible    ${customer_account_profile_first_name_field}
    ${profileData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{profileData}
        IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'  
                IF    '${env}' in ['ui_suite']
                    Select From List By Label    ${customer_account_profile_salutation_selector}    ${value}
                ELSE
                    Click    ${customer_account_profile_salutation_span}[${env}]
                    Click    xpath=//li[contains(@id,'select2-profileForm_salutation-result')][contains(text(),'${value}')]
                END        
        END
        IF    '${key}'=='first name' and '${value}' != '${EMPTY}'    Type Text    ${customer_account_profile_first_name_field}    ${value}
        IF    '${key}'=='last name' and '${value}' != '${EMPTY}'    Type Text    ${customer_account_profile_last_name_field}    ${value}
        IF    '${key}'=='email' and '${value}' != '${EMPTY}'    Type Text    ${customer_account_profile_email_field}    ${value}
    END
    Click    ${customer_account_profile_submit_profile_button}

Zed: assert customer profile data:
    [Arguments]    @{args}
    ${profileData}=    Set Up Keyword Arguments    @{args}
    Zed: go to URL:    /customer
    Zed: click Action Button in a table for row that contains:    ${email}    Edit
    Wait Until Element Is Visible    ${zed_customer_edit_salutation_select}
    FOR    ${key}    ${value}    IN    &{profileData}
        IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Get Text    xpath=//select[@id='customer_salutation']//option[@selected]    contains    ${value}
        IF    '${key}'=='first name' and '${value}' != '${EMPTY}'    Get Text    ${zed_customer_edit_first_name_field}    contains    ${value}
        IF    '${key}'=='last name' and '${value}' != '${EMPTY}'    Get Text    ${zed_customer_edit_last_name_field}    contains    ${value}
    END
    Zed: submit the form

Zed: update customer profile data:
    [Arguments]    @{args}
    ${profileData}=    Set Up Keyword Arguments    @{args}
    Zed: go to URL:    /customer
    Zed: click Action Button in a table for row that contains:    ${email}    Edit
    Wait Until Element Is Visible    ${zed_customer_edit_salutation_select}
    FOR    ${key}    ${value}    IN    &{profileData}
        IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    ${zed_customer_edit_salutation_select}    ${value}
        IF    '${key}'=='first name' and '${value}' != '${EMPTY}'    Type Text    ${zed_customer_edit_first_name_field}    ${value}
        IF    '${key}'=='last name' and '${value}' != '${EMPTY}'    Type Text    ${zed_customer_edit_last_name_field}    ${value}
    END
    Zed: submit the form

Zed: create a new customer address in profile:
    [Arguments]    @{args}
    ${profileData}=    Set Up Keyword Arguments    @{args}
    Zed: go to URL:    /customer
    Zed: click Action Button in a table for row that contains:    ${email}    View
    Zed: click button in Header:    Add new Address
    Wait Until Element Is Visible    ${zed_customer_edit_address_salutation_select}
    FOR    ${key}    ${value}    IN    &{profileData}
        IF    '${key}'=='salutation' and '${value}' != '${EMPTY}'    Select From List By Label    ${zed_customer_edit_address_salutation_select}    ${value}
        IF    '${key}'=='first name' and '${value}' != '${EMPTY}'    Type Text    ${zed_customer_edit_address_first_name_field}    ${value}
        IF    '${key}'=='last name' and '${value}' != '${EMPTY}'    Type Text    ${zed_customer_edit_address_last_name_field}    ${value}
        IF    '${key}'=='address 1' and '${value}' != '${EMPTY}'    Type Text    ${zed_customer_edit_address_address_1_field}    ${value}
        IF    '${key}'=='address 2' and '${value}' != '${EMPTY}'    Type Text    ${zed_customer_edit_address_address_2_field}    ${value}
        IF    '${key}'=='address 3' and '${value}' != '${EMPTY}'    Type Text    ${zed_customer_edit_address_address_3_field}    ${value}
        IF    '${key}'=='city' and '${value}' != '${EMPTY}'    Type Text    ${zed_customer_edit_address_city_field}    ${value}
        IF    '${key}'=='zip code' and '${value}' != '${EMPTY}'    Type Text    ${zed_customer_edit_address_zip_code_field}    ${value}
        IF    '${key}'=='country' and '${value}' != '${EMPTY}'    Select From List By Label    ${zed_customer_edit_address_country_select}    ${value}
        IF    '${key}'=='phone' and '${value}' != '${EMPTY}'    Type Text    ${zed_customer_edit_address_phone_field}    ${value}
        IF    '${key}'=='company' and '${value}' != '${EMPTY}'    Type Text    ${zed_customer_edit_address_company_field}    ${value}
    END
    Click    ${zed_customer_edit_address_submit_button}
    ${error_flash_message}=    Run Keyword And Ignore Error    Page Should Not Contain Element    ${zed_error_flash_message}    400ms
    IF    'FAIL' in $error_flash_message
        Click    ${zed_customer_edit_address_submit_button}
    END
    ${error_message}=    Run Keyword And Ignore Error    Page Should Not Contain Element    ${zed_error_message}    400ms
    IF    'FAIL' in $error_message
        Click    ${zed_customer_edit_address_submit_button}
    END
    Wait Until Element Is Not Visible    ${zed_customer_edit_address_submit_button}

Yves: go to user menu:
    [Arguments]    ${user_menu_item}
    ${user_menu_item}=    Convert To Lower Case    ${user_menu_item}
    IF    'profile' in '${user_menu_item}'   Yves: go to URL:    /customer/profile
    IF    'sign' in '${user_menu_item}'    Yves: go to URL:    /register
    IF    'login' in '${user_menu_item}'    Yves: go to URL:    /login
    IF    'history' in '${user_menu_item}' or 'order' in '${user_menu_item}'    Yves: go to URL:    /customer/order
    IF    'overview' in '${user_menu_item}'    Yves: go to URL:    /customer/overview
    IF    'quote' in '${user_menu_item}'    Yves: go to URL:    /quote-request
    IF    'address' in '${user_menu_item}'    Yves: go to URL:    /customer/address
    IF    'return' in '${user_menu_item}'    Yves: go to URL:    /return/list
    IF    'newsletter' in '${user_menu_item}'    Yves: go to URL:    /customer/newsletter
    IF    'shopping list' in '${user_menu_item}' or 'shopping-list' in '${user_menu_item}'    Yves: go to URL:    /shopping-list
    IF    'cart' in '${user_menu_item}'    Yves: go to URL:    /multi-cart
    IF    'wishlist' in '${user_menu_item}'    Yves: go to URL:    /wishlist