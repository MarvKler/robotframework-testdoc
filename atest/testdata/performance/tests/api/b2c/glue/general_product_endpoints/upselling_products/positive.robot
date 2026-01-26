*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    product-relations

*** Test Cases ***
#Logged in customer's cart

Get_upselling_products
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    Find or create customer cart
    ...    AND    Cleanup all items in the cart:    ${cart_id}
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_with_relations.has_upselling_products.concrete_sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}/up-selling-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array larger than a certain size:    [data]    0
    And Each array element of array in response should contain nested property with value:    [data]    type    abstract-products
    And Response body parameter should be:    [data][7][id]    ${product_related_product_with_upselling_relation.sku}
    And Response body parameter should not be EMPTY:    [data][7][attributes]
    And Response body parameter should be:    [data][7][attributes][sku]    ${product_related_product_with_upselling_relation.sku}
    And Response body parameter should be:    [data][7][attributes][averageRating]    None
    And Response body parameter should be:    [data][7][attributes][reviewCount]    0
    And Response body parameter should be:    [data][7][attributes][name]    ${product_related_product_with_upselling_relation.name}
    And Response body parameter should not be EMPTY:    [data][7][attributes][description]
    And Response body parameter should not be EMPTY:    [data][7][attributes][attributes]
    And Response should contain the array larger than a certain size:    [data][7][attributes][superAttributesDefinition]    0
    And Response should contain the array larger than a certain size:    [data][7][attributes][superAttributes]    0
    And Response should contain the array larger than a certain size:    [data][7][attributes][attributeMap]    0
    And Response should contain the array larger than a certain size:    [data][7][attributes][attributeMap][super_attributes]   0
    And Response should contain the array larger than a certain size:    [data][7][attributes][attributeMap][product_concrete_ids]   0
    And Response should contain the array of a certain size:    [data][7][attributes][attributeMap][attribute_variants]   0
    And Response should contain the array larger than a certain size:    [data][7][attributes][attributeMap][attribute_variant_map]   0 
    And Response should contain the array larger than a certain size:    [data][7][attributes][metaTitle]    0  
    And Response body parameter should not be EMPTY:    [data][7][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][7][attributes][metaDescription]
    And Response body parameter should not be EMPTY:    [data][7][attributes][attributeNames]
    And Response body parameter should not be EMPTY:    [data][7][attributes][url]     
    And Response body has correct self link
    [Teardown]    Run Keyword    Cleanup all items in the cart:    ${cart_id}


Get_upselling_products_plus_includes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    Find or create customer cart
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_with_relations.has_upselling_products.concrete_sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}/up-selling-products?include=abstract-product-prices,abstract-product-image-sets,concrete-products,abstract-product-availabilities,product-labels,product-tax-sets,product-options,product-reviews,category-nodes
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array larger than a certain size:    [data]    0
    And Each array element of array in response should contain nested property with value:    [data]    type    abstract-products  
    And Response body has correct self link 
    And Response should contain the array larger than a certain size:    [included]    0
    And Response should contain the array of a certain size:    [data][0][relationships][abstract-product-prices][data]    1
    And Response should contain the array of a certain size:    [data][0][relationships][abstract-product-image-sets][data]    1
    And Response should contain the array of a certain size:    [data][0][relationships][concrete-products][data]    1
    And Response should contain the array of a certain size:    [data][0][relationships][abstract-product-availabilities][data]    1
    And Response should contain the array of a certain size:    [data][0][relationships][product-tax-sets][data]    1
    And Response should contain the array larger than a certain size:    [data][0][relationships][product-options][data]    1
    And Response should contain the array larger than a certain size:    [data][0][relationships][category-nodes][data]    1 
    And Response include should contain certain entity type:    abstract-product-prices
    And Response include should contain certain entity type:    abstract-product-image-sets
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    abstract-product-availabilities
    And Response include should contain certain entity type:    product-labels
    And Response include should contain certain entity type:    product-tax-sets
    And Response include should contain certain entity type:    product-options
    And Response include should contain certain entity type:    product-reviews
    And Response include should contain certain entity type:    category-nodes
    And Response include element has self link:    abstract-product-prices
    And Response include element has self link:    abstract-product-image-sets
    And Response include element has self link:    concrete-products
    And Response include element has self link:    abstract-product-availabilities
    And Response include element has self link:    product-labels
    And Response include element has self link:    product-tax-sets
    And Response include element has self link:    product-options
    And Response include element has self link:    product-reviews
    And Response include element has self link:    category-nodes
    [Teardown]    Run Keyword    Cleanup all items in the cart:    ${cart_id}


