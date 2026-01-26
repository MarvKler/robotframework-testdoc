*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    cart    spryker-core    customer-access    acl    promotions-discounts    marketplace-promotions-discounts    gift-cards
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Create_git_card_code_with_invalid_access_token
     [Setup]    Run Keyword   I set Headers:    Authorization=345A9
    When I send a POST request:    /carts/cart_id/cart-codes   {"data": {"type": "cart-codes","attributes": {"code": "${random}"}}}
    Then Response status code should be:    401
    And Response should return error code:    001
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.

Create_git_card_code_without_access_token
    When I send a POST request:    /carts/cart_id/cart-codes   {"data": {"type": "cart-codes","attributes": {"code": "${random}"}}}
    Then Response status code should be:    403
    And Response should return error code:    002
    And Response reason should be:    Forbidden 
    And Response should return error message:    Missing access token.
    
Create_git_card_code_with_invalid_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
     When I send a POST request:    /carts/123/cart-codes    {"data": {"type": "cart-codes","attributes": {"code": "${random}"}}}
    Then Response status code should be:    404
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Adding_eur_gift_cart_code_in_chf_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.chf.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cart_id
     When I send a POST request:    /carts/${cart_id}/cart-codes  {"data": {"type": "cart-codes","attributes": {"code": "${random}"}}}
    Then Response status code should be:    422
    And Response should return error code:    3302
    And Response should return error message:    "Cart code cant be added."

Adding_invalid_cart_code
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cart_id
    When I send a POST request:    /carts/${cart_id}/cart-codes   {"data": {"type": "cart-codes","attributes": {"code": "123"}}}
    Then Response status code should be:    422
    And Response should return error code:    3302
    And Response should return error message:    "Cart code cant be added."   

Gift_card_fully_used
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Create giftcode in Database:    used_${random}    ${gift_card.amount}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items   {"data": {"type": "items","attributes": {"sku": "${concrete_available_product.with_label}","quantity": 3}}}
    ...  AND    I send a POST request:    /carts/${cart_id}/cart-codes?include=gift-cards    {"data": {"type": "cart-codes","attributes": {"code": "used_${random}"}}}
    ...  AND    I send a POST request:    /checkout   {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_second_user.email}","salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_second_user.salutation}","firstName": "${yves_second_user.first_name}","lastName": "${yves_second_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_available_product.with_label}"]}}}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items   {"data": {"type": "items","attributes": {"sku": "${concrete_available_product.with_label}","quantity": 1}}}
    When I send a POST request:    /carts/${cart_id}/cart-codes?include=gift-cards    {"data": {"type": "cart-codes","attributes": {"code": "used_${random}"}}}
    And Response status code should be:    422
    And Response should return error code:    3302
    And Response should return error message:    "Cart code cant be added."