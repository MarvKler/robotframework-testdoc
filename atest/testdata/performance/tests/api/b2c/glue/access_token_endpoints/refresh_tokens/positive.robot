*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    spryker-core    customer-access    acl

*** Test Cases ***
Refresh_access_token_for_customer
    [Setup]    Run Keywords    I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${yves_user.email}","password":"${yves_user.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][refreshToken]    refresh_token
    When I send a POST request:    /refresh-tokens    {"data": {"type": "refresh-tokens","attributes": {"refreshToken": "${refresh_token}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be greater than:    [data][attributes][expiresIn]    0
    And Response body parameter should be less than:    [data][attributes][expiresIn]    30000
    And Response body parameter should not be EMPTY:    [data][attributes][tokenType]
    And Response body parameter should not be EMPTY:    [data][attributes][accessToken]
    And Save value to a variable:    [data][attributes][accessToken]    refreshed_access_token
    And Response body has correct self link internal
    When I set Headers:    Authorization=Bearer ${refreshed_access_token}
    And I send a GET request:    /customers
    Then Response status code should be:    200

Delete_refresh_token_for_customer
    [Tags]    skip-due-to-issue
    [Documentation]    Bug: https://spryker.atlassian.net/browse/FRW-10160
    [Setup]    Run Keywords    I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${yves_user.email}","password":"${yves_user.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][refreshToken]    refresh_token
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    access_token
    When I set Headers:    Authorization=Bearer ${access_token}
    And I send a DELETE request:    /refresh-tokens/${refresh_token}
    Then Response status code should be:    204
    And Response reason should be:    No Content

