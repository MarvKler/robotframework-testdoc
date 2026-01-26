*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    product-relations

*** Test Cases ***
Product_has_related_products
    When I send a GET request:    /abstract-products/${product_with_relations.has_related_products.sku}/related-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array larger than a certain size:    [data]    0
    And Each array element of array in response should contain nested property with value:    [data]    type    abstract-products
    And Response body parameter should be:    [data][0][id]    ${product_related_product_with_related_relation.sku}
    And Response body parameter should not be EMPTY:    [data][0][attributes]
    And Response body parameter should be:    [data][0][attributes][sku]    ${product_related_product_with_related_relation.sku}
    And Response body parameter should be:    [data][0][attributes][averageRating]    None
    And Response body parameter should be:    [data][0][attributes][reviewCount]    0
    And Response body parameter should be:    [data][0][attributes][name]    ${product_related_product_with_related_relation.name}
    And Response body parameter should not be EMPTY:    [data][0][attributes][description]
    And Response body parameter should not be EMPTY:    [data][0][attributes][attributes]
    And Response should contain the array larger than a certain size:    [data][0][attributes][superAttributesDefinition]    0
    And Response should contain the array larger than a certain size:    [data][0][attributes][superAttributesDefinition]    0
    And Response should contain the array of a certain size:    [data][0][attributes][superAttributes]    1
    And Response should contain the array larger than a certain size:    [data][0][attributes][attributeMap]    0
    And Response should contain the array of a certain size:    [data][0][attributes][attributeMap][super_attributes]   1
    And Response should contain the array larger than a certain size:    [data][0][attributes][attributeMap][product_concrete_ids]   0
    And Response should contain the array of a certain size:    [data][0][attributes][attributeMap][attribute_variants]    0
    And Response should contain the array of a certain size:    [data][0][attributes][attributeMap][attribute_variant_map]    1
    And Response should contain the array larger than a certain size:    [data][0][attributes][metaTitle]    0  
    And Response body parameter should not be EMPTY:    [data][0][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][0][attributes][metaDescription]
    And Response body parameter should not be EMPTY:    [data][0][attributes][attributeNames]
    And Response body parameter should not be EMPTY:    [data][0][attributes][url]     
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes   
    And Each array element of array in response should contain nested property:    [data]    [attributes]    sku
    And Each array element of array in response should contain property with value NOT in:    [data]    [attributes][sku]    None    null
    And Each array element of array in response should contain nested property:    [data]    [attributes]    averageRating
    And Each array element of array in response should contain nested property:    [data]    [attributes]    reviewCount
    And Each array element of array in response should contain property with value NOT in:    [data]    [attributes][name]    None    null
    And Each array element of array in response should contain nested property:    [data]    [attributes]    description
    And Each array element of array in response should contain nested property:    [data]    [attributes]    attributes
    And Each array element of array in response should contain nested property:    [data]    [attributes][attributes]    brand
    And Each array element of array in response should contain nested property:    [data]    [attributes]    superAttributesDefinition
    And Each array element of array in response should contain nested property:    [data]    [attributes]   superAttributes
    And Each array element of array in response should contain nested property:    [data]    [attributes]   attributeMap
    And Each array element of array in response should contain nested property:    [data]    [attributes][attributeMap]    super_attributes
    And Each array element of array in response should contain nested property:    [data]    [attributes][attributeMap]    product_concrete_ids
    And Each array element of array in response should contain nested property:    [data]    [attributes][attributeMap]    attribute_variants
    And Each array element of array in response should contain nested property:    [data]    [attributes][attributeMap]    attribute_variant_map
    And Each array element of array in response should contain nested property:    [data]    [attributes]    metaTitle
    And Each array element of array in response should contain nested property:    [data]    [attributes]    metaKeywords
    And Each array element of array in response should contain nested property:    [data]    [attributes]   metaDescription
    And Each array element of array in response should contain nested property:    [data]    [attributes]   attributeNames
    And Each array element of array in response should contain nested property:    [data]    [attributes][attributeNames]    brand
    And Each array element of array in response should contain nested property:    [data]    [attributes]   url
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link

Product_has_related_products_with_includes
    [Setup]    Run Keywords    Trigger product labels update
    ...    AND    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /abstract-products/${product_with_relations.has_related_products.sku}/related-products?include=product-labels
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array larger than a certain size:    [data]    0
    And Each array element of array in response should contain nested property with value:    [data]    type    abstract-products  
    And Response body has correct self link 
    And Response should contain the array larger than a certain size:    [data][8][relationships][product-labels][data]    0
    And Response should contain the array larger than a certain size:    [included]    0
    And Response include should contain certain entity type:    product-labels
    And Response include element has self link:    product-labels

Product_has_no_related_products
    When I send a GET request:    /abstract-products/${abstract_available_product_with_stock.sku}/related-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array larger than a certain size:    [data]    0
    And Response body has correct self link