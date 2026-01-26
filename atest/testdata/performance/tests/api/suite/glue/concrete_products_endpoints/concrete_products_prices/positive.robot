*** Settings ***
Suite Setup       API_suite_setup
Test Tags      glue    product    prices
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
####GET####
Get_concrete_product_with_only_default_price
    When I send a GET request:    /concrete-products/${concrete_product.product_with_original_prices.concrete_sku}/concrete-product-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]   concrete-product-prices
    And Response body parameter should be:    [data][0][id]    ${concrete_product.product_with_original_prices.concrete_sku}
    And Response body parameter should not be EMPTY:    [data][0][attributes][price]
    And Response body parameter should contain:    [data][0][attributes][prices]    grossAmount
    And Response body parameter should contain:    [data][0][attributes][prices]    netAmount
    And Response body parameter should contain:    [data][0][attributes][prices][0][currency][code]    ${currency.eur.code}
    And Response body parameter should contain:    [data][0][attributes][prices][0][currency][name]    ${currency.eur.name}
    And Response body parameter should contain:    [data][0][attributes][prices][0][currency][symbol]    ${currency.eur.symbol}
    And Response body parameter should be:    [data][0][attributes][prices][0][priceTypeName]   DEFAULT 
    And Response body has correct self link

Get_concrete_product_with_default_and_original_prices
    When I send a GET request:    /concrete-products/${concrete_product.product_with_original_prices.concrete_sku}/concrete-product-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]   concrete-product-prices
    And Response body parameter should be:    [data][0][id]    ${concrete_product.product_with_original_prices.concrete_sku}
    And Response should contain the array of a certain size:    [data][0][attributes][prices]    2
    And Response body parameter should be:    [data][0][attributes][prices][0][priceTypeName]    DEFAULT
    And Response body parameter should be:    [data][0][attributes][prices][1][priceTypeName]    ORIGINAL
    And Response body parameter should not be EMPTY:    [data][0][attributes][prices][0][grossAmount] 
    And Each array element of array in response should contain property with value:    [data][0][attributes][prices]    netAmount    ${None}
    And Each array element of array in response should contain property with value:    [data][0][attributes][prices]    volumePrices    ${arrow}
    And Response body has correct self link

Get_concrete_product_with_volume_product_prices
    When I send a GET request:    /concrete-products/${concrete_product.product_with_volume_prices.concrete_sku}/concrete-product-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]   concrete-product-prices
    And Response body parameter should be:    [data][0][id]    ${concrete_product.product_with_volume_prices.concrete_sku}
    And Response should contain the array of a certain size:    [data][0][attributes][prices][0][volumePrices]   3
    And Each array element of array in response should contain property:    [data][0][attributes][prices][0][volumePrices]    grossAmount
    And Each array element of array in response should contain property:    [data][0][attributes][prices][0][volumePrices]    netAmount
    And Each array element of array in response should contain property:    [data][0][attributes][prices][0][volumePrices]    quantity
    And Response body has correct self link

Get_concrete_product_with_CHF_price_and_gross_mode
    When I send a GET request:    /concrete-products/${concrete_product.product_with_original_prices.concrete_sku}/concrete-product-prices?currency=${currency.chf.code}&priceMode=${mode.gross}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]   concrete-product-prices
    And Response body parameter should be:    [data][0][id]    ${concrete_product.product_with_original_prices.concrete_sku}
    And Response body parameter should not be EMPTY:    [data][0][attributes][price]
    And Response body parameter should contain:    [data][0][attributes][prices]    grossAmount
    And Response body parameter should contain:    [data][0][attributes][prices]    netAmount
    And Response body parameter should contain:    [data][0][attributes][prices][0][currency][code]    ${currency.chf.code}
    And Response body parameter should contain:    [data][0][attributes][prices][0][currency][name]    ${currency.chf.name}
    And Response body parameter should contain:    [data][0][attributes][prices][0][currency][symbol]    ${currency.chf.symbol}
    And Response body parameter should be:    [data][0][attributes][prices][0][priceTypeName]   DEFAULT 
    And Response body has correct self link