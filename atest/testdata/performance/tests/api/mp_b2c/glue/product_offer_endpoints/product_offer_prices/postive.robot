*** Settings ***
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        API_test_setup
Test Tags    glue    product    marketplace-product-offer    product-offer-shipment    marketplace-product-offer-prices    prices    marketplace-product    merchant    marketplace-merchant

*** Test Cases ***
Get_product_offer_without_volume_price
     I send a GET request:    /concrete-products/${concrete_of_alternative_product_with_relations_upselling.sku}/product-offers
    AND Save value to a variable:    [data][0][id]    offerId
    When I send a GET request:    /product-offers/${offerId}/product-offer-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property with value:    [data]    type    product-offer-prices
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain nested property:    [data]    [attributes]    price
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][price]    int
    And Response body parameter should be greater than:    [data][0][attributes][price]    0
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0]    priceTypeName
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0]    netAmount
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0]    grossAmount
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0]    currency
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][prices][0][currency][code]    ${currency.eur.code}    
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][prices][0][currency][name]    ${currency.eur.name}    
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][prices][0][currency][symbol]    ${currency.eur.symbol}    
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link


Get_product_offer_with_volume_price
    I send a GET request:    /concrete-products/${concrete_available_product.with_stock}/product-offers
    AND Save value to a variable:    [data][0][id]    offerId
    When I send a GET request:    /product-offers/${offerId}/product-offer-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property with value:    [data]    type    product-offer-prices
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain nested property:    [data]    [attributes]    price
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][price]    int
    And Response body parameter should be greater than:    [data][0][attributes][price]    0
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0]    priceTypeName
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0]    netAmount
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0]    grossAmount
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0]    currency
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][prices][0][currency][code]    ${currency.eur.code}    
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][prices][0][currency][name]    ${currency.eur.name}    
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][prices][0][currency][symbol]    ${currency.eur.symbol}    
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0][volumePrices][0]    grossAmount
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][prices][0][volumePrices][0][grossAmount]    int
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0][volumePrices][0]    netAmount
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][prices][0][volumePrices][0][netAmount]    int
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0][volumePrices][0]    quantity
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][prices][0][volumePrices][0][quantity]    int
    And Response body has correct self link


Get_default&original_prices_of_a_product_offer
    I send a GET request:    /concrete-products/${concrete_available_product.with_stock}/product-offers
    AND Save value to a variable:    [data][0][id]    offerId
    When I send a GET request:    /product-offers/${offerId}/product-offer-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property with value:    [data]    type    product-offer-prices
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain nested property:    [data]    [attributes]    price
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][price]    int
    And Response body parameter should be greater than:    [data][0][attributes][price]    0
    And Each array element of array in response should contain a nested array of a certain size:    [data]    [attributes][prices]    2
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0]    priceTypeName
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0]    netAmount
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0]    grossAmount
    And Each array element of array in response should contain nested property:    [data]    [attributes][prices][0]    currency
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][prices][0][priceTypeName]    DEFAULT
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][prices][1][priceTypeName]    ORIGINAL    
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][prices][0][currency][code]    ${currency.eur.code}    
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][prices][0][currency][name]    ${currency.eur.name}    
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][prices][0][currency][symbol]    ${currency.eur.symbol}    
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link