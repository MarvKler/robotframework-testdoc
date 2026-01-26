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
    [Documentation]    Checks OMS and that Yves user and in Zed main merchant can create/execute returns.
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    returnCart+${random}
    Yves: go to PDP of the product with sku:    M90802
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M21711
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M90737
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M72843
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    returnCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    skip grace period
    Zed: trigger all matching states inside this order:    Pay
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    send to distribution
    Zed: trigger matching state of xxx merchant's shipment:    1    confirm at center
    Zed: trigger matching state of xxx merchant's shipment:    1    Ship
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    410083    108278
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    410083    108278
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Orders
    MP: wait for order to appear:    ${lastPlacedOrder}--${merchant_spryker_reference}
    MP: click on a table row that contains:    ${lastPlacedOrder}--${merchant_spryker_reference}
    MP: update order state using header button:    Execute return
    MP: order states on drawer should contain:    Returned
    MP: order states on drawer should contain:    Shipped
    Zed: login on Zed with provided credentials:    admin@spryker.com
    Zed: create a return for the following order and product in it:    ${lastPlacedOrder}    103838
    Zed: create new Zed user with the following data:    return+agent+${random}@spryker.com    ${default_secure_password}    Agent    Assist    Root group    This user is an agent in Storefront    en_US
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    return+agent+${random}@spryker.com    ${default_secure_password}    agent_assist=${True}
    Yves: as an agent login under the customer:    ${yves_company_user_buyer_email}
    Yves: go to user menu:    Order History
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    421426
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    421426
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    Execute return
    Zed: go to second navigation item level:    Sales    My Returns
    Zed: table should contain xxx N times:    ${lastPlacedOrder}    3
    Zed: view the latest return from My Returns:    ${lastPlacedOrder}
    Zed: return details page contains the following items:    421426
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu:    Order History
    Yves: 'Order History' page is displayed
    Yves: 'Order History' page contains the following order with a status:    ${lastPlacedOrder}    Returned
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: delete Zed user with the following email:    return+agent+${random}@spryker.com

