*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    prices

*** Test Cases ***
Abstract_prices_default_only
    When I send a GET request:    /abstract-products/${multivariant.abstract_product.concretes_3}/abstract-product-prices?currency=EUR&priceMode=GROSS_MODE
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][id]    ${multivariant.abstract_product.concretes_3}
    And Response body parameter should be greater than:    [data][0][attributes][price]   100
    And Save value to a variable:    [data][0][attributes][price]    default.price
    And Response should contain the array of a certain size:    [data][0][attributes][prices]    1
    And Response body parameter should be:    [data][0][attributes][prices][0][priceTypeName]    DEFAULT
    And Response body parameter should be:    [data][0][attributes][prices][0][netAmount]    None
    And Response body parameter should be:    [data][0][attributes][prices][0][grossAmount]    ${default.price}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][code]    ${currency.eur.code}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][name]    ${currency.eur.name}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][symbol]    ${currency.eur.symbol}
    And Response should contain the array of a certain size:    [data][0][attributes][prices][0][volumePrices]   0
    And Response body has correct self link

Abstract_prices_default_only_CHF
    When I send a GET request:    /abstract-products/${multivariant.abstract_product.concretes_3}/abstract-product-prices?currency=CHF&priceMode=GROSS_MODE
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][id]    ${multivariant.abstract_product.concretes_3}
    And Response body parameter should be greater than:    [data][0][attributes][price]   100
    And Save value to a variable:    [data][0][attributes][price]    default.price
    And Response should contain the array of a certain size:    [data][0][attributes][prices]    1
    And Response body parameter should be:    [data][0][attributes][prices][0][priceTypeName]    DEFAULT
    And Response body parameter should be:    [data][0][attributes][prices][0][netAmount]    None
    And Response body parameter should be:    [data][0][attributes][prices][0][grossAmount]    ${default.price}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][code]    ${currency.chf.code}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][name]    ${currency.chf.name}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][symbol]    ${currency.chf.symbol}
    And Response should contain the array of a certain size:    [data][0][attributes][prices][0][volumePrices]   0
    And Response body has correct self link

Abstract_volume_prices
    When I send a GET request:    /abstract-products/${abstract_product.volume_prices.sku}/abstract-product-prices?currency=EUR&priceMode=GROSS_MODE
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][id]    ${abstract_product.volume_prices.sku}
    And Response body parameter should be greater than:    [data][0][attributes][price]   100
    And Save value to a variable:    [data][0][attributes][price]    default.price
    And Response should contain the array of a certain size:    [data][0][attributes][prices]    1
    And Response body parameter should be:    [data][0][attributes][prices][0][priceTypeName]    DEFAULT
    And Response body parameter should be:    [data][0][attributes][prices][0][netAmount]    None
    And Response body parameter should be:    [data][0][attributes][prices][0][grossAmount]    ${default.price}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][code]    ${currency.eur.code}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][name]    ${currency.eur.name}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][symbol]    ${currency.eur.symbol}
    And Response should contain the array of a certain size:    [data][0][attributes][prices][0][volumePrices]   3
    And Each array element of array in response should contain property:    [data][0][attributes][prices][0][volumePrices]    grossAmount
    And Each array element of array in response should contain property:    [data][0][attributes][prices][0][volumePrices]    netAmount
    And Each array element of array in response should contain property:    [data][0][attributes][prices][0][volumePrices]    quantity
    And Response body parameter should be greater than:    [data][0][attributes][prices][0][volumePrices][0][grossAmount]    1
    And Response body parameter should be greater than:    [data][0][attributes][prices][0][volumePrices][0][netAmount]    1
    And Response body parameter should be greater than:    [data][0][attributes][prices][0][volumePrices][0][quantity]    1
    And Response body has correct self link

Abstract_prices_original_price
    When I send a GET request:    /abstract-products/${abstract_product.original_prices.sku}/abstract-product-prices?currency=EUR&priceMode=GROSS_MODE
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][id]    ${abstract_product.original_prices.sku}
    And Response body parameter should be greater than:    [data][0][attributes][price]   100
    And Save value to a variable:    [data][0][attributes][price]    default.price
    And Response should contain the array of a certain size:    [data][0][attributes][prices]    2
    And Response body parameter should be:    [data][0][attributes][prices][0][priceTypeName]    DEFAULT
    And Response body parameter should be:    [data][0][attributes][prices][0][grossAmount]    ${default.price}
    And Response body parameter should be:    [data][0][attributes][prices][1][priceTypeName]    ORIGINAL
    And Response body parameter should be greater than:    [data][0][attributes][prices][1][grossAmount]   ${default.price}
    And Each array element of array in response should contain property with value:    [data][0][attributes][prices]    netAmount    ${None}
    And Each array element of array in response should contain value:    [data][0][attributes][prices]    ${currency.eur.code}
    And Each array element of array in response should contain value:    [data][0][attributes][prices]    ${currency.eur.name}
    And Each array element of array in response should contain value:    [data][0][attributes][prices]    ${currency.eur.symbol}
    And Each array element of array in response should contain property with value:    [data][0][attributes][prices]    volumePrices    ${array}
    And Response body has correct self link
