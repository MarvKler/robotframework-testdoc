*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    spryker-core    customer-access    acl


*** Test Cases ***
Get_token_for_customer_with_invalid_grant_type
    When I set Headers:    Content-Type=${urlencoded_header_content_type}
    Then I send a POST request with data:
    ...    /token
    ...    {"grant_type": "invalid_grant_type","username": "${yves_user.email}","password": "${yves_user.password}"}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body parameter should be:    [error]    invalid_grant
    And Response body parameter should be:
    ...    [error_description]
    ...    The provided authorization grant (e.g., authorization code, resource owner credentials) or refresh token is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client.

Get_token_for_customer_with_missing_grant_type
    When I set Headers:    Content-Type=${urlencoded_header_content_type}
    Then I send a POST request with data:
    ...    /token
    ...    {"username": "${yves_user.email}","password": "${yves_user.password}"}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body parameter should be:    [error]    invalid_grant
    And Response body parameter should be:
    ...    [error_description]
    ...    The provided authorization grant (e.g., authorization code, resource owner credentials) or refresh token is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client.

Get_token_for_customer_with_invalid_password
    When I set Headers:    Content-Type=${urlencoded_header_content_type}
    Then I send a POST request with data:
    ...    /token
    ...    {"grant_type": "${grant_type.password}","username": "${yves_user.email}","password": "wrong_password"}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body parameter should be:    [error]    invalid_grant
    And Response body parameter should be:    [error_description]    The user credentials were incorrect.

Get_token_for_customer_with_missing_password
    When I set Headers:    Content-Type=${urlencoded_header_content_type}
    Then I send a POST request with data:
    ...    /token
    ...    {"grant_type": "${grant_type.password}","username": "${yves_user.email}"}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body parameter should be:    [error]    invalid_request
    And Response body parameter should be:
    ...    [error_description]
    ...    The request is missing a required parameter, includes an invalid parameter value, includes a parameter more than once, or is otherwise malformed.

Get_token_for_customer_with_invalid_email
    When I set Headers:    Content-Type=${urlencoded_header_content_type}
    Then I send a POST request with data:
    ...    /token
    ...    {"grant_type": "${grant_type.password}","username": "fake@spryker.com","password": "${yves_user.password}"}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body parameter should be:    [error]    invalid_grant
    And Response body parameter should be:    [error_description]    The user credentials were incorrect.

Get_token_for_customer_with_missing_email
    When I set Headers:    Content-Type=${urlencoded_header_content_type}
    Then I send a POST request with data:
    ...    /token
    ...    {"grant_type": "${grant_type.password}","password": "${yves_user.password}"}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body parameter should be:    [error]    invalid_request
    And Response body parameter should be:
    ...    [error_description]
    ...    The request is missing a required parameter, includes an invalid parameter value, includes a parameter more than once, or is otherwise malformed.

Get_token_using_refresh_token_for_customer_with_missing_grant_type
    [Setup]    Run Keywords    I set Headers:    Content-Type=${urlencoded_header_content_type}
    ...    AND    I send a POST request with data:    /token    {"grant_type": "${grant_type.password}","username": "${yves_user.email}","password": "${yves_user.password}"}
    ...    AND    Response status code should be:    200
    ...    AND    Save value to a variable:    [refresh_token]    refresh_token
    When I set Headers:    Content-Type=${urlencoded_header_content_type}
    And I send a POST request with data:    /token    {"refresh_token": "${refresh_token}"}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body parameter should be:    [error]    invalid_grant
    And Response body parameter should be:
    ...    [error_description]
    ...    The provided authorization grant (e.g., authorization code, resource owner credentials) or refresh token is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client.

Get_token_using_refresh_token_for_customer_with_invalid_grant_type
    [Setup]    Run Keywords    I set Headers:    Content-Type=${urlencoded_header_content_type}
    ...    AND    I send a POST request with data:    /token    {"grant_type": "${grant_type.password}","username": "${yves_user.email}","password": "${yves_user.password}"}
    ...    AND    Response status code should be:    200
    ...    AND    Save value to a variable:    [refresh_token]    refresh_token
    When I set Headers:    Content-Type=${urlencoded_header_content_type}
    And I send a POST request with data:
    ...    /token
    ...    {"grant_type": "invalid_grant_type","refresh_token": "${refresh_token}"}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body parameter should be:    [error]    invalid_grant
    And Response body parameter should be:
    ...    [error_description]
    ...    The provided authorization grant (e.g., authorization code, resource owner credentials) or refresh token is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client.

Get_token_using_refresh_token_for_customer_with_missing_refresh_token
    When I set Headers:    Content-Type=${urlencoded_header_content_type}
    And I send a POST request with data:    /token    {"grant_type": "${grant_type.refresh_token}"}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body parameter should be:    [error]    invalid_request
    And Response body parameter should be:
    ...    [error_description]
    ...    The request is missing a required parameter, includes an invalid parameter value, includes a parameter more than once, or is otherwise malformed.

Get_token_using_refresh_token_for_customer_with_invalid_refresh_token
    When I set Headers:    Content-Type=${urlencoded_header_content_type}
    And I send a POST request with data:
    ...    /token
    ...    {"grant_type": "${grant_type.refresh_token}","refresh_token": "invalid_refresh_token"}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response body parameter should be:    [error]    invalid_request
    And Response body parameter should be:    [error_description]    The refresh token is invalid.
