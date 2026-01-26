*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    shopping-lists    marketplace-shopping-lists    customer-access    customer-account-management    acl

*** Test Cases ***
Create_a_shopping_list_with_empty_type
    I send a POST request:    /shopping-lists    {"data":{"type":"","attributes":{"name":"${shopping_list_name}${random}"}}}
    Response status code should be:    400
    And Response reason should be:   Bad Request 
    And Response should return error message:    Invalid type.
    And Response header parameter should be:    Content-Type    ${default_header_content_type} 

Create_a_shopping_list_with_empty_values_for_required_fields
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":""}}}
    Response status code should be:    ${422}
    And Response reason should be:   Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    name => This value should not be blank.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Create_a_shopping_list_with_non_autorized_user
    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    Response status code should be:    403
    And Response reason should be:   Forbidden
    And Response should return error code:    002
    And Array in response should contain property with value:    [errors]    detail    Missing access token.

Create_a_shopping_list_with_absent_type
    I send a POST request:    /shopping-lists    {"data":{"attributes":{"name":"${shopping_list_name}${random}"}}}
    Response status code should be:    400
    And Response reason should be:   Bad Request
    And Response should return error message:    Post data is invalid.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Create_a_shopping_list_with_already_existing_name
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    shoppingListId
    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    And Response status code should be:    ${422}
    And Response reason should be:   Unprocessable Content
    And Response should return error code:    1506
    And Array in response should contain property with value:    [errors]    detail    Shopping list with given name already exists.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    I send a DELETE request:    /shopping-lists/${shoppingListId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Create_a_shopping_list_with_too_long_name
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a POST request:    /shopping-lists    {"data":{"type":"shopping-lists","attributes":{"name":"12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"}}}
    And Response status code should be:    ${422}
    And Response reason should be:   Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    name => This value is too long. It should have 255 characters or less.

Delete_not_existing_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a DELETE request:    /shopping-lists/test12345
    And Response status code should be:    404
    And Response reason should be:   Not Found
    And Response should return error code:    1503
    And Array in response should contain property with value:    [errors]    detail    Shopping list not found.

Delete_existing_shopping_list_of_another_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /shopping-lists
    ...    AND    Save value to a variable:    [data][0][id]    shoppingListId
    ...    AND    I get access token for the customer:    ${yves_fourth_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    I send a DELETE request:    /shopping-lists/${shoppingListId}
    And Response status code should be:    404
    And Response reason should be:   Not Found
    And Response should return error code:    1503
    And Array in response should contain property with value:    [errors]    detail    Shopping list not found.

Delete_shopping_list_without_access_token
    I send a DELETE request:    /shopping-lists/shoppingListId
    Response status code should be:    403
    And Response reason should be:   Forbidden
    And Response should return error code:    002
    And Array in response should contain property with value:    [errors]    detail    Missing access token.

Delete_shopping_list_with_wrong_access_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}1
    I send a DELETE request:    /shopping-lists/shoppingListId
    And Response status code should be:    401
    And Response reason should be:   Unauthorized
    And Response should return error code:    001
    And Array in response should contain property with value:    [errors]    detail    Invalid access token.

Delete_a_shopping_list_withouth_shopping_list_id
    I send a DELETE request:    /shopping-lists
    And Response status code should be:    400
    And Response reason should be:   Bad Request
    And Array in response should contain property with value:    [errors]    detail    Resource id is not specified.

Update_shopping_list_for_the_customer_with_empty_attribute_section
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a PATCH request:    /shopping-lists/shoppingListId    {"data":{"type":"shopping-lists","attributes":{}}}
    And Response status code should be:    ${422}
    And Response reason should be:   Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    name => This field is missing.

Update_shopping_list_with_existing_name_of_another_available_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a GET request:    /shopping-lists
    ...    AND    Save value to a variable:    [data][0][id]    shoppingListId
    ...    AND    Save value to a variable:    [data][1][attributes][name]    2ndShoppingListName
    I send a PATCH request:    /shopping-lists/${shoppingListId}    {"data":{"type":"shopping-lists","attributes":{"name":"${2ndShoppingListName}"}}}
    And Response status code should be:    ${422}
    And Response reason should be:   Unprocessable Content
    And Response should return error code:    1506
    And Array in response should contain property with value:    [errors]    detail    Shopping list with given name already exists.

Update_shopping_list_with_empty_name
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a PATCH request:    /shopping-lists/shoppingListId    {"data":{"type":"shopping-lists","attributes":{"name":""}}}
    And Response status code should be:    ${422}
    And Response reason should be:   Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    name => This value should not be blank.

Update_shopping_list_name_with_too_long_value
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a PATCH request:    /shopping-lists/shoppingListId    {"data":{"type":"shopping-lists","attributes":{"name":"12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"}}}
    And Response status code should be:    ${422}
    And Response reason should be:   Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    name => This value is too long. It should have 255 characters or less.

Update_shopping_list_withouth_shopping_list_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a PATCH request:    /shopping-lists/    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    And Response status code should be:    400
    And Response reason should be:   Bad Request
    And Array in response should contain property with value:    [errors]    detail    Resource id is not specified.

Update_shopping_list_with_wrong_shopping_list_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    I send a PATCH request:    /shopping-lists/shoppingListId     {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}${random}"}}}
    And Response status code should be:    404
    And Response reason should be:   Not Found
    And Response should return error code:    1503
    And Array in response should contain property with value:    [errors]    detail    Shopping list not found.

Update_shopping_list_with_non_autorized_user
    I send a PATCH request:    /shopping-lists/shoppingListId    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}"}}}
    Response status code should be:    403
    And Response reason should be:   Forbidden
    And Response should return error code:    002
    And Array in response should contain property with value:    [errors]    detail    Missing access token.

