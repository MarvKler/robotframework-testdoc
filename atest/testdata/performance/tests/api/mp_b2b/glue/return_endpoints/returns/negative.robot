*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    marketplace-return-management    return-management    checkout    cart    spryker-core    refunds

*** Test Cases ***
Create_a_return_with_order_is_not_returnable
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${merchants.computer_experts.concrete_product_with_offer_sku}","quantity": 10, "merchantReference" : "${merchants.computer_experts.merchant_id}", "productOfferReference" : "${merchants.computer_experts.merchant_offer_id}"}}}
    ...  AND    I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${merchants.computer_experts.concrete_product_with_offer_sku}"]}}}
    ...  AND    Save value to a variable:    [included][0][attributes][items][0][uuid]    returnableSalesOrderItemUuid
    When I send a POST request:     /returns     {"data":{"type":"returns","attributes":{"store":"${store.de}","returnItems":[{"salesOrderItemUuid":"${returnableSalesOrderItemUuid}","reason":"${return_reason_damaged}"}]}}}
    Then Response status code should be:     ${422}
    And Response reason should be:     Unprocessable Content
    And Response should return error message:    "Return cant be created."    
    And Response should return error code:    3601

Retrieves_a_return_with_non_exists_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /returns/fake_returns_id
    Then Response status code should be:     404
    And Response reason should be:     Not Found
    And Response should return error message:    "Cant find return by the given return reference."
    And Response should return error code:    3602

Retrieves_a_return_with_missing_auth_token
    When I send a GET request:    /returns/DE--21-R1
    Then Response status code should be:     403
    And Response reason should be:     Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002


Retrieves_list_of_returns_with_missing_auth_token
    When I send a GET request:    /returns
    Then Response status code should be:     403
    And Response reason should be:     Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002