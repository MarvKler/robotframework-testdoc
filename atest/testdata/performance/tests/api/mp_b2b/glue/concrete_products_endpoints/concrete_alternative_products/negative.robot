*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    product
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Get_abstract_product_alternative_for_concrete_product_with_invalid_sku_of_product
    When I send a GET request:    /concrete-products/65789/concrete-alternative-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:    Concrete product is not found.


Get_abstract_product_alternative_for_concrete_product_using_abstract_product_SKU
    When I send a GET request:    /concrete-products/${bundle_product.abstract.product_1_sku}/concrete-alternative-products
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:    Concrete product is not found.