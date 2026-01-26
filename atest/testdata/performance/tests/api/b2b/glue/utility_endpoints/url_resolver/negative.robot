*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    spryker-core


*** Test Cases ***
Get_url_collection_by_non_exist_url
    When I send a GET request:    /url-resolver?url=/non/exists/url
    Then Response status code should be:    404
    And Response should return error code:    2802
    And Response should return error message:    Url not found.

Get_absent_url_collections
    When I send a GET request:    /url-resolver
    Then Response status code should be:    422
    And Response should return error code:    2801
    And Response should return error message:    Url request parameter is missing.
