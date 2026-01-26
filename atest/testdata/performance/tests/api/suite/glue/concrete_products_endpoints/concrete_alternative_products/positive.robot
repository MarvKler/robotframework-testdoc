*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    discontinued-products    alternative-products

*** Test Cases ***
Get_concrete_alternative_product_for_a_product_that_has_none
    When I send a GET request:    /concrete-products/${bundle_product.concrete.product_1_sku}/concrete-alternative-products
    Then Response status code should be:    200
    And Response should contain the array of a certain size:    [data]    0
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body has correct self link
    And Response reason should be:    OK

Get_concrete_alternative_product
    When I send a GET request:    /concrete-products/${product_with_alternative.concrete_sku}/concrete-alternative-products
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    2
    And Response body parameter should be:    [data][0][type]    concrete-products
    And Response body should contain:    id
    And Response body parameter should not be EMPTY:    [data][0][attributes][sku]
    And Response body parameter should contain:    [data][0][attributes]    isDiscontinued
    And Response body parameter should contain:    [data][0][attributes]    discontinuedNote
    And Response body parameter should contain:    [data][0][attributes]    averageRating
    And Response body parameter should contain:    [data][0][attributes]    reviewCount
    And Response body parameter should not be EMPTY:    [data][0][attributes][productAbstractSku]
    And Response body parameter should not be EMPTY:    [data][0][attributes][name]
    And Response body parameter should not be EMPTY:    [data][0][attributes][description]
    And Response body parameter should contain:    [data][0][attributes]    attributes
    Response should contain the array of a certain size:    [data][0][attributes][superAttributesDefinition]    3
    And Response body parameter should not be EMPTY:    [data][0][attributes][metaTitle]
    And Response body parameter should not be EMPTY:    [data][0][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][0][attributes][metaDescription]
    And Response body parameter should contain:    [data][0][attributes]    attributeNames
    And Response should contain the array of a certain size:    [data][0][attributes][attributes]    6
    And Response should contain the array of a certain size:    [data][0][attributes][attributeNames]    6
    And Response body has correct self link

Get_concrete_alternative_product_with_include
    When I send a GET request:    /concrete-products/${product_with_alternative.concrete_sku}/concrete-alternative-products?include=concrete-product-image-sets,concrete-product-availabilities,concrete-product-prices
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    2
    And Response body parameter should be:    [data][0][type]    concrete-products
    And Response should contain the array of a certain size:    [data][0][relationships]   3
    And Response include should contain certain entity type:    concrete-product-image-sets
    And Response include should contain certain entity type:    concrete-product-availabilities
    And Response include should contain certain entity type:    concrete-product-prices 
    And Response include element has self link:   concrete-product-image-sets
    And Response include element has self link:   concrete-product-availabilities
    And Response include element has self link:   concrete-product-prices