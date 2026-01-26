*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../resources/common/common_api.robot
Test Tags    bapi    spryker-core    spryker-core-back-office    warehouse-user-management

*** Test Cases ***
New_warehouse_token_without_autorization
    And I send a POST request:    /warehouse-tokens   {}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden


New_warehouse_token_with_invalid_token
    When I set Headers:    Authorization=fake_token    Content-Type=application/x-www-form-urlencoded
    And I send a POST request:    /warehouse-tokens   {}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden

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
