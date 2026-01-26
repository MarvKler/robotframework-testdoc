*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    spryker-core    customer-access    acl

*** Test Cases ***
Get_token_for_customer
    I set Headers:    Content-Type=${urlencoded_header_content_type}
    I send a POST request with data:    /token    {"grant_type": "${grant_type.password}","username": "${yves_user.email}","password": "${yves_user.password}"}
    Response status code should be:    200
    Response reason should be:    OK
    And Response body parameter should be:    [token_type]    Bearer
    And Response body parameter should be greater than:    [expires_in]    0
    And Response body parameter should be less than:    [expires_in]    30000
    And Response body parameter should not be EMPTY:    [access_token]
    And Response body parameter should not be EMPTY:    [refresh_token]


Get_token_using_refresh_token_for_customer
    [Setup]    Run Keywords    I set Headers:    Content-Type=${urlencoded_header_content_type}
    ...  AND    I send a POST request with data:    /token    {"grant_type": "${grant_type.password}","username": "${yves_user.email}","password": "${yves_user.password}"}
    ...  AND    Response status code should be:    200
    ...  AND    Save value to a variable:    [refresh_token]    refresh_token
    When I set Headers:    Content-Type=${urlencoded_header_content_type}
    And I send a POST request with data:    /token    {"grant_type": "${grant_type.refresh_token}","refresh_token": "${refresh_token}"}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [token_type]    Bearer
    And Response body parameter should be greater than:    [expires_in]    0
    And Response body parameter should be less than:    [expires_in]    30000
    And Response body parameter should not be EMPTY:    [access_token]
    And Response body parameter should not be EMPTY:    [refresh_token]

