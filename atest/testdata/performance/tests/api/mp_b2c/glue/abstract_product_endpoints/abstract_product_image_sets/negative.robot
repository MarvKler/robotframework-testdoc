*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    product

*** Test Cases ***
Get_abstract_image_sets_by_concrete_sku
    When I send a GET request:    /abstract-products/${concrete_product_with_abstract_product_alternative.sku}/abstract-product-image-sets
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    303
    And Response should return error message:    Can`t find abstract product image sets.

Get_abstract_image_sets_by_not_existing_sku
    When I send a GET request:    /abstract-products/test/abstract-product-image-sets
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    303
    And Response should return error message:    Can`t find abstract product image sets.

Get_abstract_image_sets_with_missing_sku_in_url
    When I send a GET request:    /abstract-products//abstract-product-image-sets
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    301
    And Response should return error message:    Abstract product is not found.
