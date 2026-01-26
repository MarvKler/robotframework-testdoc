*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    product    tax


*** Test Cases ***

Get_a_tax_set_with_concrete_sku
    When I send a GET request:
    ...    /abstract-products/${concrete.available_product.with_stock.product_1.sku}/product-tax-sets
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    310
    And Response should return error message:    Product tax sets not found.

Get_a_tax_set_with_missing_sku
    When I send a GET request:    /abstract-products//product-tax-sets
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    301
    And Response should return error message:    Abstract product is not found.

Get_a_tax_set_with_non_existing_sku
    When I send a GET request:    /abstract-products/fake/product-tax-sets
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    310
    And Response should return error message:    Product tax sets not found.
