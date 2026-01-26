*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    quotation-process    spryker-core    cart    acl    customer-account-management    customer-access    approval-process

*** Test Cases ***
#POST#
Create_quote_request_without_access_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I set Headers:    Authorization=
    When I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    Then Response status code should be:    403
    And Response should return error code:    002
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.

Create_quote_request_with_invalid_access_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I set Headers:    Authorization=345A9
    When I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    Then Response status code should be:    401
    And Response should return error code:    001
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.

Create_quote_request_with_invalid_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity": 1}}}
    When I send a POST request:    /quote-requests    {"data":{"type":"Invalid","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}
    ...    AND    Response status code should be:    204

Create_quote_request_with_empty_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity": 1}}}
    When I send a POST request:    /quote-requests    {"data":{"type":"","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}
    ...    AND    Response status code should be:    204

Create_quote_request_with_invalid_cartId
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"Test123","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    Then Response status code should be:    404
    And Response should return error code:    101
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.

Create_quote_request_with_empty_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    Then Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    cartUuid => This value should not be blank.

Create_quote_request_from_another_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...  AND    Save value to a variable:    [data][attributes][accessToken]    first_user_token
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity": 1}}}
    ...  AND    I get access token for the customer:    ${yves_fifth_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    Then Response status code should be:    404
    And Response should return error code:    101
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.
    [Teardown]    Run Keywords    I set Headers:    Authorization=Bearer ${first_user_token}
    ...    AND    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204

Create_quote_request_for_cart_with_read_only_access
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    userToken
    ...    AND    I set Headers:    Authorization=Bearer ${userToken}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Get company user id by customer reference:    ${yves_fifth_user.reference}
    ...    AND    I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":2}}}
    ...    AND    Save value to a variable:    [data][id]    shared_cart_id
    ...    AND    I send a PATCH request:    /shared-carts/${shared_cart_id}    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":1}}}
    ...    AND    I get access token for the customer:    ${yves_fifth_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a GET request:    /carts/${shared_cart_id}?include=cart-permission-groups
    When I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    Request for quote denied. User does not have permissions to request quote.
    And Response should return error code:    4506
    [Teardown]    Run Keywords    I set Headers:    Authorization=Bearer ${userToken}
    ...    AND    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

# #GET#
Retrieve_quote_requests_with_incorrect_url
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /quoterequests
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    Not Found

Retrieve_quote_requests_without_token
    When I send a GET request:    /quote-requests
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Retrieve_quote_requests_with_invalid_access_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=324H4
    When I send a GET request:    /quote-requests
    Then Response status code should be:    401
    And Response should return error code:    001
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.

Retrieve_quote_request_with_incorrect_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /quote-requests/test123
    Then Response status code should be:    404
    And Response should return error code:    4501
    And Response reason should be:    Not Found
    And Response should return error message:    Quote request not found.

Retrieve_quote_request_by_id_with_incorrect_url
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /quoterequests/test123
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    Not Found

#PATCH#
Update_quote_request_without_token
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity": 1}}}
    ...    AND    I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    quoteRequestId
    ...    AND    I set Headers:    Authorization=
    When I send a PATCH request:    /quote-requests/${quoteRequestId}    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"note":"Test1"}}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.
    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...    AND    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204

Update_quote_request_with_empty_id
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    When I send a PATCH request:    /quote-requests/    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"note":"Test1"}}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}
    ...    AND    Response status code should be:    204

Update_quote_request_with_incorrect_id
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    userToken
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    When I send a PATCH request:    /quote-requests/test123    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"note":"Test1"}}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    4501
    And Response should return error message:    Quote request not found.
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}
    ...    AND    Response status code should be:    204

Update_quote_request_with_empty_cart_id
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity": 1}}}
    ...    AND    I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    quoteRequestId
    When I send a PATCH request:    /quote-requests/${quoteRequestId}    {"data":{"type":"quote-requests","attributes":{"cartUuid":"","meta":{"note":"Test1"}}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    cartUuid => This value should not be blank.
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}
    ...    AND    Response status code should be:    204

Update_quote_request_with_invalid_cart_id
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity": 1}}}
    ...    AND    I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    quoteRequestId
    When I send a PATCH request:    /quote-requests/${quoteRequestId}    {"data":{"type":"quote-requests","attributes":{"cartUuid":"Invalid","meta":{"note":"Test1"}}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}
    ...    AND    Response status code should be:    204

Update_quote_request_with_invalid_type
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity": 1}}}
    ...    AND    I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    quoteRequestId
    When I send a PATCH request:    /quote-requests/${quoteRequestId}    {"data":{"type":"invalid","attributes":{"cartUuid":"Invalid","meta":{"note":"Test1"}}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}
    ...    AND    Response status code should be:    204

Update_quote_request_with_empty_type
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity": 1}}}
    ...    AND    I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    quoteRequestId
    When I send a PATCH request:    /quote-requests/${quoteRequestId}    {"data":{"type":"","attributes":{"cartUuid":"Invalid","meta":{"note":"Test1"}}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}
    ...    AND    Response status code should be:    204

Update_quote_request_with_another_user_token
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    first_user_token
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity": 1}}}
    ...    AND    I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    quoteRequestId
    ...  AND    I get access token for the customer:    ${yves_fifth_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a PATCH request:    /quote-requests/${quoteRequestId}    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"note":"Test1"}}}}
    Then Response status code should be:    404
    And Response should return error code:    4501
    And Response reason should be:    Not Found
    And Response should return error message:    Quote request not found.
    [Teardown]    Run Keywords    I set Headers:    Authorization=Bearer ${first_user_token}
    ...    AND    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
