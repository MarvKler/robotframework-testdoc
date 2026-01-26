*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product

*** Test Cases ***
Request_product_concrete_by_id
    When I send a GET request:    /concrete-products/${product_with_alternative.concrete_sku}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]   concrete-products
    And Response body parameter should be:    [data][id]    ${product_with_alternative.concrete_sku}
    And Response body parameter should be:    [data][attributes][sku]    ${product_with_alternative.concrete_sku}
    And Response body parameter should be:    [data][attributes][name]    ${product_with_alternative.concrete_name}
    And Response should contain the array of a certain size:    [data][attributes][attributeNames]    6
    And Response should contain the array of a certain size:    [data][attributes][attributes]    6
    And Response body parameter should not be EMPTY:    [data][attributes][description]
    And Response body parameter should not be EMPTY:    [data][attributes][productAbstractSku]
    And Response body parameter should not be EMPTY:    [data][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][attributes][metaDescription]
    And Response body parameter should be:    [data][attributes][averageRating]    None
    And Response body parameter should be:    [data][attributes][reviewCount]    0
    And Response body has correct self link internal

Request_product_concrete_with_included_image_sets
    When I send a GET request:    /concrete-products/${concrete_product.one_image_set.sku}?include=concrete-product-image-sets
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]   concrete-products
    And Response body parameter should be:    [data][id]    ${concrete_product.one_image_set.sku}
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_product.one_image_set.sku}
    And Response body parameter should be:    [data][attributes][name]    ${concrete_product.one_image_set.name}
    And Response should contain the array of a certain size:    [data][attributes][attributeNames]    6
    And Response should contain the array of a certain size:    [data][attributes][attributes]    6
    And Response should contain the array of a certain size:    [data][relationships]   1
    And Response include should contain certain entity type:    concrete-product-image-sets
    And Response include element has self link:   concrete-product-image-sets

Request_product_concrete_with_included_abstract_product 
    When I send a GET request:    /concrete-products/${product_with_alternative.concrete_sku}?include=abstract-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]   concrete-products
    And Response body parameter should be:    [data][id]    ${product_with_alternative.concrete_sku}
    And Response body parameter should be:    [data][attributes][sku]    ${product_with_alternative.concrete_sku}
    And Response body parameter should be:    [data][attributes][name]    ${product_with_alternative.concrete_name}
    And Response should contain the array of a certain size:    [data][attributes][attributeNames]    6
    And Response should contain the array of a certain size:    [data][attributes][attributes]    6
    And Response should contain the array of a certain size:    [data][relationships]   1
    And Response include should contain certain entity type:    abstract-products
    And Response include element has self link:   abstract-products

Request_product_concrete_with_included_availabilities_and_product_prices
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}     Authorization=${token}  
    When I send a GET request:    /concrete-products/${concrete_product.original_prices.sku}?include=concrete-product-availabilities,concrete-product-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]   concrete-products
    And Response body parameter should be:    [data][id]    ${concrete_product.original_prices.sku}
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_product.original_prices.sku}
    And Response body parameter should be:    [data][attributes][name]    ${concrete_product.original_prices.name}
    And Response should contain the array of a certain size:    [data][attributes][attributeNames]    7
    And Response should contain the array of a certain size:    [data][attributes][attributes]    7
    And Response should contain the array of a certain size:    [data][relationships]   2
    And Response include should contain certain entity type:    concrete-product-availabilities
    And Response include should contain certain entity type:    concrete-product-prices
    And Response include element has self link:   concrete-product-prices
    And Response include element has self link:   concrete-product-availabilities

Request_product_concrete_with_included_sales_unit_and_product_measurement_units
    When I send a GET request:    /concrete-products/${concrete_product.product_with_sales_and_measurement_units.sku}?include=sales-units,product-measurement-units
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]   concrete-products
    And Response body parameter should be:    [data][id]    ${concrete_product.product_with_sales_and_measurement_units.sku}
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_product.product_with_sales_and_measurement_units.sku}
    And Response body parameter should be:    [data][attributes][name]    ${concrete_product.product_with_sales_and_measurement_units.name}
    And Response should contain the array of a certain size:    [data][attributes][attributeNames]    1
    And Response should contain the array of a certain size:    [data][attributes][attributes]    1
    And Response body parameter should not be EMPTY:    [data][attributes][description]
    And Response body parameter should not be EMPTY:    [data][attributes][productAbstractSku]
    And Response body parameter should be:    [data][attributes][averageRating]    None
    And Response body parameter should be:    [data][attributes][reviewCount]    0
    And Response body has correct self link internal
    And Response should contain the array of a certain size:    [data][relationships]   2
    And Response should contain the array of a certain size:    [included]    2
    And Response include should contain certain entity type:    product-measurement-units
    And Response include should contain certain entity type:    sales-units
    And Response include element has self link:   product-measurement-units
    And Response include element has self link:   sales-units

