*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    shopping-lists    marketplace-shopping-lists    customer-access    customer-account-management    acl

*** Test Cases ***
Create_a_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}!@#$%^&*()-_"}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][id]    shoppingListId
    And Save value to a variable:    [data][attributes][createdAt]    createdAt
    And Save value to a variable:    [data][attributes][updatedAt]    updatedAt
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    shopping-lists
    And Response body parameter should be:    [data][id]    ${shoppingListId}
    And Response body parameter should be:    [data][attributes][owner]    ${yves_user.first_name} ${yves_user.last_name}
    And Response body parameter should be:    [data][attributes][name]    ${shopping_list_name}${random}!@#$%^&*()-_
    And Response body parameter should be:    [data][attributes][numberOfItems]    0
    And Response body parameter should be:    [data][attributes][createdAt]    ${createdAt}
    And Response body parameter should be:    [data][attributes][updatedAt]    ${updatedAt}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Delete_a_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a DELETE request:    /shopping-lists/${shoppingListId}
    And Response status code should be:    204
    And Response reason should be:    No Content

Update_a_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a PATCH request:    /shopping-lists/${shoppingListId}    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}"}}}
    And Response status code should be:    200
    And Save value to a variable:    [data][attributes][updatedAt]    updatedAt
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][name]    ${shopping_list_name}
    And Response body parameter should be:    [data][attributes][updatedAt]    ${updatedAt}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Update_a_shopping_list_name
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a PATCH request:    /shopping-lists/${shoppingListId}    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}!@#$%^&*()-_"}}}
    And Response status code should be:    200
    And Save value to a variable:    [data][attributes][updatedAt]    updatedAt
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][name]    ${shopping_list_name}${random}!@#$%^&*()-_
    And Response body parameter should be:    [data][attributes][updatedAt]    ${updatedAt}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Update_a_shopping_list_name_with_includes
    [Documentation]   bug https://spryker.atlassian.net/browse/CC-16543
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a PATCH request:    /shopping-lists/${shoppingListId}?include=shopping-list-items,concrete-products    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}!@#$%^&*()-_"}}}
    And Response status code should be:    200
    And Save value to a variable:    [data][attributes][numberOfItems]    numberOfItems
    And Save value to a variable:    [data][attributes][updatedAt]    updatedAt
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][attributes][name]    ${shopping_list_name}${random}!@#$%^&*()-_
    And Response body parameter should be:    [data][attributes][updatedAt]    ${updatedAt}
    And Save value to a variable:    [data][attributes][numberOfItems]    numberOfItems
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain nested property with value:    [data][relationships][shopping-list-items][data]    [type]    shopping-list-items
    And Each array element of array in response should contain nested property with datatype:    [data][relationships][shopping-list-items][data]    [id]    str
    And Each array element of array in response should contain nested property with datatype:    [included]    [type]    str
    And Each array element of array in response should contain nested property with datatype:    [included]    [id]    str
    And Response body parameter should be:    [data][type]    shopping-lists
    And Response should contain the array of a certain size:    [included]    2
    And Response should contain the array larger than a certain size:    [data][relationships]    0
    And Response should contain the array smaller than a certain size:    [data][relationships]    ${numberOfItems}+1
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    shopping-list-items
    And Response include element has self link:   concrete-products
    And Response include element has self link:   shopping-list-items
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Get_a_shopping_list_info
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    Save value to a variable:    [data][attributes][createdAt]    createdAt
    ...    AND    Save value to a variable:    [data][attributes][updatedAt]    updatedAt
    I send a GET request:    /shopping-lists/${shoppingListId}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    shopping-lists
    And Response body parameter should be:    [data][id]    ${shoppingListId}
    And Response body parameter should be:    [data][attributes][owner]    ${yves_user.first_name} ${yves_user.last_name}
    And Response body parameter should be:    [data][attributes][name]    ${shopping_list_name}${random}
    And Response body parameter should be:    [data][attributes][numberOfItems]    0
    And Response body parameter should be:    [data][attributes][createdAt]    ${createdAt}
    And Response body parameter should be:    [data][attributes][updatedAt]    ${updatedAt}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Get_several_shopping_lists_info
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}1"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId1
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}2"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId2
    I send a GET request:    /shopping-lists
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain nested property with value:    [data]    type    shopping-lists
    And Each array element of array in response should contain nested property with datatype:    [data]    id    str
    And Each array element of array in response should contain nested property with value:    [data]   [attributes][owner]    ${yves_user.first_name} ${yves_user.last_name}
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][name]    str
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][createdAt]    str
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][updatedAt]    str
    And Each array element of array in response should contain nested property:    [data]   [attributes]    name
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId1}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content
    ...    AND    I send a DELETE request:    /shopping-lists/${shoppingListId2}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Get_shopping_lists_info_with_non_zero_quantity_of_number_of_items
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${product_related_product_with_upselling_relation.concrete_available_product.sku}","quantity":3}}}
    I send a GET request:    /shopping-lists/${shoppingListId}
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be greater than:    [data][attributes][numberOfItems]    0
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
     ...    AND    Response status code should be:    204
     ...    AND    Response reason should be:    No Content

Get_shopping_lists_info_for_user_with_zero_quantity_of_number_of_shopping_lists
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_fourth_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    I send a GET request:    /shopping-lists
    And Response status code should be:    200
    And Response should contain the array of a certain size:    [data]    0
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Get_single_shopping_list_info_with_includes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    ...    AND    I send a POST request:    /shopping-lists/${shoppingListId}/shopping-list-items    {"data":{"type":"shopping-list-items","attributes":{"sku":"${abstract_available_product_with_stock.concrete_available_product.sku}","quantity":3}}}
    ...    AND    Response status code should be:    201
    I send a GET request:    /shopping-lists/${shoppingListId}?include=shopping-list-items,concrete-products
    And Response status code should be:    200
    And Save value to a variable:    [data][attributes][numberOfItems]    numberOfItems
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain nested property with value:    [data][relationships][shopping-list-items][data]    [type]    shopping-list-items
    And Each array element of array in response should contain nested property with datatype:    [data][relationships][shopping-list-items][data]    [id]    str
    And Each array element of array in response should contain nested property with datatype:    [included]    [type]    str
    And Each array element of array in response should contain nested property with datatype:    [included]    [id]    str
    And Response body parameter should be:    [data][type]    shopping-lists
    And Response should contain the array of a certain size:    [included]    2
    And Response should contain the array larger than a certain size:    [data][relationships]    0
    And Response should contain the array smaller than a certain size:    [data][relationships]    ${numberOfItems}+1
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    shopping-list-items
    And Response include element has self link:   concrete-products
    And Response include element has self link:   shopping-list-items
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Get_several_shopping_lists_info_with_includes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a GET request:    /shopping-lists?include=shopping-list-items,concrete-products
    And Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain nested property with value:    [data]    [relationships][shopping-list-items][data][0][type]    shopping-list-items
    And Each array element of array in response should contain nested property with datatype:    [data]    [relationships][shopping-list-items][data][0][id]    str
    And Each array element of array in response should contain nested property with datatype:    [included]    [type]    str
    And Each array element of array in response should contain nested property with datatype:    [included]    [id]    str
    And Each array element of array in response should contain nested property with value:    [data]    type    shopping-lists
    And Response should contain the array larger than a certain size:    [included]    2
    And Response should contain the array larger than a certain size:    [data][0][relationships]    0
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    shopping-list-items
    And Response include element has self link:   concrete-products
    And Response include element has self link:   shopping-list-items