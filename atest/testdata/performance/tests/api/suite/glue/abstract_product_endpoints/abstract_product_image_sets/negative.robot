*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product

*** Test Cases ***
Get_abstract_image_sets_by_concrete_SKU
    When I send a GET request:    /abstract-products/${product_with_alternative.concrete_sku}/abstract-product-image-sets
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    303
    And Response should return error message:    Can`t find abstract product image sets.

Get_abstract_image_sets_by_fake_SKU
    When I send a GET request:    /abstract-products/fake/abstract-product-image-sets
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    303
    And Response should return error message:    Can`t find abstract product image sets.

Get_abstract_image_sets_with_missing_SKU
    When I send a GET request:    /abstract-products//abstract-product-image-sets
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    301
    And Response should return error message:    Abstract product is not found.