Get_upselling_products_for_cart_containing_multiple_products
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    Find or create customer cart
    ...    AND    Cleanup all items in the cart:    ${cart_id}
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_with_relations.has_upselling_products.concrete_sku}","quantity": 2}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_of_alternative_product_with_relations_upselling.sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_of_product_without_relations.sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}/up-selling-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array larger than a certain size:    [data]    0
    And Each array element of array in response should contain nested property with value:    [data]    type    abstract-products   
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes   
    And Each array element of array in response should contain nested property:    [data]    [attributes]    sku
    And Each array element of array in response should contain property with value NOT in:    [data]    [attributes][sku]    None    null
    And Each array element of array in response should contain nested property:    [data]    [attributes]    averageRating
    And Each array element of array in response should contain nested property:    [data]    [attributes]    reviewCount
    And Each array element of array in response should contain property with value NOT in:    [data]    [attributes][name]    None    null
    And Each array element of array in response should contain nested property:    [data]    [attributes]    description
    And Each array element of array in response should contain nested property:    [data]    [attributes]    attributes
    And Each array element of array in response should contain property with value NOT in:   [data]    [attributes][attributes]    None    null
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
    And Each array element of array in response should contain property with value NOT in:   [data]    [attributes][attributeNames]    None    null
    And Each array element of array in response should contain nested property:    [data]    [attributes]   url
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link
    [Teardown]    Run Keyword    Cleanup all items in the cart:    ${cart_id}
 

Get_upselling_products_for_cart_without_upselling_relations
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    ...    AND    Cleanup all items in the cart:    ${cart_id}
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_of_product_without_relations.sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}/up-selling-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    0
    And Response body has correct self link
    [Teardown]    Run Keyword    Cleanup all items in the cart:    ${cart_id}


Get_upselling_products_for_empty_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    Find or create customer cart
    ...    AND    Cleanup all items in the cart:    ${cart_id}
    When I send a GET request:    /carts/${cart_id}/up-selling-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    0
    And Response body has correct self link
    [Teardown]    Run Keyword    Cleanup all items in the cart:    ${cart_id}


#Guest user cart

Get_upselling_products_for_guest_cart
    [Setup]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Create a guest cart:    ${random}    ${product_with_relations.has_upselling_products.concrete_sku}    1
    ...    AND    Response status code should be:    201
    When I send a GET request:    /guest-carts/${guest_cart_id}/up-selling-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array larger than a certain size:    [data]    0
    And Each array element of array in response should contain nested property with value:    [data]    type    abstract-products
    And Response body parameter should be:    [data][7][id]    ${product_related_product_with_upselling_relation.sku}
    And Response body parameter should not be EMPTY:    [data][7][attributes]
    And Response body parameter should be:    [data][7][attributes][sku]    ${product_related_product_with_upselling_relation.sku}
    And Response body parameter should be:    [data][7][attributes][averageRating]    None
    And Response body parameter should be:    [data][7][attributes][reviewCount]    0
    And Response body parameter should be:    [data][7][attributes][name]    ${product_related_product_with_upselling_relation.name}
    And Response body parameter should not be EMPTY:    [data][7][attributes][description]
    And Response body parameter should not be EMPTY:    [data][7][attributes][attributes]
    And Response should contain the array larger than a certain size:    [data][7][attributes][superAttributesDefinition]    0
    And Response should contain the array larger than a certain size:    [data][7][attributes][superAttributes]    0
    And Response should contain the array larger than a certain size:    [data][7][attributes][attributeMap]    0
    And Response should contain the array larger than a certain size:    [data][7][attributes][attributeMap][super_attributes]   0
    And Response should contain the array larger than a certain size:    [data][7][attributes][attributeMap][product_concrete_ids]   0
    And Response should contain the array of a certain size:    [data][7][attributes][attributeMap][attribute_variants]   0
    And Response should contain the array larger than a certain size:    [data][7][attributes][attributeMap][attribute_variant_map]   0 
    And Response should contain the array larger than a certain size:    [data][7][attributes][metaTitle]    0  
    And Response body parameter should not be EMPTY:    [data][7][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][7][attributes][metaDescription]
    And Response body parameter should not be EMPTY:    [data][7][attributes][attributeNames]
    And Response body parameter should not be EMPTY:    [data][7][attributes][url]     
    And Response body has correct self link
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}


