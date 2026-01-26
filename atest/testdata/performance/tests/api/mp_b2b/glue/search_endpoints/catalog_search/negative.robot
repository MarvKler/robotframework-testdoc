*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    search    catalog

*** Test Cases ***
Search_without_query_parameter
    When I send a GET request:    /catalog-search?
    Then Response status code should be:    200