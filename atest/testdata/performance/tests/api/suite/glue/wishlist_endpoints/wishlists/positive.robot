*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Test Tags    glue    wishlist    marketplace-wishlist    customer-access    customer-account-management    customer-access    customer-account-management    acl

*** Test Cases ***
Create_a_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    I send a POST request:    /wishlists        {"data":{"type":"wishlists","attributes":{"name":"${random}"}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][type]    wishlists
    And Save value to a variable:    [data][id]    wishlistId
    And Response body parameter should be:    [data][id]    ${wishlistId}
    And Response body parameter should be:    [data][attributes][name]    ${random}
    And Response body parameter should be:    [data][attributes][numberOfItems]    0
    And Save value to a variable:    [data][attributes][createdAt]    createdAt
    And Save value to a variable:    [data][attributes][updatedAt]    updatedAt
    And Response body parameter should be:    [data][attributes][createdAt]    ${createdAt}
    And Response body parameter should be:    [data][attributes][updatedAt]    ${updatedAt}
    AND Response body parameter should not be EMPTY:    [data][links][self]
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlistId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

#Get_Request
Retrieves_wishlists
    [Setup]     Run Keywords    I GET access token for the customer:    ${yves_user.email}
    ...    AND     I set headers:    authorization=${token}
    ...    AND    I send a POST request:    /wishlists        {"data":{"type":"wishlists","attributes":{"name":"${random}"}}}
    ...    AND     Response status code should be:    201
    ...    AND     Save value to a variable:     [data][id]    wishlist_id
    When I send a GET request:    /wishlists
    Then Response status code should be:    200
    AND Response reason should be:    OK
    AND Response body parameter should not be EMPTY:    [links][self]
    And Each array element of array in response should contain property with value:    [data]    type    wishlists
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name 
    And Each array element of array in response should contain nested property:    [data]    [attributes]    numberOfItems   
    And Each array element of array in response should contain property with value NOT in:    [data]    [links][self]    None
    And Each array element of array in response should contain property with value NOT in:    [data]    [id]    None
    
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlistId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Getting_wishlists_for_customer_with_no_wishlists
   [Setup]     Run Keywords    I GET access token for the customer:    ${yves_user.email}
    ...    AND     I set headers:    authorization=${token}
    When I send a GET request:    /wishlists
    Then Response status code should be:    200
    AND Response reason should be:    OK
    AND Response should contain the array of a certain size:    [data]    0
    AND Response body has correct self link

Retrieves_wishlist_data_by_id
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user.email}
    ...    AND    I set headers:    authorization=${token}
    ...    AND    I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    when I send a GET request:    /wishlists/${wishlist_id}
     then Response status code should be:    200
     AND Response reason should be:    OK
     AND Response body parameter should be:    [data][type]    wishlists
     AND Response body parameter should be:    [data][attributes][name]    ${random}
     AND Response body parameter should be greater than:    [data][attributes][numberOfItems]    -1
     AND Response body parameter should not be EMPTY:    [data][id]
     AND Response body parameter should not be EMPTY:    [data][attributes][createdAt]
     AND Response body parameter should not be EMPTY:    [data][attributes][updatedAt]
     AND Response body parameter should not be EMPTY:    [data][links][self]
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204

Retrieves_wishlist_with_items
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user.email}
    ...    AND    I set headers:    authorization=${token}
    ...    AND    I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a Post request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${concrete_available_product.with_label}"}}}
    ...    AND    Response status code should be:    201
     when I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items
     then Response status code should be:    200
     AND Response reason should be:    OK
     And Response body has correct self link internal
     And Response body parameter should be:    [data][type]    wishlists
     And Save value to a variable:   [data][attributes][name]    wishlist_name
     And Save value to a variable:   [data][id]    wishlist_id
     And Response body parameter should be:    [data][attributes][name]    ${random}
     And Response body parameter should be greater than:    [data][attributes][numberOfItems]    -1
     And Response body parameter should be:    [data][id]    ${wishlist_id} 
     And Response body parameter should not be EMPTY:    [data][relationships]
     And Response body parameter should not be EMPTY:    [data][relationships][wishlist-items][data]
    And Response body parameter should not be EMPTY:    [data][relationships][wishlist-items][data][0][id]
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204


Updates_customer_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...        AND    I set Headers:    Authorization=${token}
    ...    AND    I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "himanshupal"}}}  
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    When I send a PATCH request:    /wishlists/${wishlist_id}    {"data": {"type": "wishlists","attributes": {"name": "${random}"}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][id]    ${wishlist_id}
    AND Response body parameter should be:    [data][attributes][name]    ${random}
    AND Response body parameter should be:    [data][type]    wishlists
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204

Removes_customer_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    wishlists_id
    When I send a DELETE request:    /wishlists/${wishlists_id}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    When I send a GET request:    /wishlists/${wishlists_id}
    Then Response status code should be:    404
    And Response reason should be:    Not Found

Wishlist_Product_Labels
    [Setup]   Run Keywords    I GET access token for the customer:    ${yves_user.email}
    ...    AND    I set headers:    authorization=${token}
    ...    AND    I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a Post request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${concrete_available_product.with_label}"}}}
    ...    AND    Response status code should be:    201
     when I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items,concrete-products,product-labels
     then Response status code should be:    200
     AND Response reason should be:    OK
     And Response body has correct self link internal
     And Response body parameter should be:    [data][type]    wishlists
     And Save value to a variable:   [data][attributes][name]    wishlist_name
     And Save value to a variable:   [data][id]    wishlist_id
     And Response body parameter should be:    [data][attributes][name]    ${random}
     And Response body parameter should be greater than:    [data][attributes][numberOfItems]    -1
     And Response body parameter should be:    [data][id]    ${wishlist_id} 
     And Response body parameter should not be EMPTY:    [data][relationships]
     And Response body parameter should not be EMPTY:    [data][relationships][wishlist-items][data][0]
     And Response include element has self link:    wishlist-items
     And Response include element has self link:    concrete-products
     And Response include element has self link:    product-labels
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204

Retrieves_wishlist_with_items_including_concrete_products
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user.email}
    ...    AND    I set headers:    authorization=${token}
    ...    AND    I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a Post request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${concrete_available_product.with_label}"}}}
    ...    AND    Response status code should be:    201
     when I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items,concrete-products
     then Response status code should be:    200
     AND Response reason should be:    OK
     And Response body has correct self link internal
     And Response body parameter should be:    [data][type]    wishlists
     And Response body parameter should be:    [data][attributes][name]    ${random}
     And Response body parameter should be:     [data][attributes][numberOfItems]    1
     And Response body parameter should be:    [data][id]    ${wishlist_id}
     And Response body parameter should not be EMPTY:    [data][relationships]
     And Response body parameter should not be EMPTY:    [data][relationships][wishlist-items][data][0]
     AND Response body parameter should not be EMPTY:    [data][attributes][createdAt]
     AND Response body parameter should not be EMPTY:    [data][attributes][updatedAt]
     And Response include element has self link:    wishlist-items
     And Response include element has self link:    concrete-products
     And Response should contain the array larger than a certain size:    [included]    1
     And Response include should contain certain entity type:    concrete-products
     And Response include should contain certain entity type:    wishlist-items
     [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204