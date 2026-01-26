*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    inventory-management

*** Test Cases ***
Product_is_available_with_stock_and_never_out_of_stock
    When I send a GET request:    /abstract-products/${product_availability.abstract_available_with_stock_and_never_out_of_stock}/abstract-product-availabilities
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    abstract-product-availabilities
    And Response body parameter should be:    [data][0][id]    ${product_availability.abstract_available_with_stock_and_never_out_of_stock}
    And Response body parameter should be greater than:    [data][0][attributes][quantity]   1
    And Response body parameter should be:    [data][0][attributes][availability]   True
    And Response body has correct self link
 
Product_is_available_with_stock
    When I send a GET request:    /abstract-products/${abstract_available_product_with_stock.sku}/abstract-product-availabilities
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    abstract-product-availabilities
    And Response body parameter should be:    [data][0][id]    ${abstract_available_product_with_stock.sku}
    And Response body parameter should be greater than:    [data][0][attributes][quantity]   1
    And Response body parameter should be:    [data][0][attributes][availability]   True
    And Response body has correct self link    

Product_is_available_never_out_of_stock
    When I send a GET request:    /abstract-products/${product_availability.abstract_available_product_with_no_stock_and_never_out_of_stock}/abstract-product-availabilities
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    abstract-product-availabilities
    And Response body parameter should be:    [data][0][id]    ${product_availability.abstract_available_product_with_no_stock_and_never_out_of_stock}
    And Response body parameter should be:    [data][0][attributes][availability]   True
    And Response body parameter should be:    [data][0][attributes][quantity]    ${stock_is_0}
    And Response body has correct self link   

# No demo data for B2C BUG CC-16485
# Bug is resolved and unavailable product SKU is updated in test data
Product_is_unavailable
    When I send a GET request:    /abstract-products/${product_availability.abstract_unavailable_product}/abstract-product-availabilities
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    abstract-product-availabilities
    And Response body parameter should be:    [data][0][id]    ${product_availability.abstract_unavailable_product}
    And Response body parameter should be:    [data][0][attributes][availability]   False
    And Response body parameter should be:    [data][0][attributes][quantity]    ${stock_is_0}
    And Response body has correct self link       

Product_is_available_with_3_concrete_stocks_combined
    #checks that stock of all 3 concretes as aggregated in response
    When I send a GET request:    /abstract-products/${multivariant.abstract_product.concretes_3}/abstract-product-availabilities
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    abstract-product-availabilities
    And Response body parameter should be:    [data][0][id]    ${multivariant.abstract_product.concretes_3}
    And Response body parameter should be:    [data][0][attributes][availability]    True
    And Response body parameter should be greater than:    [data][0][attributes][quantity]    ${stock_is_20}
    And Response body has correct self link  
