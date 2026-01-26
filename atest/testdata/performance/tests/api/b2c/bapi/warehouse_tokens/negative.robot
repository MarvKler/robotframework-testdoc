*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../resources/common/common_api.robot
Test Tags    bapi

*** Test Cases ***
New_warehouse_token_without_autorization
    [Tags]    skip-due-to-issue
    [Documentation]    https://spryker.atlassian.net/browse/FRW-2142
    And I send a POST request:    /warehouse-tokens   {}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    003
    And Response should return error message:    Autorization is required.

New_warehouse_token_with_invalid_token
    [Tags]    skip-due-to-issue
    [Documentation]    https://spryker.atlassian.net/browse/FRW-1728
    When I set Headers:    Authorization=fake_token    Content-Type=application/x-www-form-urlencoded
    And I send a POST request:    /warehouse-tokens   {}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    003
    And Response should return error message:    Failed to authenticate user.

New_warehouse_token_for_admin_user_who_is_not_a_WH_user
    When I set Headers:    Content-Type=application/x-www-form-urlencoded
    When I send a POST request:    /token  {"grantType": "${grant_type.password}","username": "${admin_not_warehouse_user.email}","password": "${admin_not_warehouse_user.password}"}
    Then Response status code should be:    200
    And Save value to a variable:    [access_token]   bapi_token
    When I set Headers:    Authorization=Bearer ${bapi_token}  
    And I send a POST request:    /warehouse-tokens    {}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response body parameter should be:    [0][code]    5101
    And Response body parameter should be:    [0][message]    Operation is forbidden.   