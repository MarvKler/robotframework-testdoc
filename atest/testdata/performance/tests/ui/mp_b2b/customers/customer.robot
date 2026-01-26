*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_one
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/steps/header_steps.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/common/common_zed.robot
Resource    ../../../../resources/common/common_mp.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/shopping_lists_steps.robot
Resource    ../../../../resources/steps/checkout_steps.robot
Resource    ../../../../resources/steps/order_history_steps.robot
Resource    ../../../../resources/steps/product_set_steps.robot
Resource    ../../../../resources/steps/catalog_steps.robot
Resource    ../../../../resources/steps/agent_assist_steps.robot
Resource    ../../../../resources/steps/company_steps.robot
Resource    ../../../../resources/steps/customer_account_steps.robot
Resource    ../../../../resources/steps/zed_users_steps.robot
Resource    ../../../../resources/steps/products_steps.robot
Resource    ../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../resources/steps/zed_customer_steps.robot
Resource    ../../../../resources/steps/zed_discount_steps.robot
Resource    ../../../../resources/steps/zed_availability_steps.robot
Resource    ../../../../resources/steps/zed_cms_page_steps.robot
Resource    ../../../../resources/steps/merchant_profile_steps.robot
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/steps/mp_profile_steps.robot
Resource    ../../../../resources/steps/mp_orders_steps.robot
Resource    ../../../../resources/steps/mp_offers_steps.robot
Resource    ../../../../resources/steps/mp_products_steps.robot
Resource    ../../../../resources/steps/mp_account_steps.robot
Resource    ../../../../resources/steps/mp_dashboard_steps.robot
Resource    ../../../../resources/steps/zed_root_menus_steps.robot
Resource    ../../../../resources/steps/minimum_order_value_steps.robot
Resource    ../../../../resources/steps/availability_steps.robot
Resource    ../../../../resources/steps/glossary_steps.robot
Resource    ../../../../resources/steps/order_comments_steps.robot
Resource    ../../../../resources/steps/configurable_product_steps.robot
Resource    ../../../../resources/steps/dynamic_entity_steps.robot

*** Test Cases ***
Guest_User_Access_Restrictions
    [Documentation]    Checks that guest users are not able to see: Prices, Availability, Quick Order, "My Account" features
    Yves: header contains/doesn't contain:    false    ${priceModeSwitcher}    ${currencySwitcher}[${env}]     ${quickOrderIcon}    ${accountIcon}    ${shopping_list_icon_header_menu_item}[${env}]    ${shoppingCartIcon}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku} 
    Yves: PDP contains/doesn't contain:     false    ${pdpPriceLocator}    ${addToCartButton}
    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    Yves: header contains/doesn't contain:    true    ${priceModeSwitcher}    ${currencySwitcher}[${env}]    ${quickOrderIcon}    ${accountIcon}    ${shopping_list_icon_header_menu_item}[${env}]    ${shoppingCartIcon}
    Yves: company menu 'should' be available for logged in user
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: PDP contains/doesn't contain:     true    ${pdpPriceLocator}    ${addToCartButton}
    Yves: go to company menu item:    Users
    Yves: 'Company Users' page is displayed

Share_Shopping_Lists
    [Documentation]    Checks that shopping list can be shared
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: go to 'Shopping Lists' page
    Yves: 'Shopping Lists' page is displayed
    Yves: create new 'Shopping List' with name:    shareShoppingList+${random}
    Yves: the following shopping list is shown:    shareShoppingList+${random}    ${yves_company_user_shared_permission_owner_firstname} ${yves_company_user_shared_permission_owner_lastname}    Full access
    Yves: share shopping list with user:    shareShoppingList+${random}    ${yves_company_user_shared_permission_receiver_firstname} ${yves_company_user_shared_permission_receiver_lastname}    Full access
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: add product to the shopping list:    shareShoppingList+${random}
    Yves: select xxx merchant's offer:    Computer Experts
    Yves: add product to the shopping list:    shareShoppingList+${random}
    Create New Context
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_receiver_email}
    Yves: 'Shopping List' widget contains:    shareShoppingList+${random}    Full access
    Yves: create new 'Shopping Cart' with name:    shoppingListToCart+${random}
    Yves: go to 'Shopping Lists' page
    Yves: 'Shopping Lists' page is displayed
    Yves: the following shopping list is shown:    shareShoppingList+${random}    ${yves_company_user_shared_permission_owner_firstname} ${yves_company_user_shared_permission_owner_lastname}    Full access
    Yves: view shopping list with name:    shareShoppingList+${random}
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Computer Experts
    Yves: add all available products from list to cart  
    Yves: 'Shopping Cart' page is displayed
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Computer Experts
    Yves: delete 'Shopping Cart' with name:    shoppingListToCart+${random}
    [Teardown]    Run Keywords    Close Current Context    AND    Yves: delete 'Shopping List' with name:    shareShoppingList+${random}

