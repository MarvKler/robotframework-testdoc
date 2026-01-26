*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    shopping-lists    product    bundle-products   prices    configurable-product    configurable-product-shopping-lists    customer-access    customer-account-management    acl


*** Test Cases ***
Add_a_concrete_product_to_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:
    ...    /shopping-lists/${shoppingListId}/shopping-list-items
    ...    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:
    ...    [data][attributes][sku]
    ...    ${concrete.available_product.with_stock.product_1.sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_concrete_product_to_the_shopping_list_with_includes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:
    ...    /shopping-lists/${shoppingListId}/shopping-list-items?include=concrete-products
    ...    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:
    ...    [data][attributes][sku]
    ...    ${concrete.available_product.with_stock.product_1.sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:    concrete-products
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_one_more_product_to_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    I send a POST request:
    ...    /shopping-lists/${shoppingListId}/shopping-list-items
    ...    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundle_product.product_1.concrete_sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${bundle_product.product_1.concrete_sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And I send a GET request:    /shopping-lists/${shoppingListId}
    And Response status code should be:    200
    And Response body parameter should be:    [data][attributes][numberOfItems]    2
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_the_same_product_to_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    I send a POST request:
    ...    /shopping-lists/${shoppingListId}/shopping-list-items
    ...    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:
    ...    [data][attributes][sku]
    ...    ${concrete.available_product.with_stock.product_1.sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And I send a GET request:    /shopping-lists/${shoppingListId}
    And Response status code should be:    200
    And Response body parameter should be:    [data][attributes][numberOfItems]    2
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_concrete_product_with_random_weight_to_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:
    ...    /shopping-lists/${shoppingListId}/shopping-list-items
    ...    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete.random_weight.sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${concrete.random_weight.sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_bundle_concrete_product_to_the_shopping_list_with_includes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:
    ...    /shopping-lists/${shoppingListId}/shopping-list-items?include=concrete-products
    ...    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundle_product.product_1.concrete_sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${bundle_product.product_1.concrete_sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:    concrete-products
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

# need to find unavailable product

Add_an_unavailable_product_to_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:
    ...    /shopping-lists/${shoppingListId}/shopping-list-items
    ...    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete.unavailable_products_sku}","quantity":1}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:    [data][attributes][sku]    ${concrete.unavailable_products_sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_a_concrete_product_to_the_shared_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /shopping-lists/
    ...    AND    Save value to a variable:    [data][0][id]    sharedShoppingListId
    ...    AND    I get access token for the customer:    ${yves_shared_shopping_list_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a POST request:
    ...    /shopping-lists/${sharedShoppingListId}/shopping-list-items
    ...    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":1}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    shoppingListItemId
    And Response body parameter should be:    [data][attributes][quantity]    1
    And Response body parameter should be:
    ...    [data][attributes][sku]
    ...    ${concrete.available_product.with_stock.product_1.sku}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items/${shoppingListItemId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_quantity_of_the_concrete_product_in_the_shopping_list_with_includes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a PATCH request:
    ...    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}?include=concrete-products
    ...    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][quantity]    2
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:    concrete-products
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_quantity_of_the_bundle_concrete_product_in_the_shopping_list_with_includes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundle_product.product_1.concrete_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a PATCH request:
    ...    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}?include=concrete-products
    ...    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][quantity]    2
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:    concrete-products
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_quantity_of_the_concrete_product_in_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a PATCH request:
    ...    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}
    ...    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][quantity]    2
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_quantity_of_a_concrete_product_at_the_shared_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /shopping-lists/
    ...    AND    Save value to a variable:    [data][0][id]    sharedShoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    ...    AND    I get access token for the customer:    ${yves_shared_shopping_list_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a PATCH request:
    ...    /shopping-lists/${sharedShoppingListId}/shopping-list-items/${shoppingListItemId}
    ...    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response body parameter should be:    [data][attributes][quantity]    2
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items/${shoppingListItemId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_quantity_of_the_bundle_concrete_product_in_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundle_product.product_1.concrete_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a PATCH request:
    ...    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}
    ...    {"data":{"type":"shopping-list-items","attributes":{"quantity":2}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][quantity]    2
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Remove_a_concrete_product_from_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a DELETE request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}
    And Response status code should be:    204
    And Response reason should be:    No Content
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Remove_a_bundle_concrete_product_from_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${bundle_product.product_1.concrete_sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    I send a DELETE request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}
    And Response status code should be:    204
    And Response reason should be:    No Content
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Remove_a_concrete_product_from_the_shared_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /shopping-lists/
    ...    AND    Response status code should be:    200
    ...    AND    Save value to a variable:    [data][0][id]    sharedShoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListItemId
    ...    AND    I get access token for the customer:    ${yves_shared_shopping_list_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a DELETE request:    /shopping-lists/${sharedShoppingListId}/shopping-list-items/${shoppingListItemId}
    And Response status code should be:    204
    And Response reason should be:    No Content

Add_a_configurable_product_to_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    shoppingListItemId
    And Response body parameter should be:    [data][attributes][quantity]    3
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"09.09.2050\"} 
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  True  
    And I send a GET request:    /shopping-lists/${shoppingListId}?include=shopping-list-items,concrete-products
    And Response status code should be:    200
    And Response body parameter should be:  [data][type]    shopping-lists
    And Response body parameter should be:  [data][id]    ${shoppingListId}
    And Response body parameter should be:    [data][attributes][numberOfItems]    3
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response body parameter should be:    [data][relationships][shopping-list-items][data][0][type]   shopping-list-items
    And Response body parameter should be:    [data][relationships][shopping-list-items][data][0][id]   ${shoppingListItemId}
    And Response should contain the array of a certain size:    [included]    2
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    shopping-list-items
    And Response body parameter should be:    [included][0][id]    ${configurable_product.sku}
    And Response body parameter should be:    [included][1][id]    ${shoppingListItemId}
    And Response body parameter should be:    [included][1][attributes][productConfigurationInstance][isComplete]  True 
    And Response body parameter should be:    [included][1][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"09.09.2050\"}
   [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
   ...    AND    Response status code should be:    204
   ...    AND    Response reason should be:    No Content

Change_preferred_time_of_the_day_of_the_configurable_product_in_the_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"9.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    shoppingListItemId
     And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"9.09.2050\"} 
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  True  
    I send a PATCH request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}?include=concrete-products    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Evening\\\",\\\"Date\\\":\\\"9.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${shoppingListItemId}
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Evening\",\"Date\":\"9.09.2050\"} 
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  True  
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_preferred_date_of_the_configurable_product_in_the_shopping_list
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
   I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"9.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    201
   And Save value to a variable:    [data][id]    shoppingListItemId
   And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"9.09.2050\"} 
   And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  True  
   I send a PATCH request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}?include=concrete-products    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"20.10.2030\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    200
   And Response header parameter should be:    Content-Type    ${default_header_content_type}
   And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
   And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"20.10.2030\"} 
   And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  True  
   [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content 

Set_configuration_for_the_configurable_product_in_the_shopping_list
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
   I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":1,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"9.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":false,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    201
   And Save value to a variable:    [data][id]    shoppingListItemId
   And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  False  
   I send a PATCH request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}?include=concrete-products    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":1,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Morning\\\",\\\"Date\\\":\\\"01.01.2025\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    200
   And I send a GET request:    /shopping-lists/${shoppingListId}?include=shopping-list-items
   And Response status code should be:    200
   And Response body parameter should be:  [data][type]    shopping-lists
   And Response body parameter should be:  [data][id]    ${shoppingListId}
   And Response body parameter should be:    [data][attributes][numberOfItems]    1
   And Response should contain the array of a certain size:    [included]    1
   And Response should contain the array of a certain size:    [data][relationships]    1
   And Response include should contain certain entity type:    shopping-list-items
   And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][isComplete]  True 
   And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Morning\",\"Date\":\"01.01.2025\"}
      [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content 

Change_the_quantity_of_the_Configured_Product_so_Volume_price_is_applied
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
   I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":1,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"9.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":false,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    201
   And Save value to a variable:    [data][id]    shoppingListItemId
   And Response body parameter should be:    [data][attributes][quantity]    1
   I send a PATCH request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}?include=concrete-products    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":6,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Morning\\\",\\\"Date\\\":\\\"01.01.2025\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    200
   And I send a GET request:    /shopping-lists/${shoppingListId}?include=shopping-list-items
   And Response status code should be:    200
   And Response body parameter should be:    [data][attributes][numberOfItems]    6
   And Response body parameter should be:    [included][0][attributes][sku]    ${configurable_product.sku}
   And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][prices][0][volumePrices][0][grossAmount]   165
   And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][prices][0][volumePrices][0][netAmount]    150
   And Response include element has self link:   shopping-list-items
   [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${ShoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content 

Add_2_Configurable_products_but_with_different_configurations
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
   I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":2,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Morning\\\",\\\"Date\\\":\\\"10.10.2040\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":true,"quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    201
   And Save value to a variable:    [data][id]    shoppingListItemId1
   And Response body parameter should be:    [data][attributes][quantity]    2
   I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":1,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"11.11.2040\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":false,"quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    201
   And Save value to a variable:    [data][id]    shoppingListItemId2
   And Response body parameter should be:    [data][attributes][quantity]    1
   And I send a GET request:    /shopping-lists/${shoppingListId}?include=shopping-list-items
   And Response status code should be:    200
   And Response body parameter should be:    [data][attributes][numberOfItems]    3
   And Response should contain the array of a certain size:    [included]    2
   And Response body parameter should be in:   [included][0][id]    ${shoppingListItemId1}    ${shoppingListItemId2}
   And Response body parameter should be in:   [included][0][attributes][quantity]    2    1
   And Response body parameter should be in:   [included][0][attributes][sku]    ${configurable_product.sku}    ${shoppingListItemId1}    ${shoppingListItemId2}
   And Response body parameter should be in:    [included][0][attributes][productConfigurationInstance][displayData]    {\"Preferred time of the day\":\"Morning\",\"Date\":\"10.10.2040\"}    {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"11.11.2040\"}
   And Response body parameter should be in:    [included][0][attributes][productConfigurationInstance][isComplete]    True    False
   And Response body parameter should be in:   [included][1][id]    ${shoppingListItemId1}    ${shoppingListItemId2}    ${configurable_product.sku}
   And Response body parameter should be in:   [included][1][attributes][quantity]    1    2
   And Response body parameter should be in:   [included][1][attributes][sku]    ${shoppingListItemId1}    ${shoppingListItemId2}    ${configurable_product.sku}
   And Response body parameter should be in:    [included][1][attributes][productConfigurationInstance][displayData]    {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"11.11.2040\"}    {\"Preferred time of the day\":\"Morning\",\"Date\":\"10.10.2040\"}
   And Response body parameter should be in:    [included][1][attributes][productConfigurationInstance][isComplete]    False    True
   And Response include element has self link:   shopping-list-items
   [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${ShoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content 

Add_Configurable_products_and_regular_product
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
   I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":2,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Morning\\\",\\\"Date\\\":\\\"10.10.2040\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":true,"quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    201
   And Save value to a variable:    [data][id]    shoppingListItemId1
   And Response body parameter should be:    [data][attributes][quantity]    2
   I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":1}}}
   And Response status code should be:    201
   And Save value to a variable:    [data][id]    shoppingListItemId2
   And Response body parameter should be:    [data][attributes][quantity]    1
   And Response body parameter should be:    [data][attributes][sku]    ${concrete.available_product.with_stock.product_1.sku}
   And I send a GET request:    /shopping-lists/${shoppingListId}?include=shopping-list-items
   And Response status code should be:    200
   And Response body parameter should be:    [data][attributes][numberOfItems]    3
   And Response should contain the array of a certain size:    [included]    2
   And Response body parameter should be in:   [included][0][id]    ${shoppingListItemId2}    ${shoppingListItemId1}
   And Response body parameter should be in:   [included][0][attributes][quantity]    2    1
   And Response body parameter should be in:   [included][0][attributes][sku]    ${configurable_product.sku}    ${concrete.available_product.with_stock.product_1.sku}
   And Nested array element should contain sub-array with property and value at least once:    [included]    [attributes]    [productConfigurationInstance]    displayData    {\"Preferred time of the day\":\"Morning\",\"Date\":\"10.10.2040\"}
   And Nested array element should contain sub-array with property and value at least once:    [included]    [attributes]    [productConfigurationInstance]    isComplete    True
   And Response body parameter should be in:   [included][1][id]    ${shoppingListItemId2}    ${shoppingListItemId1}
   And Response body parameter should be in:   [included][1][attributes][quantity]    1    2
   And Response body parameter should be in:   [included][1][attributes][sku]    ${configurable_product.sku}    ${concrete.available_product.with_stock.product_1.sku}
   And Response include element has self link:   shopping-list-items
   [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${ShoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content 

Remove_a_configurable_product_from_the_shopping_list    
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":2,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Morning\\\",\\\"Date\\\":\\\"10.10.2040\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":true,"quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    shoppingListItemId
    And Response body parameter should be:    [data][attributes][quantity]    2
    I send a DELETE request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId}
    And Response status code should be:    204
    And Response reason should be:    No Content
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content  

Remove_a_configurable_product_from_the_shopping_list_and_leave_a_regular_product
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
   I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${configurable_product.sku}","quantity":1,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Morning\\\",\\\"Date\\\":\\\"10.10.2040\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":true,"quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    201
   And Save value to a variable:    [data][id]    shoppingListItemId1
   And Response body parameter should be:    [data][attributes][quantity]    1
   I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${concrete.available_product.with_stock.product_1.sku}","quantity":1}}}
   And Response status code should be:    201
   And Save value to a variable:    [data][id]    shoppingListItemId2
   And Response body parameter should be:    [data][attributes][quantity]    1
   And Response body parameter should be:    [data][attributes][sku]    ${concrete.available_product.with_stock.product_1.sku}
   I send a DELETE request:    /shopping-lists/${shoppingListId}/shopping-list-items/${shoppingListItemId1}
   And Response status code should be:    204
   And Response reason should be:    No Content
   And I send a GET request:    /shopping-lists/${shoppingListId}?include=shopping-list-items
   And Response status code should be:    200
   And Response body parameter should be:    [data][attributes][numberOfItems]    1
   And Response should contain the array of a certain size:    [included]    1
   And Response body parameter should be:   [included][0][id]    ${shoppingListItemId2}
   And Response body parameter should be:   [included][0][attributes][quantity]    1
   And Response body parameter should be:   [included][0][attributes][sku]    ${concrete.available_product.with_stock.product_1.sku}
   And Response body parameter should be:    [included][0][attributes][productConfigurationInstance]    None
   And Response include element has self link:   shopping-list-items
   [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${ShoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content 
