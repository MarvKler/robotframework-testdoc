*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    configurable-bundle

*** Test Cases ***
Get_configurable_bundle_templates_by_invalid_configurable_bundle_template_id
    When I send a GET request:    /configurable-bundle-templates/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    3901
    And Response should return error message:    Configurable bundle template not found.