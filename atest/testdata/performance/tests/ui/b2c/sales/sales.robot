*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_tree
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
Return_Management
    [Documentation]    Checks that returns work and oms process is checked. DMS-ON: https://spryker.atlassian.net/browse/FRW-7463
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    008
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    010
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
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
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    skip grace period
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: trigger all matching states inside this order:    skip picking
    Zed: trigger all matching states inside this order:    Ship
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to user menu:    Orders History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    010_30692994
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    010_30692994
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create a return for the following order and product in it:    ${lastPlacedOrder}    007_30691822
    Zed: create new Zed user with the following data:    returnagent+${random}@spryker.com    ${default_secure_password}    Agent    Assist    Root group    This user is an agent    en_US
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    returnagent+${random}@spryker.com    ${default_secure_password}    agent_assist=${True}
    Yves: as an agent login under the customer:    ${yves_user_email}
    Yves: go to user menu:    Orders History
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    008_30692992
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    008_30692992
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Execute return
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to user menu:    Orders History
    Yves: 'Order History' page is displayed
    Yves: 'Order History' page contains the following order with a status:    ${lastPlacedOrder}    Returned
    [Teardown]    Run Keywords    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    returnagent+${random}@spryker.com

Refunds
    [Documentation]    Checks that refund can be created for one item and the whole order. DMS-ON: https://spryker.atlassian.net/browse/FRW-7463
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate all discounts from Overview page
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    008
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    010
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €394.41
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    skip grace period
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: trigger all matching states inside this order:    skip picking
    Zed: trigger matching state of order item inside xxx shipment:    008_30692992    Ship
    Zed: trigger matching state of order item inside xxx shipment:    008_30692992    Stock
    Zed: trigger matching state of order item inside xxx shipment:    008_30692992    Refund
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €265.03
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Ship
    Zed: trigger all matching states inside this order:    Stock update
    Zed: trigger all matching states inside this order:    Refund
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €0.00
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: activate following discounts from Overview page:    Tu & Wed $5 off 5 or more    10% off $100+    20% off cameras    Tu & Wed €5 off 5 or more    10% off minimum order

Manage_Shipments
    [Documentation]    Checks create/edit shipment functions from backoffice
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: delete all user addresses
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
    ...    || product        | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Canon IXUS 175 | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in new delivery address for a product:
    ...    || product        | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Canon IXUS 165 | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €225.87
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    1
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 1          | Hermes          | Next Day        | €15.00         | ASAP                    ||
    Zed: create new shipment inside the order:
    ...    || delivery address | salutation | first name | last name | email              | country | address 1     | address 2 | city   | zip code | shipment method | sku          ||
    ...    || New address      | Mr         | Evil       | Tester    | ${yves_user_email} | Austria | Hartmanngasse | 1         | Vienna | 1050     | DHL - Standard  | 012_25904598 ||
    Zed: billing address for the order should be:    First Last, Billing Street 123, 10247 Berlin, Germany
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    2
    Zed: shipping address inside xxx shipment should be:    1    Dr First, Last, First Street, 1, Additional street, Spryker, 10247, Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    2    Mr Evil, Tester, Hartmanngasse, 1, 1050, Vienna, Austria
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 2          | DHL             | Standard        | €0.00          | ASAP                    ||
    Zed: edit xxx shipment inside the order:
    ...    || shipmentN | delivery address | salutation | first name | last name | email              | country | address 1     | address 2 | city   | zip code | shipment method | requested delivery date | sku          ||
    ...    || 2         | New address      | Mr         | Edit       | Shipment  | ${yves_user_email} | Germany | Hartmanngasse | 9         | Vienna | 0987     | DHL - Express   | 2025-01-25              | 005_30663301 ||
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    3
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 2          | DHL             | Standard        |  €0.00         | ASAP                    ||
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 3          | DHL             | Express         |  €0.00         | 2025-01-25              ||
    Zed: xxx shipment should/not contain the following products:    1    true    007_30691822
    Zed: xxx shipment should/not contain the following products:    1    false    012_25904598
    Zed: xxx shipment should/not contain the following products:    2    true    012_25904598
    Zed: xxx shipment should/not contain the following products:    3    true    005_30663301
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €225.87
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses

