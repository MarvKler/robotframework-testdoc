*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    return-management    checkout    cart    spryker-core    refunds


*** Test Cases ***
Create_a_return_with_order_is_not_returnable
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":"1"}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cartId}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment_provider_name}","paymentMethodName": "${payment_method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete.available_product.with_stock.product_1.sku}"]}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [included][0][items][0][uuid]    returnableSalesOrderItemUuid
    When I send a POST request:
    ...    /returns
    ...    {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${returnableSalesOrderItemUuid}","reason":"${return_reason.damaged}"}]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    "Return cant be created."
    And Response should return error code:    3601

Retrieves_a_return_with_non_exists_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /returns/fake_returns_id
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    "Cant find return by the given return reference."
    And Response should return error code:    3602

Retrieves_a_return_with_missing_auth_token
    When I send a GET request:    /returns/DE--21-R1
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002

Retrieves_list_of_returns_with_missing_auth_token
    When I send a GET request:    /returns
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002
