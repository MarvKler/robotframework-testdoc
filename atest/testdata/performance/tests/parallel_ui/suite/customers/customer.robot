*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_two    spryker-core-back-office    spryker-core    acl    customer-account-management    customer-access
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/customer_registration_steps.robot
Resource    ../../../../resources/steps/zed_customer_steps.robot
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/common/common_mp.robot
Resource    ../../../../resources/steps/mp_offers_steps.robot
Resource    ../../../../resources/steps/zed_availability_steps.robot
Resource    ../../../../resources/steps/company_steps.robot

*** Test Cases ***
Guest_User_Access_Restrictions
    [Tags]    smoke
    [Documentation]    Checks that guest users see products info and cart but not profile
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
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
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
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

New_Customer_Registration
    [Tags]    smoke
    [Documentation]    Check that a new user can be registered in the system
    Create dynamic admin user in DB
    Register a new customer with data:
    ...    || salutation | first name | last name | e-mail                            | password                   ||
    ...    || Mr.        | New        | User      | sonia+ui+new${random}@spryker.com | ${default_secure_password} ||
    Yves: flash message should be shown:    success    Almost there! We send you an email to validate your email address. Please confirm it to be able to log in.
    [Teardown]    Run Keywords    Zed: delete customer:    sonia+ui+new${random}@spryker.com
    ...    AND    Delete dynamic admin user from DB

User_Account
    [Tags]    smoke
    [Documentation]    Checks user account pages work + address management
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Create dynamic admin user in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
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
    Yves: create a new customer address in profile:     Mr    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    true    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany
    Yves: delete user address:    Kirncher Str. ${random}
    Yves: go to user menu item in the left bar:    Addresses
    Yves: 'Addresses' page is displayed
    Yves: check that user has address exists/doesn't exist:    false    ${yves_second_user_first_name} ${random}    ${yves_second_user_last_name} ${random}    Kirncher Str. ${random}    7    10247    Berlin${random}    Germany
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create a new customer address in profile:
    ...    || email               | salutation | first name                              | last name                              | address 1          | address 2           | address 3           | city            | zip code  | country | phone     | company          ||
    ...    || ${dynamic_customer} | Mr         | ${yves_second_user_first_name}${random} | ${yves_second_user_last_name}${random} | address 1${random} | address 2 ${random} | address 3 ${random} | Berlin${random} | ${random} | Austria | 123456789 | Spryker${random} ||
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Overview
    Yves: go to user menu item in the left bar:    Addresses
    Yves: check that user has address exists/doesn't exist:    true    ${yves_second_user_first_name}${random}    ${yves_second_user_last_name}${random}    address 1${random}    address 2 ${random}    ${random}    Berlin${random}    Austria
    [Teardown]    Delete dynamic admin user from DB

Update_Customer_Data
    [Tags]    smoke
    [Documentation]    Checks customer data can be updated from Yves and Zed
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Create dynamic admin user in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    My Profile
    Yves: 'Profile' page is displayed
    Yves: assert customer profile data:
    ...    || salutation | first name | last name | email               ||
    ...    || Ms.        | Dynamic    | Customer  | ${dynamic_customer} ||
    Yves: update customer profile data:
    ...    || salutation | first name                            | last name                            ||
    ...    || Dr.        | updated${yves_second_user_first_name} | updated${yves_second_user_last_name} ||
    Yves: assert customer profile data:
    ...    || salutation | first name                            | last name                            ||
    ...    || Dr.        | updated${yves_second_user_first_name} | updated${yves_second_user_last_name} ||
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: assert customer profile data:
    ...    || email               | salutation | first name                            | last name                            ||
    ...    || ${dynamic_customer} | Dr         | updated${yves_second_user_first_name} | updated${yves_second_user_last_name} ||
    Zed: update customer profile data:
    ...    || email               | salutation | first name          | last name          ||
    ...    || ${dynamic_customer} | Mr         | Dynamic${random}    | Customer${random}  ||
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    My Profile
    Yves: 'Profile' page is displayed
    Yves: assert customer profile data:
    ...    || salutation | first name       | last name         | email               ||
    ...    || Mr.        | Dynamic${random} | Customer${random} | ${dynamic_customer} ||
    [Teardown]    Delete dynamic admin user from DB

Add_to_Wishlist
    [Tags]    smoke    wishlist    marketplace-wishlist
    [Documentation]    Check creation of wishlist and adding to different wishlists
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:  003
    Yves: add product to wishlist:    My wishlist
    Yves: go to 'Wishlist' page
    Yves: create wishlist with name:    Second wishlist
    Yves: go to PDP of the product with sku:  004
    Yves: add product to wishlist:    Second wishlist    select
    Yves: go to 'Wishlist' page
    Yves: go to wishlist with name:    My wishlist
    Yves: wishlist contains product with sku:    003_26138343
    Yves: go to wishlist with name:    Second wishlist
    Yves: wishlist contains product with sku:    004_30663302
    Yves: go to PDP of the product with sku:    ${bundled_product_3_concrete_sku}
    Yves: try to add product to wishlist as guest user

