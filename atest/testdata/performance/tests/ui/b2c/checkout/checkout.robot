*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_two
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
Split_Delivery
    [Documentation]    Checks split delivery in checkout and check dashboard graph created in zed.
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
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: select the following shipping method for the shipment:    2    Hermes    Same Day
    Yves: select the following shipping method for the shipment:    3    DHL    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    3
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses

Guest_Checkout
    [Documentation]    Guest checkout with bundles, discounts and OMS. DMS-ON: https://spryker.atlassian.net/browse/FRW-7463
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
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    008
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: apply discount voucher to cart:    guestTest${random}
    Yves: shopping cart contains the following products:    ${bundle_product_product_name}
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
    Zed: trigger all matching states inside xxx order:    ${zedLastPlacedOrder}    Pay
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: trigger all matching states inside this order:    skip picking
    Zed: trigger all matching states inside this order:    Ship
    Zed: trigger all matching states inside this order:    Stock update
    Zed: trigger all matching states inside this order:    Close
    [Teardown]    Run keywords    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate following discounts from Overview page:    Guest Voucher Code 5% ${random}    Guest Cart Rule 10% ${random}

Guest_Checkout_Addresses
    [Documentation]    Guest checkout with different addresses and OMS. DMS-ON: https://spryker.atlassian.net/browse/FRW-7463
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
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: select the following shipping method for the shipment:    2    Hermes    Same Day
    Yves: select the following shipping method for the shipment:    3    DHL    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: get the last placed order ID of the customer by email:    sonia+guest+new${random}@spryker.com
    Zed: trigger all matching states inside xxx order:    ${zedLastPlacedOrder}    skip grace period
    Zed: trigger all matching states inside xxx order:    ${zedLastPlacedOrder}    Pay
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

Checkout_Address_Management
    [Documentation]    Bug: CC-30439. Checks that user can change address during the checkout and save new into the address book
    [Setup]    Run Keywords
    ...    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: delete all user addresses
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: create a new customer address in profile:     Mr    ${yves_user_first_name}    ${yves_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Yves: go to PDP of the product with sku:    007
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

Login_during_checkout
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
    [Tags]    glue
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

Configurable_Product_Checkout
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate all discounts from Overview page
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: create new 'Wishlist' with name:    configProduct${random}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses
    ...    AND    Yves: create a new customer address in profile:     Mr    ${yves_user_first_name}    ${yves_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: change variant of the product on PDP on:    ${configurable_product_concrete_one_attribute}
    Yves: PDP contains/doesn't contain:    true    ${configureButton}
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: change the product options in configurator to:
    ...    || option one | option two | option three |option four | option five | option six | option seven | option eight | option nine | option ten       ||
    ...    || 517        | 473        | 100          | 0.00       |  51         | 19         | 367          | 46           | 72          | English Keyboard ||
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    sku=${configurable_product_concrete_one_sku}    productName=${configurable_product_name}    productPrice=1,599.00
    Yves: change the product options in configurator to:
    ...    || option one | option two | option three |option four | option five | option six | option seven | option eight | option nine | option ten      ||
    ...    || 905        | 249        | 100          | 36         |  15         | 0.00       | 48           | 57           | 36          | German Keyboard ||
    Yves: save product configuration
    Yves: shopping cart contains product with unit price:    sku=${configurable_product_concrete_one_sku}    productName=${configurable_product_name}    productPrice=1,346.00
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:   ${yves_user_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,361.00
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    skip grace period
    Zed: trigger all matching states inside this order:    Pay
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: trigger all matching states inside this order:    skip picking
    Zed: trigger all matching states inside this order:    Ship
    Zed: trigger all matching states inside this order:    Stock update
    Zed: trigger all matching states inside this order:    Refund
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €0.00
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: activate following discounts from Overview page:    Free Acer Notebook    Tu & Wed $5 off 5 or more    10% off $100+    Free smartphone    20% off cameras    Free Acer M2610    Free standard delivery    10% off Intel Core    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order
