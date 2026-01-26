*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    product    tax    product-labels    product-options    inventory-management


*** Test Cases ***
Abstract_product_with_one_concrete
    #Bug - CC-16551
    When I send a GET request:    /abstract-products/${abstract.available_products.with_stock.sku}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${abstract.available_products.with_stock.sku}
    And Response body parameter should be:    [data][attributes][sku]    ${abstract.available_products.with_stock.sku}
    And Response body parameter should be:    [data][attributes][averageRating]    None
    And Response body parameter should be:    [data][attributes][reviewCount]    0
    And Response body parameter should be:
    ...    [data][attributes][name]
    ...    ${abstract.available_products.with_stock.name}
    And Response body parameter should not be EMPTY:    [data][attributes][description]
    And Response body parameter should not be EMPTY:    [data][attributes][attributes]
    And Response should contain the array of a certain size:    [data][attributes][superAttributesDefinition]    0
    And Response should contain the array of a certain size:    [data][attributes][attributeMap]    4
    And Response should contain the array of a certain size:
    ...    [data][attributes][attributeMap][product_concrete_ids]
    ...    1
    And Response body parameter should contain:
    ...    [data][attributes][superAttributes]
    ...    ${abstract.available_products.with_stock.superattribute}
    And Response body parameter should not be EMPTY:    [data][attributes][metaTitle]
    And Response body parameter should not be EMPTY:    [data][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][attributes][metaDescription]
    And Response body parameter should not be EMPTY:    [data][attributes][attributeNames]
    And Response body parameter should not be EMPTY:    [data][attributes][url]
    And Response body has correct self link internal

Abstract_product_with_3_concrete3
    #Bug - CC-16551
    When I send a GET request:    /abstract-products/${abstract.available_products.with_3_concretes.sku}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${abstract.available_products.with_3_concretes.sku}
    And Response body parameter should be:
    ...    [data][attributes][sku]
    ...    ${abstract.available_products.with_3_concretes.sku}
    And Response body parameter should be:    [data][attributes][averageRating]    None
    And Response body parameter should be:    [data][attributes][reviewCount]    0
    And Response body parameter should be:
    ...    [data][attributes][name]
    ...    ${abstract.available_products.with_3_concretes.name}
    And Response body parameter should not be EMPTY:    [data][attributes][description]
    And Response body parameter should not be EMPTY:    [data][attributes][attributes]
    And Response should contain the array of a certain size:    [data][attributes][superAttributesDefinition]    0
    And Response should contain the array of a certain size:    [data][attributes][attributeMap]    4
    And Response should contain the array of a certain size:
    ...    [data][attributes][attributeMap][product_concrete_ids]
    ...    2
    And Response body parameter should contain:
    ...    [data][attributes][superAttributes]
    ...    ${abstract.available_products.with_3_concretes.superattribute}
    And Response body parameter should not be EMPTY:    [data][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][attributes][metaDescription]
    And Response body parameter should not be EMPTY:    [data][attributes][attributeNames]
    And Response body parameter should not be EMPTY:    [data][attributes][url]
    And Response body has correct self link internal

Abstract_product_with_abstract_includes_for_availability_images_taxes_categories_and_prices
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:
    ...    /abstract-products/${abstract.available_products.with_stock.sku}?include=abstract-product-availabilities,abstract-product-image-sets,product-tax-sets,category-nodes,abstract-product-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${abstract.available_products.with_stock.sku}
    And Response body parameter should be:    [data][attributes][sku]    ${abstract.available_products.with_stock.sku}
    And Response body parameter should be:
    ...    [data][attributes][name]
    ...    ${abstract.available_products.with_stock.name}
    And Response body has correct self link internal
    And Response should contain the array of a certain size:
    ...    [data][relationships][abstract-product-image-sets][data]
    ...    1
    And Response should contain the array of a certain size:
    ...    [data][relationships][abstract-product-availabilities][data]
    ...    1
    And Response should contain the array of a certain size:    [data][relationships][product-tax-sets][data]    1
    And Response should contain the array larger than a certain size:
    ...    [data][relationships][category-nodes][data]
    ...    1
    And Response should contain the array larger than a certain size:
    ...    [data][relationships][abstract-product-prices][data]
    ...    0
    And Response should contain the array larger than a certain size:    [included]    4
    And Response include should contain certain entity type:    category-nodes
    And Response include should contain certain entity type:    abstract-product-image-sets
    And Response include should contain certain entity type:    abstract-product-availabilities
    And Response include should contain certain entity type:    product-tax-sets
    And Response include should contain certain entity type:    abstract-product-prices
    And Response include element has self link:    category-nodes
    And Response include element has self link:    abstract-product-image-sets
    And Response include element has self link:    abstract-product-availabilities
    And Response include element has self link:    product-tax-sets
    And Response include element has self link:    abstract-product-prices

