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
Create_a_return_with_Invalid_access_token
    [Setup]    I set Headers:    Authorization=3485h7
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${random}","reason":"${return_reason_damaged}"}]}}}
    Then Response status code should be:     401
    And Response reason should be:     Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001

Create_a_return_with_without_access_token
    [Setup]    I set Headers:    Authorization=
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${random}","reason":"${return_reason_damaged}"}]}}}
    Then Response status code should be:     403
    And Response reason should be:     Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002

Create_return_for_order_item_that_cannot_be_returned
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cartId
    ...  AND    I send a POST request:    /carts/${CartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete.available_product.with_stock_and_never_out_of_stock.sku}","quantity":"1"}}}
    ...  AND    Save value to a variable:    [included][0][id]    item_id_not_returnable        
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_not_returnable}"]}}}
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
    Then Response status code should be:     422
    And Response reason should be:     Unprocessable Content
    And Response should return error message:    "Return cant be created."    
    And Response should return error code:    3601

Create_a_return_with_order_is_not_returnable_for_merchant
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${merchants.sony_experts.concrete_product_with_offer_sku}","quantity": 10, "merchantReference" : "${merchants.sony_experts.merchant_reference}", "productOfferReference" : "${merchants.sony_experts.merchant_offer_id}"}}}
    ...  AND    Save value to a variable:    [included][0][id]    item_id_not_returnable_merchant     
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${item_id_not_returnable_merchant}"]}}}
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    returnableSalesOrderItemUuid
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${returnableSalesOrderItemUuid}","reason":"${return_reason_damaged}"}]}}}
    Then Response status code should be:     422
    And Response reason should be:     Unprocessable Content
    And Response should return error message:    "Return cant be created."    
    And Response should return error code:    3601

Create_return_with_invalid_returnItems_uuid
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${random}","reason":"${return_reason_damaged}"}]}}}
    Then Response status code should be:     422
    And Response reason should be:     Unprocessable Content
    And Response should return error message:    "Return cant be created."    
    And Response should return error code:    3601

Create_return_without_returnItems_uuid
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"","reason":"${return_reason_damaged}"}]}}}
    Then Response status code should be:     422
    And Response reason should be:     Unprocessable Content
    And Response should return error message:    "Return cant be created."    
    And Response should return error code:    3601

Create_return_without_returnItems_reason
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"920fc22f-3fb6-53ec-bc5e-c4d321115462","reason":""}]}}}
    Then Response status code should be:     422
    And Response reason should be:     Unprocessable Content
    And Response should return error message:    "Return cant be created."    
    And Response should return error code:    3601


#GET#
Get_lists_of_returns_with_Invalid_access_token
    [Setup]    I set Headers:    Authorization=3485h7
    When I send a GET request:     /returns
    Then Response status code should be:     401
    And Response reason should be:     Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001

Get_lists_of_returns_without_access_token
    [Setup]    I set Headers:    Authorization=
    When I send a GET request:     /returns
    Then Response status code should be:     403
    And Response reason should be:     Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002

Get_return_by_Id_with_Invalid_return_reference
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:     /returns/${random}
    Then Response status code should be:     404
    And Response reason should be:     Not Found
    And Response should return error message:    "Cant find return by the given return reference."
    And Response should return error code:    3602