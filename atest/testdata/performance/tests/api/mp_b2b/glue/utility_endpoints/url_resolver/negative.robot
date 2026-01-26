*** Settings *** 
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    spryker-core

Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Get_url_collection_by_empty_url
    When I send a GET request:    /url-resolver
    Then Response status code should be:    ${422}
    And Response should return error code:    2801
    And Response should return error message:    Url request parameter is missing.

Get_url_collection_when_requested_url_does_not_exist
    When I send a GET request:    /url-resolver?url=/requested/url/does/not/exist/
    Then Response status code should be:    404
    And Response should return error code:    2802
    And Response should return error message:    Url not found.