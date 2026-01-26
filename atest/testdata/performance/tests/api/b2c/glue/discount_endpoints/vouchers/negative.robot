*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    promotions-discounts    product-promotions

*** Test Cases ***
#POST requests
Add_voucher_code_to_cart_with_invalid_access_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    ...    AND    I set Headers:    Authorization=fake_token
    When I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "discount_voucher_code"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Add_voucher_code_to_cart_without_access_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    ...    AND    I set Headers:    Authorization=
    When I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "discount_voucher_code"}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Add_voucher_code_to_guest_cart_with_invalid_anonymous_customer_id
    [Setup]    Run Keywords    Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount.concrete.product_with_voucher_code.sku}    1
    ...   AND    I set Headers:    X-Anonymous-Customer-Unique-Id=fake_anonymous_customer_id
    When I send a POST request:    /guest-carts/${guest_cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "discount_voucher_code"}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.
    [Teardown]    Run Keywords    I set Headers:    X-Anonymous-Customer-Unique-Id=${x_anonymous_prefix}${random}
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}

Add_voucher_code_to_guest_cart_without_anonymous_customer_id
    [Setup]    Run Keywords    Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount.concrete.product_with_voucher_code.sku}    1
    ...   AND    I set Headers:    X-Anonymous-Customer-Unique-Id=
    When I send a POST request:    /guest-carts/${guest_cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "discount_voucher_code"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    109
    And Response should return error message:    Anonymous customer unique id is empty.
    [Teardown]    Run Keywords    I set Headers:    X-Anonymous-Customer-Unique-Id=${x_anonymous_prefix}${random}
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}

Add_invalid_voucher_code_to_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    When I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "fake_discount_voucher_code"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    3302
    And Response should return error message:    "Cart code cant be added."

Add_empty_voucher_code_to_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    When I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": ""}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    code => This value should not be blank.

Add_voucher_to_cart_without_voucher_code
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    When I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    code => This field is missing.

Add_invalid_voucher_code_to_guest_cart
    [Setup]    Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount.concrete.product_with_voucher_code.sku}    1
    When I send a POST request:    /guest-carts/${guest_cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "fake_discount_voucher_code"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    3302
    And Response should return error message:    "Cart code cant be added."
    [Teardown]    Cleanup all items in the guest cart:    ${guest_cart_id}

Add_empty_voucher_code_to_guest_cart
    [Setup]    Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount.concrete.product_with_voucher_code.sku}    1
    When I send a POST request:    /guest-carts/${guest_cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": ""}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    code => This value should not be blank.
    [Teardown]    Cleanup all items in the guest cart:    ${guest_cart_id}

Add_voucher_to_guest_cart_without_voucher_code    
    [Setup]    Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount.concrete.product_with_voucher_code.sku}    1
    When I send a POST request:    /guest-carts/${guest_cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    code => This field is missing.
    [Teardown]    Cleanup all items in the guest cart:    ${guest_cart_id}

Add_voucher_code_to_cart_with_invalid_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /carts/fake_cart_id/vouchers    {"data": {"type": "vouchers","attributes": {"code": "fake_discount_voucher_code"}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Add_voucher_code_to_guest_cart_with_invalid_cart_id
    [Setup]    I set Headers:    X-Anonymous-Customer-Unique-Id=${x_anonymous_prefix}${random}
    When I send a POST request:    /guest-carts/fake_guest_cart_id/vouchers    {"data": {"type": "vouchers","attributes": {"code": "fake_discount_voucher_code"}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Add_voucher_code_from_another_discount_to_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    When I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "discount_voucher_code"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    3302
    And Response should return error message:    "Cart code cant be added."

Add_voucher_code_from_another_discount_to_guest_user_cart
    [Setup]    Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount.concrete.product_with_voucher_code.sku}    1
    When I send a POST request:    /guest-carts/${guest_cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "discount_voucher_code"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    3302
    And Response should return error message:    "Cart code cant be added."
    [Teardown]    Cleanup all items in the guest cart:    ${guest_cart_id}

Add_voucher_code_to_cart_without_voucher_discount
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    ...    AND    Cleanup all items in the cart:    ${cart_id}
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    When I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "discount_voucher_code"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    3302
    And Response should return error message:    "Cart code cant be added."

Add_voucher_code_to_guest_user_cart_without_voucher_discount
    [Setup]    Create a guest cart:    ${x_anonymous_prefix}${random}    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}    1
    When I send a POST request:    /guest-carts/${guest_cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "discount_voucher_code"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    3302
    And Response should return error message:    "Cart code cant be added."
    [Teardown]    Cleanup all items in the guest cart:    ${guest_cart_id}

Add_voucher_code_from_another_customer_to_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    ...    AND    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "discount_voucher_code"}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Add_voucher_code_from_another_customer_to_guest_user_cart
    [Setup]    Run Keywords    Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount.concrete.product_with_voucher_code.sku}    1
    ...   AND    I set Headers:    X-Anonymous-Customer-Unique-Id=fake_anonymous_customer_id
    When I send a POST request:    /guest-carts/${guest_cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "discount_voucher_code"}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.
    [Teardown]    Run Keywords    I set Headers:    X-Anonymous-Customer-Unique-Id=${x_anonymous_prefix}${random}
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}

Add_voucher_code_to_empty_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    ...    AND    Cleanup all items in the cart:    ${cart_id}
    When I send a POST request:    /carts/${cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "discount_voucher_code"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    3302
    And Response should return error message:    "Cart code cant be added."
    
Add_voucher_code_to_empty_guest_user_cart
    [Setup]    Run Keywords    Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount.concrete.product_with_voucher_code.sku}    1
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guest_cart_id}/vouchers    {"data": {"type": "vouchers","attributes": {"code": "discount_voucher_code"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    3302
    And Response should return error message:    "Cart code cant be added."



#DELETE requests
Delete_voucher_code_from_cart_with_invalid_access_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    ...    AND    I set Headers:    Authorization=fake_token
    When I send a DELETE request:    /carts/${cart_id}/vouchers/fake_discount_voucher_code
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Delete_voucher_code_from_cart_without_access_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    ...    AND    I set Headers:    Authorization=
    When I send a DELETE request:    /carts/${cart_id}/vouchers/fake_discount_voucher_code
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Delete_voucher_code_from_guest_user_cart_with_invalid_anonymous_customer_id
    [Setup]    Run Keywords    Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount.concrete.product_with_voucher_code.sku}    1
    ...   AND    I set Headers:    X-Anonymous-Customer-Unique-Id=fake_anonymous_customer_id
    When I send a DELETE request:    /guest-carts/${guest_cart_id}/vouchers/fake_discount_voucher_code
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.
    [Teardown]    Run Keywords    I set Headers:    X-Anonymous-Customer-Unique-Id=${x_anonymous_prefix}${random}
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}

Delete_voucher_code_from_guest_cart_without_anonymous_customer_id
    [Setup]    Run Keywords    Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount.concrete.product_with_voucher_code.sku}    1
    ...   AND    I set Headers:    X-Anonymous-Customer-Unique-Id=
    When I send a DELETE request:    /guest-carts/${guest_cart_id}/vouchers/fake_discount_voucher_code
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    109
    And Response should return error message:    Anonymous customer unique id is empty.
    [Teardown]    Run Keywords    I set Headers:    X-Anonymous-Customer-Unique-Id=${x_anonymous_prefix}${random}
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}

