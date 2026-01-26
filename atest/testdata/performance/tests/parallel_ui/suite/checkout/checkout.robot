*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_one    spryker-core    cart    checkout    orders-management    acl    customer-account-management    customer-access   
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/zed_customer_steps.robot
Resource    ../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/steps/zed_availability_steps.robot
Resource    ../../../../resources/common/common_mp.robot
Resource    ../../../../resources/steps/mp_offers_steps.robot
Resource    ../../../../resources/steps/order_comments_steps.robot

*** Test Cases ***
Login_during_checkout
    [Tags]    smoke
    Create dynamic customer in DB
    Yves: go to the 'Home' page
    Yves: go to PDP of the product with sku:    ${bundled_product_3_concrete_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page  
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: proceed as a guest user and login during checkout:   ${dynamic_customer}
    Yves: fill in the following new shipping address:
    ...    || salutation     | firstName                    | lastName                    | street        | houseNumber       | postCode     | city       | country     | company    | phone     | additionalAddress     ||
    ...    || ${Salutation}  | ${Guest_user_first_name}     | ${Guest_user_last_name}     | ${random}     | ${random}         | ${random}    | ${city}    | ${country}  | ${company} | ${random} | ${additional_address} ||
    Yves: billing address same as shipping address:    true
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer

Register_during_checkout
    [Documentation]    Guest user email should be whitelisted from the AWS side before running the test
    [Tags]    glue    smoke    default-run-feature
    [Setup]    Create dynamic admin user in DB
    Yves: go to the 'Home' page
    Yves: go to PDP of the product with sku:    ${bundled_product_3_concrete_sku}
    Yves: add product to the shopping cart
    Page Should Not Contain Element    ${pdp_add_to_wishlist_button}
    Yves: go to shopping cart page  
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: signup guest user during checkout:    ${guest_user_first_name}    ${guest_user_last_name}    sonia+guest${random}@spryker.com    Kj${random_str_password}!0${random_id_password}    Kj${random_str_password}!0${random_id_password}
    Save the result of a SELECT DB query to a variable:    select registration_key from spy_customer where email = 'sonia+guest${random}@spryker.com'    confirmation_key
    API_test_setup
    I send a POST request:     /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"${confirmation_key}"}}}
    Yves: login after signup during checkout:    sonia+guest${random}@spryker.com    Kj${random_str_password}!0${random_id_password}
    Yves: fill in the following new shipping address:
    ...    || salutation     | firstName                | lastName                | street    | houseNumber | postCode     | city       | country     | company    | phone     | additionalAddress         ||
    ...    || ${salutation}  | ${guest_user_first_name} | ${guest_user_last_name} | ${random} | ${random}   | ${random}    | ${city}    | ${country}  | ${company} | ${random} | ${additional_address}     ||
    Yves: billing address same as shipping address:    true
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: go to user menu:    Overview
    Yves: 'Overview' page is displayed
    Yves: go to user menu:    My Profile
    Yves: 'Profile' page is displayed
    Yves: assert customer profile data:
    ...    || salutation    | first name               | last name               | email                            ||
    ...    || ${salutation} | ${guest_user_first_name} | ${guest_user_last_name} | sonia+guest${random}@spryker.com ||
    [Teardown]    Run Keywords    Zed: delete customer:    sonia+guest${random}@spryker.com
    ...    AND    Delete dynamic admin user from DB