Share_Shopping_Carts
    [Documentation]    Checks that cart can be shared and used for checkout
    [Setup]    Run Keywords    
    ...    MP: login on MP with provided credentials:    ${merchant_computer_experts_email}
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer395 | 10             | true                  ||
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: go to 'Shopping Carts' page through the header
    Yves: 'Shopping Carts' page is displayed
    Yves: delete all shopping carts
    Yves: create new 'Shopping Cart' with name:    shoppingCartName+${random}
    Yves: 'Shopping Carts' widget contains:    shoppingCartName+${random}    Owner access
    Yves: go to 'Shopping Carts' page through the header
    Yves: 'Shopping Carts' page is displayed
    Yves: the following shopping cart is shown:    shoppingCartName+${random}    Owner access
    Yves: share shopping cart with user:    shoppingCartName+${random}    ${yves_company_user_shared_permission_receiver_lastname} ${yves_company_user_shared_permission_receiver_firstname}    Full access
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: change quantity on PDP:    2
    Yves: add product to the shopping cart
    Yves: select xxx merchant's offer:    Computer Experts
    Yves: add product to the shopping cart
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_receiver_email}
    Yves: 'Shopping Carts' widget contains:    shoppingCartName+${random}    Full access
    Yves: go to 'Shopping Carts' page through the header
    Yves: 'Shopping Carts' page is displayed
    Yves: the following shopping cart is shown:    shoppingCartName+${random}    Full access
    Yves: go to the shopping cart through the header with name:    shoppingCartName+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Computer Experts
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_shared_permission_receiver_address}
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: select the following shipping method for the shipment:    2    Hermes    Same Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: go to the 'Home' page
    Yves: go to user menu:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page is displayed

Business_on_Behalf
    [Documentation]    Check that BoB user has possibility to change the business unit
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Customers    Company Users
    Zed: click Action Button in a table for row that contains:    Donald    Attach to BU
    Zed: attach company user to the following BU with role:    Spryker Systems Zurich (id: 25)    Admin
    Yves: login on Yves with provided credentials:    ${yves_company_user_bob_email}
    Yves: go to URL:    en/company/user/select
    Yves: 'Select Business Unit' page is displayed
    Yves: 'Business Unit' dropdown contains:    Spryker Systems GmbH / Spryker Systems Berlin    Spryker Systems GmbH / Spryker Systems Zurich
    [Teardown]    Zed: delete company user xxx withing xxx company business unit:    Donald    Spryker Systems Zurich

User_Account
    [Documentation]    Checks user account pages work + address management
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    Order History
    Yves: 'Order History' page is displayed
    Yves: go to user menu:    Profile
    Yves: 'Profile' page is displayed
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: go to user menu item in the left bar:    Newsletter
    Yves: 'Newsletter' page is displayed
    Yves: go to user menu item in the left bar:    Returns
    Yves: 'Returns' page is displayed
    Yves: create a new customer address in profile:    Ms    ${yves_user_first_name} ${random}    ${yves_user_last_name} ${random}   Kirncher Str. ${random}    7    ${random}    Berlin    Germany
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    true    ${yves_user_first_name} ${random}    ${yves_user_last_name} ${random}    Kirncher Str. ${random}    7    ${random}    Berlin    Germany
    Yves: delete user address:    Kirncher Str. ${random}
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    false    ${yves_user_first_name} ${random}    ${yves_user_last_name} ${random}    Kirncher Str. ${random}    7    ${random}    Berlin    Germany
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create a new customer address in profile:
    ...    || email              | salutation | first name                  | last name                       | address 1          | address 2           | address 3           | city            | zip code  | country | phone     | company          ||
    ...    || ${yves_user_email} | Ms         | ${yves_user_first_name}${random} | ${yves_user_last_name}${random} | address 1${random} | address 2 ${random} | address 3 ${random} | Berlin${random} | ${random} | Austria | 123456789 | Spryker${random} ||
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to user menu:    Overview
    Yves: go to user menu item in the left bar:    Addresses
    Yves: check that user has address exists/doesn't exist:    true    ${yves_user_first_name}${random}    ${yves_user_last_name}${random}    address 1${random}    address 2 ${random}    ${random}    Berlin${random}    Austria
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND     Yves: delete all user addresses

Update_Customer_Data
    [Documentation]    Checks customer data can be updated from Yves and Zed
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    Profile
    Yves: 'Profile' page is displayed
    Yves: assert customer profile data:
    ...    || salutation | first name                           | last name                           | email                            ||
    ...    || Mr.        | ${yves_company_user_buyer_firstname} | ${yves_company_user_buyer_lastname} | ${yves_company_user_buyer_email} ||
    Yves: update customer profile data:
    ...    || salutation | first name                                  | last name                                  ||
    ...    || Dr.        | updated${yves_company_user_buyer_firstname} | updated${yves_company_user_buyer_lastname} ||
    Yves: assert customer profile data:
    ...    || salutation | first name                                  | last name                                  ||
    ...    || Dr.        | updated${yves_company_user_buyer_firstname} | updated${yves_company_user_buyer_lastname} ||
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: assert customer profile data:
    ...    || email                            | salutation | first name                                  | last name                                  ||
    ...    || ${yves_company_user_buyer_email} | Dr         | updated${yves_company_user_buyer_firstname} | updated${yves_company_user_buyer_lastname} ||
    Zed: update customer profile data:
    ...    || email                            | salutation | first name                           | last name                           ||
    ...    || ${yves_company_user_buyer_email} | Mr         | ${yves_company_user_buyer_firstname} | ${yves_company_user_buyer_lastname} ||
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    Profile
    Yves: 'Profile' page is displayed
    Yves: assert customer profile data:
    ...    || salutation | first name                           | last name                           | email                            ||
    ...    || Mr.        | ${yves_company_user_buyer_firstname} | ${yves_company_user_buyer_lastname} | ${yves_company_user_buyer_email} ||
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: update customer profile data:
    ...    || email                            | salutation | first name                           | last name                           ||
    ...    || ${yves_company_user_buyer_email} | Mr         | ${yves_company_user_buyer_firstname} | ${yves_company_user_buyer_lastname} ||
