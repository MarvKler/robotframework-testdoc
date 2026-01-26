*** Settings ***
Suite Setup       API_suite_setup
Test Tags      glue    marketplace-return-management    return-management    checkout    cart    spryker-core    refunds
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
### Important CHECKOUT and CHECKOUT-DATA endpoints require Item ID and NOT intem sku. To get item id and include to the cart endpoint.
### Example:
###I send a POST request:    /carts/${cartId}/items?include=items   {"data": {"type": "items","attributes": {"sku": "${concrete_product.random_weight.sku}","quantity": 1,"salesUnit": {"id": "${sales_unit_id}","amount": 5}}}}
### Save value to a variable:    [included][0][id]    test
### I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${test}"]}}}

#POST#
Create_a_return
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Cleanup all customer carts
    ### steps below just duplicate the order creation and status change. This is needed as we 'hack' the order status in the database. ###
    ### Needs to be done only once in the first test ###
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${CartId}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${concrete.available_product.with_stock_and_never_out_of_stock.sku}","quantity":"1"}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_id_return
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_return}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Update order status in Database:    shipped    ${uuid}
    ...    AND    Run Keyword And Ignore Error    I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    ### steps below just duplicate the order creation and status change. This is needed as we 'hack' the order status in the database. ###
    ### Needs to be done only once in the first test ###
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${CartId}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${concrete.available_product.with_stock_and_never_out_of_stock.sku}","quantity":"1"}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_id_return
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_return}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    productPrice
    ...    AND    Update order status in Database:    shipped    ${uuid}
    When I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    Then Save value to a variable:    [data][id]    returnId
    And Response status code should be:     201
    And Response reason should be:     Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should contain:    [data]    id
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_user.reference}
    And Response body parameter should be:    [data][attributes][returnTotals][refundTotal]    0
    And Response body parameter should be:    [data][attributes][returnTotals][remunerationTotal]    ${productPrice}
    And Response body has correct self link for created entity:    ${returnId}

Create_a_return_include_return_items
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${CartId}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${concrete.available_product.with_stock_and_never_out_of_stock.sku}","quantity":"1"}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_id_in_return
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_in_return}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    productPrice
    ...    AND    Update order status in Database:    shipped    ${uuid}
    When I send a POST request:     /returns?include=return-items     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    Then Response status code should be:     201
    And Response reason should be:     Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should contain:    [data]    id
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_user.reference}
    And Response body parameter should be:    [data][attributes][returnTotals][refundTotal]    0
    And Response body parameter should be:    [data][attributes][returnTotals][remunerationTotal]    ${productPrice}
    And Response body parameter should contain:    [data]    relationships
    And Response body parameter should be:    [data][relationships][return-items][data][0][type]    return-items
    And Response body parameter should contain:    [data][relationships][return-items][data][0]    id
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should be:    [included][0][type]    return-items
    And Response body parameter should contain:    [included][0]    id
    And Response body parameter should not be empty:    [included][0][attributes][uuid]
    And Response body parameter should be:    [included][0][attributes][reason]    ${return_reason_damaged}
    And Response body parameter should contain:    [included][0][attributes]    orderItemUuid


#GET#
Get_lists_of_returns
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${CartId}/items?include=items     {"data":{"type":"items","attributes":{"sku":"${concrete.available_product.with_stock_and_never_out_of_stock.sku}","quantity":"1"}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_id_in_return_list
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_in_return_list}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Update order status in Database:    shipped    ${uuid}
    ...    AND    I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    When I send a GET request:     /returns
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Each array element of array in response should contain property with value:    [data]    type    returns
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    links
    And Each array element of array in response should contain nested property:    [data]    [attributes]    returnReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    store
    And Each array element of array in response should contain nested property:    [data]    [attributes]    customerReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    returnTotals
    And Each array element of array in response should contain nested property:    [data]    [attributes][returnTotals]    refundTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][returnTotals]    remunerationTotal
    And Each array element of array in response should contain nested property:    [data]    [links]    self


