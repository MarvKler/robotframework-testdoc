*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    return-management    checkout    cart    spryker-core    refunds


*** Test Cases ***
Create_a_return
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Cleanup all customer carts
    ### steps below just duplicate the order creation and status change. This is needed as we 'hack' the order status in the database. ###
    ### Needs to be done only once in the first test ###
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${cartId}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":"1"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [included][0][id]    item_id_return1   
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_return1}"]}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][orderReference]    order_reference
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...    AND    Update order status in Database:    shipped    ${uuid}
    ...    AND    Run Keyword And Ignore Error    I send a POST request:   /returns    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason.damaged}"}]}}}  
    ### steps below just duplicate the order creation and status change. This is needed as we 'hack' the order status in the database. ###
    ### Needs to be done only once in the first test ###      
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${cartId}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":"1"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [included][0][id]    item_id_return1   
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_return1}"]}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][orderReference]    order_reference
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...    AND    Update order status in Database:    shipped    ${uuid}
    When I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason.damaged}"}]}}}
    And Save value to a variable:    [data][id]    returnId
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_user.reference}
    And Response body parameter should be:
    ...    [data][attributes][returnTotals][remunerationTotal]
    ...    ${refundable_amount}
    And Response body has correct self link for created entity:    ${returnId}

Retrieves_return_by_id_with_returns_items_included
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":"1"}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete.available_product.with_stock.product_1.sku}"]}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...    AND    Update order status in Database:    shipped    ${uuid}
    ...    AND    I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason.damaged}"}]}}}
    ...    AND    Save value to a variable:    [data][id]    returnId
    When I send a GET request:    /returns/${returnId}?include=return-items
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should be:    [data][id]    ${returnId}
    And Response body parameter should be:    [data][attributes][returnReference]    ${returnId}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_user.reference}
    And Response body parameter should be:
    ...    [data][attributes][returnTotals][remunerationTotal]
    ...    ${refundable_amount}
    And Response should contain the array larger than a certain size:    [included]    0
    And Response should contain the array larger than a certain size:    [data][relationships]    0
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][return-items]
    And Each array element of array in response should contain property:
    ...    [data][relationships][return-items][data]
    ...    type
    And Each array element of array in response should contain property:
    ...    [data][relationships][return-items][data]
    ...    id
    And Response body parameter should not be EMPTY:    [included]
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Each array element of array in response should contain nested property:    [included]    [attributes]    uuid
    And Each array element of array in response should contain property with value:
    ...    [included]
    ...    type
    ...    return-items
    And Each array element of array in response should contain property with value in:
    ...    [included]
    ...    [attributes][orderItemUuid]
    ...    ${Uuid}
    ...    ${Uuid}
    And Each array element of array in response should contain property with value in:
    ...    [included]
    ...    [attributes][reason]
    ...    ${return_reason.damaged}
    ...    ${return_reason.damaged}
    And Response body has correct self link internal

Retrieves_list_of_returns
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":"1"}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete.available_product.with_stock.product_1.sku}"]}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Update order status in Database:    shipped    ${uuid}
    ...    AND    I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason.damaged}"}]}}}
    When I send a GET request:    /returns
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property with value:    [data]    type    returns
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    links
    And Each array element of array in response should contain nested property:
    ...    [data]
    ...    [attributes]
    ...    returnReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    store
    And Each array element of array in response should contain nested property:
    ...    [data]
    ...    [attributes]
    ...    customerReference
    And Each array element of array in response should contain nested property:
    ...    [data]
    ...    [attributes]
    ...    returnTotals
    And Each array element of array in response should contain nested property:
    ...    [data]
    ...    [attributes][returnTotals]
    ...    refundTotal
    And Each array element of array in response should contain nested property:
    ...    [data]
    ...    [attributes][returnTotals]
    ...    remunerationTotal
    And Response body has correct self link
