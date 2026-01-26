*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    product    prices

*** Test Cases ***
Get_abstract_prices_by_concrete_sku
    When I send a GET request:    /abstract-products/${concrete_product_with_abstract_product_alternative.sku}/abstract-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    307
    And Response should return error message:    Can`t find abstract product prices.

Get_abstract_prices_by_non_existing_sku
    When I send a GET request:    /abstract-products/fake/abstract-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    307
    And Response should return error message:    Can`t find abstract product prices.

Get_abstract_prices_with_missing_sku_in_url
    When I send a GET request:    /abstract-products//abstract-product-prices
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    311
    And Response should return error message:    Abstract product sku is not specified.
