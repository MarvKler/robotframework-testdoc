*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    product
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Request_product_concrete_with_product_doesn't_exist
    When I send a GET request:    /concrete-products/354656u7i8
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:     Concrete product is not found.

Request_product_concrete_with_abstract_SKU
    When I send a GET request:    /concrete-products/${bundle_product.abstract.product_2_sku}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:    Concrete product is not found.

Request_product_concrete_with_empty_SKU
    When I send a GET request:    /concrete-products/   
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    312
    And Response should return error message:    Concrete product sku is not specified.

Request_product_concrete_with_special_characters
    When I send a GET request:    /concrete-products/~!@#$%^&*()_+/
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:     Concrete product is not found.
