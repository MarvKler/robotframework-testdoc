*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_one    checkout    spryker-core-back-office    spryker-core    marketplace-merchantportal-core    cart    multiple-carts    marketplace-shipment    shipment    inventory-management
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
Login_during_checkout
    [Tags]    smoke
    Yves: go to the 'Home' page
    Yves: go to PDP of the product with sku:    ${bundled_product_3_concrete_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: proceed as a guest user and login during checkout:   ${yves_second_user_email}
    Yves: fill in the following new shipping address:
    ...    || salutation     | firstName                    | lastName                    | street        | houseNumber       | postCode     | city       | country     | company    | phone           | additionalAddress     ||
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
    [Tags]    glue    smoke
    Yves: go to the 'Home' page
    Yves: go to PDP of the product with sku:    ${bundled_product_3_concrete_sku}
    Yves: add product to the shopping cart
    Page Should Not Contain Element    ${pdp_add_to_wishlist_button}
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: signup guest user during checkout:    ${guest_user_first_name}    ${guest_user_last_name}    sonia+guest${random}@spryker.com    ${default_secure_password}    ${default_secure_password}
    Save the result of a SELECT DB query to a variable:    select registration_key from spy_customer where email = 'sonia+guest${random}@spryker.com'    confirmation_key
    API_test_setup
    I send a POST request:     /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"${confirmation_key}"}}}
    Yves: login after signup during checkout:    sonia+guest${random}@spryker.com    ${default_secure_password}
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
    [Teardown]    Zed: delete customer:    sonia+guest${random}@spryker.com

Guest_Checkout
    [Tags]    smoke    product-bundles    promotions-discounts    marketplace-promotions-discounts    order-management    marketplace-order-management    
    [Documentation]    Guest checkout with bundles, discounts and OMS
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: change product stock:    ${bundled_product_1_abstract_sku}    ${bundled_product_1_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_2_abstract_sku}    ${bundled_product_2_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_3_abstract_sku}    ${bundled_product_3_concrete_sku}    true    10
    ...    AND    Zed: create a discount and activate it:    voucher    Percentage    5    sku = '*'    guestTest${random}    discountName=Guest Voucher Code 5% ${random}
    ...    AND    Zed: create a discount and activate it:    cart rule    Percentage    10    sku = '*'    discountName=Guest Cart Rule 10% ${random}
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${bundleItemsSmall}
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to shopping cart page
    Yves: apply discount voucher to cart:    guestTest${random}
    Yves: shopping cart contains the following products:    ${bundle_product_concrete_sku}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: proceed with checkout as guest:    Mr    Guest    user    sonia+guest${random}@spryker.com
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName | lastName | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | Guest     | User     | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: get the last placed order ID of the customer by email:    sonia+guest${random}@spryker.com
    Zed: trigger all matching states inside xxx order:    ${zedLastPlacedOrder}    skip grace period
    Zed: trigger all matching states inside this order:    Pay
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: trigger all matching states inside this order:    skip picking
    Zed: trigger all matching states inside this order:    Ship
    Zed: trigger all matching states inside this order:    Stock update
    Zed: trigger all matching states inside this order:    Close
    [Teardown]    Run keywords    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate following discounts from Overview page:    Guest Voucher Code 5% ${random}    Guest Cart Rule 10% ${random}

Guest_Checkout_Addresses
    [Tags]    smoke    order-management    marketplace-order-management    product        
    [Documentation]    Guest checkout with different addresses and OMS
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    012
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: proceed with checkout as guest:    Mr    Guest    user    sonia+guest+new${random}@spryker.com
    Yves: billing address same as shipping address:    true
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
    Yves: select the following shipping method for the shipment:    2    Spryker Dummy Shipment    Express
    Yves: select the following shipping method for the shipment:    3    Spryker Drone Shipment    Air Sonic
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: get the last placed order ID of the customer by email:    sonia+guest+new${random}@spryker.com
    Zed: trigger all matching states inside xxx order:    ${zedLastPlacedOrder}    skip grace period
    Zed: trigger all matching states inside this order:    Pay
    Zed: billing address for the order should be:    First Last, Billing Street 123, 10247 Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    1    Dr First, Last, First Street, 1, Additional street, Spryker, 10247, Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    2    Dr First, Last, Second Street, 2, Additional street, Spryker, 10247, Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    3    Dr First, Last, Third Street, 3, Additional street, Spryker, 10247, Berlin, Germany
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: trigger all matching states inside this order:    skip picking
    Zed: trigger all matching states inside this order:    Ship
    Zed: trigger all matching states inside this order:    Stock update
    Zed: trigger all matching states inside this order:    Close
    [Teardown]    Run keywords    Yves: check if cart is not empty and clear it

