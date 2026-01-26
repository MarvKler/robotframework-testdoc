*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    content-item

*** Test Cases ***
Get_banner_without_id
    When I send a GET request:    /content-banners
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    2202
    And Response should return error message:    Content key is missing.

Get_banner_with_wrong_content_id_type
    When I send a GET request:    /content-banners/${abstract_product_list.id}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    2203
    And Response should return error message:    Content type is invalid.

Get_banner_with_invalid_content_id
    When I send a GET request:    /content-banners/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    2201
    And Response should return error message:    Content not found.