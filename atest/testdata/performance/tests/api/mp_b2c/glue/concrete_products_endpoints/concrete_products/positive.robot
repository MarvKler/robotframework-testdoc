*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    product
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
####GET####
Get_concrete_product_information_by_sku
    When I send a GET request:    /concrete-products/${concrete_product_with_alternative.sku}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]   concrete-products
    And Response body parameter should be:    [data][id]    ${concrete_product_with_alternative.sku}
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_product_with_alternative.sku}
    And Response body parameter should be:    [data][attributes][name]    ${concrete_product_with_alternative.name}
    And Response should contain the array of a certain size:    [data][attributes][attributeNames]    6
    And Response should contain the array of a certain size:    [data][attributes][attributes]    6
    And Response body parameter should not be EMPTY:    [data][attributes][description]
    And Response body parameter should not be EMPTY:    [data][attributes][productAbstractSku]
    And Response body parameter should not be EMPTY:    [data][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][attributes][metaDescription]
    And Response body parameter should be:    [data][attributes][averageRating]    None
    And Response body parameter should be:    [data][attributes][reviewCount]    0
    And Response body has correct self link internal

Get_concrete_product_with_included_image_sets
    When I send a GET request:    /concrete-products/${concrete_product.product_one_image_set.sku}?include=concrete-product-image-sets
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]   concrete-products
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_product.product_one_image_set.sku}
    And Response body parameter should be:    [data][attributes][name]    ${concrete_product.product_one_image_set.name}
    And Response should contain the array of a certain size:    [data][attributes][attributeNames]    6
    And Response should contain the array of a certain size:    [data][attributes][attributes]    6
    And Response should contain the array of a certain size:    [data][relationships]   1
    And Response include should contain certain entity type:    concrete-product-image-sets
    And Response include element has self link:   concrete-product-image-sets

Get_concrete_product_with_included_availabilities_and_product_prices
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}     Authorization=${token}  
    When I send a GET request:    /concrete-products/${concrete_product.product_with_original_prices.concrete_sku}?include=concrete-product-availabilities,concrete-product-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]   concrete-products
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_product.product_with_original_prices.concrete_sku}
    And Response body parameter should be:    [data][attributes][name]    ${concrete_product.product_with_original_prices.concrete_name}
    And Response should contain the array of a certain size:    [data][attributes][attributeNames]    7
    And Response should contain the array of a certain size:    [data][attributes][attributes]    7
    And Response should contain the array of a certain size:    [data][relationships]   2
    And Response include should contain certain entity type:    concrete-product-availabilities
    And Response include should contain certain entity type:    concrete-product-prices
    And Response include element has self link:   concrete-product-prices
    And Response include element has self link:   concrete-product-availabilities

Get_concrete_product_with_included_abstract_product 
    When I send a GET request:    /concrete-products/${concrete_product.product_multiple_image_set.sku}?include=abstract-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]   concrete-products
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_product.product_multiple_image_set.sku}
    And Response body parameter should be:    [data][attributes][name]    ${concrete_product.product_multiple_image_set.name}
    And Response should contain the array of a certain size:    [data][attributes][attributeNames]    6
    And Response should contain the array of a certain size:    [data][attributes][attributes]    6
    And Response should contain the array of a certain size:    [data][relationships]   1
    And Response include should contain certain entity type:    abstract-products
    And Response include element has self link:   abstract-products

Get_concrete_product_with_included_product_labels
    [Setup]    Trigger product labels update
    When I send a GET request:    /concrete-products/${concrete_product_with_alternative.sku}?include=product-labels
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]   concrete-products
    And Response body parameter should be:    [data][id]    ${concrete_product_with_alternative.sku}
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_product_with_alternative.sku}
    And Response body parameter should be:    [data][attributes][name]    ${concrete_product_with_alternative.name}
    And Response should contain the array of a certain size:    [data][attributes][attributeNames]    6
    And Response should contain the array of a certain size:    [data][attributes][attributes]    6
    And Response should contain the array of a certain size:    [data][relationships]   1
    And Response body parameter should not be EMPTY:    [data][attributes][description]
    And Response body parameter should not be EMPTY:    [data][attributes][productAbstractSku]
    And Response body parameter should not be EMPTY:    [data][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][attributes][metaDescription]
    And Response body parameter should be:    [data][attributes][averageRating]    None
    And Response body parameter should be:    [data][attributes][reviewCount]    0
    And Response include should contain certain entity type:    product-labels
    And Response include element has self link:   product-labels