Request_product_concrete_with_included_product_labels_and_product_options
    [Setup]    Trigger product labels update
    When I send a GET request:    /concrete-products/${concrete_product.original_prices.sku}?include=product-labels,product-options
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]   concrete-products
    And Response body parameter should be:    [data][id]    ${concrete_product.original_prices.sku}
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_product.original_prices.sku}
    And Response body parameter should be:    [data][attributes][name]    ${concrete_product.original_prices.name}
    And Response should contain the array of a certain size:    [data][attributes][attributeNames]    7
    And Response should contain the array of a certain size:    [data][attributes][attributes]    7
    And Response should contain the array of a certain size:    [data][relationships]   2
    And Response include should contain certain entity type:    product-labels
    And Response include should contain certain entity type:    product-options
    And Response include element has self link:   product-labels
    And Response include element has self link:   product-options

Request_product_concrete_with_included_product_reviews
    When I send a GET request:    /concrete-products/${concrete_product.with_review.sku}?include=product-reviews
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]   concrete-products
    And Response body parameter should be:    [data][id]    ${concrete_product.with_review.sku}
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_product.with_review.sku}
    And Response body parameter should be:    [data][attributes][name]    ${concrete_product.with_review.name}
    And Response should contain the array of a certain size:    [data][attributes][attributeNames]    6
    And Response should contain the array of a certain size:    [data][attributes][attributes]    6
    And Response body parameter should not be EMPTY:    [data][attributes][description]
    And Response body parameter should not be EMPTY:    [data][attributes][productAbstractSku]
    And Response body parameter should not be EMPTY:    [data][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][attributes][metaDescription]
    And Response body parameter should not be EMPTY:   [data][attributes][averageRating]
    And Response should contain the array of a certain size:    [data][relationships]   1
    And Response include should contain certain entity type:    product-reviews
    And Response body has correct self link internal

Request_product_concrete_with_included_product_offers
    When I send a GET request:    /concrete-products/${concrete_product.product_with_concrete_offers.sku}?include=product-offers
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]   concrete-products
    And Response body parameter should be:    [data][id]    ${concrete_product.product_with_concrete_offers.sku}
    And Response body parameter should be:    [data][attributes][sku]    ${concrete_product.product_with_concrete_offers.sku}
    And Response body parameter should be:    [data][attributes][name]    ${concrete_product.product_with_concrete_offers.name}
    And Response should contain the array of a certain size:    [data][attributes][attributeNames]    7
    And Response should contain the array of a certain size:    [data][attributes][attributes]    7
    And Response body parameter should not be EMPTY:    [data][attributes][description]
    And Response body parameter should not be EMPTY:    [data][attributes][productAbstractSku]
    And Response body parameter should not be EMPTY:    [data][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][attributes][metaDescription]
    And Response body parameter should be:    [data][attributes][averageRating]    None
    And Response body parameter should be:    [data][attributes][reviewCount]    0
    And Response body has correct self link internal
    And Response should contain the array of a certain size:    [data][relationships]   1
    And Response should contain the array of a certain size:    [data][relationships][product-offers][data]    1
    And Response should contain the array of a certain size:    [included]    1
    And Response include should contain certain entity type:    product-offers
    And Response include element has self link:   product-offers

