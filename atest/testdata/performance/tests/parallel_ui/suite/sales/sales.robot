*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_tree    spryker-core-back-office    spryker-core    cart    checkout    order-management    marketplace-order-management    state-machine    return-management    marketplace-return-management
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../resources/common/common_mp.robot
Resource    ../../../../resources/steps/mp_orders_steps.robot
Resource    ../../../../resources/steps/agent_assist_steps.robot
Resource    ../../../../resources/steps/order_comments_steps.robot

*** Test Cases ***
Return_Management
    [Documentation]    Checks that returns work and oms process is checked.
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Create dynamic admin user in DB
    ...    AND    Zed: create dynamic merchant user:    Spryker
    ...    AND    Zed: create dynamic merchant user:    merchant=Spryker    merchant_user_group=Root group
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    007
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    008
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    010
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    012
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_spryker_second_merchant}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    skip grace period
    Zed: trigger all matching states inside this order:    Pay
    Zed: trigger all matching states inside this order:    skip picking
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    send to distribution
    Zed: trigger matching state of xxx merchant's shipment:    1    confirm at center
    Zed: trigger matching state of xxx merchant's shipment:    1    Ship   
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Orders History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    010_30692994    007_30691822
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    010_30692994    007_30691822
    MP: login on MP with provided credentials:    ${dynamic_spryker_merchant}
    MP: open navigation menu tab:    Orders    
    MP: wait for order to appear:    ${lastPlacedOrder}--${merchant_spryker_reference}
    MP: click on a table row that contains:    ${lastPlacedOrder}--${merchant_spryker_reference}
    MP: update order state using header button:    Execute return
    MP: order states on drawer should contain:    Returned
    MP: order states on drawer should contain:    Shipped   
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create a return for the following order and product in it:    ${lastPlacedOrder}    012_25904598
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    ${dynamic_admin_user}    agent_assist=${True}
    Yves: as an agent login under the customer:    ${dynamic_customer}
    Yves: go to user menu:    Orders History
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    008_30692992
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    008_30692992
    Zed: login on Zed with provided credentials:    ${dynamic_spryker_second_merchant}
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    Execute return
    Zed: go to second navigation item level:    Sales    My Returns
    Zed: table should contain xxx N times:    ${lastPlacedOrder}    3
    Zed: view the latest return from My Returns:    ${lastPlacedOrder}
    Zed: return details page contains the following items:    008_30692992
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Orders History
    Yves: 'Order History' page is displayed
    Yves: 'Order History' page contains the following order with a status:    ${lastPlacedOrder}    Returned
    [Teardown]    Delete dynamic admin user from DB

Order_Cancellation
    [Documentation]    Check that customer is able to cancel order.
    Create dynamic admin user in DB
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Spryker Dummy Shipment    Standard
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed    
    Yves: go to 'Order History' page
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    skip grace period
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: cancel the order:    ${lastPlacedOrder}
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: wait for order item to be in state:    005_30663301    cancelled
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
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
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page contains the cancel order button:    true
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    skip grace period
    ### change the order state of one product ###
    Zed: trigger matching state of order item inside xxx shipment:    005_30663301    Pay
    Zed: trigger matching state of order item inside xxx shipment:    005_30663301    Skip timeout 
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to 'Order History' page
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page contains the cancel order button:    false
    ### change state for all products ###
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger matching state of order item inside xxx shipment:    007_30691822    Pay
    Zed: trigger matching state of order item inside xxx shipment:    007_30691822    Skip timeout
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to 'Order History' page
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page contains the cancel order button:    false
    [Teardown]    Delete dynamic admin user from DB

Comment_Management_in_Order
    [Documentation]    Add comments in Yves and check in Zed. 
    Create dynamic admin user in DB
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${bundled_product_3_abstract_sku}
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
    Yves: get the last placed order ID by current customer
    Yves: go to 'Order History' page
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: add comment on order in order detail page:    abc${random}
    Yves: check comments is visible or not in order:    true    abc${random}
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}    
    Zed: check comment appears at order detailed page in zed:    abc${random}    ${lastPlacedOrder}
    [Teardown]    Delete dynamic admin user from DB