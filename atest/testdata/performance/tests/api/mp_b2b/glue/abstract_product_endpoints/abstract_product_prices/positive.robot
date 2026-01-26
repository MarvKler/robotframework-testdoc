*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    prices

*** Test Cases ***    
Get_abstract_prices_detault_only
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /abstract-products/${abstract_product.abstract_product_with_variants.concretes_3}/abstract-product-prices?currency=EUR&priceMode=GROSS_MODE
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${abstract_product.abstract_product_with_variants.concretes_3}
    And Response body parameter should be:    [data][0][type]    abstract-product-prices
    And Response body parameter should be greater than:    [data][0][attributes][price]   100
    And Save value to a variable:    [data][0][attributes][price]    default_price
    And Response should contain the array of a certain size:    [data][0][attributes][prices]    1
    And Response body parameter should be:    [data][0][attributes][prices][0][priceTypeName]    DEFAULT
    And Response body parameter should be:    [data][0][attributes][prices][0][netAmount]    None
    And Response body parameter should be:    [data][0][attributes][prices][0][grossAmount]    ${default_price}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][code]    ${currency.eur.code}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][name]    ${currency.eur.name}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][symbol]    ${currency.eur.symbol}
    And Response should contain the array of a certain size:    [data][0][attributes][prices][0][volumePrices]   0
    And Response body has correct self link


Get_abstract_prices_detault_only_CHF
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /abstract-products/${abstract_product.abstract_product_with_variants.concretes_3}/abstract-product-prices?currency=CHF&priceMode=GROSS_MODE
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${abstract_product.abstract_product_with_variants.concretes_3}
    And Response body parameter should be:    [data][0][type]    abstract-product-prices
    And Response body parameter should be greater than:    [data][0][attributes][price]   100
    And Save value to a variable:    [data][0][attributes][price]    default_price
    And Response should contain the array of a certain size:    [data][0][attributes][prices]    1
    And Response body parameter should be:    [data][0][attributes][prices][0][priceTypeName]    DEFAULT
    And Response body parameter should be:    [data][0][attributes][prices][0][netAmount]    None
    And Response body parameter should be:    [data][0][attributes][prices][0][grossAmount]    ${default_price}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][code]    ${currency.chf.code}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][name]    ${currency.chf.name}
    And Response body parameter should be:    [data][0][attributes][prices][0][currency][symbol]    ${currency.chf.symbol}
    And Response should contain the array of a certain size:    [data][0][attributes][prices][0][volumePrices]   0
    And Response body has correct self link

Get_abstract_product_with_include_abstract_product_prices_only_default
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /abstract-products/${abstract_product.abstract_product_with_variants.concretes_3}?include=abstract-product-prices&currency=EUR&priceMode=GROSS_MODE
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][relationships][abstract-product-prices][data][0][id]    ${abstract_product.abstract_product_with_variants.concretes_3}
    And Response body parameter should be:    [data][relationships][abstract-product-prices][data][0][type]    abstract-product-prices
    And Each array element of array in response should contain property:    [data][relationships][abstract-product-prices][data]    type
    And Each array element of array in response should contain property:    [data][relationships][abstract-product-prices][data]    id
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Response include should contain certain entity type:    abstract-product-prices
    And Each array element of array in response should contain property with value:    [included]    type    abstract-product-prices
    And Response body parameter should be:    [included][0][id]    ${abstract_product.abstract_product_with_variants.concretes_3}
    And Each array element of array in response should contain nested property:    [included]    attributes    price
    And Each array element of array in response should contain nested property:    [included]    attributes    prices
    And Each array element of array in response should contain nested property:    [included]    [attributes][prices]    priceTypeName
    And Response body parameter should be:    [included][0][attributes][prices][0][priceTypeName]    DEFAULT
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][grossAmount]    0
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    ${currency.eur.code}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    ${currency.eur.name}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    ${currency.eur.symbol}
    
