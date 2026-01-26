*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Test Tags    glue    wishlist    marketplace-wishlist    customer-access    customer-account-management    customer-access    customer-account-management    acl

*** Test Cases ***
#Get_request
Getting_wishlist_by_invalid_Access_Token
    [Setup]    I set Headers:    Authorization=abc
    When I send a GET request:    /wishlists
    Then Response status code should be:    401 
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
    
Getting_wishlist_without_Access_Token
    [Setup]    I set Headers:    Authorization=
    When I send a GET request:    /wishlists
    And Response should return error code:    002
    And Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.

Getting_wishlist_with_invalid_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /wishlists/2345hasd
    Then Response status code should be:    404 
    And Response reason should be:    Not Found
    And Response should return error code:    201
    And Response should return error message:    "Cant find wishlist."

Creating_wishlist_with_missing_name
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user.email}
    ...    AND     I set headers:    authorization=${token}
    When I send a POST request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": ""}}}
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content

Creating_wishlist_with_space_in_name
    Run Keywords    I GET access token for the customer:    ${yves_second_user.email}
    ...    AND     I set headers:    authorization=${token}
    When I send a POST request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": " "}}}
    And Response status code should be:    400
    And Response should return error code:    210
    And Response should return error message:    Please enter name using only letters, numbers, underscores, spaces or dashes.

Creating_Wishlist_with_a_name_that_already_exists
    [Setup]    Run Keywords    I GET access token for the customer:    ${yves_user.email}
    ...    AND    I set headers:    authorization=${token}
    ...    AND    I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    When I send a Post request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${wishlist_name}"}}}
    Then Response status code should be:    400
    And Response should return error message:    A wishlist with the same name already exists.
    AND Response should return error code:    202
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204