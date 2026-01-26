*** Settings ***
Suite Setup       API_suite_setup
Test Tags      glue    return-management    checkout    cart    spryker-core    refunds
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
####POST####
Create_a_return
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Cleanup all customer carts
    ### steps below just duplicate the order creation and status change. This is needed as we 'hack' the order status in the database. ###
    ### Needs to be done only once in the first test ###
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a GET request:    /customers/${yves_user.reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items?include=items     {"data":{"type":"items","attributes":{"sku":"${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity":"1"}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_id_return   
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_return}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    productPrice
    ...    AND    Update order status in Database:    shipped    ${uuid}   
    ...    AND    Run Keyword And Ignore Error    I send a POST request:   /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    ### steps below just duplicate the order creation and status change. This is needed as we 'hack' the order status in the database. ###
    ### Needs to be done only once in the first test ###   
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a GET request:    /customers/${yves_user.reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items?include=items     {"data":{"type":"items","attributes":{"sku":"${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity":"1"}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_id_return   
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_return}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    productPrice
    ...    AND    Update order status in Database:    shipped    ${uuid}   
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
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
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}"}}}
    ...    AND    I send a GET request:    /customers/${yves_user.reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity":"1"}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_id_in_return   
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_in_return}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    productPrice
    ...    AND    Update order status in Database:    shipped    ${uuid}   
    When I send a POST request:     /returns?include=return-items     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
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


#GET####
Get_lists_of_returns
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}"}}}
    ...    AND    I send a GET request:    /customers/${yves_user.reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity":"1"}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_id_in_return_list         
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_in_return_list}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Update order status in Database:    shipped    ${uuid}   
    ...    AND    I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
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
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}"}}}
    ...    AND    I send a GET request:    /customers/${yves_user.reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${concrete_available_product.sku}","quantity":"1"}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_id_in_return_list_items      
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_in_return_list_items}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Update order status in Database:    shipped    ${uuid}   
    ...    AND    I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
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

###GET####
Get_return_by_Id
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}"}}}
    ...    AND    I send a GET request:    /customers/${yves_user.reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items?include=intems    {"data":{"type":"items","attributes":{"sku":"${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity":"1"}}}
     ...    AND    Save value to a variable:    [included][0][id]    item_id_id            
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_id}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    productPrice
    ...    AND    Update order status in Database:    shipped    ${uuid}   
    ...    AND    I send a POST request:    /returns    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
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
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}"}}}
    ...    AND    I send a GET request:    /customers/${yves_user.reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity":"1"}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_id_id_item             
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_id_item}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    productPrice
    ...    AND    Update order status in Database:    shipped    ${uuid}   
    ...    AND    I send a POST request:    /returns?include=return-items    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
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