Get_lists_of_returns_include_return-items
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${CartId}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${product_with_alternative.concrete_sku}","quantity":"1"}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_id_in_return_list_items
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_in_return_list_items}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Update order status in Database:    shipped    ${uuid}
    ...    AND    I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    When I send a GET request:     /returns?include=return-items
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Each array element of array in response should contain property with value:    [data]    type    returns
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    links
    And Each array element of array in response should contain nested property:    [data]    [attributes]    returnReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    store
    And Each array element of array in response should contain nested property:    [data]    [attributes]    customerReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    returnTotals
    And Each array element of array in response should contain nested property:    [data]    [attributes][returnTotals]    refundTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][returnTotals]    remunerationTotal
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Each array element of array in response should contain property:    [data]    relationships
    And Each array element of array in response should contain nested property:    [data]    [relationships]    return-items
    And Each array element of array in response should contain nested property:    [data]    [relationships][return-items][data][0]    type
    And Each array element of array in response should contain nested property:    [data]    [relationships][return-items][data][0]    id
    And Each array element of array in response should contain nested property with value:    [data]    [relationships][return-items][data][0][type]    return-items
    And Response include element has self link:    return-items
    And Response include should contain certain entity type:    return-items
    And Response body has correct self link

#GET#
Get_return_by_Id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${CartId}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${concrete.available_product.with_stock_and_never_out_of_stock.sku}","quantity":"1"}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_id_id
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_id}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    productPrice
    ...    AND    Update order status in Database:    shipped    ${uuid}
    ...    AND    I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    ...    AND    Save value to a variable:    [data][attributes][returnReference]    returnReference
    ...    AND    Save value to a variable:    [data][id]    returnId
    When I send a GET request:     /returns/${returnReference}
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Response header parameter should be:     Content-Type     ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should be:    [data][id]    ${returnReference}
    And Response body parameter should be:    [data][attributes][returnReference]    ${returnReference}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_user.reference}
    And Response body parameter should be:    [data][attributes][returnTotals][refundTotal]    0
    And Response body parameter should be:    [data][attributes][returnTotals][remunerationTotal]    ${productPrice}
    And Response body has correct self link internal

Get_return_by_Id_include_return-items
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${CartId}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${concrete.available_product.with_stock_and_never_out_of_stock.sku}","quantity":"1"}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_id_id_item
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_id_item}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    productPrice
    ...    AND    Update order status in Database:    shipped    ${uuid}
    ...    AND    I send a POST request:    /returns?include=return-items    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    ...    AND    Save value to a variable:    [data][attributes][returnReference]    returnReference
    ...    AND    Save value to a variable:    [included][0][attributes][orderItemUuid]    orderItemUuid
    ...    AND    Save value to a variable:    [data][id]    returnId
    When I send a GET request:     /returns/${returnReference}?include=return-items
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Response header parameter should be:     Content-Type     ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should be:    [data][id]    ${returnReference}
    And Response body parameter should be:    [data][attributes][returnReference]    ${returnReference}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_user.reference}
    And Response body parameter should be:    [data][attributes][returnTotals][refundTotal]    0
    And Response body parameter should be:    [data][attributes][returnTotals][remunerationTotal]    ${productPrice}
    And Response body parameter should contain:    [data]    relationships
    And Response body parameter should be:    [data][relationships][return-items][data][0][type]    return-items
    And Response body parameter should contain:    [data][relationships][return-items][data][0]    id
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should be:    [included][0][type]    return-items
    And Response body parameter should contain:    [included][0]    id
    And Response body parameter should be:    [included][0][type]    return-items
    And Response body parameter should contain:    [included][0]    id
    And Response body parameter should be:    [included][0][attributes][reason]    ${return_reason_damaged}
    And Response body parameter should be:    [included][0][attributes][orderItemUuid]    ${orderItemUuid}

Retrieves_list_of_returns_included_merchants
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${merchants.sony_experts.concrete_product_with_offer_sku}","quantity": 4, "merchantReference" : "${merchants.sony_experts.merchant_reference}", "productOfferReference" : "${merchants.sony_experts.merchant_offer_id}"}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_id_id_item_merch
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_id_item_merch}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Save value to a variable:    [data][attributes][orderReference]    order_reference
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...    AND    Update order status in Database:    shipped by merchant    ${uuid}
    ...    AND    I send a POST request:     /returns?include=merchants    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    When I send a GET request:     /returns?include=merchants
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Each array element of array in response should contain property with value:    [data]    type    returns
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    links
    And Each array element of array in response should contain nested property:    [data]    [attributes]    merchantReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    returnReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    store
    And Each array element of array in response should contain nested property:    [data]    [attributes]    customerReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    returnTotals
    And Each array element of array in response should contain nested property:    [data]    [attributes][returnTotals]    refundTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][returnTotals]    remunerationTotal
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Array element should contain nested array at least once:    [data]    [relationships]
    And Response body parameter should be:    [data][0][relationships][merchants][data][0][type]    merchants
    And Response body parameter should be:    [data][0][relationships][merchants][data][0][id]    MER000006
    And Response include element has self link:    merchants
    And Response include should contain certain entity type:    merchants
    And Response body has correct self link

