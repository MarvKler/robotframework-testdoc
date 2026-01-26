*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    wishlist    marketplace-wishlist    product    marketplace-product-offer    marketplace-product   prices    configurable-product    configurable-product-wishlist    customer-access    customer-account-management    acl

*** Test Cases ***
Adding_item_in_wishlist 
    [Documentation]    CC-16555 API: JSON response is missing product availability and price
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id  
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${abstract_product_with_merchant.concrete_sku}"}}}
    Then Response status code should be:    201 
    And Response reason should be:    Created
    And Save value to a variable:    [data][id]    wishlist_items_id  
    And Response body parameter should not be EMPTY:    [data][attributes][sku]
    And Response body parameter should not be EMPTY:    [data][attributes][merchantReference]
    And Response body parameter should be:    [data][attributes][productOfferReference]    None
    And Response body parameter should be:    [data][type]    wishlist-items
    And Response body parameter should be:    [data][id]    ${wishlist_items_id}
    And Response body parameter should be:    [data][attributes][sku]    ${abstract_product_with_merchant.concrete_sku}
    And Response body parameter should be:    [data][attributes][id]    ${wishlist_items_id}
    And Response body parameter should not be EMPTY:    [data][attributes][availability]
    And Response body parameter should not be EMPTY:    [data][attributes][prices]
    And Response body parameter should not be EMPTY:    [data][links][self]
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204

#Post
Adding_item_in_wishlist_with_offer 
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${concrete_available_product.with_offer}", "productOfferReference": "offer37"}}}
    Then Response status code should be:    201 
    And Response reason should be:    Created
    And Save value to a variable:    [data][id]    wishlist_items_id
    And Response body parameter should not be EMPTY:    [data][attributes][sku]
    And Response body parameter should not be EMPTY:    [data][attributes][merchantReference]
    And Response body parameter should not be EMPTY:    [data][attributes][productOfferReference]
    And Response body parameter should be:    [data][type]    wishlist-items
    And Response body parameter should be:    [data][id]    ${wishlist_items_id}
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_available_product.with_offer}
    And Response body parameter should be:    [data][attributes][id]    ${wishlist_items_id}
    And Response body parameter should not be EMPTY:    [data][attributes][availability]
    And Response body parameter should not be EMPTY:    [data][attributes][prices]
    And Response body parameter should not be EMPTY:    [data][links][self]
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204


Adding_multiple_variant_of_abstract_product_in_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${abstract_product_with_variants.variant1_sku}"}}}
    Then Response status code should be:    201 
    And Response reason should be:    Created
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${abstract_product_with_variants.variant2_sku}"}}}
    Then Response status code should be:    201 
    And Response reason should be:    Created
    And Save value to a variable:    [data][id]    wishlist_items_id
    And Response body parameter should not be EMPTY:    [data][attributes][sku]
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items
    Then Response status code should be:    200 
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    wishlists
    And Response body parameter should be:    [data][id]    ${wishlist_id}
    And Response body parameter should be:    [data][attributes][name]    ${random}
    And Response body parameter should be:    [data][attributes][numberOfItems]    2
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][wishlist-items][data][0]
    And Response body parameter should not be EMPTY:    [data][relationships][wishlist-items][data][1]
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204

#Delete
Deleting_item_from_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${concrete_available_product.with_offer}"}}}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    When I send a DELETE request:    /wishlists/${wishlist_id}/wishlist-items/${concrete_available_product.with_offer}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
   
