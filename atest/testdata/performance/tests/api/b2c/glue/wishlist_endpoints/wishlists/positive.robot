*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    wishlist    customer-access    customer-account-management    acl

*** Test Cases ***
#GET Request
Retrieves_all_customer_wishlists
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user.email}
    ...    AND     I set headers:    authorization=${token}
    When I send a GET request:    /wishlists
     Then Response status code should be:    200
     AND Response reason should be:    OK
     And Each array element of array in response should contain property with value:    [data]    type   wishlists
     And Response body has correct self link
     And Each array element of array in response should contain nested property:    [data]    [attributes]    name
     And Each array element of array in response should contain nested property:    [data]    [attributes]    numberOfItems
     And Each array element of array in response should contain property with value NOT in:    [data]    [links][self]    None
    
#GET Request
Retrieves_wishlist_data_by_id
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user.email}
    ...    AND    I set headers:    authorization=${token}
    ...    AND    I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    when I send a GET request:    /wishlists/${wishlist_id}
     then Response status code should be:    200
     AND Response reason should be:    OK
     AND Response body parameter should be:    [data][type]    wishlists
     AND Save value to a variable:   [data][attributes][name]    wishlist_name
     AND Save value to a variable:   [data][id]    wishlist_id
     AND Response body parameter should be:    [data][attributes][name]    ${wishlist_name}
     AND Response body parameter should be greater than:    [data][attributes][numberOfItems]    -1
     AND Response body parameter should not be EMPTY:    [data][id]
     AND Response body parameter should not be EMPTY:    [data][attributes][createdAt]
     AND Response body parameter should not be EMPTY:    [data][attributes][updatedAt]
     [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204

#Get_Request
Retrieves_wishlist_with_items
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user.email}
    ...    AND    I set headers:    authorization=${token}
    ...    AND    I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a Post request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${concrete_available_product.label}"}}}
    ...    AND    Response status code should be:    201
    when I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items
     then Response status code should be:    200
     AND Response reason should be:    OK
     And Response body has correct self link internal
     And Response body parameter should be:    [data][type]    wishlists
     And Save value to a variable:   [data][attributes][name]    wishlist_name
     And Save value to a variable:   [data][id]    wishlist_id
     And Response body parameter should be:    [data][attributes][name]    ${wishlist_name}
     And Response body parameter should be greater than:    [data][attributes][numberOfItems]    -1
     And Response body parameter should be:    [data][id]    ${wishlist_id} 
     And Response body parameter should not be EMPTY:    [data][relationships]
     And Response body parameter should not be EMPTY:    [data][relationships][wishlist-items][data][0]
     And Response include element has self link:    wishlist-items
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204

#Get Request
Retrieves_wishlist_with_items_in_concrete
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user.email}
    ...    AND    I set headers:    authorization=${token}
    ...    AND    I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a Post request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${concrete_available_product.label}"}}}
    ...    AND    Response status code should be:    201
     when I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items,concrete-products
     then Response status code should be:    200
     AND Response reason should be:    OK
     And Response body has correct self link internal
     And Response body parameter should be:    [data][type]    wishlists
     And Save value to a variable:   [data][attributes][name]    wishlist_name
     And Save value to a variable:   [data][id]    wishlist_id
     And Response body parameter should be:    [data][attributes][name]    ${wishlist_name}
     And Response body parameter should be:     [data][attributes][numberOfItems]    1
     And Response body parameter should be:    [data][id]    ${wishlist_id}
     And Response body parameter should not be EMPTY:    [data][relationships]
     And Response body parameter should not be EMPTY:    [data][relationships][wishlist-items][data][0]
     And Response include element has self link:    wishlist-items
     And Response include element has self link:    concrete-products
     [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204
    
#Get Request
Wishlist_Product_Labels
     [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user.email}
    ...    AND    I set headers:    authorization=${token}
    ...    AND    I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a Post request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${concrete_available_product.label}"}}}
    ...    AND    Response status code should be:    201
     when I send a GET request:    /wishlists/${wishlist_id}?include=wishlist-items,concrete-products,product-labels
     then Response status code should be:    200
     AND Response reason should be:    OK
     And Response body has correct self link internal
     And Response body parameter should be:    [data][type]    wishlists
     And Save value to a variable:   [data][attributes][name]    wishlist_name
     And Save value to a variable:   [data][id]    wishlist_id
     And Response body parameter should be:    [data][attributes][name]    ${wishlist_name}
     And Response body parameter should be greater than:    [data][attributes][numberOfItems]    -1
     And Response body parameter should be:    [data][id]    ${wishlist_id} 
     And Response body parameter should not be EMPTY:    [data][relationships]
     And Response body parameter should not be EMPTY:    [data][relationships][wishlist-items][data][0]
     And Response include element has self link:    wishlist-items
     And Response include element has self link:    concrete-products
     And Response include element has self link:    product-labels
     [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204

#Post Request
Creates_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...        AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name}"}}}
    And Save value to a variable:    [data][id]    wishlist_del_id
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][id]    ${wishlist_del_id}
    AND Response body parameter should be:    [data][attributes][name]    ${wishlist_name}
    AND Response body parameter should be:    [data][type]    wishlists
    AND Response body parameter should be:    [data][attributes][numberOfItems]    0
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_del_id}
    ...  AND    Response status code should be:    204

#Patch Request
Updates_customer_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...        AND    I set Headers:    Authorization=${token}
    ...    AND    I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name}"}}}  
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    When I send a PATCH request:    /wishlists/${wishlist_id}    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name}"}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][id]    ${wishlist_id}
    AND Response body parameter should be:    [data][attributes][name]    ${wishlist_name}
    AND Response body parameter should be:    [data][type]    wishlists
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204

# Delete Request
Removes_customer_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    wishlists_id
    When I send a DELETE request:    /wishlists/${wishlists_id}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    When I send a GET request:    /wishlists/${wishlists_id}
    Then Response status code should be:    404
    And Response reason should be:    Not Found