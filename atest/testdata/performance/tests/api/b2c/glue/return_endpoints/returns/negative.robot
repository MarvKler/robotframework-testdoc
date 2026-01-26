*** Settings ***
Suite Setup       API_suite_setup
Test Tags      glue    return-management    checkout    cart    spryker-core    refunds
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
 ####POST####
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
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}"}}}
    ...    AND    I send a GET request:    /customers/${yves_second_user.reference}/carts
    ...    AND    Save value to a variable:    [data][0][id]    CartId
    ...    AND    I send a POST request:    /carts/${CartId}/items    {"data":{"type":"items","attributes":{"sku":"${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity":"1"}}}
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${CartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "DummyPayment","paymentMethodName": "Credit Card"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_product.sku}"]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    uuid
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${Uuid}","reason":"${return_reason_damaged}"}]}}}
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


####GET####
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


####GET####
Get_return_by_Id_with_Invalid_access_token
     [Setup]    I set Headers:    Authorization=3485h7
    When I send a GET request:     /returns/${random}
    Then Response status code should be:     401
    And Response reason should be:     Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001


Get_return_by_Id_without_access_token
     [Setup]    I set Headers:    Authorization=
    When I send a GET request:     /returns/${random}
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

