*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    marketplace-merchant-portal-product-management    marketplace-product

*** Test Cases ***    
Get_an_attribute_with_non_existent_attribute_id
    When I send a GET request:    /product-management-attributes/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    4201
    And Response should return error message:    Attribute not found.
