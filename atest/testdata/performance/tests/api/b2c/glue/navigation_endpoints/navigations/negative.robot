*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    navigation    spryker-core
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Get_navigations_by_non_exist_id
    When I send a GET request:    /navigations/testNonExistNavigations
    Then Response status code should be:    404
    And Response should return error code:    1601
    And Response should return error message:    Navigation not found.


Get_absent_navigations
    When I send a GET request:    /navigations
    Then Response status code should be:    400
    And Response should return error code:    1602
    And Response should return error message:    Navigation id not specified.