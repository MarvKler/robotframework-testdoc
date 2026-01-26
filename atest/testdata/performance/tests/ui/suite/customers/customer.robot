*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_two    spryker-core-back-office    spryker-core    acl    customer-account-management    customer-access    cart    multiple-carts
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
Resource    ../../../../resources/steps/customer_registration_steps.robot

*** Test Cases ***
Guest_User_Access_Restrictions
    [Documentation]    Checks that guest users see products info and cart but not profile
    Yves: header contains/doesn't contain:    true    ${currencySwitcher}[${env}]    ${shoppingCartIcon}
    Yves: go to PDP of the product with sku:    002
    Yves: PDP contains/doesn't contain:     true    ${pdpPriceLocator}    ${addToCartButton}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:   sku=002    productPrice=99.99    productName=Canon IXUS 160
    Yves: go to user menu:    Overview
    Yves: 'Login' page is displayed
    Yves: go to 'Wishlist' page
    Yves: 'Login' page is displayed

Authorized_User_Access
    [Documentation]    Checks that authorized users see products info, cart and profile
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: check if cart is not empty and clear it
    Yves: header contains/doesn't contain:    true    ${currencySwitcher}[${env}]    ${accountIcon}    ${shoppingCartIcon}
    Yves: go to PDP of the product with sku:    002
    Yves: PDP contains/doesn't contain:     true    ${pdpPriceLocator}     ${addToCartButton}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    sku=002    productPrice=99.99    productName=Canon IXUS 160
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    Orders History
    Yves: 'Order History' page is displayed
    Yves: go to 'Wishlist' page
    Yves: 'Wishlist' page is displayed
    [Teardown]    Yves: check if cart is not empty and clear it

New_Customer_Registration
    [Tags]    smoke
    [Documentation]    Check that a new user can be registered in the system
    Register a new customer with data:
    ...    || salutation | first name | last name | e-mail                       | password                   ||
    ...    || Mr.        | New        | User      | sonia+${random}@spryker.com  | ${default_secure_password} ||
    Yves: flash message should be shown:    success    Almost there! We send you an email to validate your email address. Please confirm it to be able to log in.
    [Teardown]    Zed: delete customer:    sonia+${random}@spryker.com

User_Account
    [Tags]    smoke
    [Documentation]    Checks user account pages work + address management
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    Orders History
    Yves: 'Order History' page is displayed
    Yves: go to user menu:    My Profile
    Yves: 'Profile' page is displayed
    Yves: go to 'Wishlist' page
    Yves: 'Wishlist' page is displayed
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: go to user menu item in the left bar:    Newsletter
    Yves: 'Newsletter' page is displayed
    Yves: go to user menu item in the left bar:    Returns
    Yves: 'Returns' page is displayed
    Yves: delete all user addresses
    Yves: create a new customer address in profile:     Mr    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    true    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany
    Yves: delete user address:    Kirncher Str. ${random}
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    false    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create a new customer address in profile:
    ...    || email                     | salutation | first name                              | last name                              | address 1          | address 2           | address 3           | city            | zip code  | country | phone     | company          ||
    ...    || ${yves_second_user_email} | Mr         | ${yves_second_user_first_name}${random} | ${yves_second_user_last_name}${random} | address 1${random} | address 2 ${random} | address 3 ${random} | Berlin${random} | ${random} | Austria | 123456789 | Spryker${random} ||
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to user menu:    Overview
    Yves: go to user menu item in the left bar:    Addresses
    Yves: check that user has address exists/doesn't exist:    true    ${yves_second_user_first_name}${random}    ${yves_second_user_last_name}${random}    address 1${random}    address 2 ${random}    ${random}    Berlin${random}    Austria
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    ...    AND     Yves: delete all user addresses

