*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product

*** Test Cases ***
Request_concrete_availability_by_concrete_SKU_with_stock
    When I send a GET request:    /concrete-products/${concrete.available_product.with_stock.sku3}/concrete-product-availabilities
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${concrete.available_product.with_stock.sku3}
    And Response body parameter should be:    [data][0][type]   concrete-product-availabilities
    And Response body parameter should be:    [data][0][attributes][availability]   True
    And Response body parameter should be:    [data][0][attributes][isNeverOutOfStock]   False
    And Response body parameter should be greater than:    [data][0][attributes][quantity]   1
    And Response body has correct self link

Request_concrete_availability_by_concrete_SKU_with_stock_and_never_out_of_stock
    When I send a GET request:    /concrete-products/${concrete.available_product.with_stock_and_never_out_of_stock.sku}/concrete-product-availabilities
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${concrete.available_product.with_stock_and_never_out_of_stock.sku}
    And Response body parameter should be:    [data][0][type]   concrete-product-availabilities
    And Response body parameter should be:    [data][0][attributes][availability]   True
    And Response body parameter should be:    [data][0][attributes][isNeverOutOfStock]   True
    And Response body parameter should be greater than:    [data][0][attributes][quantity]   0
    And Response body has correct self link
    

Request_concrete_availability_by_concrete_SKU_without_stock
    When I send a GET request:    /concrete-products/${concrete.available_product.without_stock.sku}/concrete-product-availabilities
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${concrete.available_product.without_stock.sku}
    And Response body parameter should be:    [data][0][type]   concrete-product-availabilities
    And Response body parameter should be:    [data][0][attributes][availability]   False
    And Response body parameter should be:    [data][0][attributes][isNeverOutOfStock]   False
    And Response body parameter should be:    [data][0][attributes][quantity]   ${stock_is_0}
    And Response body has correct self link