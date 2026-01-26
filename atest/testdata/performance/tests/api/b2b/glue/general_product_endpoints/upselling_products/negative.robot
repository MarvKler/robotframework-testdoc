*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    product    product-relations


*** Test Cases ***
Get_upselling_products_with_missing_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /carts//up-selling-products
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    104
    And Response should return error message:    Cart uuid is missing.

Get_upselling_products_with_nonexistent_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /carts/not_a_cart/up-selling-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Get_upselling_products_with_invalid_token
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    Authorization=invalid
    When I send a GET request:    /carts//up-selling-products
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Get_upselling_products_without_access_token
    When I send a GET request:    /carts//up-selling-products
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Get_upselling_products_using_cart_of_other_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    first_user_token
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /carts/${cart_id}/up-selling-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.
    And Response should return error code:    101
    [Teardown]    Run Keywords    I set Headers:    Authorization=Bearer ${first_user_token}
    ...    AND    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204