Request_product_concrete_with_included_bundled_products
    When I send a GET request:    /concrete-products/${bundle_product.concrete.product_4_sku}?include=bundled-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]   concrete-products
    And Response body parameter should be:    [data][id]    ${bundle_product.concrete.product_4_sku}
    And Response body parameter should be:    [data][attributes][sku]    ${bundle_product.concrete.product_4_sku}
    And Response body parameter should be:    [data][attributes][name]    ${bundle_product.bundle_product_product_name}
    And Response should contain the array of a certain size:    [data][attributes][attributeNames]    2
    And Response should contain the array of a certain size:    [data][attributes][attributes]    2
    And Response body parameter should not be EMPTY:    [data][attributes][description]
    And Response body parameter should be:    [data][attributes][productAbstractSku]    ${bundle_product.abstract.sku}
    And Response body parameter should not be EMPTY:    [data][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][attributes][metaDescription]
    And Response body parameter should be:    [data][attributes][averageRating]    None
    And Response body parameter should be:    [data][attributes][reviewCount]    0
    And Response body has correct self link internal 
    And Response should contain the array of a certain size:    [data][relationships]   1
    And Response should contain the array of a certain size:    [data][relationships][bundled-products][data]    3
    And Response body parameter should be in:    [data][relationships][bundled-products][data][0][id]    ${bundle_product.concrete.product_3_sku}    ${bundle_product.concrete.product_2_sku}    ${bundle_product.concrete.product_1_sku}
    And Response body parameter should be in:    [data][relationships][bundled-products][data][1][id]    ${bundle_product.concrete.product_3_sku}    ${bundle_product.concrete.product_2_sku}    ${bundle_product.concrete.product_1_sku}
    And Response body parameter should be in:    [data][relationships][bundled-products][data][2][id]    ${bundle_product.concrete.product_3_sku}    ${bundle_product.concrete.product_2_sku}    ${bundle_product.concrete.product_1_sku}
    And Response should contain the array of a certain size:    [included]    6
    And Response include should contain certain entity type:    bundled-products
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:   bundled-products
    And Response include element has self link:   concrete-products

Request_product_concrete_with_included_bundled_products_concrete_products_and_abstract_products
    When I send a GET request:    /concrete-products/${bundle_product.concrete.product_4_sku}?include=bundled-products,concrete-products,abstract-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]   concrete-products
    And Response body parameter should be:    [data][id]    ${bundle_product.concrete.product_4_sku}
    And Response body parameter should be:    [data][attributes][sku]    ${bundle_product.concrete.product_4_sku}
    And Response body parameter should be:    [data][attributes][name]    ${bundle_product.bundle_product_product_name}
    And Response should contain the array of a certain size:    [data][attributes][attributeNames]    2
    And Response should contain the array of a certain size:    [data][attributes][attributes]    2
    And Response body parameter should not be EMPTY:    [data][attributes][description]
    And Response body parameter should be:    [data][attributes][productAbstractSku]    ${bundle_product.abstract.sku}
    And Response body parameter should not be EMPTY:    [data][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][attributes][metaDescription]
    And Response body parameter should be:    [data][attributes][averageRating]    None
    And Response body parameter should be:    [data][attributes][reviewCount]    0
    And Response body has correct self link internal 
    And Response should contain the array of a certain size:    [data][relationships]   2
    And Response should contain the array of a certain size:    [data][relationships][abstract-products][data]    1
    And Response body parameter should be:    [data][relationships][abstract-products][data][0][id]    ${bundle_product.abstract.sku}
    And Response should contain the array of a certain size:    [data][relationships][bundled-products][data]    3
    And Response body parameter should be in:    [data][relationships][bundled-products][data][0][id]    ${bundle_product.concrete.product_3_sku}    ${bundle_product.concrete.product_2_sku}    ${bundle_product.concrete.product_1_sku}
    And Response body parameter should be in:    [data][relationships][bundled-products][data][1][id]    ${bundle_product.concrete.product_3_sku}    ${bundle_product.concrete.product_2_sku}    ${bundle_product.concrete.product_1_sku}
    And Response body parameter should be in:    [data][relationships][bundled-products][data][2][id]    ${bundle_product.concrete.product_3_sku}    ${bundle_product.concrete.product_2_sku}    ${bundle_product.concrete.product_1_sku}
    And Response should contain the array of a certain size:    [included]    16
    And Response include should contain certain entity type:    abstract-products
    And Response include should contain certain entity type:    bundled-products
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:   abstract-products
    And Response include element has self link:   bundled-products
    And Response include element has self link:   concrete-products