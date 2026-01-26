*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_one
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/common/common_mp.robot
Resource    ../../../../resources/steps/mp_offers_steps.robot
Resource    ../../../../resources/steps/company_steps.robot

*** Test Cases ***
Guest_User_Access_Restrictions
    [Documentation]    Checks that guest users are not able to see: Prices, Availability, Quick Order, "My Account" features
    Create dynamic customer in DB
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: header contains/doesn't contain:    false    ${priceModeSwitcher}    ${currencySwitcher}[${env}]     ${quickOrderIcon}    ${accountIcon}    ${shopping_list_icon_header_menu_item}[${env}]    ${shoppingCartIcon}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku} 
    Yves: PDP contains/doesn't contain:     false    ${pdpPriceLocator}    ${addToCartButton}
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: header contains/doesn't contain:    true    ${priceModeSwitcher}    ${currencySwitcher}[${env}]    ${quickOrderIcon}    ${accountIcon}    ${shopping_list_icon_header_menu_item}[${env}]    ${shoppingCartIcon}
    Yves: company menu 'should' be available for logged in user
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: PDP contains/doesn't contain:     true    ${pdpPriceLocator}    ${addToCartButton}
    Yves: go to company menu item:    Users
    Yves: 'Company Users' page is displayed

Share_Shopping_Lists
    [Documentation]    Checks that shopping list can be shared
    [Setup]    Run Keywords    Create dynamic customer in DB    based_on=${yves_company_user_shared_permission_owner_email}    email=sonia+sharelist${random}@spryker.com    first_name=Share${random}    last_name=List${random}
    ...    AND    Create dynamic customer in DB    based_on=${yves_company_user_shared_permission_receiver_email}    email=sonia+receivelist${random}@spryker.com    first_name=Receive${random}    last_name=List${random}
    Yves: login on Yves with provided credentials:    sonia+sharelist${random}@spryker.com
    Yves: go to 'Shopping Lists' page
    Yves: 'Shopping Lists' page is displayed
    Yves: create new 'Shopping List' with name:    shareShoppingList+${random}
    Yves: the following shopping list is shown:    shoppingListName=shareShoppingList+${random}    shoppingListOwner=Share${random} List${random}    shoppingListAccess=Full access
    Yves: share shopping list with user:    shoppingListName=shareShoppingList+${random}    customer=Receive${random} List${random}    accessLevel=Full access
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: add product to the shopping list:    shareShoppingList+${random}
    Yves: select xxx merchant's offer:    Computer Experts
    Yves: add product to the shopping list:    shareShoppingList+${random}
    Create New Context
    Yves: login on Yves with provided credentials:    sonia+receivelist${random}@spryker.com
    Yves: 'Shopping List' widget contains:    shareShoppingList+${random}    Full access
    Yves: create new 'Shopping Cart' with name:    shoppingListToCart+${random}
    Yves: go to 'Shopping Lists' page
    Yves: 'Shopping Lists' page is displayed
    Yves: the following shopping list is shown:    shoppingListName=shareShoppingList+${random}    shoppingListOwner=Share${random} List${random}    shoppingListAccess=Full access
    Yves: view shopping list with name:    shareShoppingList+${random}
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Computer Experts
    Yves: add all available products from list to cart  
    Yves: 'Shopping Cart' page is displayed
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Computer Experts
    [Teardown]    Run Keywords    Close Current Context

