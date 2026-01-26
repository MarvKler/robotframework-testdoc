*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    wishlist    customer-access    customer-account-management    acl

*** Test Cases ***
#Get_request
Getting_wishlist_by_invalid_Access_Token
    [Setup]    I set Headers:    Authorization=3485h7
    When I send a GET request:    /wishlists
    Then Response status code should be:    401 
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
    
Getting_wishlist_without_Access_Token
     [Setup]    I set Headers:    Authorization=
    When I send a GET request:    /wishlists
    Then Response status code should be:    403 
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Getting_wishlist_with_invalid_id
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /wishlists/2345hasd
    Then Response status code should be:    404 
    And Response reason should be:    Not Found

######POST#####
Creating_wishlist_by_invalid_Access_Token
     [Setup]    I set Headers:    Authorization=3485h7
    When I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": ""}}}
    Then Response status code should be:    401 
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.


Creating_wishlist_with_space_in_name
    [Documentation]   Post Request https://spryker.atlassian.net/browse/CC-16553
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...        AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name":" "}}}
    Then Response status code should be:    400
    And Response should return error message:   Please enter name using only letters, numbers, underscores, spaces or dashes.
    And Response should return error code:    210

Creating_wishlist_without_Access_Token
     [Setup]    I set Headers:    Authorization=
    When I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": ""}}}
    Then Response status code should be:    403 
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Creating_wishlist_with_missing_name
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user.email}
    ...    AND     I set headers:    authorization=${token}
    When I send a POST request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": ""}}}
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Array in response should contain property with value:    [errors]    detail    name => This value should not be blank.

Creating_wishlist_with_invalid_name
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "."}}}
    Then Response status code should be:    400
    And Response should return error message:   Please enter name using only letters, numbers, underscores, spaces or dashes.
    And Response should return error code:    210

Creating_Wishlist_with_a_name_that_already_exists
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user.email}
    ...    AND    I set headers:    authorization=${token}
    ...    AND    I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    When I send a POST request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    AND Response should return error code:    202
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204
    
#Delete
Delete_already_deleted_wishlist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": { "type": "wishlists","attributes": { "name": "${wishlist_name}"} }}
    ...    AND    Response status code should be:    201 
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][id]    wishlist_reference_id
    When I send a DELETE request:    /wishlists/${wishlist_reference_id}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    When I send a DELETE request:    /wishlists
    Response status code should be:   400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Deleting_wishlist_by_invalid_Access_Token
    [Setup]    I set Headers:    Authorization=3485h7
    When I send a Delete request:    /wishlists/123    
    Then Response status code should be:    401 
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Deleting_wishlist_without_Access_Token
     [Setup]    I set Headers:    Authorization=
    When I send a Delete request:    /wishlists/123
    Then Response status code should be:    403 
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.
    
#Delete_request
Wishlist_id_not_specified
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user.email}
    ...    AND    I set headers:    authorization=${token}
    When I send a DELETE request:    /wishlists/
    Then Response reason should be:    Bad Request
    And Response status code should be:    400

#Patch_request
Updating_wishlist_with_missing_name
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user.email}
    ...    AND     I set headers:    authorization=${token}
    ...    AND     I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    When I send a Patch request:    /wishlists/${wishlist_id}    {"data": {"type": "wishlists","attributes": {"name": ""}}}
    Then Response status code should be:    ${422}
    AND Response reason should be:    Unprocessable Content
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204

Updating_wishlist_with_invalid_name
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    When I send a Patch request:    /wishlists/${wishlist_id}    {"data": {"type": "wishlists","attributes": {"name": "."}}}
    Then Response status code should be:    ${422}
    And Response should return error message:   Please enter name using only letters, numbers, underscores, spaces or dashes.
    And Response should return error code:    210
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204

Updating_wishlist_by_invalid_Access_Token
     [Setup]    I set Headers:    Authorization=3485h7
    When I send a Patch request:    /wishlists/123    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name}"}}}  
    Then Response status code should be:    401 
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
    
Updating_wishlist_without_Access_Token
     [Setup]    I set Headers:    Authorization=
    When I send a Patch request:    /wishlists/123   {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name}"}}}  
    Then Response status code should be:    403 
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.