Add_a_configurable_product_to_the_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"09.09.2050\"} 
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  True  
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items,concrete-products
    And Response status code should be:    200
    And Response body parameter should be:  [data][type]    wishlists
    And Response body parameter should be:  [data][id]    ${wishlist_id}
    And Response body parameter should be:    [data][attributes][numberOfItems]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response body parameter should be:    [data][relationships][wishlist-items][data][0][type]   wishlist-items
    And Response body parameter should be:    [data][relationships][wishlist-items][data][0][id]   ${WishListItemId}
    And Response should contain the array of a certain size:    [included]    2
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    wishlist-items
    And Response body parameter should be:    [included][0][type]    concrete-products
    And Response body parameter should be:    [included][1][type]    wishlist-items
    And Response body parameter should be:    [included][1][id]    ${WishListItemId}
    And Response body parameter should be:    [included][1][attributes][productConfigurationInstance][isComplete]  True 
    And Response body parameter should be:    [included][1][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"09.09.2050\"}
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Change_preferred_time_of_the_day_of_the_configurable_product_in_the_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "update-config-product-${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId
    And Response body parameter should be:    [data][id]    ${WishListItemId}
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"09.09.2050\"} 
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  True  
    I send a PATCH request:    /wishlists/${ wishlist_id}/wishlist-items/${WishListItemId}?include=concrete-products    {"data":{"type":"wishlist-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Evening\\\",\\\"Date\\\":\\\"9.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Evening\",\"Date\":\"9.09.2050\"} 
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  True
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content
 
Change_preferred_date_of_the_configurable_product_in_the_wishlist
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
     ...    AND    I set Headers:    Authorization=${token}
     ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "update-date-config-product-${random}" } }}
     ...    AND    Response status code should be:    201 
     ...    AND    Response reason should be:    Created
     ...    AND    Save value to a variable:    [data][id]        wishlist_id
     When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
     And Response status code should be:    201
     And Save value to a variable:    [data][id]    WishListItemId
     And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
     And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"09.09.2050\"} 
     And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  True  
     I send a PATCH request:    /wishlists/${ wishlist_id}/wishlist-items/${WishListItemId}?include=concrete-products    {"data":{"type":"wishlist-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"10.10.2030\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
     And Response status code should be:    200
     And Response header parameter should be:    Content-Type    ${default_header_content_type}
     And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
     And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"10.10.2030\"} 
     And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  True
     [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
     ...    AND    Response status code should be:    204
     ...    AND    Response reason should be:    No Content

Set_configuration_for_the_configurable_product_in_the_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "configurate-product-${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"11.11.2029\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":false,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"11.11.2029\"}
    And Response body parameter should be:    [data][attributes][productConfigurationInstance][isComplete]  False 
    I send a PATCH request:    /wishlists/${ wishlist_id}/wishlist-items/${WishListItemId}?include=concrete-products    {"data":{"type":"wishlist-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Morning\\\",\\\"Date\\\":\\\"11.11.2029\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items,concrete-products
    And Response status code should be:    200
    And Response body parameter should be:  [data][type]    wishlists
    And Response body parameter should be:  [data][id]    ${wishlist_id}
    And Response body parameter should be:    [data][attributes][numberOfItems]    1
    And Response should contain the array of a certain size:    [included]    2
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    wishlist-items
    And Response body parameter should be:    [included][1][attributes][productConfigurationInstance][isComplete]  True 
    And Response body parameter should be:    [included][1][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Morning\",\"Date\":\"11.11.2029\"}
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_2_Configurable_products_but_with_different_configurations
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "2-config-products-${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"11.11.2029\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":false,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Morning\\\",\\\"Date\\\":\\\"11.12.2029\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId2
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items,concrete-products
    And Response status code should be:    200
    And Response body parameter should be:  [data][type]    wishlists
    And Response body parameter should be:  [data][id]    ${wishlist_id}
    And Response body parameter should be:    [data][attributes][numberOfItems]    2
    And Response should contain the array of a certain size:    [included]    3
    And Response body parameter should be in:   [included][0][type]    concrete-products    wishlist-items
    And Response body parameter should be in:   [included][0][id]    ${WishListItemId}    ${WishListItemId2}    ${configurable_product.sku}
    And Response body parameter should be in:   [included][1][type]    concrete-products    wishlist-items
    And Response body parameter should be in:   [included][1][id]    ${WishListItemId}    ${WishListItemId2}    ${configurable_product.sku}
    And Response body parameter should be:   [included][1][attributes][sku]    ${configurable_product.sku}
    And Response body parameter should be in:   [included][1][attributes][productConfigurationInstance][displayData]    {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"11.11.2029\"}    {\"Preferred time of the day\":\"Morning\",\"Date\":\"11.12.2029\"}
    And Response body parameter should be in:   [included][1][attributes][productConfigurationInstance][isComplete]    False    True
    And Response body parameter should be in:   [included][2][type]    concrete-products    wishlist-items
    And Response body parameter should be in:   [included][2][id]    ${WishListItemId}    ${WishListItemId2}    ${configurable_product.sku}
    And Response body parameter should be:   [included][2][attributes][sku]    ${configurable_product.sku}
    And Response body parameter should be in:    [included][2][attributes][productConfigurationInstance][displayData]    {\"Preferred time of the day\":\"Morning\",\"Date\":\"11.12.2029\"}    {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"11.11.2029\"}
    And Response body parameter should be in:    [included][2][attributes][productConfigurationInstance][isComplete]    False    True
    And Response include element has self link:   wishlist-items
   [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content 

Add_Configurable_products_without_configurations_and_set_configuration
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "no-configurations-${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"11.11.2029\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":false,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items
    And Response status code should be:    200
    And Response body parameter should be:  [data][type]    wishlists
    And Response body parameter should be:  [data][id]    ${wishlist_id}
    And Response body parameter should be:    [data][attributes][numberOfItems]    1
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should be:   [included][0][type]    wishlist-items
    And Response body parameter should be:   [included][0][id]    ${WishListItemId}
    And Response body parameter should be:   [included][0][attributes][sku]    ${configurable_product.sku}
    And Response body parameter should be:   [included][0][attributes][productConfigurationInstance][displayData]    {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"11.11.2029\"}
    And Response body parameter should be:   [included][0][attributes][productConfigurationInstance][isComplete]    False
    And Response include element has self link:   wishlist-items
    I send a PATCH request:    /wishlists/${ wishlist_id}/wishlist-items/${WishListItemId}?include=concrete-products    {"data":{"type":"wishlist-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Morning\\\",\\\"Date\\\":\\\"11.11.2029\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    200
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items
    And Response status code should be:    200
    And Response body parameter should be:   [included][0][attributes][productConfigurationInstance][isComplete]    True
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Add_Configurable_products_and_regular_product
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "product-mix-${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"11.11.2029\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${concrete_available_product.sku}"}}}
    Then Response status code should be:    201 
    And Save value to a variable:    [data][id]    wishlist_items_id2
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_available_product.sku}
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items
    And Response status code should be:    200
    And Response body parameter should be:    [data][attributes][numberOfItems]    2
    And Response should contain the array of a certain size:    [included]    2
    And Response body parameter should be in:   [included][0][id]    ${WishListItemId}    ${wishlist_items_id2}
    And Response body parameter should be in:   [included][0][attributes][sku]    ${configurable_product.sku}    ${concrete_available_product.sku}
    And Nested array element should contain sub-array with property and value at least once:    [included]    [attributes]    [productConfigurationInstance]    displayData    {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"11.11.2029\"}
    And Nested array element should contain sub-array with property and value at least once:    [included]    [attributes]    [productConfigurationInstance]    isComplete    True
    And Response body parameter should be in:   [included][1][id]    ${WishListItemId}    ${wishlist_items_id2}
    And Response body parameter should be in:   [included][1][attributes][sku]    ${configurable_product.sku}    ${concrete_available_product.sku}
    And Response include element has self link:   wishlist-items
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content 

Remove_a_configurable_product_from_the_wishlist    
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "remove-product-${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"11.11.2029\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
    I send a DELETE request:    /wishlists/${wishlist_id}/wishlist-items/${WishListItemId}
    And Response status code should be:    204
    And Response reason should be:    No Content
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content 

Remove_a_configurable_product_from_the_wishlist_and_leave_a_regular_product
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "remove-one-product-${random}" } }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]        wishlist_id
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes":{"sku":"${configurable_product.sku}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"11.11.2029\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    WishListItemId1
    And Response body parameter should be:    [data][attributes][sku]    ${configurable_product.sku}
    When I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${concrete_available_product.sku}"}}}
    Then Response status code should be:    201 
    And Save value to a variable:    [data][id]    wishlist_items_id2
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_available_product.sku}
    I send a DELETE request:    /wishlists/${wishlist_id}/wishlist-items/${WishListItemId1}
    And Response status code should be:    204
    And Response reason should be:    No Content
    And I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items
    And Response status code should be:    200
    And Response body parameter should be:    [data][attributes][numberOfItems]    1
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should be:   [included][0][id]    ${concrete_available_product.sku}
    And Response body parameter should be:   [included][0][attributes][sku]    ${concrete_available_product.sku}
    And Response body parameter should be:    [included][0][attributes][productConfigurationInstance]    None
    And Response include element has self link:   wishlist-items
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content  