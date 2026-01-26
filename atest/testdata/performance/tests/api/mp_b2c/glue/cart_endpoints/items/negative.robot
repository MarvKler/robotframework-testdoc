*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    cart    product    configurable-product    inventory-management    marketplace-inventory-management

*** Test Cases ***
###### POST #######
Add_item_to_cart_non_existing_sku
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    Find or create customer cart
    When I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "fake","quantity": 1}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    102
    And Response should return error message:    Product "fake" not found

Add_item_to_non_existing_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a POST request:    /carts/fake/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Add_item_to_missing_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a POST request:    /carts//items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    104
    And Response should return error message:    Cart uuid is missing.

Add_item_to_cart_with_invalid_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=asdasfas
    When I send a POST request:    /carts/han/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Add_item_to_cart_with_missing_token
    When I send a POST request:    /carts/fake/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Add_item_to_cart_with_wrong_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /carts
    ...    AND    Save value to a variable:    [data][0][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items    {"data": {"type": "carts","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.

Add_item_to_cart_with_missing_properties
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /carts
    ...    AND    Save value to a variable:    [data][0][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items    {"data": {"type": "items","attributes": {}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    sku => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    quantity => This field is missing.

Add_item_to_cart_with_invalid_properties
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /carts
    ...    AND    Save value to a variable:    [data][0][id]    cart_uid
    When I send a POST request:    /carts/${cart_uid}/items    {"data": {"type": "items","attributes": {"sku": "","quantity": "" }}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    sku => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should be of type numeric.
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should be greater than 0.

###### PATCH #######
Update_item_in_cart_with_non_existing_item_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /carts
    ...    AND    Save value to a variable:    [data][0][id]    cart_uid
    When I send a PATCH request:    /carts/${cart_uid}/items/fake    {"data": {"type": "items","attributes": {"quantity": 1}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    103
    And Response should return error message:    Item with the given group key not found in the cart.


Update_item_in_cart_with_no_item_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /carts
    ...    AND    Save value to a variable:    [data][0][id]    cart_uid
    When I send a PATCH request:    /carts/${cart_uid}/items    {"data": {"type": "items","attributes": {"quantity": 1}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Update_item_in_cart_with_non_existing_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a PATCH request:    /carts/fake/items/fake    {"data": {"type": "items","attributes": {"quantity": 1}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Update_item_in_cart_with_no_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /carts
    ...    AND    Save value to a variable:    [data][0][id]    cart_uid
    ...    AND    I send a POST request:    /carts/${cart_uid}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_uid
    When I send a PATCH request:    /carts//items/${item_uid}    {"data": {"type": "items","attributes": {"quantity": 1}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.


Update_item_in_cart_with_another_user_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    find or create customer cart
    ...    AND    Cleanup all items in the cart:    ${cart_id}
    ...    AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_uid
    ...    AND    I get access token for the customer:    ${Yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a PATCH request:    /carts/${cart_id}/items/${item_uid}    {"data": {"type": "items","attributes": {"quantity": 1}}}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Update_item_with_invalid_parameters
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    find or create customer cart
    ...    AND    Cleanup all items in the cart:    ${cart_id}
    ...    AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...    AND    Save value to a variable:    [included][0][id]    item_uid
    When I send a PATCH request:    /carts/${cart_id}/items/${item_uid}    {"data": {"type": "items","attributes": {"quantity":""}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    quantity => This value should be of type numeric.
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}/items/${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
    ...    AND    Response status code should be:    204

###### DELETE #######
Delete_cart_item_with_non_existing_item_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    find or create customer cart
    ...    AND    Cleanup all items in the cart:    ${cart_id}
    ...    AND    I send a GET request:    /carts
    ...    AND    Save value to a variable:    [data][0][id]    cart_id
    When I send a DELETE request:    /carts/${cart_id}/items/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    103
    And Response should return error message:    Item with the given group key not found in the cart.

Delete_cart_item_with_empty_item_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /carts
    ...    AND    Save value to a variable:    [data][0][id]    cart_uid
    When I send a DELETE request:    /carts/${cart_uid}/items
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Delete_cart_item_with_non_existing_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a DELETE request:    /carts/fake/items/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    101
    And Response should return error message:    Cart with given uuid not found.

Delete_cart_item_with_missing_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a DELETE request:    /carts//items/fake
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Add_a_configurable_product_to_the_cart_with_empty_quantity
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
   ...    AND    Find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}
   I send a POST request:    /carts/${cart_id}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${configurable_product.sku_1}","quantity":"","productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    422
   And Response should return error code:    901
   And Response reason should be:    Unprocessable Content
   And Response should return error message:    quantity => This value should not be blank.
   When I send a GET request:    /carts/${cart_id}?include=items,concrete-products
   Then Response status code should be:    200
   And Response reason should be:    OK
   And Response body parameter should be:  [data][attributes][totals][priceToPay]    0
   And Response body parameter should not be EMPTY:    [data][links][self]

Add_a_configurable_product_to_the_cart_with_0_quantity
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
   ...    AND    Find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}
   I send a POST request:    /carts/${cart_id}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${configurable_product.sku_1}","quantity":"0","productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    422
   And Response should return error code:    901
   And Response reason should be:    Unprocessable Content
   And Response should return error message:    quantity => This value should be greater than 0.
   When I send a GET request:    /carts/${cart_id}?include=items,concrete-products
   Then Response status code should be:    200
   And Response reason should be:    OK
   And Response body parameter should be:  [data][attributes][totals][priceToPay]    0
   And Response body parameter should not be EMPTY:    [data][links][self]

Add_a_configurable_product_to_the_cart_with_negative_quantity
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
   ...    AND    Find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}
   I send a POST request:    /carts/${cart_id}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${configurable_product.sku_1}","quantity":"-1","productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    422
   And Response should return error code:    901
   And Response reason should be:    Unprocessable Content
   And Response should return error message:    quantity => This value should be greater than 0.
   When I send a GET request:    /carts/${cart_id}?include=items,concrete-products
   Then Response status code should be:    200
   And Response reason should be:    OK
   And Response body parameter should be:  [data][attributes][totals][priceToPay]    0
   And Response body parameter should not be EMPTY:    [data][links][self]

Add_a_configurable_product_to_the_cart_with_negative_price
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
   ...    AND    Find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}
   I send a POST request:    /carts/${cart_id}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${configurable_product.sku_1}","quantity":"1","productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":-23434,"grossAmount":-42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    422
   And Response should return error code:    901
   And Response reason should be:    Unprocessable Content
   And Array in response should contain property with value:
   ...    [errors]
   ...    detail
   ...    productConfigurationInstance.prices.0.netAmount => This value should be greater than or equal to 0.
   And Array in response should contain property with value:
   ...    [errors]
   ...    detail
   ...    productConfigurationInstance.prices.0.grossAmount => This value should be greater than or equal to 0.
   When I send a GET request:    /carts/${cart_id}?include=items,concrete-products
   Then Response status code should be:    200
   And Response reason should be:    OK
   And Response body parameter should be:  [data][attributes][totals][priceToPay]    0
   And Response body parameter should not be EMPTY:    [data][links][self]

Add_a_configurable_product_to_the_cart_with_empty_price
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
   ...    AND    Find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}
   I send a POST request:    /carts/${cart_id}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${configurable_product.sku_1}","quantity":"1","productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":"","grossAmount":"","currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    422
   And Response should return error code:    901
   And Response reason should be:    Unprocessable Content
   And Array in response should contain property with value:
   ...    [errors]
   ...    detail
   ...    productConfigurationInstance.prices.0.netAmount => This value should not be blank.
   And Array in response should contain property with value:
   ...    [errors]
   ...    detail
   ...    productConfigurationInstance.prices.0.grossAmount => This value should not be blank.
   When I send a GET request:    /carts/${cart_id}?include=items,concrete-products
   Then Response status code should be:    200
   And Response reason should be:    OK
   And Response body parameter should be:  [data][attributes][totals][priceToPay]    0
   And Response body parameter should not be EMPTY:    [data][links][self]

Add_a_configurable_product_with_missing_isComplete_value_of_to_the_cart
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
   ...    AND    Find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}
   I send a POST request:    /carts/${cart_id}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${configurable_product.sku_1}","quantity":"1","productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    422
   And Response should return error code:    901
   And Response reason should be:    Unprocessable Content
   And Response should return error message:    productConfigurationInstance.isComplete => This field is missing.
   When I send a GET request:    /carts/${cart_id}?include=items,concrete-products
   Then Response status code should be:    200
   And Response reason should be:    OK
   And Response body parameter should be:  [data][attributes][totals][priceToPay]    0
   And Response body parameter should not be EMPTY:    [data][links][self]

