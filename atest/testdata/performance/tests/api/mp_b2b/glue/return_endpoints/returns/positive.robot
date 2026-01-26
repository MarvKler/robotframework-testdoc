*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    marketplace-return-management    return-management    checkout    cart    spryker-core    refunds

*** Test Cases ***    
####POST####
Create_a_return
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Cleanup all customer carts
    ### steps below just duplicate the order creation and status change. This is needed as we 'hack' the order status in the database. ###
    ### Needs to be done only once in the first test ###
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    ...  AND    Save value to a variable:    [included][0][id]    item_id_return      
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_return}"]}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_reference
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...  AND    Create merchant order for the item in DB and change status:    shipped   ${uuid}    ${merchants.merchant_spryker_id}
    ...  AND    Update order status in Database:    shipped by merchant    ${uuid}
    ...  AND    Run Keyword And Ignore Error    I send a POST request:    /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    ### steps below just duplicate the order creation and status change. This is needed as we 'hack' the order status in the database. ###
    ### Needs to be done only once in the first test ###    
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    ...  AND    Save value to a variable:    [included][0][id]    item_id_return      
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_return}"]}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_reference
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...  AND    Create merchant order for the item in DB and change status:    shipped   ${uuid}    ${merchants.merchant_spryker_id}
    ...  AND    Update order status in Database:    shipped by merchant    ${uuid}
    ...  AND    Run Keyword And Ignore Error    I send a POST request:    /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    ### steps below just duplicate the order creation and status change. This is needed as we 'hack' the order status in the database. ###
    ### Needs to be done only once in the first test ###
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    ...  AND    Save value to a variable:    [included][0][id]    item_id_return      
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_return}"]}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_reference
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...  AND    Create merchant order for the item in DB and change status:    shipped   ${uuid}    ${merchants.merchant_spryker_id}
    ...  AND    Update order status in Database:    shipped by merchant    ${uuid}
    ...  AND    Run Keyword And Ignore Error    I send a POST request:    /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    ### steps below just duplicate the order creation and status change. This is needed as we 'hack' the order status in the database. ###
    ### Needs to be done only once in the first test ###    
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    ...  AND    Save value to a variable:    [included][0][id]    item_id_return      
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_return}"]}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_reference
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...  AND    Create merchant order for the item in DB and change status:    shipped   ${uuid}    ${merchants.merchant_spryker_id}
    ...  AND    Update order status in Database:    shipped by merchant    ${uuid}
    When I send a POST request:    /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    And Save value to a variable:    [data][id]    returnId
    Then Response status code should be:     201
    And Response reason should be:     Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_user.reference}
    And Response body parameter should be:    [data][attributes][returnTotals][remunerationTotal]    ${refundable_amount}
    And Response body has correct self link for created entity:    ${returnId}

Create_a_return_with_return_items
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id    
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${merchants.computer_experts.concrete_product_with_offer_sku}","quantity": 10, "merchantReference" : "${merchants.computer_experts.merchant_id}", "productOfferReference" : "${merchants.computer_experts.merchant_offer_id}"}}}
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${merchants.computer_experts.concrete_product_with_offer_sku}"]}}}
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_reference
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...  AND    Create merchant order for the item in DB and change status:    shipped   ${uuid}    ${merchants.merchant_spryker_id}
    ...  AND    Update order status in Database:    shipped by merchant    ${uuid} 
    When I send a POST request:     /returns?include=return-items     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${uuid}","reason":"${return_reason_damaged}"}]}}}
    Then Response status code should be:     201
    And Response reason should be:     Created
    And Save value to a variable:    [data][id]    returnId
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should be:    [data][attributes][merchantReference]    ${merchants.computer_experts.merchant_id}
    And Response body parameter should contain:    [data]    id
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][customerReference]    ${yves_user.reference}
    And Response body parameter should be:    [data][attributes][returnTotals][refundTotal]    0
    And Response body parameter should be:    [data][attributes][returnTotals][remunerationTotal]    ${refundable_amount}
    And Response should contain the array larger than a certain size:    [included]    0
    And Response should contain the array larger than a certain size:    [data][relationships]    0    
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response should contain the array of a certain size:    [data][relationships][return-items][data]    1
    And Response body parameter should not be EMPTY:    [data][relationships][return-items]
    And Response body parameter should contain:    [data][relationships][return-items][data]    type
    And Response body parameter should contain:    [data][relationships][return-items][data]    id
    And Response body parameter should not be EMPTY:    [included]  
    And Response include should contain certain entity type:    return-items
    And Response body parameter should be:    [included][0][attributes][orderItemUuid]    ${uuid}
    And Response body parameter should be:    [included][0][attributes][reason]    ${return_reason_damaged}
    And Response include element has self link:    return-items

####GET####
Retrieves_list_of_returns
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${merchants.computer_experts.concrete_product_with_offer_sku}","quantity": 10, "merchantReference" : "${merchants.computer_experts.merchant_id}", "productOfferReference" : "${merchants.computer_experts.merchant_offer_id}"}}}
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${merchants.computer_experts.concrete_product_with_offer_sku}"]}}}
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_reference
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...  AND    Create merchant order for the item in DB and change status:    shipped   ${uuid}    ${merchants.merchant_spryker_id}
    ...  AND    Update order status in Database:    shipped by merchant    ${uuid} 
    ...  AND    I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
    When I send a GET request:     /returns
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
    And Response body has correct self link
    