Business_Unit_Address_on_Checkout
    [Tags]    company-account
    [Documentation]    Checks that business unit address can be used during checkout
    Create dynamic customer in DB    based_on=${yves_company_user_buyer_email}
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${available_never_out_of_stock_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    Mr Dynamic Customer, Gurmont Str. 23, 8002 Barcelona
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: go to user menu:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page is displayed
    Yves: shipping address on the order details page is:    Mr. Dynamic Customer Spryker Systems GmbH Gurmont Str. 23 8002 Barcelona, Spain 3490284322

Request_for_Quote
    [Tags]    smoke    quotation-process    agent-assist
    [Documentation]    Checks user can request and receive quote.
    [Setup]    Run keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB    based_on=${yves_company_user_buyer_email}
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${product_with_sale_price_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: submit new request for quote
    Yves: click 'Send to Agent' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    ${dynamic_admin_user}    agent_assist=${True}
    Yves: header contains/doesn't contain:    true    ${quoteRequestsWidget}
    Yves: go to 'Agent Quote Requests' page through the header
    Yves: 'Quote Requests' page is displayed
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Waiting
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: 'Quote Request Details' page is displayed
    Yves: click 'Revise' button on the 'Quote Request Details' page
    Yves: change price for the product in the quote request with sku xxx on:    ${product_with_sale_price_concrete_sku}    500
    Yves: click 'Send to Customer' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Quote Requests
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Ready
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: click 'Revise' button on the 'Quote Request Details' page
    Yves: click 'Edit Items' button on the 'Quote Request Details' page
    Yves: delete product from the shopping cart with sku:    ${one_variant_product_concrete_sku}
    Yves: click 'Save and Back to Edit' button on the 'Quote Request Details' page
    Yves: add the following note to the quote request:    Spryker rocks
    Yves: click 'Save' button on the 'Quote Request Details' page
    Yves: click 'Send to Agent' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    ${dynamic_admin_user}    agent_assist=${True}
    Yves: move mouse over header menu item:     ${quoteRequestsWidget}
    Yves: 'Quote Requests' widget is shown
    Yves: go to the quote request through the header with reference:    ${lastCreatedRfQ}
    Yves: 'Quote Request Details' page contains the following note:   Spryker rocks
    Yves: click 'Revise' button on the 'Quote Request Details' page
    Yves: set 'Valid Till' date for the quote request, today +:    1 day
    Yves: change price for the product in the quote request with sku xxx on:    ${product_with_sale_price_concrete_sku}    500
    Yves: click 'Send to Customer' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Quote Requests
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Ready
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: click 'Convert to Cart' button on the 'Quote Request Details' page
    Yves: shopping cart contains product with unit price:    sku=${product_with_sale_price_concrete_sku}    productName=${product_with_sale_price_abstract_name}    productPrice=500
    Yves: shopping cart doesn't contain the following products:    ${one_variant_product_concrete_sku}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: checkout summary step contains product with unit price:    productName=${product_with_sale_price_abstract_name}    productPrice=500
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Delete dynamic admin user from DB

Split_Delivery
    [Tags]    smoke    shipment    
    [Documentation]    Checks split delivery in checkout
    [Setup]    Run Keywords    Create dynamic customer in DB    based_on=${yves_user_email}
    ...    AND    Create dynamic admin user in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    012
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: select delivery to multiple addresses
    Yves: fill in new delivery address for a product:
    ...    || product        | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Canon IXUS 285 | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in new delivery address for a product:
    ...    || product        | salutation | firstName | lastName | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Canon IXUS 175 | Dr.        | First     | Last     | Second Street | 2           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in new delivery address for a product:
    ...    || product        | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Canon IXUS 165 | Dr.        | First     | Last     | Third Street | 3           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Spryker Dummy Shipment    Standard
    Yves: select the following shipping method for the shipment:    2    Spryker Drone Shipment    Air Light
    Yves: select the following shipping method for the shipment:    3    Spryker Dummy Shipment    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    3
    [Teardown]    Delete dynamic admin user from DB

Checkout_Address_Management
    [Tags]    smoke
    [Documentation]    Bug: CC-30439. Checks that user can change address during the checkout and save new into the address book
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${available_never_out_of_stock_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    false
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: save new billing address to address book:    false
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: return to the previous checkout step:    Address
    Yves: billing address same as shipping address:    false
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | New       | Billing  | Changed Street | 098         | 09876    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: save new billing address to address book:    false
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName | lastName | street          | houseNumber | postCode | city   | country     | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Shipping Street | 7           | 10247    | Geneva | Switzerland | Spryker | 123456789 | Additional street ||
    Yves: save new delivery address to address book:    true
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: check that user has address exists/doesn't exist:    true    First    Last    Shipping Street    7    10247    Geneva    Switzerland
    Yves: check that user has address exists/doesn't exist:    false    New    Billing    Changed Street    098    09876    Berlin    Germany
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: billing address for the order should be:    New Billing, Changed Street 098, 09876 Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    1    Mr First, Last, Shipping Street, 7, Additional street, Spryker, 10247, Geneva, Switzerland
    [Teardown]    Delete dynamic admin user from DB

Multiple_Merchants_Order
    [Tags]    marketplace-product-offer    marketplace-merchant    merchant    marketplace-product
    [Documentation]    Checks that order with products and offers of multiple merchants could be placed and it will be split per merchant
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: create dynamic merchant user:    Video King
    ...    AND    Zed: create dynamic merchant user:    Budget Cameras
    ...    AND    Zed: change product stock:    ${one_variant_product_of_main_merchant_abstract_sku}    ${one_variant_product_of_main_merchant_concrete_sku}    true    10    10
    ...    AND    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    ...    AND    MP: change offer stock:
    ...    || offer   | stock quantity | is never out of stock ||
    ...    || offer30 | 10             | true                  ||
    ...    AND    MP: login on MP with provided credentials:    ${dynamic_budget_merchant}
    ...    AND    MP: change offer stock:
    ...    || offer   | stock quantity | is never out of stock ||
    ...    || offer89 | 10             | true                  ||
    ...    AND    Repeat Keyword    3    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${one_variant_product_of_main_merchant_abstract_sku}
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to PDP of the product with sku:     ${product_with_multiple_offers_abstract_sku}
    Yves: merchant's offer/product price should be:    Budget Cameras    ${product_with_multiple_offers_budget_cameras_price}
    Yves: merchant's offer/product price should be:    Video King    ${product_with_multiple_offers_video_king_price}
    Yves: select xxx merchant's offer:    Budget Cameras
    Yves: product price on the PDP should be:    ${product_with_multiple_offers_budget_cameras_price}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:     ${second_product_with_multiple_offers_abstract_sku}
    Yves: select xxx merchant's offer:    Video King
    Yves: product price on the PDP should be:    ${second_product_with_multiple_offers_video_king_price}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: assert merchant of product in cart or list:    ${one_variant_product_of_main_merchant_concrete_sku}    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Budget Cameras
    Yves: assert merchant of product in cart or list:    ${second_product_with_multiple_offers_concrete_sku}    Video King
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Spryker Dummy Shipment    Standard
    Yves: select the following shipping method for the shipment:    2    Spryker Drone Shipment    Air Light
    Yves: select the following shipping method for the shipment:    3    Spryker Dummy Shipment    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice Marketplace
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    3
    [Teardown]    Delete dynamic admin user from DB
    
Unique_URL
    [Tags]    dms-on    shared-carts
    [Documentation]    Bug: https://spryker.atlassian.net/browse/CC-12380
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: create new 'Shopping Cart' with name:    externalCart+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    externalCart+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: get link for external cart sharing
    Yves: logout on Yves as a customer
    Yves: go to external URL:    ${externalURL}
    Yves: Shopping Cart title should be equal:    Preview: externalCart+${random}
    Yves: preview shopping cart contains the following products:    ${one_variant_product_abstract_sku}

Comments_in_Cart
    [Documentation]    Add comments to cart and verify comments in Yves and Zed
    Create dynamic customer in DB
    Create dynamic admin user in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${bundled_product_3_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: add comment on cart:    abc${random}
    Yves: check comments are visible or not in cart:    true    abc${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: go to order details page to check comment:    abc${random}    ${lastPlacedOrder}
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}    
    Zed: check comment appears at order detailed page in zed:    abc${random}    ${lastPlacedOrder}
    [Teardown]    Delete dynamic admin user from DB

Comment_Management_in_the_Cart
    [Tags]    smoke
    [Documentation]    Editing and deleting comments in carts
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${bundled_product_3_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: add comment on cart:    abc${random}
    Yves: check comments are visible or not in cart:    true    abc${random}    
    Yves: edit comment on cart:    xyz${random}
    Yves: check comments are visible or not in cart:    true    xyz${random}    
    Yves: delete comment on cart
    Yves: check comments are visible or not in cart:    false    xyz${random}

# Approval_Process
#     ### *** DEMODATA - NO OOT LIMITS AND CAN'T SET THEM IN SUITE *** ###
#     [Tags]    skip-due-to-refactoring
#     [Documentation]    Checks role permissions on checkout and Approval process
#     [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_with_limit_email}
#     ...    AND    Yves: create new 'Shopping Cart' with name:    approvalCart+${random}
#     ...    AND    Yves: delete all user addresses
#     Yves: go to PDP of the product with sku:    M49320
#     Yves: add product to the shopping cart
#     Yves: go to the shopping cart through the header with name:    approvalCart+${random}
#     Yves: click on the 'Checkout' button in the shopping cart
#     Yves: billing address same as shipping address:    true
#     Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_with_limit_address}
#     Yves: select the following shipping method on the checkout and go next:    Express
#     Yves: select the following payment method on the checkout and go next:    Invoice
#     Yves: select approver on the 'Summary' page:    Lilu Dallas (€1,000.00)
#     Yves: 'send the request' on the summary page
#     Yves: 'Summary' page is displayed
#     Yves: 'Summary' page contains/doesn't contain:    true    ${cancelRequestButton}    ${alertWarning}    ${quoteStatus}
#     Yves: go to the 'Home' page
#     Yves: go to the shopping cart through the header with name:    approvalCart+${random}
#     Yves: shopping cart contains/doesn't contain the following elements:    true    ${lockedCart}
#     Yves: create new 'Shopping Cart' with name:    newApprovalCart+${random}
#     Yves: go to PDP of the product with sku:    M58314
#     Yves: add product to the shopping cart
#     Yves: go to the shopping cart through the header with name:    newApprovalCart+${random}
#     Yves: click on the 'Checkout' button in the shopping cart
#     Yves: billing address same as shipping address:    true
#     Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_with_limit_address}
#     Yves: select the following shipping method on the checkout and go next:    Express
#     Yves: select the following payment method on the checkout and go next:    Invoice
#     Yves: accept the terms and conditions:    true
#     Yves: 'submit the order' on the summary page
#     Yves: 'Thank you' page is displayed
#     Yves: create new 'Shopping Cart' with name:    anotherApprovalCart+${random}
#     Yves: go to PDP of the product with sku:    M58314
#     Yves: add product to the shopping cart
#     Yves: go to the shopping cart through the header with name:    anotherApprovalCart+${random}
#     Yves: click on the 'Checkout' button in the shopping cart
#     Yves: billing address same as shipping address:    true
#     Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_with_limit_address}
#     Yves: select the following shipping method on the checkout and go next:    Express
#     Yves: select the following payment method on the checkout and go next:    Invoice
#     Yves: select approver on the 'Summary' page:    Lilu Dallas (€1,000.00)
#     Yves: 'send the request' on the summary page
#     Yves: 'Summary' page is displayed
#     Yves: 'Summary' page contains/doesn't contain:    true    ${cancelRequestButton}    ${alertWarning}    ${quoteStatus}
#     Yves: logout on Yves as a customer
#     Yves: login on Yves with provided credentials:    ${yves_company_user_approver_email}
#     Yves: go to user menu:    Overview
#     Yves: 'Overview' page is displayed
#     Yves: go to user menu item in the left bar:    Shopping carts
#     Yves: 'Shopping Carts' page is displayed
#     Yves: the following shopping cart is shown:    approvalCart+${random}    Read-only
#     Yves: the following shopping cart is shown:    anotherApprovalCart+${random}    Read-only
#     Yves: shopping cart with name xxx has the following status:    approvalCart+${random}    Waiting
#     Yves: shopping cart with name xxx has the following status:    anotherApprovalCart+${random}    Waiting
#     Yves: go to the shopping cart through the header with name:    approvalCart+${random}
#     Yves: click on the 'Checkout' button in the shopping cart
#     Yves: 'Summary' page is displayed
#     Yves: 'approve the cart' on the summary page
#     Yves: 'Summary' page is displayed
#     Yves: 'Summary' page contains/doesn't contain:    false    ${cancelRequestButton}    ${alertWarning}
#     Yves: go to the 'Home' page
#     Yves: go to user menu:    Overview
#     Yves: 'Overview' page is displayed
#     Yves: go to user menu item in the left bar:    Shopping carts
#     Yves: 'Shopping Carts' page is displayed
#     Yves: the following shopping cart is shown:    approvalCart+${random}    Read-only
#     Yves: the following shopping cart is shown:    anotherApprovalCart+${random}    Read-only
#     Yves: shopping cart with name xxx has the following status:    approvalCart+${random}    Approved
#     Yves: shopping cart with name xxx has the following status:    anotherApprovalCart+${random}    Waiting
#     Yves: logout on Yves as a customer
#     Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_with_limit_email}
#     Yves: go to user menu item in the left bar:    Shopping carts
#     Yves: shopping cart with name xxx has the following status:    approvalCart+${random}    Approved
#     Yves: go to the shopping cart through the header with name:    approvalCart+${random}
#     Yves: shopping cart contains/doesn't contain the following elements:    true    ${lockedCart}
#     Yves: click on the 'Checkout' button in the shopping cart
#     Yves: 'Summary' page is displayed
#     Yves: Accept the Terms and Conditions:    true
#     Yves: 'submit the order' on the summary page
#     Yves: 'Thank you' page is displayed
