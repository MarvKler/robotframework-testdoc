*** Settings ***
Suite Setup       API_suite_setup
Test Tags      glue    product    prices
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Get_product_prices_with_abstract_sku
    When I send a GET request:    /concrete-products/${bundle_product.abstract.product_2_sku}/concrete-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    308
    And Response should return error message:    Can`t find concrete product prices.

Get_product_prices_with_empty_SKU

    When I send a GET request:    /concrete-products//concrete-product-prices
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    312
    And Response should return error message:    Concrete product sku is not specified.

Get_product_prices_with_special_characters
    When I send a GET request:    /concrete-products/~!@#$%^&*()_+/concrete-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:     Concrete product is not found.

Get_product_prices_by_concrete_sku_product_doesn't_exist
    When I send a GET request:    /concrete-products/4567890/concrete-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    308
    And Response should return error message:     Can`t find concrete product prices.



Request_URL_type_is_wrong
    When I send a GET request:    /concrete-product/${concrete_product.product_with_original_prices.concrete_sku}/concrete-product-prices
    Then Response status code should be:    404
    And Response should return error message:     Not Found