Share_Shopping_Lists
    [Tags]    smoke    shopping-lists    marketplace-shopping-lists
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
    Yves: go to PDP of the product with sku:    ${product_with_multiple_offers_abstract_sku}
    Yves: select xxx merchant's offer:    Budget Cameras
    Yves: add product to the shopping list:    shareShoppingList+${random}
    Create New Context
    Yves: login on Yves with provided credentials:    sonia+receivelist${random}@spryker.com
    Yves: 'Shopping List' widget contains:    shoppingListName=shareShoppingList+${random}    accessLevel=Full access
    Yves: go to 'Shopping Lists' page
    Yves: 'Shopping Lists' page is displayed
    Yves: the following shopping list is shown:    shoppingListName=shareShoppingList+${random}    shoppingListOwner=Share${random} List${random}    shoppingListAccess=Full access
    Yves: view shopping list with name:    shareShoppingList+${random}
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Budget Cameras
    Yves: add all available products from list to cart
    Yves: 'Shopping Cart' page is displayed
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Budget Cameras
    [Teardown]    Run Keywords    Close Current Context    

Share_Shopping_Carts
    [Tags]    cart   shared-carts    multiple-carts    checkout
    [Documentation]    Checks that cart can be shared and used for checkout
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB    based_on=${yves_company_user_shared_permission_owner_email}    email=sonia+sharecart${random}@spryker.com    first_name=Share${random}    last_name=Cart${random}
    ...    AND    Create dynamic customer in DB    based_on=${yves_company_user_shared_permission_receiver_email}    email=sonia+receivecart${random}@spryker.com    first_name=Receive${random}    last_name=Cart${random}
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: create dynamic merchant user:    Sony Experts
    ...    AND    MP: login on MP with provided credentials:    ${dynamic_expert_merchant}
    ...    AND    MP: change offer stock:
    ...    || offer   | stock quantity | is never out of stock ||
    ...    || offer97 | 10             | true                  ||
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
    Yves: go to PDP of the product with sku:    ${second_product_with_multiple_offers_abstract_sku}
    Yves: change quantity on PDP:    2
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${second_product_with_multiple_offers_abstract_sku}
    Yves: select xxx merchant's offer:    Sony Experts
    Yves: add product to the shopping cart
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    sonia+receivecart${random}@spryker.com
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
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
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
    [Teardown]    Delete dynamic admin user from DB

Quick_Order
    [Tags]    smoke    cart    checkout    reorder    marketplace-product-offer   marketplace-product    product
    [Documentation]    Checks Quick Order, checkout and Reorder
    [Setup]    Run keywords    Create dynamic customer in DB
    ...    AND    Create dynamic admin user in DB
    ...    AND    Zed: check and restore product availability in Zed:    ${product_with_multiple_offers_abstract_sku}    Available    ${product_with_multiple_offers_concrete_sku}    ${dynamic_admin_user}
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: create new 'Shopping List' with name:    quickOrderList+${random}
    Yves: go to 'Quick Order' page through the header
    Yves: 'Quick Order' page is displayed
    Yves: add the following articles into the form through quick order text area:     202_5782479,1\n056_31714843,3
    Yves: find and add new item in the quick order form:
    ...    || searchQuery                                  | merchant       ||
    ...    || ${product_with_multiple_offers_concrete_sku} | Budget Cameras ||
    Yves: add products to the shopping cart from quick order page
    Yves: go to shopping cart page
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
    Yves: go to shopping cart page
    ### Order placement ###
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
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

Reorder
    [Tags]    reorder    checkout    cart    order-management    state-machine
    [Documentation]    Checks that merchant relation is saved with reorder
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${available_never_out_of_stock_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: assert merchant of product in cart or list:    ${available_never_out_of_stock_concrete_sku}    Spryker
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:    Reorder    ${lastPlacedOrder}
    Yves: assert merchant of product in cart or list:    ${available_never_out_of_stock_concrete_sku}    Spryker

Business_on_Behalf
    [Tags]    smoke    company-account
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

Wishlist_List_Supports_Offers
    [Tags]    wishlist    marketplace-wishlist    marketplace-product-offer   marketplace-product    product
    [Documentation]    Checks that customer is able to add merchant products and offers to list and merchant relation won't be lost in list and afterwards in cart
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Yves: login on Yves with provided credentials:    ${dynamic_customer}
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

Shopping_List_Contains_Offers
    [Tags]    smoke    shopping-lists    marketplace-shopping-lists    marketplace-product-offer   marketplace-product    product
    [Documentation]    Checks that customer is able to add merchant products and offers to list and merchant relation won't be lost in list and afterwards in cart
    [Setup]    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
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

Email_Confirmation
    [Tags]    smoke    mailing-notifications
    [Documentation]    Check that a new user cannot login if the email is not verified
    Register a new customer with data:
    ...    || salutation | first name | last name | e-mail                                | password                   ||
    ...    || Mr.        | New        | User      | sonia+ui+fails+${random}@spryker.com  | ${default_secure_password} ||
    Yves: flash message should be shown:    success    Almost there! We send you an email to validate your email address. Please confirm it to be able to log in.
    Yves: login on Yves with provided credentials and expect error:     sonia+ui+fails+${random}@spryker.com     ${default_secure_password}
    [Teardown]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Zed: delete customer:    sonia+ui+fails+${random}@spryker.com
    ...    AND    Delete dynamic admin user from DB