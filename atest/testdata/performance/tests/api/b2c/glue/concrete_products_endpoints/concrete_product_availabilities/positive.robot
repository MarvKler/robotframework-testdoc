*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product

*** Test Cases ***
Request_concrete_availability_by_concrete_SKU_with_stock
    When I send a GET request:    /concrete-products/${product_availability.concrete_available_product_with_stock2}/concrete-product-availabilities
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${product_availability.concrete_available_product_with_stock2}
    And Response body parameter should be:    [data][0][type]   concrete-product-availabilities
    And Response body parameter should be:    [data][0][attributes][availability]   True
    And Response body parameter should be:    [data][0][attributes][isNeverOutOfStock]   False
    And Response body parameter should be greater than:    [data][0][attributes][quantity]   1
    And Response body has correct self link

Request_concrete_availability_by_concrete_SKU_with_stock_and_never_out_of_stock
    When I send a GET request:    /concrete-products/${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku1}/concrete-product-availabilities
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku1}
    And Response body parameter should be:    [data][0][type]   concrete-product-availabilities
    And Response body parameter should be:    [data][0][attributes][availability]   True
    And Response body parameter should be:    [data][0][attributes][isNeverOutOfStock]   True
    And Response body parameter should be greater than:    [data][0][attributes][quantity]    0.0000000000
    And Response body has correct self link
    

Request_concrete_availability_by_concrete_SKU_without_stock
    When I send a GET request:    /concrete-products/${product_availability.concrete_available_product_without_stock}/concrete-product-availabilities
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${product_availability.concrete_available_product_without_stock}
    And Response body parameter should be:    [data][0][type]   concrete-product-availabilities
    And Response body parameter should be:    [data][0][attributes][availability]   False
    And Response body parameter should be:    [data][0][attributes][isNeverOutOfStock]   False
    And Response body parameter should be:    [data][0][attributes][quantity]   ${stock_is_0}
    And Response body has correct self link