Update_Customer_Data
    [Documentation]    Checks customer data can be updated from Yves and Zed
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    My Profile
    Yves: 'Profile' page is displayed
    Yves: assert customer profile data:
    ...    || salutation | first name                     | last name                     | email                     ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | ${yves_second_user_email} ||
    Yves: update customer profile data:
    ...    || salutation | first name                            | last name                            ||
    ...    || Dr.        | updated${yves_second_user_first_name} | updated${yves_second_user_last_name} ||
    Yves: assert customer profile data:
    ...    || salutation | first name                            | last name                            ||
    ...    || Dr.        | updated${yves_second_user_first_name} | updated${yves_second_user_last_name} ||
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: assert customer profile data:
    ...    || email                     | salutation | first name                            | last name                            ||
    ...    || ${yves_second_user_email} | Dr         | updated${yves_second_user_first_name} | updated${yves_second_user_last_name} ||
    Zed: update customer profile data:
    ...    || email                     | salutation | first name                     | last name                     ||
    ...    || ${yves_second_user_email} | Mr         | ${yves_second_user_first_name} | ${yves_second_user_last_name} ||
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    My Profile
    Yves: 'Profile' page is displayed
    Yves: assert customer profile data:
    ...    || salutation | first name                     | last name                     | email                     ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | ${yves_second_user_email} ||
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: update customer profile data:
    ...    || email                     | salutation | first name                     | last name                     ||
    ...    || ${yves_second_user_email} | Mr         | ${yves_second_user_first_name} | ${yves_second_user_last_name} ||

Add_to_Wishlist
    [Tags]    smoke    wishlist
    [Documentation]    Check creation of wishlist and adding to different wishlists
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: delete all wishlists
    Yves: go to PDP of the product with sku:  005
    Yves: add product to wishlist:    My wishlist
    Yves: go to 'Wishlist' page
    Yves: create wishlist with name:    Second wishlist
    Yves: go to PDP of the product with sku:  006
    Yves: add product to wishlist:    Second wishlist    select
    Yves: go to 'Wishlist' page
    Yves: go to wishlist with name:    My wishlist
    Yves: wishlist contains product with sku:    005_30663301
    Yves: go to wishlist with name:    Second wishlist
    Yves: wishlist contains product with sku:    006_30692993
    Yves: go to PDP of the product with sku:    ${bundled_product_3_concrete_sku}
    Yves: try to add product to wishlist as guest user
    [Teardown]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: delete all wishlists
    ...    AND    Yves: check if cart is not empty and clear it

Share_Shopping_Lists
    [Tags]    smoke    shopping-lists
    [Documentation]    Checks that shopping list can be shared
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: go to 'Shopping Lists' page
    Yves: 'Shopping Lists' page is displayed
    Yves: create new 'Shopping List' with name:    shareShoppingList+${random}
    Yves: the following shopping list is shown:    shoppingListName=shareShoppingList+${random}    shoppingListOwner=${yves_company_user_shared_permission_owner_firstname} ${yves_company_user_shared_permission_owner_lastname}    shoppingListAccess=Full access
    Yves: share shopping list with user:    shoppingListName=shareShoppingList+${random}    customer=${yves_company_user_shared_permission_receiver_firstname} ${yves_company_user_shared_permission_receiver_lastname}    accessLevel=Full access
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: add product to the shopping list:    shareShoppingList+${random}
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: select xxx merchant's offer:    Budget Cameras
    Yves: add product to the shopping list:    shareShoppingList+${random}
    Create New Context
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_receiver_email}
    Yves: 'Shopping List' widget contains:    shoppingListName=shareShoppingList+${random}    accessLevel=Full access
    Yves: go to 'Shopping Lists' page
    Yves: 'Shopping Lists' page is displayed
    Yves: the following shopping list is shown:    shoppingListName=shareShoppingList+${random}    shoppingListOwner=${yves_company_user_shared_permission_owner_firstname} ${yves_company_user_shared_permission_owner_lastname}    shoppingListAccess=Full access
    Yves: view shopping list with name:    shareShoppingList+${random}
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Budget Cameras
    Yves: add all available products from list to cart
    Yves: 'Shopping Cart' page is displayed
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Budget Cameras
    [Teardown]    Run Keywords    Close Current Context    AND    Yves: delete 'Shopping List' with name:    shareShoppingList+${random}