Share_Shopping_Carts
    [Documentation]    Checks that cart can be shared and used for checkout
    [Setup]    Run Keywords    
    ...    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB    based_on=${yves_company_user_shared_permission_owner_email}    email=sonia+sharecart${random}@spryker.com    first_name=Share${random}    last_name=Cart${random}
    ...    AND    Create dynamic customer in DB    based_on=${yves_company_user_shared_permission_receiver_email}    email=sonia+receivecart${random}@spryker.com    first_name=Receive${random}    last_name=Cart${random}
    ...    AND    Zed: create dynamic merchant user:    Computer Experts
    ...    AND    MP: login on MP with provided credentials:    ${dynamic_expert_merchant}
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer395 | 10             | true                  ||
    Trigger p&s      
    Yves: login on Yves with provided credentials:    sonia+sharecart${random}@spryker.com
    Yves: go to 'Shopping Carts' page through the header
    Yves: 'Shopping Carts' page is displayed
    Yves: create new 'Shopping Cart' with name:    shoppingCartName+${random}
    Yves: 'Shopping Carts' widget contains:    shoppingCartName+${random}    Owner access
    Yves: go to 'Shopping Carts' page through the header
    Yves: 'Shopping Carts' page is displayed
    Yves: the following shopping cart is shown:    shoppingCartName+${random}    Owner access
    Yves: share shopping cart with user:    shoppingCartName+${random}    Cart${random} Receive${random}    Full access
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: change quantity on PDP:    2
    Yves: add product to the shopping cart
    Yves: select xxx merchant's offer:    Computer Experts
    Yves: add product to the shopping cart
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    sonia+receivecart${random}@spryker.com
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
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
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
    [Teardown]    Delete dynamic admin user from DB

Business_on_Behalf
    [Documentation]    Check that BoB user has possibility to change the business unit
    Create dynamic customer in DB    first_name=Oryx${random}    last_name=Bob
    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Customers    Company Users
    Zed: click Action Button in a table for row that contains:    Oryx${random}    Attach to BU
    Zed: attach company user to the following BU with role:    Spryker Systems Zurich    Admin
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to URL:    en/company/user/select
    Yves: 'Select Business Unit' page is displayed
    Yves: 'Business Unit' dropdown contains:    Spryker Systems GmbH / Spryker Systems HR department    Spryker Systems GmbH / Spryker Systems Zurich
    [Teardown]    Run Keywords    Zed: delete company user xxx withing xxx company business unit:    Oryx${random}    Spryker Systems Zurich
    ...    AND    Delete dynamic admin user from DB

User_Account
    [Documentation]    Checks user account pages work + address management
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Create dynamic admin user in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
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
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create a new customer address in profile:
    ...    || email               | salutation | first name                       | last name                       | address 1          | address 2           | address 3           | city            | zip code  | country | phone     | company          ||
    ...    || ${dynamic_customer} | Ms         | ${yves_user_first_name}${random} | ${yves_user_last_name}${random} | address 1${random} | address 2 ${random} | address 3 ${random} | Berlin${random} | ${random} | Austria | 123456789 | Spryker${random} ||
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Overview
    Yves: go to user menu item in the left bar:    Addresses
    Yves: check that user has address exists/doesn't exist:    true    ${yves_user_first_name}${random}    ${yves_user_last_name}${random}    address 1${random}    address 2 ${random}    ${random}    Berlin${random}    Austria
    [Teardown]    Delete dynamic admin user from DB

Update_Customer_Data
    [Documentation]    Checks customer data can be updated from Yves and Zed
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Create dynamic admin user in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    Profile
    Yves: 'Profile' page is displayed
    Yves: assert customer profile data:
    ...    || salutation | first name | last name | email               ||
    ...    || Ms.        | Dynamic    | Customer  | ${dynamic_customer} ||
    Yves: update customer profile data:
    ...    || salutation | first name                                  | last name                                  ||
    ...    || Dr.        | updated${yves_company_user_buyer_firstname} | updated${yves_company_user_buyer_lastname} ||
    Yves: assert customer profile data:
    ...    || salutation | first name                                  | last name                                  ||
    ...    || Dr.        | updated${yves_company_user_buyer_firstname} | updated${yves_company_user_buyer_lastname} ||
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: assert customer profile data:
    ...    || email               | salutation | first name                                  | last name                                  ||
    ...    || ${dynamic_customer} | Dr         | updated${yves_company_user_buyer_firstname} | updated${yves_company_user_buyer_lastname} ||
    Zed: update customer profile data:
    ...    || email               | salutation | first name          | last name          ||
    ...    || ${dynamic_customer} | Mr         | Dynamic${random}    | Customer${random}  ||
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    Profile
    Yves: 'Profile' page is displayed
    Yves: assert customer profile data:
    ...    || salutation | first name       | last name         | email               ||
    ...    || Mr.        | Dynamic${random} | Customer${random} | ${dynamic_customer} ||
    [Teardown]    Delete dynamic admin user from DB