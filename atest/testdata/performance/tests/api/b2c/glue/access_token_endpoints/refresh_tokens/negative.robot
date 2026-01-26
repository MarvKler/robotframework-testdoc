*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    spryker-core    customer-access    acl

*** Test Cases ***
#######POST#######
Refresh_token_with_access_token
    [Setup]    I get access token for the customer:    ${yves_user.email}
    When I send a POST request:    /refresh-tokens    {"data": {"type": "refresh-tokens","attributes": {"refreshToken": "${token}"}}}
    And Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    004
    And Response should return error message:    Failed to refresh token.

Refresh_token_with_invalid_refresh_token
    When I send a POST request:    /refresh-tokens    {"data": {"type": "refresh-tokens","attributes": {"refreshToken": "faketoken"}}}
    And Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    004
    And Response should return error message:    Failed to refresh token.

Refresh_token_with_empty_refresh_token
    When I send a POST request:    /refresh-tokens    {"data": {"type": "refresh-tokens","attributes": {"refreshToken": ""}}}
    And Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    refreshToken => This value should not be blank.

Refresh_token_with_invalid_type
    [Setup]    Run Keywords    I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${yves_user.email}","password":"${yves_user.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][refreshToken]    refresh_token
    When I send a POST request:    /refresh-tokens    {"data": {"type": "access-tokens","attributes": {"refreshToken": "${refresh_token}"}}}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.

Refresh_token_with_deleted_refresh_token
    [Tags]    skip-due-to-issue
    [Documentation]    Bug: https://spryker.atlassian.net/browse/FRW-10160
    [Setup]    Run Keywords    I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${yves_user.email}","password":"${yves_user.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][refreshToken]    refresh_token
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    access_token
    ...    AND    I set Headers:    Authorization=Bearer ${access_token}
    ...    AND    I send a DELETE request:    /refresh-tokens/${refresh_token}
    ...    AND    Response status code should be:    204
    And I send a POST request:    /refresh-tokens    {"data": {"type": "refresh-tokens","attributes": {"refreshToken": "${refresh_token}"}}}
    And Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error message:    Failed to refresh token.

#######DELETE#######
# Spryker is designed so removing non-existent refresh token will return 204 for security reasons
Delete_refresh_token_with_invalid_refresh_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a DELETE request:    /refresh-tokens/faketoken
    Then Response status code should be:    204
    And Response reason should be:    No Content

Delete_refresh_token_with_missing_refresh_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    And I send a DELETE request:    /refresh-tokens/
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Delete_refresh_token_with_no_access_token
    [Setup]    Run Keywords    I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${yves_user.email}","password":"${yves_user.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][refreshToken]    refresh_token
    And I send a DELETE request:    /refresh-tokens/${refresh_token}
    And Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

# Spryker is designed so that deleting will return 204, but the token will not be removed and can be used (done for security reasons)
Delete_refresh_token_for_another_user
    [Setup]    Run Keywords    I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${yves_user.email}","password":"${yves_user.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][refreshToken]    refresh_token
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    access_token
    When I get access token for the customer:    ${yves_second_user.email}
    And I set Headers:    Authorization=${token}
    And I send a DELETE request:    /refresh-tokens/${refresh_token}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    And I set Headers:    Authorization=Bearer ${access_token}
    And I send a POST request:    /refresh-tokens    {"data": {"type": "refresh-tokens","attributes": {"refreshToken": "${refresh_token}"}}}
    And Response status code should be:    201
    And Response reason should be:    Created

