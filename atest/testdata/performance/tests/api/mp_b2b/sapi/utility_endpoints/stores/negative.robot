*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    sapi

*** Test Cases ***
Get_store_by_non_exist_id
    And I set Headers:    Content-Type=${default_header_content_type}
    When I send a GET request:    /stores/NON_EXIST_STORE
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    601
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should return error message:    Store not found
