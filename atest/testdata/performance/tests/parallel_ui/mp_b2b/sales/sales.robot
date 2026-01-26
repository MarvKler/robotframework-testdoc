*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_tree
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
    [Documentation]    Checks OMS and that Yves user and in Zed main merchant can create/execute returns.
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Create dynamic admin user in DB
    ...    AND    Zed: create dynamic merchant user:    Spryker
    ...    AND    Zed: create dynamic merchant user:    merchant=Spryker    merchant_user_group=Root group
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    M90802
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M21711
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M90737
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M72843
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_spryker_second_merchant}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    skip grace period
    Zed: trigger all matching states inside this order:    Pay
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    send to distribution
    Zed: trigger matching state of xxx merchant's shipment:    1    confirm at center
    Zed: trigger matching state of xxx merchant's shipment:    1    Ship
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    410083    108278
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    410083    108278
    MP: login on MP with provided credentials:    ${dynamic_spryker_merchant}
    MP: open navigation menu tab:    Orders
    MP: wait for order to appear:    ${lastPlacedOrder}--${merchant_spryker_reference}
    MP: click on a table row that contains:    ${lastPlacedOrder}--${merchant_spryker_reference}
    MP: update order state using header button:    Execute return
    MP: order states on drawer should contain:    Returned
    MP: order states on drawer should contain:    Shipped
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create a return for the following order and product in it:    ${lastPlacedOrder}    103838
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    ${dynamic_admin_user}    agent_assist=${True}
    Yves: as an agent login under the customer:    ${dynamic_customer}
    Yves: go to user menu:    Order History
    Yves: 'View Order/Reorder/Return' on the order history page:     Return    ${lastPlacedOrder}
    Yves: 'Create Return' page is displayed
    Yves: create return for the following products:    421426
    Yves: 'Return Details' page is displayed
    Yves: check that 'Print Slip' contains the following products:    421426
    Zed: login on Zed with provided credentials:    ${dynamic_spryker_second_merchant}
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    Execute return
    Zed: go to second navigation item level:    Sales    My Returns
    Zed: table should contain xxx N times:    ${lastPlacedOrder}    3
    Zed: view the latest return from My Returns:    ${lastPlacedOrder}
    Zed: return details page contains the following items:    421426
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to user menu:    Order History
    Yves: 'Order History' page is displayed
    Yves: 'Order History' page contains the following order with a status:    ${lastPlacedOrder}    Returned
    [Teardown]    Delete dynamic admin user from DB

Order_Cancellation
    [Documentation]    Check that customer is able to cancel order
    Create dynamic admin user in DB
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
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
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
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
    [Teardown]    Delete dynamic admin user from DB

Comment_Management_in_Order
    [Documentation]    Add comments in Yves and check in Zed
    Create dynamic admin user in DB
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
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
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: check comment appears at order detailed page in zed:    abc${random}    ${lastPlacedOrder}
    [Teardown]    Delete dynamic admin user from DB
