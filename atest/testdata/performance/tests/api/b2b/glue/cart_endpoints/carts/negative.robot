*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    cart    customer-access    spryker-core


*** Test Cases ***
#GET requests

Get_cart_by_cart_id_with_invalid_access_token
    [Setup]    I set Headers:    Authorization=3485h7
    When I send a GET request:    /carts/not-existing-cart
    Then Response status code should be:    ${401}
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001

Get_cart_by_cart_id_without_access_token
    [Setup]    I set Headers:    Authorization=
    When I send a GET request:    /carts/not-existing-cart
    Then Response status code should be:    ${403}
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002

Get_cart_with_non_existing_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /carts/12345678
    Then Response status code should be:    ${404}
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Get_cart_by_cart_id_from_another_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    first_user_token
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /carts/${cart_id}
    Then Response status code should be:    ${404}
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.
    And Response should return error code:    101
    [Teardown]    Run Keywords    I set Headers:    Authorization=Bearer ${first_user_token}
    ...    AND    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

Get_cart_by_customer_id_with_invalid_access_token
    [Setup]    I set Headers:    Authorization=234567thgf
    When I send a GET request:    /customers/${yves_user.reference}/carts
    Then Response status code should be:    ${401}
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001

Get_cart_by_customer_id_without_access_token
    [Setup]    I set Headers:    Authorization=
    When I send a GET request:    /customers/${yves_user.reference}/carts
    Then Response status code should be:    ${403}
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002

Get_cart_with_non_existing_customer_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /customers/user-01/carts
    Then Response status code should be:    ${403}
    And Response reason should be:    Forbidden
    And Response should return error code:    802
    And Response should return error message:    Unauthorized request.

Get_cart_without_customer_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /customers//carts
    Then Response status code should be:    ${403}
    And Response reason should be:    Forbidden
    And Response should return error code:    802
    And Response should return error message:    Unauthorized request.

Get_cart_from_another_customer_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    first_user_token
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /customers/${yves_user.reference}/carts
    Then Response status code should be:    ${403}
    And Response reason should be:    Forbidden
    And Response should return error code:    802
    And Response should return error message:    Unauthorized request.
    [Teardown]    Run Keywords    I set Headers:    Authorization=Bearer ${first_user_token}
    ...    AND    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

#POST requests

Create_cart_with_invalid_access_token
    When I send a POST request:
    ...    /carts
    ...    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    Then Response status code should be:    ${403}
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002

Create_cart_without_access_token
    When I send a POST request:
    ...    /carts
    ...    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    Then Response status code should be:    ${403}
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002

