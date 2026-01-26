*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    spryker-core    customer-access    acl


*** Test Cases ***
Get_acess_token_with_invalid_password
    When I send a POST request:
    ...    /access-tokens
    ...    {"data":{"type":"access-tokens","attributes":{"username":"${yves_second_user.email}","password":"fake"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    003
    And Response should return error message:    Failed to authenticate user.

Get_acess_token_with_invalid_email
    When I send a POST request:
    ...    /access-tokens
    ...    {"data":{"type":"access-tokens","attributes":{"username":"fake@spryker.com","password":"${yves_user.password}"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    003
    And Response should return error message:    Failed to authenticate user.

Get_acess_token_with_empty_password
    When I send a POST request:
    ...    /access-tokens
    ...    {"data":{"type":"access-tokens","attributes":{"username":"${yves_second_user.email}","password":""}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    password => This value should not be blank.

Get_acess_token_with_empty_email
    When I send a POST request:
    ...    /access-tokens
    ...    {"data":{"type":"access-tokens","attributes":{"username":"","password":"${yves_second_user.password}"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    username => This value should not be blank.

Get_acess_token_with_invalid_type
    When I send a POST request:
    ...    /access-tokens
    ...    {"data":{"type":"access","attributes":{"username":"${yves_second_user.email}","password":"${yves_second_user.password}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.

Get_acess_token_with_empty_type
    When I send a POST request:
    ...    /access-tokens
    ...    {"data":{"type":"","attributes":{"username":"${yves_second_user.email}","password":"${yves_second_user.password}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.
