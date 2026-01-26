*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    merchant-category    category-management


*** Test Cases ***
# endpoint receive category_node_id as int
# here I use str type of the id and test response body

Get_category_node_by_invalid_id
    When I send a GET request:    /category-nodes/test
    Then Response status code should be:    400
    And Response should return error code:    701
    And Response should return error message:    Category node id has not been specified or invalid.

# non exists mean that type of id is valid but it does not exists at DB level

Get_category_node_by_non_exist_id
    When I send a GET request:    /category-nodes/111111
    Then Response status code should be:    404
    And Response should return error code:    703
    And Response should return error message:    "Cant find category node with the given id."

# Missing category_node_id have response error

Get_absent_category_node
    When I send a GET request:    /category-nodes
    Then Response status code should be:    400
    And Response should return error code:    701
    And Response should return error message:    Category node id has not been specified or invalid.