Get_upselling_products_for_guest_cart_plus_includes
    [Setup]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Create a guest cart:    ${random}    ${product_with_relations.has_upselling_products.concrete_sku}    1
    ...    AND    Response status code should be:    201
    When I send a GET request:    /guest-carts/${guest_cart_id}/up-selling-products?include=abstract-product-prices,abstract-product-image-sets,concrete-products,abstract-product-availabilities,product-labels,product-tax-sets,product-options,product-reviews,category-nodes
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array larger than a certain size:    [data]    0
    And Each array element of array in response should contain nested property with value:    [data]    type    abstract-products  
    And Response body has correct self link 
    And Response should contain the array larger than a certain size:    [included]    0
    And Response should contain the array of a certain size:    [data][0][relationships][abstract-product-prices][data]    1
    And Response should contain the array of a certain size:    [data][0][relationships][abstract-product-image-sets][data]    1
    And Response should contain the array of a certain size:    [data][0][relationships][concrete-products][data]    1
    And Response should contain the array of a certain size:    [data][0][relationships][abstract-product-availabilities][data]    1
    And Response should contain the array of a certain size:    [data][0][relationships][product-tax-sets][data]    1
    And Response should contain the array larger than a certain size:    [data][0][relationships][product-options][data]    1
    And Response should contain the array larger than a certain size:    [data][0][relationships][category-nodes][data]    1 
    And Response include should contain certain entity type:    abstract-product-prices
    And Response include should contain certain entity type:    abstract-product-image-sets
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    abstract-product-availabilities
    And Response include should contain certain entity type:    product-labels
    And Response include should contain certain entity type:    product-tax-sets
    And Response include should contain certain entity type:    product-options
    And Response include should contain certain entity type:    product-reviews
    And Response include should contain certain entity type:    category-nodes
    And Response include element has self link:    abstract-product-prices
    And Response include element has self link:    abstract-product-image-sets
    And Response include element has self link:    concrete-products
    And Response include element has self link:    abstract-product-availabilities
    And Response include element has self link:    product-labels
    And Response include element has self link:    product-tax-sets
    And Response include element has self link:    product-options
    And Response include element has self link:    product-reviews
    And Response include element has self link:    category-nodes
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}


Get_upselling_products_for_guest_cart_containing_multiple_products
    [Setup]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Create a guest cart:    ${random}    ${product_with_relations.has_upselling_products.concrete_sku}    2
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /guest-carts/${guest_cart_id}/guest-cart-items    {"data": {"type": "guest-cart-items","attributes": {"sku": "${concrete_of_alternative_product_with_relations_upselling.sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /guest-carts/${guest_cart_id}/guest-cart-items    {"data": {"type": "guest-cart-items","attributes": {"sku": "${concrete_of_product_without_relations.sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /guest-carts/${guest_cart_id}/up-selling-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array larger than a certain size:    [data]    0
    And Each array element of array in response should contain nested property with value:    [data]    type    abstract-products   
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes   
    And Each array element of array in response should contain nested property:    [data]    [attributes]    sku
    And Each array element of array in response should contain property with value NOT in:    [data]    [attributes][sku]    None    null
    And Each array element of array in response should contain nested property:    [data]    [attributes]    averageRating
    And Each array element of array in response should contain nested property:    [data]    [attributes]    reviewCount
    And Each array element of array in response should contain property with value NOT in:    [data]    [attributes][name]    None    null
    And Each array element of array in response should contain nested property:    [data]    [attributes]    description
    And Each array element of array in response should contain nested property:    [data]    [attributes]    attributes
    And Each array element of array in response should contain property with value NOT in:   [data]    [attributes][attributes]    None    null
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
    And Each array element of array in response should contain property with value NOT in:   [data]    [attributes][attributeNames]    None    null
    And Each array element of array in response should contain nested property:    [data]    [attributes]   url
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}
 

Get_upselling_products_for_guest_cart_without_upselling_relations
    [Setup]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Create a guest cart:    ${random}    ${concrete_of_product_without_relations.sku}    1
    ...    AND    Response status code should be:    201
    When I send a GET request:    /guest-carts/${guest_cart_id}/up-selling-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    0
    And Response body has correct self link
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}