Retrieves_return_by_id_with_returns_items_included
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cartId}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${merchants.sony_experts.concrete_product_with_offer_sku}","quantity": 4, "merchantReference" : "${merchants.sony_experts.merchant_reference}", "productOfferReference" : "${merchants.sony_experts.merchant_offer_id}"}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_id_id_item_included
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_id_item_included}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...    AND    Update order status in Database:    shipped by merchant    ${uuid}
    ...    AND    Create merchant order for the item in DB and change status:    shipped    ${uuid}    ${merchants.sony_experts.merchant_reference}
    ${return_result}=    Run Keyword And Ignore Error    I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    Run Keyword If    "${return_result[0]}" != "PASS"    Run Keywords    Log    Retry sending return request    AND    I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    Save value to a variable:    [data][id]    returnId
    When I send a GET request:    /returns/${returnId}?include=return-items
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should be:    [data][id]    ${returnId}
    And Response body parameter should be:    [data][attributes][merchantReference]    ${merchants.sony_experts.merchant_reference}
    And Response body parameter should be:    [data][attributes][returnReference]    ${returnId}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_user.reference}
    And Response body parameter should be:    [data][attributes][returnTotals][remunerationTotal]    ${refundable_amount}
    And Response should contain the array larger than a certain size:    [included]    0
    And Response should contain the array larger than a certain size:    [data][relationships]    0
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][return-items]
    And Each array element of array in response should contain property:    [data][relationships][return-items][data]    type
    And Each array element of array in response should contain property:    [data][relationships][return-items][data]    id
    And Response body parameter should not be EMPTY:    [included]
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Each array element of array in response should contain nested property:    [included]    [attributes]    uuid
    And Each array element of array in response should contain property with value:    [included]    type    return-items
    And Each array element of array in response should contain property with value in:    [included]    [attributes][orderItemUuid]    ${uuid}    ${uuid}
    And Each array element of array in response should contain property with value in:    [included]    [attributes][reason]    ${return_reason_damaged}    ${return_reason_damaged}
    And Response body has correct self link internal

Retrieves_return_by_id_for_sales_order
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cartId}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${merchants.sony_experts.concrete_product_with_offer_sku}","quantity": 4, "merchantReference" : "${merchants.sony_experts.merchant_reference}", "productOfferReference" : "${merchants.sony_experts.merchant_offer_id}"}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_id_id_item_sales
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_id_item_sales}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...    AND    Update order status in Database:    shipped by merchant    ${uuid}
    ...    AND    Create merchant order for the item in DB and change status:    shipped    ${uuid}    ${merchants.sony_experts.merchant_reference}
    ...    AND    I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    ...    AND    Save value to a variable:    [data][id]    returnId
    When I send a GET request:    /returns/${returnId}?include=return-items
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should contain:    [data][attributes]    merchantReference
    And Response body parameter should be:    [data][id]    ${returnId}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_user.reference}
    And Response body parameter should be:    [data][attributes][returnTotals][refundTotal]    0
    And Response body parameter should be:    [data][attributes][returnTotals][remunerationTotal]    ${refundable_amount}

Retrieves_return_by_id_with_merchants_included
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cartId}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${merchants.sony_experts.concrete_product_with_offer_sku}","quantity": 4, "merchantReference" : "${merchants.sony_experts.merchant_reference}", "productOfferReference" : "${merchants.sony_experts.merchant_offer_id}"}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_id_id_item_included_m
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_id_item_included_m}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...    AND    Update order status in Database:    shipped by merchant    ${uuid}
    ...    AND    Create merchant order for the item in DB and change status:    shipped    ${uuid}    ${merchants.sony_experts.merchant_reference}
    ...    AND    I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    ...    AND    Save value to a variable:    [data][id]    returnId
    When I send a GET request:    /returns/${returnId}?include=merchants
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should be:    [data][id]    ${returnId}
    And Response body parameter should be:    [data][attributes][merchantReference]    ${merchants.sony_experts.merchant_reference}
    And Response body parameter should be:    [data][attributes][returnReference]    ${returnId}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_user.reference}
    And Response body parameter should be:    [data][attributes][returnTotals][refundTotal]    0
    And Response body parameter should be:    [data][attributes][returnTotals][remunerationTotal]    ${refundable_amount}
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][merchants]
    And Response should contain the array larger than a certain size:    [included]    0
    And Response should contain the array larger than a certain size:    [data][relationships]    0
    And Response include element has self link:    merchants
    And Response include should contain certain entity type:    merchants
    And Response body has correct self link internal
