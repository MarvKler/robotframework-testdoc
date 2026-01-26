*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    product    measurement-units    packaging-units


*** Test Cases ***
Get_a_measurement_unit_with_non_existent_sku
    When I send a GET request:    /concrete-products/fake/sales-units
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:    Concrete product is not found.

Get_a_measurement_unit_with_abstract_sku
    When I send a GET request:    /concrete-products/${abstract.available_products.with_stock.sku}/sales-units
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:    Concrete product is not found.

Get_a_measurement_unit_with_empty_sku
    When I send a GET request:    /concrete-products//sales-units
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    312
    And Response should return error message:    Concrete product sku is not specified.
