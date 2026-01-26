*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    promotions-discounts    product-promotions


*** Test Cases ***
####### POST #######

Adding_not_existing_voucher_code_to_cart_of_logged_in_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "419901","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a POST request:
    ...    /carts/${cart_id}/vouchers
    ...    {"data": {"type": "vouchers","attributes": {"code": "1111111"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response body parameter should not be EMPTY:    [errors]
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

Adding_voucher_code_that_could_not_be_applied_to_cart_of_logged_in_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "464012","quantity": 1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Get voucher code by discountId from Database:    3
    When I send a POST request:
    ...    /carts/${cart_id}/vouchers
    ...    {"data": {"type": "vouchers","attributes": {"code": "${discount_voucher_code}"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    3302
    And Response should return error message:    "Cart code cant be added."
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

Adding_voucher_code_with_invalid_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Get voucher code by discountId from Database:    3
    When I send a POST request:
    ...    /carts/invalidCartId/vouchers
    ...    {"data": {"type": "vouchers","attributes": {"code": "${discount_voucher_code}"}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Adding_voucher_without_access_token
    [Setup]    Get voucher code by discountId from Database:    3
    And I send a POST request:
    ...    /carts/fake/vouchers
    ...    {"data": {"type": "vouchers","attributes": {"code": "${discount_voucher_code}"}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Adding_voucher_with_invalid_access_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization="fake"
    ...    AND    Get voucher code by discountId from Database:    3
    When I send a POST request:
    ...    /carts/invalidCartId/vouchers
    ...    {"data": {"type": "vouchers","attributes": {"code": "${discount_voucher_code}"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

####### DELETE #######
# Fails because of CC-16719

Deleting_voucher_without_access_token
    [Setup]    Run Keywords    I set Headers:    Authorization=
    ...    AND    Get voucher code by discountId from Database:    3
    And I send a DELETE request:    /carts/cart_id/vouchers/${discount_voucher_code}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

# Fails because of CC-16719

Deleting_voucher_with_invalid_access_token
    [Setup]    Run Keywords    I set Headers:    Authorization="fake"
    ...    AND    Get voucher code by discountId from Database:    3
    When I send a DELETE request:    /carts/cart_id/vouchers/${discount_voucher_code}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Deleting_voucher_code_with_invalid_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Get voucher code by discountId from Database:    3
    When I send a DELETE request:    /carts/invalidCartId/vouchers/${discount_voucher_code}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.
