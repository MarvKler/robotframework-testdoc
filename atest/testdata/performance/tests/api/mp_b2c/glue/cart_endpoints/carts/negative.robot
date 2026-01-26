*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    cart    customer-access    spryker-core

*** Test Cases ***
Get_cart_by_cart_id_with_invalid_access_token
   [Setup]    I set Headers:    Authorization=3485h7
    When I send a GET request:    /carts/not-existing-cart
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001

Get_cart_by_cart_id_without_access_token
     [Setup]    I set Headers:    Authorization=
    When I send a GET request:    /carts/not-existing-cart
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002

Get_cart_with_non_existing_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
       ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /carts/12345678
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Get_cart_by_cart_id_from_another_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
        ...  AND    I set Headers:    Authorization=${token}
        ...  AND    Find or create customer cart
        ...  AND    I get access token for the customer:    ${Yves_second_user.email}
        ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /carts/${cart_id}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.
    And Response should return error code:    101

Get_cart_by_customer_id_with_invalid_access_token
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
        ...  AND    I set Headers:    Authorization=${token}
        ...  AND    Find or create customer cart
        ...  AND    I get access token for the customer:    ${Yves_second_user.email}
        ...  AND    I set Headers:    Authorization=234567thgf
    When I send a GET request:    /customers/${Yves_second_user.reference}/carts
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001

Get_cart_by_customer_id_without_access_token
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
        ...  AND    I set Headers:    Authorization=${token}
        ...  AND    Find or create customer cart
        ...  AND    I get access token for the customer:    ${Yves_second_user.email}
        ...  AND    I set Headers:    Authorization=
    When I send a GET request:    /customers/${Yves_second_user.reference}/carts
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002

Get_cart_with_non_existing_customer_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
       ...  AND    I set Headers:    Authorization=${token}
       ...  AND    Find or create customer cart
       ...  AND    I get access token for the customer:    ${Yves_second_user.email}
    When I send a GET request:    /customers/user-01/carts
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    802
    And Response should return error message:    Unauthorized request.

Get_cart_without_customer_id
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
         ...  AND    I set Headers:    Authorization=${token}
         ...  AND    Find or create customer cart
         ...  AND    I get access token for the customer:    ${Yves_second_user.email}
    When I send a GET request:    /customers//carts
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    802
    And Response should return error message:    Unauthorized request.

Get_cart_from_another_customer_id
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
       ...  AND    I set Headers:    Authorization=${token}
       ...  AND    Find or create customer cart
       ...  AND    I get access token for the customer:    ${Yves_second_user.email}
       ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /customers/${Yves_user.reference}/carts
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    802
    And Response should return error message:    Unauthorized request.

Create_cart_with_invalid_access_token
    When I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002

Create_cart_when_cart_already_exists
      [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
             ...  AND    I set Headers:    Authorization=${token}
             ...  AND    Find or create customer cart
    When I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    Customer already has a cart.

#PATCH requests
Update_cart_with_invalid_access_token
      [Setup]    I set Headers:    Authorization=u2g3v4b6jk55b    If-Match=wrong_tag
    When I send a PATCH request:    /carts/not-existing-cart    {"data": {"type": "carts","attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001

Update_cart_without_access_token
     [Setup]    I set Headers:    Authorization=    If-Match=wrong_tag
    When I send a PATCH request:    /carts/not-existing-cart    {"data": {"type": "carts","attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002

Update_cart_with_non_existing_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
            ...  AND    I set Headers:    Authorization=${token}
            ...  AND    Find or create customer cart
            ...  AND    Save Header value to a variable:    ETag    header_tag
            ...  AND    I set Headers:    Authorization=${token}    If-Match=${header_tag}
    When I send a PATCH request:    /carts/8567km    {"data": {"type": "carts","attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    412
    And Response reason should be:    Precondition Failed
    And Response should return error message:    If-Match header value is invalid.
    And Response should return error code:    006

Update_cart_without_cart_id
      [Setup]    I set Headers:    Authorization=u2g3v4b6jk55b    If-Match=wrong_tag
    When I send a PATCH request:    /carts/    {"data": {"type": "carts","attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.


Update_cart_from_another_customer_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
        ...  AND    I set Headers:    Authorization=${token}
        ...  AND    Find or create customer cart
        ...  AND    Cleanup all items in the cart:    ${cart_id}
        ...  AND    Get ETag header value from cart
        ...  AND    I get access token for the customer:    ${Yves_second_user.email}
        ...  AND    I set Headers:    Authorization=${token}    If-Match=${Etag}

    When I send a PATCH request:    /carts/${cart_id}    {"data": {"type": "carts","attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error message:    Cart with given uuid not found.
    And Response should return error code:    101

Update_cart_with_invalid_header_tag
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
        ...  AND    I set Headers:    Authorization=${token}
        ...  AND    Find or create customer cart
        ...  AND    I set Headers:    Authorization=${token}    If-Match="3278654tv3"
    When I send a PATCH request:    /carts/${cart_id}    {"data": {"type": "carts","attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    412
    And Response reason should be:    Precondition Failed
    And Response should return error message:    If-Match header value is invalid.
    And Response should return error code:    006

Update_cart_without_header_tag
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
        ...  AND    I set Headers:    Authorization=${token}
        ...  AND    Find or create customer cart
    When I send a PATCH request:    /carts/${cart_id}    {"data": {"type": "carts","attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    428
    And Response reason should be:    Precondition Required
    And Response should return error message:    If-Match header is missing.
    And Response should return error code:    005

Update_cart_with_invalid_type
       [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
        ...  AND    I set Headers:    Authorization=${token}
        ...  AND    Find or create customer cart
        ...  AND    Save Header value to a variable:    ETag    header_tag
        ...  AND    I set Headers:    Authorization=${token}    If-Match=${header_tag}
    When I send a PATCH request:    /carts/${cart_id}    {"data": {"type": "car","attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.

Update_cart_without_type
       [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
        ...  AND    I set Headers:    Authorization=${token}
        ...  AND    Find or create customer cart
        ...  AND    Save Header value to a variable:    ETag    header_tag
        ...  AND    I set Headers:    Authorization=${token}    If-Match=${header_tag}
    When I send a PATCH request:    /carts/${cart_id}    {"data": {"attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Post data is invalid.

Update_cart_with_invalid_priceMod_currency_store
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
        ...  AND    I set Headers:    Authorization=${token}
        ...  AND    Find or create customer cart
        ...  AND    Cleanup all items in the cart:    ${cart_id}
        ...  AND    Get ETag header value from cart
        ...  AND    I set Headers:    Authorization=${token}    If-Match=${Etag}
    When I send a PATCH request:    /carts/${cart_id}    {"data": {"type": "carts","attributes": {"priceMode": "GROSS","currency": "EU","store": "DEK"}}}
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
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}


Delete_cart_by_cart_id
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
       ...  AND    I set Headers:    Authorization=${token}
       ...  AND    Find or create customer cart
    When I send a DELETE request:    /carts/${cart_id}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    Cart could not be deleted.
    And Response should return error code:    105