Create_cart_with_invalid_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:
    ...    /carts
    ...    {"data": {"type": "car","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    Then Response status code should be:    ${400}
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.

Create_cart_without_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:
    ...    /carts
    ...    {"data": {"attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    Then Response status code should be:    ${400}
    And Response reason should be:    Bad Request
    And Response should return error message:    Post data is invalid.

Create_cart_with_invalid_store
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:
    ...    /carts
    ...    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "D","name": "${test_cart_name}"}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    112
    And Response should return error message:    Store data is invalid.

Create_cart_with_invalid_priceMod_and_currency
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:
    ...    /carts
    ...    {"data": {"type": "carts","attributes": {"priceMode": "GROSS","currency": "EU","store": "${store.de}","name": "${test_cart_name}"}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Response body parameter should be:    [errors][0][code]    117
    And Response body parameter should be:    [errors][0][detail]    Currency is incorrect.
    And Response body parameter should be:    [errors][1][code]    119
    And Response body parameter should be:    [errors][1][detail]    Price mode is incorrect.
    And Response body parameter should be:    [errors][2][code]    107
    And Response body parameter should be:    [errors][2][detail]    Failed to create cart.

Create_cart_with_empty_attributes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:
    ...    /carts
    ...    {"data": {"type": "carts","attributes": {"priceMode": "","currency": "","store": "","name": ""}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Array in response should contain property with value:
    ...    [errors]
    ...    detail
    ...    priceMode => This value should not be blank.
    And Array in response should contain property with value:
    ...    [errors]
    ...    detail
    ...    currency => This value should not be blank.
    And Array in response should contain property with value:
    ...    [errors]
    ...    detail
    ...    store => This value should not be blank.
    And Array in response should contain property with value:
    ...    [errors]
    ...    detail
    ...    name => This value should not be blank.

Create_cart_without_attributes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /carts    {"data": {"type": "carts","attributes": {}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Array in response should contain property with value:
    ...    [errors]
    ...    detail
    ...    priceMode => This field is missing.
    And Array in response should contain property with value:
    ...    [errors]
    ...    detail
    ...    currency => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    store => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    name => This field is missing.

#PATCH requests

Update_cart_with_invalid_access_token
    [Setup]    I set Headers:    Authorization=u2g3v4b6jk55b    If-Match=ETag
    When I send a PATCH request:
    ...    /carts/not-existing-cart
    ...    {"data": {"type": "carts","attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    Then Response status code should be:    ${401}
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001

Update_cart_without_access_token
    [Setup]    I set Headers:    Authorization=    If-Match=If-Match=ETag
    When I send a PATCH request:
    ...    /carts/not-existing-cart
    ...    {"data": {"type": "carts","attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    Then Response status code should be:    ${403}
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002

Update_cart_with_non_existing_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Save Header value to a variable:    ETag    header_tag
    ...    AND    Response status code should be:    201
    ...    AND    I set Headers:    Authorization=${token}    If-Match=${header_tag}
    When I send a PATCH request:
    ...    /carts/8567km
    ...    {"data": {"type": "carts","attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    Then Response status code should be:    ${412}
    And Response reason should be:    Precondition Failed
    And Response should return error message:    If-Match header value is invalid.
    And Response should return error code:    006
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

Update_cart_without_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Save Header value to a variable:    ETag    header_tag
    ...    AND    Response status code should be:    201
    ...    AND    I set Headers:    Authorization=${token}    If-Match=${header_tag}
    When I send a PATCH request:
    ...    /carts/
    ...    {"data": {"type": "carts","attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    Then Response status code should be:    ${400}
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

Update_cart_from_another_customer_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    first_user_token
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Save Header value to a variable:    ETag    header_tag
    ...    AND    Response status code should be:    201
    ...    AND    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Authorization=${token}    If-Match=${header_tag}
    When I send a PATCH request:
    ...    /carts/${cart_id}
    ...    {"data": {"type": "carts","attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    Then Response status code should be:    ${404}
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.
    And Response should return error code:    101
    [Teardown]    Run Keywords    I set Headers:    Authorization=Bearer ${first_user_token}
    ...    AND    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

Update_cart_with_invalid_header_tag
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I set Headers:    Authorization=${token}    If-Match="3278654tv3"
    When I send a PATCH request:
    ...    /carts/${cart_id}
    ...    {"data": {"type": "carts","attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    Then Response status code should be:    ${412}
    And Response reason should be:    Precondition Failed
    And Response should return error message:    If-Match header value is invalid.
    And Response should return error code:    006
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

Update_cart_without_header_tag
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    When I send a PATCH request:
    ...    /carts/${cart_id}
    ...    {"data": {"type": "carts","attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    Then Response status code should be:    ${428}
    And Response reason should be:    Precondition Required
    And Response should return error message:    If-Match header is missing.
    And Response should return error code:    005
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

Update_cart_with_invalid_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Save Header value to a variable:    ETag    header_tag
    ...    AND    Response status code should be:    201
    ...    AND    I set Headers:    Authorization=${token}    If-Match=${header_tag}
    When I send a PATCH request:
    ...    /carts/${cart_id}
    ...    {"data": {"type": "car","attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    Then Response status code should be:    ${400}
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

Update_cart_without_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Save Header value to a variable:    ETag    header_tag
    ...    AND    Response status code should be:    201
    ...    AND    I set Headers:    Authorization=${token}    If-Match=${header_tag}
    When I send a PATCH request:
    ...    /carts/${cart_id}
    ...    {"data": {"attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    Then Response status code should be:    ${400}
    And Response reason should be:    Bad Request
    And Response should return error message:    Post data is invalid.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

Update_cart_with_empty_name
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Save Header value to a variable:    ETag    header_tag
    ...    AND    Response status code should be:    201
    ...    AND    I set Headers:    Authorization=${token}    If-Match=${header_tag}
    When I send a PATCH request:    /carts/${cart_id}    {"data": {"type": "carts","attributes": {"name": ""}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    name => This value should not be blank.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

Update_cart_with_invalid_priceMod_currency_store
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Save Header value to a variable:    ETag    header_tag
    ...    AND    Response status code should be:    201
    ...    AND    I set Headers:    Authorization=${token}    If-Match=${header_tag}
    When I send a PATCH request:
    ...    /carts/${cart_id}
    ...    {"data": {"type": "carts","attributes": {"priceMode": "GROSS","currency": "EU","store": "DEK"}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Response body parameter should be:    [errors][0][code]    117
    And Response body parameter should be:    [errors][0][detail]    Currency is incorrect.
    And Response body parameter should be:    [errors][1][code]    119
    And Response body parameter should be:    [errors][1][detail]    Price mode is incorrect.
    When I send a GET request:    /carts/${cart_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

#DELETE requests

Delete_cart_with_invalid_access_token
    [Setup]    I set Headers:    Authorization=iuhiu6gi7
    When I send a DELETE request:    /carts/not-existing-cart
    Then Response status code should be:    ${401}
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001

Delete_cart_without_access_token
    [Setup]    I set Headers:    Authorization=
    When I send a DELETE request:    /carts/not-existing-cart
    Then Response status code should be:    ${403}
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002

Delete_cart_with_invalid_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a DELETE request:    /carts/88ca6f79
    Then Response status code should be:    ${404}
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.
    And Response should return error code:    101

Delete_cart_without_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a DELETE request:    /carts/
    Then Response status code should be:    ${400}
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Delete_cart_from_another_customer_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    first_user_token
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a DELETE request:    /carts/${cart_id}
    Then Response status code should be:    ${404}
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.
    And Response should return error code:    101
    [Teardown]    Run Keywords    I set Headers:    Authorization=Bearer ${first_user_token}
    ...    AND    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204