Abstract_product_with_abstract_includes_for_labels
    [Documentation]    https://spryker.atlassian.net/browse/CC-31988
    [Tags]    skip-due-to-refactoring
    [Setup]    Trigger product labels update
    When I send a GET request:    /abstract-products/${abstract.with_label.sku}?include=product-labels
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${abstract.with_label.sku}
    And Response body parameter should be:    [data][attributes][sku]    ${abstract.with_label.sku}
    And Response body parameter should be:    [data][attributes][name]    ${abstract.with_label.name}
    And Response body has correct self link internal
    And Response should contain the array larger than a certain size:
    ...    [data][relationships][product-labels][data]
    ...    0
    And Response should contain the array larger than a certain size:    [included]    0
    And Response include should contain certain entity type:    product-labels
    And Response include element has self link:    product-labels

# Bug CC-14879

Abstract_product_with_abstract_includes_for_reviews
    When I send a GET request:    /abstract-products/${abstract.with_review.sku}?include=product-reviews
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${abstract.with_review.sku}
    And Response body parameter should be:    [data][attributes][sku]    ${abstract.with_review.sku}
    And Response body parameter should be:    [data][attributes][name]    ${abstract.with_review.name}
    And Response body has correct self link internal
    And Response should contain the array larger than a certain size:
    ...    [data][relationships][product-reviews][data]
    ...    0
    And Response should contain the array larger than a certain size:    [included]    0
    And Response include should contain certain entity type:    product-reviews
    And Response include element has self link:    product-reviews

Abstract_product_with_abstract_includes_for_options
    When I send a GET request:    /abstract-products/${abstract.with_options.sku}?include=product-options
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${abstract.with_options.sku}
    And Response body parameter should be:    [data][attributes][sku]    ${abstract.with_options.sku}
    And Response body parameter should be:    [data][attributes][name]    ${abstract.with_options.name}
    And Response body has correct self link internal
    And Response should contain the array larger than a certain size:
    ...    [data][relationships][product-options][data]
    ...    0
    And Response should contain the array larger than a certain size:    [included]    1
    And Response include should contain certain entity type:    product-options
    And Response include element has self link:    product-options

Abstract_product_with_3_concrete_and_concrete_nested_includes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:
    ...    /abstract-products/${abstract.available_products.with_3_concretes.sku}?include=concrete-products,concrete-product-prices,concrete-product-image-sets,concrete-product-availabilities
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${abstract.available_products.with_3_concretes.sku}
    And Response body parameter should be:
    ...    [data][attributes][sku]
    ...    ${abstract.available_products.with_3_concretes.sku}
    And Response body parameter should be:
    ...    [data][attributes][name]
    ...    ${abstract.available_products.with_3_concretes.name}
    And Response body has correct self link internal
    And Response should contain the array of a certain size:    [data][relationships][concrete-products][data]    2
    And Response should contain the array larger than a certain size:    [included]    4
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    concrete-product-prices
    And Response include should contain certain entity type:    concrete-product-image-sets
    And Response include should contain certain entity type:    concrete-product-availabilities
    And Response include element has self link:    concrete-products
    And Response include element has self link:    concrete-product-prices
    And Response include element has self link:    concrete-product-image-sets
    And Response include element has self link:    concrete-product-availabilities

Abstract_product_in_different_locales_languages
    When I set Headers:    Accept-Language=de-DE
    And I send a GET request:    /abstract-products/${abstract.product_in_different_locales.sku}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should contain:    [data][attributes][description]    ${abstract.product_in_different_locales.description_de}
    When I set Headers:    Accept-Language=en-US
    And I send a GET request:    /abstract-products/${abstract.product_in_different_locales.sku}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should contain:    [data][attributes][description]    ${abstract.product_in_different_locales.description_en}