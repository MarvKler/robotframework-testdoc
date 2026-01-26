*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    product    inventory-management


*** Test Cases ***
Get_abstract_availability_by_concrete_SKU
    When I send a GET request:
    ...    /abstract-products/${concrete.alternative_products.product_1.sku}/abstract-product-availabilities
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    305
    And Response should return error message:    Availability is not found.

Get_abstract_availability_by_fake_SKU
    When I send a GET request:    /abstract-products/fake/abstract-product-availabilities
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    305
    And Response should return error message:    Availability is not found.

Get_abstract_availability_with_missing_SKU
    When I send a GET request:    /abstract-products//abstract-product-availabilities
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    311
    And Response should return error message:    Abstract product sku is not specified.