Get_abstract_product_volume_prices
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /abstract-products/${abstract_product.product_with_volume_prices.abstract_sku}/abstract-product-prices?currency=EUR&priceMode=GROSS_MODE
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${abstract_product.product_with_volume_prices.abstract_sku}
    And Response body parameter should be greater than:    [data][0][attributes][price]   100
    And Save value to a variable:    [data][0][attributes][price]    default_price
    And Response should contain the array of a certain size:    [data][0][attributes][prices]    1
    And Response body parameter should be:    [data][0][attributes][prices][0][priceTypeName]    DEFAULT
    And Response body parameter should be:    [data][0][attributes][prices][0][netAmount]    None
    And Response body parameter should be:    [data][0][attributes][prices][0][grossAmount]    ${default_price}
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

Get_abstract_product_with_include_abstract_product_prices_with_volume_prices
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}  
    When I send a GET request:    /abstract-products/${abstract_product.product_with_volume_prices.abstract_sku}?include=abstract-product-prices&currency=EUR&priceMode=GROSS_MODE
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    abstract-products
    And Response body parameter should be:    [data][id]    ${abstract_product.product_with_volume_prices.abstract_sku}
    And Response should contain the array larger than a certain size:    [included]    0
    And Response should contain the array larger than a certain size:    [data][relationships]    0
    And Response body parameter should be:    [data][relationships][abstract-product-prices][data][0][id]    ${abstract_product.product_with_volume_prices.abstract_sku}
    And Response body parameter should be:    [data][relationships][abstract-product-prices][data][0][type]    abstract-product-prices
    And Each array element of array in response should contain property:    [data][relationships][abstract-product-prices][data]    type
    And Each array element of array in response should contain property:    [data][relationships][abstract-product-prices][data]    id
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Each array element of array in response should contain property with value:    [included]    type    abstract-product-prices
    And Each array element of array in response should contain nested property:    [included]    attributes    price
    And Each array element of array in response should contain nested property:    [included]    attributes    prices
    And Each array element of array in response should contain nested property:    [included]    [attributes][prices]    priceTypeName
    And Each array element of array in response should contain nested property:    [included]    [attributes][prices][0][volumePrices]    grossAmount
    And Each array element of array in response should contain nested property:    [included]    [attributes][prices][0][volumePrices]    netAmount
    And Each array element of array in response should contain nested property:    [included]    [attributes][prices][0][volumePrices]    quantity
    And Response body parameter should be:    [included][0][id]    ${abstract_product.product_with_volume_prices.abstract_sku}
    And Response body parameter should be:    [included][0][attributes][prices][0][priceTypeName]    DEFAULT
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][grossAmount]    0
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    ${currency.eur.code}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    ${currency.eur.name}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    ${currency.eur.symbol}

Get_abstract_product_with_original_price
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /abstract-products/${abstract_product.product_with_original_prices.abstract_sku}/abstract-product-prices?currency=EUR&priceMode=GROSS_MODE
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${abstract_product.product_with_original_prices.abstract_sku}
    And Response body parameter should be greater than:    [data][0][attributes][price]   100
    And Save value to a variable:    [data][0][attributes][price]    default_price
    And Response should contain the array of a certain size:    [data][0][attributes][prices]    2
    And Response body parameter should be:    [data][0][attributes][prices][0][priceTypeName]    DEFAULT
    And Response body parameter should be:    [data][0][attributes][prices][0][grossAmount]    ${default_price}
    And Response body parameter should be:    [data][0][attributes][prices][1][priceTypeName]    ORIGINAL
    And Response body parameter should be greater than:    [data][0][attributes][prices][1][grossAmount]   ${default_price}
    And Each array element of array in response should contain property with value:    [data][0][attributes][prices]    netAmount     ${NONE}
    And Each array element of array in response should contain value:    [data][0][attributes][prices]    ${currency.eur.code}
    And Each array element of array in response should contain value:    [data][0][attributes][prices]    ${currency.eur.name}
    And Each array element of array in response should contain value:    [data][0][attributes][prices]    ${currency.eur.symbol}
    ${list} =	Create List
    And Each array element of array in response should contain property with value:    [data][0][attributes][prices]    volumePrices    ${list}
    And Response body has correct self link