Share_Shopping_Carts
    [Tags]    smoke    checkout    shared-carts    persistent-cart-sharing
    [Documentation]    Checks that cart can be shared and used for checkout
    [Setup]    Run Keywords
    ...    MP: login on MP with provided credentials:    ${merchant_sony_experts_email}
    ...    AND    MP: change offer stock:
    ...    || offer   | stock quantity | is never out of stock ||
    ...    || offer97 | 10             | true                  ||
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
    Yves: go to PDP of the product with sku:    ${second_product_with_multiple_offers_abstract_sku}
    Yves: change quantity on PDP:    2
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${second_product_with_multiple_offers_abstract_sku}
    Yves: select xxx merchant's offer:    Sony Experts
    Yves: add product to the shopping cart
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_receiver_email}
    Yves: 'Shopping Carts' widget contains:    shoppingCartName+${random}    Full access
    Yves: go to 'Shopping Carts' page through the header
    Yves: 'Shopping Carts' page is displayed
    Yves: the following shopping cart is shown:    shoppingCartName+${random}    Full access
    Yves: go to the shopping cart through the header with name:    shoppingCartName+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: assert merchant of product in cart or list:    ${second_product_with_multiple_offers_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${second_product_with_multiple_offers_concrete_sku}    Sony Experts
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_shared_permission_receiver_address}
    Yves: select the following shipping method for the shipment:    1    Spryker Dummy Shipment    Express
    Yves: select the following shipping method for the shipment:    2    Spryker Dummy Shipment    Standard
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

Quick_Order
    [Tags]    smoke    checkout    reorder    cart    order-management
    [Documentation]    Checks Quick Order, checkout and Reorder
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts
    ...    AND    Yves: create new 'Shopping Cart' with name:    quickOrderCart+${random}
    ...    AND    Yves: create new 'Shopping List' with name:    quickOrderList+${random}
    Yves: go to 'Quick Order' page through the header
    Yves: 'Quick Order' page is displayed
    Yves: add the following articles into the form through quick order text area:     202_5782479,1\n056_31714843,3
    Yves: find and add new item in the quick order form:
    ...    || searchQuery                                  | merchant       ||
    ...    || ${product_with_multiple_offers_concrete_sku} | Budget Cameras ||
    Yves: add products to the shopping cart from quick order page
    Yves: go to the shopping cart through the header with name:    quickOrderCart+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:     202_5782479    056_31714843    ${product_with_multiple_offers_concrete_sku}
    Yves: assert merchant of product in cart or list:    202_5782479    Video King
    Yves: assert merchant of product in cart or list:    056_31714843    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Budget Cameras
    Yves: go to 'Quick Order' page through the header
    Yves: add the following articles into the form through quick order text area:     202_5782479,1\n056_31714843,3
    Yves: find and add new item in the quick order form:
    ...    || searchQuery                                  | merchant       ||
    ...    || ${product_with_multiple_offers_concrete_sku} | Budget Cameras ||
    Yves: add products to the shopping list from quick order page with name:    quickOrderList+${random}
    Yves: 'Shopping List' page is displayed
    Yves: shopping list contains the following products:     202_5782479    056_31714843    ${product_with_multiple_offers_concrete_sku}
    Yves: assert merchant of product in cart or list:    202_5782479    Video King
    Yves: assert merchant of product in cart or list:    056_31714843    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Budget Cameras
    Yves: go to the shopping cart through the header with name:    quickOrderCart+${random}
    ### Order placement ###
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method for the shipment:    1    Spryker Dummy Shipment    Standard
    Yves: select the following shipping method for the shipment:    2    Spryker Dummy Shipment    Express
    Yves: select the following shipping method for the shipment:    3    Spryker Drone Shipment    Air Light
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    ### Order History ###
    Yves: go to the 'Home' page
    Yves: go to user menu:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page is displayed
    ### Reorder ###
    Yves: reorder all items from 'Order Details' page
    Yves: go to the shopping cart through the header with name:    ${lastPlacedOrder}
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:     202_5782479    056_31714843    ${product_with_multiple_offers_concrete_sku}
    Yves: assert merchant of product in cart or list:    202_5782479    Video King
    Yves: assert merchant of product in cart or list:    056_31714843    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Budget Cameras
    [Teardown]    Yves: delete 'Shopping List' with name:    quickOrderList+${random}

