*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags      glue    product    prices

*** Test Cases ***
Request_concrete_product_with_only_default_price
    When I send a GET request:    /concrete-products/${concrete_product.one_image_set.sku}/concrete-product-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body has correct self link
    And Response body parameter should be:    [data][0][id]    ${concrete_product.one_image_set.sku}
    And Response body parameter should be:    [data][0][type]   concrete-product-prices
    And Response body parameter should not be EMPTY:    [data][0][attributes][price]
    And Response body parameter should be greater than:    [data][0][attributes][price]    1
    And Response body parameter should contain:    [data][0][attributes][prices]    grossAmount
    And Response body parameter should contain:    [data][0][attributes][prices]    netAmount
    And Response body parameter should be greater than:    [data][0][attributes][prices][0][grossAmount]    1
    And Response body parameter should contain:    [data][0][attributes][prices][0][currency][code]    ${currency.eur.code}
    And Response body parameter should contain:    [data][0][attributes][prices][0][currency][name]    ${currency.eur.name}
    And Response body parameter should contain:    [data][0][attributes][prices][0][currency][symbol]    ${currency.eur.symbol}
    And Response body parameter should be:    [data][0][attributes][prices][0][priceTypeName]   DEFAULT 
    
Request_concrete_product_with_default_and_original_prices
    When I send a GET request:    /concrete-products/${concrete_product.original_prices.sku}/concrete-product-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][id]    ${concrete_product.original_prices.sku}
    And Response body parameter should be:    [data][0][type]   concrete-product-prices
    And Response should contain the array of a certain size:    [data][0][attributes][prices]    2
    And Response body parameter should be:    [data][0][attributes][prices][0][priceTypeName]    DEFAULT
    And Response body parameter should be:    [data][0][attributes][prices][1][priceTypeName]    ORIGINAL
    And Response body parameter should not be EMPTY:    [data][0][attributes][prices][0][grossAmount] 
    And Each array element of array in response should contain property with value:    [data][0][attributes][prices]    netAmount    ${None}
    And Each array element of array in response should contain property with value:    [data][0][attributes][prices]    volumePrices    ${array}
      
Request_concrete_product_with_volume_product_prices
    When I send a GET request:    /concrete-products/${concrete_product.volume_prices.sku}/concrete-product-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][id]    ${concrete_product.volume_prices.sku}
    And Response body parameter should be:    [data][0][type]   concrete-product-prices
    And Response should contain the array of a certain size:    [data][0][attributes][prices][0][volumePrices]   3
    And Each array element of array in response should contain property:    [data][0][attributes][prices][0][volumePrices]    grossAmount
    And Each array element of array in response should contain property:    [data][0][attributes][prices][0][volumePrices]    netAmount
    And Each array element of array in response should contain property:    [data][0][attributes][prices][0][volumePrices]    quantity
    And Response body parameter should be:    [data][0][attributes][prices][0][volumePrices][0][grossAmount]   ${concrete_product.volume_prices_gross.amount}
    And Response body parameter should be:    [data][0][attributes][prices][0][volumePrices][0][netAmount]   ${concrete_product.volume_prices_net.amount}
    And Response body parameter should be:    [data][0][attributes][prices][0][volumePrices][0][quantity]   5