Update_existing_shopping_list_of_another_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /shopping-lists
    ...    AND    Save value to a variable:    [data][0][id]    shoppingListId
    ...    AND    I get access token for the customer:    ${yves_fourth_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    I send a PATCH request:    /shopping-lists/${shoppingListId}    {"data":{"type":"shopping-lists","attributes":{"name":"${shopping_list_name}"}}}
    And Response status code should be:    404
    And Response reason should be:   Not Found
    And Response should return error code:    1503
    And Array in response should contain property with value:    [errors]    detail    Shopping list not found.

Update_a_shopping_list_with_absent_type
    I send a PATCH request:    /shopping-lists/shoppingListId    {"data":{"attributes":{"name":"${shopping_list_name}${random}"}}}
    Response status code should be:    400
    And Response reason should be:   Bad Request
    And Response should return error message:    Post data is invalid.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_a_shopping_list_with_invalid_type
    I send a PATCH request:    /shopping-lists/shoppingListId    {"data":{"type":"shoppinglists","attributes":{"name":"${shopping_list_name}${random}"}}}
    Response status code should be:    400
    And Response reason should be:   Bad Request
    And Response should return error message:    Invalid type.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Get_shopping_list_with_non_autorized_user
    I send a GET request:    /shopping-lists/shoppingListId
    Response status code should be:    403
    And Response reason should be:   Forbidden
    And Response should return error code:    002
    And Array in response should contain property with value:    [errors]    detail    Missing access token.

Get_not_existing_shopping_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a GET request:    /shopping-lists/test12345
    And Response status code should be:    404
    And Response reason should be:   Not Found
    And Response should return error code:    1503
    And Array in response should contain property with value:    [errors]    detail    Shopping list not found.

Get_existing_shopping_list_of_another_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /shopping-lists
    ...    AND    Save value to a variable:    [data][0][id]    shoppingListId
    ...    AND    I get access token for the customer:    ${yves_fourth_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a GET request:    /shopping-lists/${shoppingListId}
    And Response status code should be:    404
    And Response reason should be:   Not Found
    And Response should return error code:    1503
    And Array in response should contain property with value:    [errors]    detail    Shopping list not found.

Get_existing_shopping_list_with_wrong_access_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}1
    I send a GET request:    /shopping-lists/shoppingListId
    And Response status code should be:    401
    And Response reason should be:   Unauthorized
    And Response should return error code:    001
    And Array in response should contain property with value:    [errors]    detail    Invalid access token.