Business_Unit_Address_on_Checkout
    [Tags]    company-account
    [Documentation]    Checks that business unit address can be used during checkout
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    businessAddressCart+${random}
    ...    AND    Yves: delete all user addresses
    Yves: go to PDP of the product with sku:    ${available_never_out_of_stock_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    businessAddressCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
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
    Yves: shipping address on the order details page is:    Mr. Armando Richi Spryker Systems GmbH Gurmont Str. 23 8002 Barcelona, Spain 3490284322

Request_for_Quote
    [Tags]    smoke    quotation-process    order-management    marketplace-order-management    agent-assist
    [Documentation]    Checks user can request and receive quote.
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: create new Zed user with the following data:    agent_quote+${random}@spryker.com   ${default_secure_password}   Request    Quote    Root group    This user is an agent in Storefront    en_US
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: delete all shopping carts
    Yves: delete all user addresses
    Yves: create new 'Shopping Cart' with name:    RfQCart+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${product_with_sale_price_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    RfQCart+${random}
    Yves: submit new request for quote
    Yves: click 'Send to Agent' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent_quote+${random}@spryker.com    ${default_secure_password}    agent_assist=${True}
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
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
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
    Yves: login on Yves with provided credentials:    agent_quote+${random}@spryker.com    ${default_secure_password}    agent_assist=${True}
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
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu:    Quote Requests
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Ready
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: click 'Convert to Cart' button on the 'Quote Request Details' page
    Yves: shopping cart contains product with unit price:    sku=${product_with_sale_price_concrete_sku}    productName=${product_with_sale_price_abstract_name}    productPrice=500
    Yves: shopping cart doesn't contain the following products:    ${one_variant_product_concrete_sku}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: checkout summary step contains product with unit price:    productName=${product_with_sale_price_abstract_name}    productPrice=500
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    agent_quote+${random}@spryker.com

Split_Delivery
    [Tags]    smoke    product
    [Documentation]    Checks split delivery in checkout
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: check if cart is not empty and clear it
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
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    3
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses

Checkout_Address_Management
    [Tags]    smoke
    [Documentation]    Bug: CC-30439. Checks that user can change address during the checkout and save new into the address book
    [Setup]    Run Keywords
    ...    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: delete all user addresses
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: create a new customer address in profile:     Mr    ${yves_user_first_name}    ${yves_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Yves: go to PDP of the product with sku:    ${available_never_out_of_stock_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    false
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: save new billing address to address book:    false
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_user_address}
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
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: billing address for the order should be:    New Billing, Changed Street 098, 09876 Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    1    Mr First, Last, Shipping Street, 7, Additional street, Spryker, 10247, Geneva, Switzerland
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: delete all user addresses

Click_and_collect
    [Tags]    smoke    product    product-approval-process    marketplace-product-approval-process    marketplace-product    marketplace-product-offer    marketplace-product-offer-prices    marketplace-merchant-portal-product-offer-management    product-offer-shipment    product-offer-shipment-availability
    [Documentation]    checks that product offer is successfully replaced with a target product offer
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate all discounts from Overview page
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Products
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku              | product name                 | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || clickCollectSku${random} | clickCollectProduct${random} | color                | white                       | black                        | series                | Ace Plus               ||
    MP: perform search by:    clickCollectProduct${random}
    MP: click on a table row that contains:     clickCollectSku${random}
    MP: fill abstract product required fields:
    ...    || product name                 | store | tax set           ||
    ...    || clickCollectProduct${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || abstract     | 1          | DE    | EUR      | 50            ||
    MP: save abstract product
    MP: click on a table row that contains:    clickCollectSku${random}
    MP: open concrete drawer by SKU:    clickCollectSku${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: click Action Button in a table for row that contains:     clickCollectSku${random}     Approve
    Trigger p&s
    MP: login on MP with provided credentials:    ${merchant_budget_cameras_email}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    clickCollectSku${random}-2
    MP: click on a table row that contains:    clickCollectSku${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku                           | store | stock quantity | service point      | services | shipment types  ||
    ...    || true      | clickCollectFirstSku${random}${random} | DE    | 100            | Spryker Main Store | Pickup   | pickup - Pickup ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | EUR      | 100           ||
    MP: save offer
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    clickCollectSku${random}-2
    MP: click on a table row that contains:    clickCollectSku${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku                            | store | stock quantity | shipment types      ||
    ...    || true      | clickCollectSecondSku${random}${random} | DE    | 100            | delivery - Delivery ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | EUR      | 150           ||
    MP: save offer
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    clickCollectSku${random}-2
    MP: click on a table row that contains:    clickCollectSku${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku                  | store | stock quantity | service point        | services | shipment types  ||
    ...    || true      | clickCollectThirdSku${random} | DE    | 100            | Spryker Berlin Store | Pickup   | pickup - Pickup ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | EUR      | 200           ||
    MP: save offer
    Trigger p&s
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Marketplace    Offers
    Zed: filter by merchant:    Budget Cameras
    Zed: table should contain:    clickCollectSku${random}-2
    Zed: click Action Button in a table for row that contains:     clickCollectSku${random}-2     View
    Zed: view offer page is displayed
    Zed: view offer product page contains:
    ...    || approval status | status | store | sku                        | merchant       | merchant sku                  | services                      | shipment types  ||
    ...    || Approved        | Active | DE    | clickCollectSku${random}-2 | Budget Cameras | clickCollectThirdSku${random} | Spryker Berlin Store - Pickup | pickup - Pickup ||
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:     clickCollectSku${random}    wait_for_p&s=true
    Yves: select xxx merchant's offer with price:    Budget Cameras    €100.00    wait_for_p&s=true
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to PDP of the product with sku:     clickCollectSku${random}
    Yves: select xxx merchant's offer with price:    Budget Cameras    €150.00
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: select multiple addresses from toggler
    Yves: select xxx shipment type for item number xxx:    shipment_type=Pickup    item_number=1
    Yves: select xxx shipment type for item number xxx:    shipment_type=Pickup    item_number=2
    Yves: check store availability for item number xxx:
    ...    || item_number | store              | availability ||
    ...    || 1           | Spryker Main Store | green        ||
    Yves: check store availability for item number xxx:
    ...    || item_number | store                | availability ||
    ...    || 1           | Spryker Berlin Store | green        ||
    Yves: check store availability for item number xxx:
    ...    || item_number | store              | availability ||
    ...    || 2           | Spryker Main Store | green        ||
    Yves: check store availability for item number xxx:
    ...    || item_number | store                | availability ||
    ...    || 2           | Spryker Berlin Store | green        ||
    Yves: select pickup service point store for item number xxx:
    ...    || item_number | store                ||
    ...    || 1           | Spryker Berlin Store ||
    Yves: select pickup service point store for item number xxx:
    ...    || item_number | store                ||
    ...    || 2           | Spryker Berlin Store ||
    Yves: 'billing same as shipping' checkbox should be displayed:    false
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Pickup    Free Pickup
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: checkout summary step contains product with unit price:    productName=clickCollectProduct${random}    productPrice=200.00
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €400.00
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    1
    Zed: billing address for the order should be:    First Last, Billing Street 123, 10247 Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    1    Spryker Berlin Store, Mr ${yves_user_first_name}, ${yves_user_last_name}, Julie-Wolfthorn-Straße, 1, 10115, Berlin, Germany
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 1          | Pickup          | Free Pickup     | €0.00          | ASAP                    ||
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: activate following discounts from Overview page:    	Free mobile phone    20% off cameras products    Free Acer M2610 product    Free delivery    10% off Intel products    5% off white products    Tuesday & Wednesday $5 off 5 or more    10% off $100+    Free smartphone    20% off cameras    Free Acer M2610    Free standard delivery    10% off Intel Core    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order
    ...    AND    Zed: go to second navigation item level:    Catalog    Products
    ...    AND    Zed: click Action Button in a table for row that contains:     clickCollectSku${random}     Deny
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: delete all user addresses
    ...    AND    Trigger p&s

Multiple_Merchants_Order
    [Tags]    product    marketplace-product    non-splittable-products    marketplace-product-offer    marketplace-product-offer-prices    product-offer-shipment
    [Documentation]    Checks that order with products and offers of multiple merchants could be placed and it will be split per merchant
    [Setup]    Run Keywords
    ...    MP: login on MP with provided credentials:    ${merchant_video_king_email}
    ...    AND    MP: change offer stock:
    ...    || offer   | stock quantity | is never out of stock ||
    ...    || offer30 | 10             | true                  ||
    ...    AND    MP: login on MP with provided credentials:    ${merchant_budget_cameras_email}
    ...    AND    MP: change offer stock:
    ...    || offer   | stock quantity | is never out of stock ||
    ...    || offer89 | 10             | true                  ||
    ...    AND    Trigger p&s
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: delete all user addresses
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: create a new customer address in profile:     Mr    ${yves_user_first_name}    ${yves_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: change product stock:    ${one_variant_product_of_main_merchant_abstract_sku}    ${one_variant_product_of_main_merchant_concrete_sku}    true    10    10
    Yves: login on Yves with provided credentials:    ${yves_user_email}
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
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_user_address}
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
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    3
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    ...    AND    Yves: delete all user addresses

Unique_URL
    [Tags]    shared-carts    persistent-cart-sharing
    [Documentation]
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
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
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete 'Shopping Cart' with name:    externalCart+${random}

Comments_in_Cart
    [Tags]    comments
    [Documentation]    Add comments to cart and verify comments in Yves and Zed
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: create new 'Shopping Cart' with name:    commentCart+${random}
    Yves: go to PDP of the product with sku:    ${bundled_product_3_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    commentCart+${random}
    Yves: add comment on cart:    abc${random}
    Yves: check comments are visible or not in cart:    true    abc${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_shared_permission_owner_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: go to order details page to check comment:    abc${random}    ${lastPlacedOrder}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: check comment appears at order detailed page in zed:    abc${random}    ${lastPlacedOrder}

Comment_Management_in_the_Cart
    [Tags]    comments
    [Documentation]    Editing and deleting comments in carts
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: create new 'Shopping Cart' with name:    commentManagement+${random}
    Yves: go to PDP of the product with sku:    ${bundled_product_3_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    commentManagement+${random}
    Yves: add comment on cart:    abc${random}
    Yves: check comments are visible or not in cart:    true    abc${random}
    Yves: edit comment on cart:    xyz${random}
    Yves: check comments are visible or not in cart:    true    xyz${random}
    Yves: delete comment on cart
    Yves: check comments are visible or not in cart:    false    xyz${random}
    [Teardown]    Run Keyword    Yves: delete 'Shopping Cart' with name:    commentManagement+${random}

Configurable_Product_Checkout
    [Tags]    product    configurable-product    prices
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate all discounts from Overview page
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses
    ...    AND    Yves: create a new customer address in profile:     Mr    ${yves_user_first_name}    ${yves_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${configureButton}
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 517        | 167        ||
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 389.50     | 249        ||
    Yves: save product configuration
    Yves: shopping cart contains product with unit price:    sku=${configurable_product_concrete_sku}    productName=${configurable_product_name}    productPrice=638.50
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_user_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €644.40
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: activate following discounts from Overview page:    	Free mobile phone    20% off cameras products    Free Acer M2610 product    Free delivery    10% off Intel products    5% off white products    Tuesday & Wednesday $5 off 5 or more    10% off $100+    Free smartphone    20% off cameras    Free Acer M2610    Free standard delivery    10% off Intel Core    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order

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
