*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    product    alternative-products


*** Test Cases ***
Get_abstract_product_alternative_for_concrete_product_with_invalid_sku_of_product
    When I send a GET request:    /concrete-products/65789/concrete-alternative-products
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Concrete product is not found.

Get_abstract_product_alternative_for_concrete_product_using_abstract_product_SKU
    When I send a GET request:
    ...    /concrete-products/${bundle_product.product_2.abstract_sku}/concrete-alternative-products
    Then Response status code should be:    404
    And Response body parameter should be:    [errors][0][detail]    Concrete product is not found.
