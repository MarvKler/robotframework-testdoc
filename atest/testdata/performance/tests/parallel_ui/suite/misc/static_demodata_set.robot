*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    static-set    spryker-core-back-office    spryker-core
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/minimum_order_value_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../resources/steps/warehouse_user_assignment_steps.robot
Resource    ../../../../resources/steps/zed_users_steps.robot
Resource    ../../../../resources/steps/picking_list_steps.robot
Resource    ../../../../resources/steps/zed_availability_steps.robot
Resource    ../../../../resources/steps/zed_discount_steps.robot

*** Test Cases ***
Minimum_Order_Value
    [Tags]    order-threshold    cart    checkout
    [Documentation]    checks that global minimum and maximum order thresholds can be applied
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Deactivate all discounts in the database
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: change global threshold settings:
    ...    || store & currency | minimum hard value | minimum hard en message  | minimum hard de message  | maximum hard value | maximum hard en message | maximum hard de message | soft threshold                | soft threshold value | soft threshold fixed fee | soft threshold en message | soft threshold de message ||
    ...    || DE - Euro [EUR]  | 5                  | EN minimum {{threshold}} | DE minimum {{threshold}} | 150                | EN max {{threshold}}    | DE max {{threshold}}    | Soft Threshold with fixed fee | 100000               | 9                        | EN fixed {{fee}} fee      | DE fixed {{fee}} fee      ||
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    005
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    ${available_never_out_of_stock_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: soft threshold surcharge is added in the cart:    €9.00
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Spryker Dummy Shipment    Standard
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: soft threshold surcharge is added on summary page:    €9.00
    Yves: hard threshold is applied with the following message:    €150.00
    Yves: go to shopping cart page
    Yves: delete product from the shopping cart with sku:    ${available_never_out_of_stock_concrete_sku}
    Yves: soft threshold surcharge is added in the cart:    €9.00
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: soft threshold surcharge is added on summary page:    €9.00
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €83.90
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: change global threshold settings:
    ...    || store & currency | minimum hard value | minimum hard en message | minimum hard de message | maximum hard value | maximum hard en message                                                                                   | maximum hard de message                                                                                                              | soft threshold | soft threshold value | soft threshold en message | soft threshold de message ||
    ...    || DE - Euro [EUR]  | ${SPACE}           | ${SPACE}                | ${SPACE}                | 10000.00           | The cart value cannot be higher than {{threshold}}. Please remove some items to proceed with the order    | Der Warenkorbwert darf nicht höher als {{threshold}} sein. Bitte entfernen Sie einige Artikel, um mit der Bestellung fortzufahren    | None           | ${EMPTY}             | ${EMPTY}                  | ${EMPTY}                  ||
    ...    AND    Delete dynamic admin user from DB

Fulfillment_app_e2e
    [Tags]   smoke    cart    warehouse-user-management    warehouse-picking    checkout    order-management    state-machine    order-amendment    marketplace-order-management    inventory-management
    # #LOGGED IN TO BO and SET CHECKBOX is a warehouse user = true FOR admin_de USER. UI TEST
    Remove all warehouse user assignments by user uuid:    ${warehouse_user[0].de_admin_user_uuid}
    Make user a warehouse user/ not a warehouse user:    ${warehouse_user[0].de_admin_user_uuid}    0
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: update Zed user:
    ...    || oldEmail             | user_is_warehouse_user ||
    ...    || admin_de@spryker.com | true                   ||
    Remove Tags    *
    Set Tags   bapi
    API_test_setup
    # #ASSIGN admin_de user TO WAREHOUSE [Spryker Mer 000001 Warehouse 1] MAKE WAREHOUSE ACTIVE BY BAPI
    And I get access token by user credentials:   ${zed_admin_email}
    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehouse_user[0].de_admin_user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"true"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assignment_id  
    # #CREATE AN ORDER BY GLUE
    I set Headers:    Content-Type=${default_header_content_type}
    Remove Tags    *
    Set Tags    glue
    API_test_setup
    When I get access token for the customer:    ${yves_user_email}    
    Then I set Headers:    Authorization=${token}
    When Find or create customer cart
    Then Cleanup all items in the cart:    ${cart_id}
    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "091_25873091","quantity": 1}}}
    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "092_24495842","quantity": 1}}}
    I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"payments": [{"paymentProviderName": "${payment_provider_name_1}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["091_25873091","092_24495842"]}}}
    Then Response status code should be:    200
    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user_email}","salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user_salutation}","firstName": "${yves_user_first_name}","lastName": "${yves_user_last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment_provider_name_1}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["091_25873091","092_24495842"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    And Save value to a variable:    [included][0][attributes][items][1][uuid]    uuid1
    # #MOVE ORDER ITEMS INTO WAITING STATE
    UI_test_setup
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: get the last placed order ID by current customer
    Trigger oms
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    skip grace period
    Zed: trigger all matching states inside this order:    Pay 
    Zed: wait for order item to be in state:    091_25873091    confirmed
    Zed: wait for order item to be in state:    092_24495842    confirmed
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: wait for order item to be in state:    091_25873091    waiting
    Zed: wait for order item to be in state:    092_24495842    waiting
    # #MOVE ORDER ITEMS TO PROPER STATE USING BO, PICKING LIST GENERATED AUTOMATICALLY. UI TEST
    Zed: trigger all matching states inside this order:    picking list generation schedule
    Zed: wait for order item to be in state:    091_25873091    picking list generation started
    Zed: wait for order item to be in state:    092_24495842    picking list generation started
    # #ORDER READY FOR PICKING
    Zed: wait for order item to be in state:    091_25873091    ready for picking
    Zed: wait for order item to be in state:    092_24495842    ready for picking
    # #START PICKING PROCESS AND PICKING ITEMS BY BAPI
    Remove Tags    *
    Set Tags   bapi
    API_test_setup
    I set Headers:    Content-Type=${default_header_content_type}
    Then I get access token by user credentials:   ${zed_admin_email_de}
    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    I send a GET request:    /picking-lists/?include=picking-list-items,concrete-products,sales-shipments,sales-orders,warehouses
    Then Response status code should be:    200
    Then Save value to a variable:    [data][0][id]    picklist_id
    And Response body parameter should be:    [data][0][type]    picking-lists
    Then Save value to a variable:    [data][0][relationships][picking-list-items][data][0][id]    item_id_1
    Then Save value to a variable:    [data][0][relationships][picking-list-items][data][1][id]    item_id_2
    And Response body parameter should be:    [data][0][attributes][status]    ready-for-picking
    And Response body parameter should be in:    [included][0][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
    And Response body parameter should be in:    [included][1][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
    And Response body parameter should be in:    [included][2][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
    And Response body parameter should be in:    [included][3][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
    And Response body parameter should be in:    [included][4][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
    And Response body parameter should be in:    [included][5][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
    And Response body parameter should be in:    [included][6][type]    concrete-products    sales-orders    sales-shipments    picking-list-items    warehouses
    And Each array in response should contain property with NOT EMPTY value:    [included]    id
    # #START PICKING
    I send a POST request:   /picking-lists/${picklist_id}/start-picking    {"data": [{"type": "picking-lists","attributes": {"action": "startPicking"}}]}
    Then Response status code should be:    201
    And Response body parameter should be:    [data][attributes][status]    picking-started
    And Response body parameter should be:    [data][type]    picking-lists
    And Response body parameter should not be EMPTY:    [data][id]
    # #PICKING ONE ITEM, ANOTHER ITEM STILL NOT PICKED
    Then I send a PATCH request:    /picking-lists/${picklist_id}/picking-list-items    {"data":[{"id":"${item_id_1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item_id_2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":0}}]}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][attributes][status]    picking-started
    And Response body parameter should be in:    [data][0][relationships][picking-list-items][data][0][id]    ${item_id_1}    ${item_id_2}
    And Response body parameter should be in:    [data][0][relationships][picking-list-items][data][1][id]    ${item_id_1}    ${item_id_2}
    # #PICKING SECOND ITEM, PICKING FINISHED
    Then I send a PATCH request:    /picking-lists/${picklist_id}/picking-list-items    {"data":[{"id":"${item_id_1}","type":"picking-list-items","attributes":{"numberOfPicked":1,"numberOfNotPicked":0}},{"id":"${item_id_2}","type":"picking-list-items","attributes":{"numberOfPicked":0,"numberOfNotPicked":1}}]}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][attributes][status]    picking-finished
    # #CLEAN SYSTEM, REMOVE CREATED RELATIONS IN DB
    [Teardown]     Run Keywords    Remove picking list item by uuid in DB:    ${item_id_1}
    ...  AND    Remove picking list item by uuid in DB:    ${item_id_2} 
    ...  AND    Remove picking list by uuid in DB:    ${picklist_id}
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].de_admin_user_uuid}    0
    ...  AND    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assignment_id}     

Discounts
    [Tags]    smoke    group_tree    promotions-discounts    marketplace-promotions-discounts    cart    checkout    shipment
    [Documentation]    Discounts, Promo Products, and Coupon Codes (includes guest checkout)
    [Setup]    Run keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Deactivate all discounts in the database
    ...    AND    Zed: change product stock:    190    190_25111746    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_1_abstract_sku}    ${bundled_product_1_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_2_abstract_sku}    ${bundled_product_2_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_3_abstract_sku}    ${bundled_product_3_concrete_sku}    true    10
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create a discount and activate it:    voucher    Percentage    5    sku = '*'    test${random}    discountName=Voucher Code 5% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    10    sku = '*'    discountName=Cart Rule 10% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    100    discountName=Promotional Product 100% ${random}    promotionalProductDiscount=True    promotionalProductAbstractSku=002    promotionalProductQuantity=2
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    190
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to shopping cart page
    Yves: apply discount voucher to cart:    test${random}
    Yves: discount is applied:    voucher    Voucher Code 5% ${random}    - €8.73
    Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €17.46
    Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €87.96
    Yves: promotional product offer is/not shown in cart:    true
    Yves: add promotional product to the cart
    Yves: shopping cart contains the following products:    190_25111746    002_25904004
    Yves: discount is applied:    cart rule    Promotional Product 100% ${random}    - €75.00
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: select xxx shipment type on checkout:    Delivery
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping':    ${default_address.full_address}
    Yves: select xxx shipment type on checkout:    Delivery
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Spryker Dummy Shipment    Standard
    Yves: select the following shipping method for the shipment:    2    Spryker Dummy Shipment    Express
    Yves: select the following shipping method for the shipment:    3    Spryker Drone Shipment    Air Light
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €773.45
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: deactivate following discounts from Overview page:    Voucher Code 5% ${random}    Cart Rule 10% ${random}    Promotional Product 100% ${random}
    ...    AND    Delete dynamic admin user from DB