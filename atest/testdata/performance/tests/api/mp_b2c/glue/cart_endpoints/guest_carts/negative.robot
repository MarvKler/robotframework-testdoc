*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    cart    spryker-core

*** Test Cases ***
Get_guest_cart_without_anonymous_customer_unique_id
    When I send a GET request:    /guest-carts
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Anonymous customer unique id is empty.
    And Response should return error code:    109

Get_guest_cart_wth_empty_anonymous_customer_unique_id
    [Setup]    I set Headers:     X-Anonymous-Customer-Unique-Id=
    When I send a GET request:    /guest-carts
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Anonymous customer unique id is empty.
    And Response should return error code:    109

Get_guest_cart_wth_non_existing_cart_id
    [Setup]    I set Headers:     X-Anonymous-Customer-Unique-Id=fake
    When I send a GET request:    /guest-carts/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.
    And Response should return error code:    101

Update_guest_cart_with_wrong_x_anonymous_customer_id
      [Setup]    Run Keywords    Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
            ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=fake
    When I send a PATCH request:    /guest-carts/${guest_cart_id}    {"data": {"type": "guest-carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.
    And Response should return error code:    101

Update_guest_cart_with_empty_x_anonymous_customer_id
      [Setup]    Run Keywords    Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
            ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=
    When I send a PATCH request:    /guest-carts/${guest_cart_id}    {"data": {"type": "guest-carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Anonymous customer unique id is empty.
    And Response should return error code:    109

Update_guest_cart_with_wrong_guest_cart_id
      [Setup]    Run Keywords    Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
            ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a PATCH request:    /guest-carts/fake    {"data": {"type": "guest-carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.
    And Response should return error code:    101

Update_guest_cart_without_guest_cart_id
      [Setup]    Run Keywords    Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
            ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a PATCH request:    /guest-carts/    {"data": {"type": "guest-carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.


Update_guest_cart_with_invalid_type
      [Setup]    Run Keywords    Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
            ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a PATCH request:    /guest-carts/${guest_cart_id}    {"data": {"type": "guest-car","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.

Update_guest_cart_without_type
      [Setup]    Run Keywords    Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
            ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a PATCH request:    /guest-carts/${guest_cart_id}    {"data": {"attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Post data is invalid.

Update_guest_cart_update_price_mode_with_items_in_the_cart
      [Setup]    Run Keywords    Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
            ...   AND    I set Headers:     X-Anonymous-Customer-Unique-Id=${x_anonymous_customer_unique_id}
    When I send a PATCH request:    /guest-carts/${guest_cart_id}    {"data": {"type": "guest-carts","attributes": {"priceMode": "${mode.net}"}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Response body parameter should be:    [errors][0][code]    111
    And Response body parameter should be:    [errors][0][detail]    Can’t switch price mode when there are items in the cart.