Delete_invalid_voucher_code_from_cart
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    When I send a DELETE request:    /carts/${cart_id}/vouchers/fake_discount_voucher_code
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    3301
    And Response should return error message:    Cart code not found in cart.

Delete_empty_voucher_code_from_cart
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    When I send a DELETE request:    /carts/${cart_id}/vouchers/
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Delete_voucher_from_cart_without_voucher_code
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    When I send a DELETE request:    /carts/${cart_id}/vouchers
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Delete_invalid_voucher_code_from_guest_user_cart
    [Setup]    Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount.concrete.product_with_voucher_code.sku}    1
    When I send a DELETE request:    /guest-carts/${guest_cart_id}/vouchers/fake_discount_voucher_code
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    3301
    And Response should return error message:    Cart code not found in cart.
    [Teardown]    Cleanup all items in the guest cart:    ${guest_cart_id}

Delete_empty_voucher_code_from_guest_user_cart
    [Setup]    Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount.concrete.product_with_voucher_code.sku}    1
    When I send a DELETE request:    /guest-carts/${guest_cart_id}/vouchers/
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.
    [Teardown]    Cleanup all items in the guest cart:    ${guest_cart_id}

Delete_voucher_from_guest_user_cart_without_voucher_code
    [Setup]    Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount.concrete.product_with_voucher_code.sku}    1
    When I send a DELETE request:    /guest-carts/${guest_cart_id}/vouchers
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.
    [Teardown]    Cleanup all items in the guest cart:    ${guest_cart_id}

Delete_voucher_code_from_cart_with_invalid_cart_id
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a DELETE request:    /carts/fake_cart_id/vouchers/fake_discount_voucher_code
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Delete_voucher_code_from_guest_user_cart_with_invalid_cart_id
    [Setup]    Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount.concrete.product_with_voucher_code.sku}    1
    When I send a DELETE request:    /guest-carts/fake_guest_cart_id/vouchers/fake_discount_voucher_code
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.
    [Teardown]    Cleanup all items in the guest cart:    ${guest_cart_id}

Delete_voucher_code_from_another_customer_cart
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    ...    AND    Cleanup all items in the cart:    ${cart_id}
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${discount.concrete.product_with_voucher_code.sku}","quantity": 1}}}
    ...    AND    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a DELETE request:    /carts/${cart_id}/vouchers/discount_voucher_code
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Delete_voucher_code_from_another_customer_guest_cart
    [Setup]    Run Keywords    Create a guest cart:    ${x_anonymous_prefix}${random}    ${discount.concrete.product_with_voucher_code.sku}    1
    ...   AND    I set Headers:    X-Anonymous-Customer-Unique-Id=fake_anonymous_customer_id
    When I send a DELETE request:    /guest-carts/${guest_cart_id}/vouchers/discount_voucher_code
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.
    [Teardown]    Run Keywords    I set Headers:    X-Anonymous-Customer-Unique-Id=${x_anonymous_prefix}${random}
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}