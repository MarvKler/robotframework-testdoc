*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Test Tags    glue    category-management

*** Test Cases ***
Get_category_node_by_invalid_id
    When I send a GET request:    /category-nodes/test
    Then Response status code should be:    400
    And Response should return error code:    701
    And Response should return error message:    Category node id has not been specified or invalid.

Get_category_node_by_non_exist_id
    When I send a GET request:    /category-nodes/111111
    Then Response status code should be:    404
    And Response should return error code:    703
    And Response should return error message:    "Cant find category node with the given id."

Get_absent_category_node
    When I send a GET request:    /category-nodes
    Then Response status code should be:    400
    And Response should return error code:    701
    And Response should return error message:    Category node id has not been specified or invalid.