Refunds
    [Documentation]    Checks that refund can be created for an item and the whole order of merchant
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate following discounts from Overview page:    20% off storage    10% off minimum order
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    refunds+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_of_main_merchant_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${multi_color_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${product_with_relations_related_products_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    refunds+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,762.85
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    skip grace period
    Zed: trigger all matching states inside this order:    Pay
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    send to distribution
    Zed: trigger matching state of xxx merchant's shipment:    1    confirm at center
    Zed: trigger matching state of order item inside xxx shipment:    107254    Ship
    Zed: trigger matching state of order item inside xxx shipment:    107254    Deliver
    Zed: trigger matching state of order item inside xxx shipment:    107254    Refund
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,559.56
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    Ship
    Zed: trigger matching state of xxx merchant's shipment:    1    Deliver
    Zed: trigger matching state of xxx merchant's shipment:    1    Refund
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €0.00
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: activate following discounts from Overview page:    20% off storage    10% off minimum order

Manage_Shipments
    [Documentation]    Checks create/edit shipment functions from backoffice
    [Setup]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts
    ...    AND    Yves: create new 'Shopping Cart' with name:    manageShipment+${random}
    Yves: go to PDP of the product with sku:    420575
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    420836
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    420845
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    manageShipment+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select delivery to multiple addresses
    Yves: fill in new delivery address for a product:
    ...    || product | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || 420575  | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in new delivery address for a product:
    ...    || product | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || 420836  | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in new delivery address for a product:
    ...    || product | salutation | firstName | lastName | street       | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || 420845  | Dr.        | First     | Last     | First Street | 1           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Dr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: click checkout button:    Next
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €86.99
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    1
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 1          | Hermes          | Next Day        | €15.00         | ASAP                    ||
    Zed: create new shipment inside the order:
    ...    || delivery address | salutation | first name | last name | email              | country | address 1     | address 2 | city   | zip code | shipment method | sku    ||
    ...    || New address      | Mr         | Evil       | Tester    | ${yves_user_email} | Austria | Hartmanngasse | 1         | Vienna | 1050     | DHL - Standard  | 420845 ||
    Zed: billing address for the order should be:    First Last, Billing Street 123, 10247 Berlin, Germany
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    2
    Zed: shipping address inside xxx shipment should be:    1    Dr First, Last, First Street, 1, Additional street, Spryker, 10247, Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    2    Mr Evil, Tester, Hartmanngasse, 1, 1050, Vienna, Austria
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 2          | DHL             | Standard        | €0.00          | ASAP                    ||
    Zed: edit xxx shipment inside the order:
    ...    || shipmentN | delivery address | salutation | first name | last name | email              | country | address 1     | address 2 | city   | zip code | shipment method | requested delivery date | sku    ||
    ...    || 2         | New address      | Mr         | Edit       | Shipment  | ${yves_user_email} | Germany | Hartmanngasse | 9         | Vienna | 0987     | DHL - Express   | 2025-01-25              | 420836 ||
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    3
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 2          | DHL             | Standard        |  €0.00         | ASAP                    ||
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 3          | DHL             | Express         |  €0.00         | 2025-01-25              ||
    Zed: xxx shipment should/not contain the following products:    1    true    420575
    Zed: xxx shipment should/not contain the following products:    1    false    420845
    Zed: xxx shipment should/not contain the following products:    2    true    420845
    Zed: xxx shipment should/not contain the following products:    3    true    420836
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €86.99
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all user addresses

Order_Cancellation
    [Documentation]    Check that customer is able to cancel order
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: delete all shopping carts
    Yves: delete all user addresses
    Yves: create new 'Shopping Cart' with name:    cancelationCart+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    cancelationCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: go to 'Order History' page
    Yves: get the last placed order ID by current customer
    Yves: cancel the order:    ${lastPlacedOrder}
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: wait for order item to be in state:    403125    cancelled
    ### NOT FINISHED AS NO REQUIREMENTS FOR MP CASE
    # Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    # Yves: create new 'Shopping Cart' with name:    cancelationCart+${random}
    # Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    # Yves: add product to the shopping cart
    # Yves: go to PDP of the product with sku:    ${multi_color_product_abstract_sku}
    # Yves: add product to the shopping cart
    # Yves: go to the shopping cart through the header with name:    cancelationCart+${random}
    # Yves: click on the 'Checkout' button in the shopping cart
    # Yves: billing address same as shipping address:    true
    # Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    # Yves: submit form on the checkout
    # Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    # Yves: submit form on the checkout
    # Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    # Yves: accept the terms and conditions:    true
    # Yves: 'submit the order' on the summary page
    # Yves: 'Thank you' page is displayed
    # Yves: go to 'Order History' page
    # Yves: get the last placed order ID by current customer
    # ### change the order state of one product ###
    # Zed: login on Zed with provided credentials:    ${zed_admin_email}
    # Zed: go to order page:    ${lastPlacedOrder}
    # Zed: trigger all matching states inside this order:    skip grace period
    # Zed: trigger matching state of order item inside xxx shipment:    403125    Pay
    # Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    # Yves: go to 'Order History' page
    # Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    # Yves: 'Order Details' page contains the cancel order button:    true
    # Zed: login on Zed with provided credentials:    ${zed_admin_email}
    # Zed: go to order page:    ${lastPlacedOrder}
    # Zed: trigger matching state of order item inside xxx shipment:    403125    Skip timeout
    # Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    # Yves: go to 'Order History' page
    # Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    # Yves: 'Order Details' page contains the cancel order button:    false
    # ### change state of state of all products ###
    # Zed: login on Zed with provided credentials:    ${zed_admin_email}
    # Zed: go to order page:    ${lastPlacedOrder}
    # Zed: trigger matching state of order item inside xxx shipment:    107254    Pay
    # Zed: trigger matching state of order item inside xxx shipment:    107254    Skip timeout
    # Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    # Yves: go to 'Order History' page
    # Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    # Yves: 'Order Details' page contains the cancel order button:    false
    # ### try to cancel order of another customer ###
    # Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    # Yves: delete all shopping carts
    # Yves: delete all user addresses
    # Yves: create new 'Shopping Cart' with name:    cancelationCart+${random}
    # Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    # Yves: add product to the shopping cart
    # Yves: go to the shopping cart through the header with name:    cancelationCart+${random}
    # Yves: click on the 'Checkout' button in the shopping cart
    # Yves: billing address same as shipping address:    true
    # Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    # Yves: submit form on the checkout
    # Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    # Yves: submit form on the checkout
    # Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    # Yves: accept the terms and conditions:    true
    # Yves: 'submit the order' on the summary page
    # Yves: 'Thank you' page is displayed
    # Yves: go to 'Order History' page
    # Yves: get the last placed order ID by current customer
    # Yves: login on Yves with provided credentials:    ${yves_user_email}
    # Yves: go to 'Order History' page
    # Yves: filter order history by business unit:    Company Orders
    # Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    # Yves: 'Order Details' page contains the cancel order button:    false
    # [Teardown]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    # ...    AND    Yves: delete all shopping carts

Comment_Management_in_Order
    [Documentation]    Add comments in Yves and check in Zed
    Yves: login on Yves with provided credentials:    ${yves_company_user_shared_permission_owner_email}
    Yves: create new 'Shopping Cart' with name:    comments+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    comments+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_shared_permission_owner_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: go to 'Order History' page
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: add comment on order in order detail page:    abc${random}
    Yves: check comments is visible or not in order:    true    abc${random}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: check comment appears at order detailed page in zed:    abc${random}    ${lastPlacedOrder}