Order_Cancellation
    [Documentation]    Check that customer is able to cancel order.
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: check if cart is not empty and clear it
    Yves: delete all user addresses
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: go to 'Order History' page
    Yves: get the last placed order ID by current customer
    Yves: cancel the order:    ${lastPlacedOrder}
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: wait for order item to be in state:    005_30663301    cancelled
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:    005_30663301
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    007_30691822
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: go to 'Order History' page
    Yves: get the last placed order ID by current customer
    ### change the order state of one product ###
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    skip grace period
    Zed: trigger matching state of order item inside xxx shipment:    005_30663301    Pay
    Zed: trigger matching state of order item inside xxx shipment:    005_30663301    Skip timeout
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to 'Order History' page
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page contains the cancel order button:    false
    ### change state for all products ###
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger matching state of order item inside xxx shipment:    007_30691822    Pay
    Zed: trigger matching state of order item inside xxx shipment:    007_30691822    Skip timeout
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to 'Order History' page
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page contains the cancel order button:    false
    [Teardown]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses

Configurable_Product_OMS
    [Documentation]    Conf Product OMS check and reorder.
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses
    ...    AND    Yves: create a new customer address in profile:     Mr    ${yves_user_first_name}    ${yves_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: change variant of the product on PDP on:    ${configurable_product_concrete_one_attribute}
    Yves: change the product options in configurator to:
    ...    || option one | option two | option three |option four | option five | option six | option seven | option eight | option nine | option ten       ||
    ...    || 517        | 473        | €0.00        | 0.00       |  51         | 19         | 367          | 46           | 72          | English Keyboard ||
    Yves: save product configuration
    Yves: add product to the shopping cart
    Yves: reset selected variant of the product on PDP
    Yves: change variant of the product on PDP on:    ${configurable_product_concrete_two_attribute}
    Yves: change the product options in configurator to:
    ...    || option one | option two | option three |option four | option five | option six | option seven | option eight | option nine | option ten      ||
    ...    || 905        | 249        | 100          | 36         |  15         | 0.00       | 48           | 57           | 36          | German Keyboard ||
    Yves: save product configuration
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: configuration should be equal:
    ...    || date       | date_time ||
    ...    || 12.12.2030 | Evening   ||
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_user_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: product configuration should be equal:
    ...    || shipment | position | sku                                      | GPU                                 ||
    ...    || 1        | 1        | ${configurable_product_concrete_one_sku} | NVIDIA GeForce GTX 1650Ti 4GB GDDR6 ||
    Zed: product configuration should be equal:
    ...    || shipment | position | sku                                      | GPU                  ||
    ...    || 1        | 2        | ${configurable_product_concrete_two_sku} | AMD Radeon RX Vega 6 ||
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    skip grace period
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Skip timeout
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    skip picking
    Zed: trigger matching state of xxx order item inside xxx shipment:    Ship    2
    Zed: trigger matching state of xxx order item inside xxx shipment:    Stock-update    2
    Zed: trigger matching state of xxx order item inside xxx shipment:    Refund    2
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx order item inside xxx shipment:    Ship    1
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to user menu:    Orders History
    Yves: 'Order History' page is displayed
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    ${configurable_product_concrete_one_sku}
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    ${configurable_product_concrete_one_sku}
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Execute return
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to user menu:    Orders History
    ### Reorder ###
    Yves: 'View Order/Reorder/Return' on the order history page:    Reorder    ${lastPlacedOrder}
    Yves: go to shopping cart page
    Yves: shopping cart contains the following products:     ${configurable_product_name}
    Yves: product configuration status should be equal:       Configuration is not complete.
    [Teardown]    Yves: check if cart is not empty and clear it
