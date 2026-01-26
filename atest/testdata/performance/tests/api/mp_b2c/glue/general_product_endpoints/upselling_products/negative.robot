*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    product-relations

*** Test Cases ***
#Logged in customer's cart
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
    [Setup]    I set Headers:   Content-Type=${default_header_content_type}     Authorization=invalid
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
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Save value to a variable:    [data][attributes][accessToken]    first_user_token
    ...  AND    Find or create customer cart
    ...  AND    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /carts/${cart_id}/up-selling-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

#Guest user cart
Get_upselling_products_with_missing_guest_cart_id
    When I send a GET request:    /guest-carts//up-selling-products
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    104
    And Response should return error message:    Cart uuid is missing.

Get_upselling_products_with_nonexistent_guest_cart_id
    [Setup]    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    When I send a GET request:    /guest-carts/not_a_cart/up-selling-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Get_upselling_products_with_empty_anonymous_id
    When I send a GET request:    /guest-carts/not_a_cart/up-selling-products
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    109
    And Response should return error message:    Anonymous customer unique id is empty.

Get_upselling_products_with_other_anonymous_id
    [Setup]    Run Keywords    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Create a guest cart:    ${random}    ${product_with_relations.has_upselling_products.concrete_sku}    1
    ...    AND    Response status code should be:    201
    ...    AND    I set Headers:    X-Anonymous-Customer-Unique-Id=222
    When I send a GET request:    /guest-carts/${guest_cart_id}/up-selling-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.
    [Teardown]    Run Keywords     I set Headers:    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}
