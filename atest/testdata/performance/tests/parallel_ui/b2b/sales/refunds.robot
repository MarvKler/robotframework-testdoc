*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_tree
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot

*** Test Cases ***
Refunds
    [Documentation]    Checks that refund can be created for an item and the whole order
    [Setup]    Run keywords    Create dynamic admin user in DB
    ...    AND    Deactivate all discounts in the database
    ...    AND    Create dynamic customer in DB   
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${multi_color_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${product_with_relations_related_products_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,366.16
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    skip grace period
    Zed: trigger all matching states inside this order:    Pay
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: trigger matching state of order item inside xxx shipment:    107254    Ship
    Zed: trigger matching state of order item inside xxx shipment:    107254    Stock
    Zed: trigger matching state of order item inside xxx shipment:    107254    Refund
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €1,162.87
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Ship
    Zed: trigger all matching states inside this order:    Stock update
    Zed: trigger all matching states inside this order:    Refund
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €0.00
    [Teardown]    Delete dynamic admin user from DB