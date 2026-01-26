*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_two
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/common/common_mp.robot
Resource    ../../../../resources/steps/mp_offers_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../resources/steps/mp_orders_steps.robot

*** Test Cases ***
Fulfill_Order_from_Merchant_Portal
    [Documentation]    Checks that merchant is able to process his order through OMS from merchant portal
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Zed: create dynamic merchant user:    Computer Experts
    ...    AND    Zed: create dynamic merchant user:    Office King
    ...    AND    MP: login on MP with provided credentials:    ${dynamic_expert_merchant}
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer395 | 10             | true                  ||
    ...    AND    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer193 | 10             | true                  ||
    ...    AND    MP: change offer stock:
    ...    || offer    | stock quantity | is never out of stock ||
    ...    || offer220 | 10             | true                  ||
    ...    AND    Create dynamic customer in DB
    ...    AND    Trigger p&s
    ...    AND    Deactivate all discounts in the database
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     ${product_with_multiple_offers_abstract_sku}
    Yves: add product to the shopping cart
    Yves: select xxx merchant's offer:    Computer Experts
    Yves: add product to the shopping cart
    Yves: select xxx merchant's offer:    Office King
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:     M22660
    Yves: select xxx merchant's offer:    Office King
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}     Office King
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}     Computer Experts
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method for the shipment:    1    DHL    Standard    
    Yves: select the following shipping method for the shipment:    2    Hermes    Same Day
    Yves: select the following shipping method for the shipment:    3    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    skip grace period
    Zed: trigger all matching states inside this order:    Pay 
    Zed: wait for order item to be in state:    ${product_with_multiple_offers_concrete_sku}    sent to merchant    2
    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    MP: open navigation menu tab:    Orders    
    MP: wait for order to appear:    ${lastPlacedOrder}--${merchant_office_king_reference}
    MP: click on a table row that contains:    ${lastPlacedOrder}--${merchant_office_king_reference}
    MP: order grand total should be:    €32.78
    MP: update order state using header button:    Ship
    MP: order states on drawer should contain:    Shipped
    MP: switch to the tab:    Items
    MP: change order item state on:    423172    Deliver
    MP: switch to the tab:    Items
    MP: order item state should be:    427915    shipped
    MP: order item state should be:    423172    delivered
    MP: update order state using header button:    Deliver
    MP: order states on drawer should contain:    Delivered
    MP: switch to the tab:    Items
    MP: order item state should be:    427915    delivered
    MP: order item state should be:    423172    delivered
    [Teardown]    Delete dynamic admin user from DB