Retrieves_list_of_returns_included_return_items
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${merchants.computer_experts.concrete_product_with_offer_sku}","quantity": 10, "merchantReference" : "${merchants.computer_experts.merchant_id}", "productOfferReference" : "${merchants.computer_experts.merchant_offer_id}"}}}
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${merchants.computer_experts.concrete_product_with_offer_sku}"]}}}
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_reference
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...  AND    Create merchant order for the item in DB and change status:    shipped   ${uuid}    ${merchants.merchant_spryker_id}
    ...  AND    Update order status in Database:    shipped by merchant    ${uuid} 
    ...  AND    I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
    When I send a GET request:     /returns?include=return-items
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
    And Each array element of array in response should contain property:    [data]    relationships
    And Each array element of array in response should contain nested property:    [data]    [relationships]    return-items
    And Each array element of array in response should contain nested property:    [data]    [relationships][return-items][data][0]    type
    And Each array element of array in response should contain nested property:    [data]    [relationships][return-items][data][0]    id
    And Each array element of array in response should contain nested property with value:    [data]    [relationships][return-items][data][0][type]    return-items
    And Response include element has self link:    return-items
    And Response include should contain certain entity type:    return-items
    And Response body parameter should be:    [included][0][attributes][orderItemUuid]    ${uuid}
    And Response body parameter should be:    [included][0][attributes][reason]    ${return_reason_damaged}
    And Response body has correct self link

Retrieves_list_of_returns_included_merchants
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${merchants.computer_experts.concrete_product_with_offer_sku}","quantity": 10, "merchantReference" : "${merchants.computer_experts.merchant_id}", "productOfferReference" : "${merchants.computer_experts.merchant_offer_id}"}}}
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${merchants.computer_experts.concrete_product_with_offer_sku}"]}}}
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...  AND    Save value to a variable:    [data][attributes][orderReference]    order_reference
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...  AND    Create merchant order for the item in DB and change status:    shipped   ${uuid}    ${merchants.merchant_spryker_id}
    ...  AND    Update order status in Database:    shipped by merchant    ${uuid} 
    ...  AND    I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
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
    And Each array element of array in response should contain property:    [data]    relationships
    And Each array element of array in response should contain nested property:    [data]    [relationships]    merchants
    And Each array element of array in response should contain nested property:    [data]    [relationships][merchants][data][0]    type
    And Each array element of array in response should contain nested property:    [data]    [relationships][merchants][data][0]    id
    And Each array element of array in response should contain nested property with value:    [data]    [relationships][merchants][data][0][type]    merchants
    And Response include element has self link:    merchants
    And Response include should contain certain entity type:    merchants
    And Response body has correct self link

Retrieves_return_by_id_with_returns_items_included
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${merchants.computer_experts.concrete_product_with_offer_sku}","quantity": 10, "merchantReference" : "${merchants.computer_experts.merchant_id}", "productOfferReference" : "${merchants.computer_experts.merchant_offer_id}"}}}
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${merchants.computer_experts.concrete_product_with_offer_sku}"]}}}
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...  AND    Create merchant order for the item in DB and change status:    shipped   ${uuid}    ${merchants.merchant_spryker_id}
    ...  AND    Update order status in Database:    shipped by merchant    ${uuid} 
    ...  AND    I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
    ...  AND    Save value to a variable:    [data][id]    returnId
    When I send a GET request:    /returns/${returnId}?include=return-items
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should be:    [data][id]    ${returnId}
    And Response body parameter should be:    [data][attributes][merchantReference]    ${merchants.computer_experts.merchant_id}
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
    And Each array element of array in response should contain property with value in:    [included]    [attributes][orderItemUuid]    ${Uuid}    ${Uuid}
    And Each array element of array in response should contain property with value in:    [included]    [attributes][reason]    ${return_reason_damaged}    ${return_reason_damaged}  
    And Response body has correct self link internal

Retrieves_return_by_id_for_sales_order
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${merchants.computer_experts.concrete_product_with_offer_sku}","quantity": 10, "merchantReference" : "${merchants.computer_experts.merchant_id}", "productOfferReference" : "${merchants.computer_experts.merchant_offer_id}"}}}
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${merchants.computer_experts.concrete_product_with_offer_sku}"]}}}
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...  AND    Create merchant order for the item in DB and change status:    shipped   ${uuid}    ${merchants.merchant_spryker_id}
    ...  AND    Update order status in Database:    shipped by merchant    ${uuid} 
    ...  AND    I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
    ...  AND    Save value to a variable:    [data][id]    returnId
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
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${merchants.computer_experts.concrete_product_with_offer_sku}","quantity": 10, "merchantReference" : "${merchants.computer_experts.merchant_id}", "productOfferReference" : "${merchants.computer_experts.merchant_offer_id}"}}}
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${merchants.computer_experts.concrete_product_with_offer_sku}"]}}}
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][refundableAmount]    refundable_amount
    ...  AND    Create merchant order for the item in DB and change status:    shipped   ${uuid}    ${merchants.merchant_spryker_id}
    ...  AND    Update order status in Database:    shipped by merchant    ${uuid} 
    ...  AND    I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
    ...  AND    Save value to a variable:    [data][id]    returnId
    When I send a GET request:    /returns/${returnId}?include=merchants
    Then Response status code should be:     200
    And Response reason should be:     OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    returns
    And Response body parameter should be:    [data][id]    ${returnId}
    And Response body parameter should be:    [data][attributes][merchantReference]    ${merchants.computer_experts.merchant_id}
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