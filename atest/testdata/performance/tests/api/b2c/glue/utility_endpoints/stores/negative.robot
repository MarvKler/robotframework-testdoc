*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    spryker-core

*** Test Cases ***
Get_store_by_non_exist_id
    When I send a GET request:    /stores/NON_EXIST_STORE
    Then Response status code should be:    404
    And Response should return error code:    601
    And Response should return error message:    Store not found.