Reorder
    [Tags]    reorder    checkout    cart    order-management
    [Documentation]    Checks that merchant relation is saved with reorder
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:    ${available_never_out_of_stock_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: assert merchant of product in cart or list:    ${available_never_out_of_stock_concrete_sku}    Spryker
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_user_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:    Reorder    ${lastPlacedOrder}
    Yves: assert merchant of product in cart or list:    ${available_never_out_of_stock_concrete_sku}    Spryker
    [Teardown]    Run Keywords    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses

Business_on_Behalf
    [Tags]    company-account
    [Documentation]    Check that BoB user has possibility to change the business unit
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Customers    Company Users
    Zed: click Action Button in a table for row that contains:    Donald    Attach to BU
    Zed: attach company user to the following BU with role:    Spryker Systems Zurich    Admin
    Yves: login on Yves with provided credentials:    ${yves_company_user_bob_email}
    Yves: go to URL:    en/company/user/select
    Yves: 'Select Business Unit' page is displayed
    Yves: 'Business Unit' dropdown contains:    Spryker Systems GmbH / Spryker Systems Berlin    Spryker Systems GmbH / Spryker Systems Zurich
    [Teardown]    Zed: delete company user xxx withing xxx company business unit:    Donald    Spryker Systems Zurich

Wishlist_List_Supports_Offers
    [Tags]    wishlist    marketplace-wishlist    product    marketplace-product    marketplace-product-offer
    [Documentation]    Checks that customer is able to add merchant products and offers to list and merchant relation won't be lost in list and afterwards in cart
    [Setup]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: delete all wishlists
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: go to 'Wishlist' page
    ...    AND    Yves: create wishlist with name:    Offer wishlist
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: add product to wishlist:    Offer wishlist
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: select xxx merchant's offer:    Budget Cameras
    Yves: add product to wishlist:    Offer wishlist
    Yves: go to 'Wishlist' page
    Yves: go to wishlist with name:    Offer wishlist
    Yves: assert merchant of product in wishlist:    ${product_with_multiple_offers_concrete_sku}    Spryker
    Yves: assert merchant of product in wishlist:    ${product_with_multiple_offers_concrete_sku}    Budget Cameras
    Yves: add all available products from wishlist to cart
    Yves: go to shopping cart page
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Budget Cameras
    [Teardown]    Run keywords    Yves: delete all wishlists    AND    Yves: check if cart is not empty and clear it

Shopping_List_Contains_Offers
    [Tags]    shopping-lists    marketplace-shopping-lists    cart    product    marketplace-product    marketplace-product-offer
    [Documentation]    Checks that customer is able to add merchant products and offers to list and merchant relation won't be lost in list and afterwards in cart
    [Setup]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts
    Yves: create new 'Shopping List' with name:    shoppingListName${random}
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: add product to the shopping list:    shoppingListName${random}
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: select xxx merchant's offer:    Budget Cameras
    Yves: add product to the shopping list:    shoppingListName${random}
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Budget Cameras
    Yves: add all available products from list to cart
    Yves: 'Shopping Cart' page is displayed
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Budget Cameras
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete 'Shopping List' with name:    shoppingListName${random}

Email_Confirmation
    [Tags]    smoke
    [Documentation]    Check that a new user cannot login if the email is not verified
    Register a new customer with data:
    ...    || salutation | first name | last name | e-mail                             | password                   ||
    ...    || Mr.        | New        | User      | sonia+fails+${random}@spryker.com  | ${default_secure_password} ||
    Yves: flash message should be shown:    success    Almost there! We send you an email to validate your email address. Please confirm it to be able to log in.
    Yves: login on Yves with provided credentials and expect error:     sonia+fails+${random}@spryker.com     ${default_secure_password}
    [Teardown]    Zed: delete customer:    sonia+fails+${random}@spryker.com
