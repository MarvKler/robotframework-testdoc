*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    product-relations

*** Test Cases ***    
Cart_contains_product_with_upselling_relation
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_with_relations.has_related_products.concrete_sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}/up-selling-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${product_related_product_with_upselling_relation.sku}
    And Response body parameter should be:    [data][0][attributes][sku]    ${product_related_product_with_upselling_relation.sku}
    And Response body parameter should be:    [data][0][attributes][merchantReference]    ${product_related_product_with_upselling_relation.merchant_reference}
    And Response body parameter should be:    [data][0][attributes][averageRating]    None
    And Response body parameter should be:    [data][0][attributes][reviewCount]    0
    And Response body parameter should be:    [data][0][attributes][name]    ${product_related_product_with_upselling_relation.name}
    And Response body parameter should be:    [data][0][attributes][description]    ${product_related_product_with_upselling_relation.description}
    And Response should contain the array of a certain size:    [data][0][attributes][superAttributesDefinition]    0
    And Response should contain the array of a certain size:    [data][0][attributes][superAttributes]    0
    And Response should contain the array larger than a certain size:    [data][0][attributes][attributeMap]    0
    And Response should contain the array of a certain size:    [data][0][attributes][attributeMap][super_attributes]   0
    And Response should contain the array larger than a certain size:    [data][0][attributes][attributeMap][product_concrete_ids]   0
    And Response should contain the array of a certain size:    [data][0][attributes][attributeMap][attribute_variants]   0
    And Response should contain the array of a certain size:    [data][0][attributes][attributeMap][attribute_variant_map]   0 
    And Response should contain the array of a certain size:    [data][0][attributes][metaTitle]    0  
    And Response body parameter should not be EMPTY:    [data][0][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [data][0][attributes][metaDescription]
    And Response body parameter should not be EMPTY:    [data][0][attributes][attributeNames]
    And Response body parameter should not be EMPTY:    [data][0][attributes][url]
    And Each array element of array in response should contain nested property with value:    [data]    type    abstract-products
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain nested property:    [data]    [attributes]    sku
    And Each array element of array in response should contain nested property:    [data]    [attributes]    merchantReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    averageRating
    And Each array element of array in response should contain nested property:    [data]    [attributes]    reviewCount
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    description
    And Each array element of array in response should contain nested property:    [data]    [attributes]    attributes
    And Each array element of array in response should contain nested property:    [data]    [attributes]    superAttributesDefinition
    And Each array element of array in response should contain nested property:    [data]    [attributes]    superAttributes
    And Each array element of array in response should contain nested property:    [data]    [attributes]    attributeMap
    And Each array element of array in response should contain nested property:    [data]    [attributes][attributeMap]    super_attributes
    And Each array element of array in response should contain nested property:    [data]    [attributes][attributeMap]    product_concrete_ids
    And Each array element of array in response should contain nested property:    [data]    [attributes][attributeMap]    attribute_variants
    And Each array element of array in response should contain nested property:    [data]    [attributes][attributeMap]    attribute_variant_map
    And Each array element of array in response should contain nested property:    [data]    [attributes]    metaTitle
    And Each array element of array in response should contain nested property:    [data]    [attributes]    metaKeywords
    And Each array element of array in response should contain nested property:    [data]    [attributes]    metaDescription
    And Each array element of array in response should contain nested property:    [data]    [attributes]    attributeNames
    And Each array element of array in response should contain nested property:    [data]    [attributes]    url
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Cart_contains_product_with_upselling_relation_with_include_abstract_product_prices
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_with_relations.has_related_products.concrete_sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}/up-selling-products?include=abstract-product-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property:    [data]    relationships
    And Each array element of array in response should contain nested property:    [data]    [relationships][abstract-product-prices][data]    type
    And Each array element of array in response should contain nested property:    [data]    [relationships][abstract-product-prices][data]    id
    And Response body parameter should be:    [included][0][type]    abstract-product-prices
    And Response body parameter should be:    [included][0][id]    ${product_related_product_with_upselling_relation.sku}
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Response include should contain certain entity type:    abstract-product-prices
    And Each array element of array in response should contain property with value:    [included]    type    abstract-product-prices
    And Each array element of array in response should contain nested property:    [included]    attributes    price
    And Each array element of array in response should contain nested property:    [included]    attributes    prices
    And Each array element of array in response should contain nested property:    [included]    [attributes][prices]    priceTypeName
    And Response body parameter should be:    [included][0][attributes][prices][0][priceTypeName]    DEFAULT
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][grossAmount]    0
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    ${currency.eur.code}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    ${currency.eur.name}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    ${currency.eur.symbol}
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Cart_contains_product_with_upselling_relation_with_include_abstract_prodcut_image_sets
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_with_relations.has_related_products.concrete_sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}/up-selling-products?include=abstract-product-image-sets
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property:    [data]    relationships
    And Each array element of array in response should contain nested property:    [data]    [relationships][abstract-product-image-sets][data]    type
    And Each array element of array in response should contain nested property:    [data]    [relationships][abstract-product-image-sets][data]    id
    And Response body parameter should be:    [included][0][type]    abstract-product-image-sets
    And Response body parameter should be:    [included][0][id]    ${product_related_product_with_upselling_relation.sku}
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Each array element of array in response should contain property with value:    [included]    type    abstract-product-image-sets
    And Each array element of array in response should contain nested property:    [included]    attributes    imageSets
    And Each array element of array in response should contain nested property:    [included]    [attributes][imageSets]    name
    And Each array element of array in response should contain nested property:    [included]    [attributes][imageSets]    images
    And Each array element of array in response should contain nested property:    [included]    [attributes][imageSets][0][images]    externalUrlLarge
    And Each array element of array in response should contain nested property:    [included]    [attributes][imageSets][0][images]    externalUrlSmall
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Cart_contains_product_with_upselling_relation_with_include_concrete_products
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_with_relations.has_related_products.concrete_sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}/up-selling-products?include=concrete-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property:    [data]    relationships
    And Each array element of array in response should contain nested property:    [data]    [relationships][concrete-products][data]    type
    And Each array element of array in response should contain nested property:    [data]    [relationships][concrete-products][data]    id
    And Response body parameter should be:    [included][0][type]    concrete-products
    And Response body parameter should be:    [included][0][attributes][sku]    ${product_related_product_with_upselling_relation.concrete_available_product.sku}
    And Response body parameter should not be EMPTY:    [included][0][attributes][isDiscontinued]
    And Response body parameter should be:    [included][0][attributes][discontinuedNote]    None
    And Response body parameter should be:    [included][0][attributes][averageRating]    None
    And Response body parameter should have datatype:    [included][0][attributes][reviewCount]    int
    And Response body parameter should be:    [included][0][attributes][productAbstractSku]    ${product_related_product_with_upselling_relation.sku}
    And Response body parameter should be:    [included][0][attributes][name]    ${product_related_product_with_upselling_relation.concrete_available_product.name}
    And Response body parameter should be:    [included][0][attributes][description]    ${product_related_product_with_upselling_relation.concrete_available_product.description}
    And Response body parameter should be:    [included][0][attributes][metaTitle]    ${product_related_product_with_upselling_relation.concrete_available_product.meta_title}
    And Response body parameter should be:    [included][0][attributes][metaKeywords]    ${product_related_product_with_upselling_relation.concrete_available_product.meta_keywords}
    And Response body parameter should be:    [included][0][attributes][metaDescription]    ${product_related_product_with_upselling_relation.concrete_available_product.meta_description}
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [attributes]    sku
    And Each array element of array in response should contain nested property:    [included]    [attributes]    isDiscontinued
    And Each array element of array in response should contain nested property:    [included]    [attributes]    discontinuedNote
    And Each array element of array in response should contain nested property:    [included]    [attributes]    averageRating
    And Each array element of array in response should contain nested property:    [included]    [attributes]    reviewCount
    And Each array element of array in response should contain nested property:    [included]    [attributes]    productAbstractSku
    And Each array element of array in response should contain nested property:    [included]    [attributes]    name
    And Each array element of array in response should contain nested property:    [included]    [attributes]    description
    And Each array element of array in response should contain nested property:    [included]    [attributes]    attributes
    And Each array element of array in response should contain nested property:    [included]    [attributes]    superAttributesDefinition
    And Each array element of array in response should contain nested property:    [included]    [attributes]    metaTitle
    And Each array element of array in response should contain nested property:    [included]    [attributes]    metaKeywords
    And Each array element of array in response should contain nested property:    [included]    [attributes]    metaDescription
    And Each array element of array in response should contain nested property:    [included]    [attributes]    attributeNames
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Cart_contains_product_with_upselling_relation_with_include_abstract_product_availabilities
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_with_relations.has_related_products.concrete_sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}/up-selling-products?include=abstract-product-availabilities
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property:    [data]    relationships
    And Each array element of array in response should contain nested property:    [data]    [relationships][abstract-product-availabilities][data]    type
    And Each array element of array in response should contain nested property:    [data]    [relationships][abstract-product-availabilities][data]    id
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property with value:    [included]    [type]    abstract-product-availabilities
    And Each array element of array in response should contain nested property:    [included]    [attributes]    quantity
    And Each array element of array in response should contain nested property with value:    [included]    [attributes][availability]    True
    And Each array element of array in response should contain nested property:    [included]    [attributes]    availability
    And Each array element of array in response should contain nested property:    [included]    [attributes]    quantity
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Cart_contains_product_with_upselling_relation_with_include_product_labels
    [Setup]    Run Keywords    Trigger product labels update
    ...    AND    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_with_relations.has_related_products.concrete_sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}/up-selling-products?include=product-labels
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Response include should contain certain entity type:    product-labels
    And Each array element of array in response should contain nested property with value:    [included]    [type]    product-labels
    And Each array element of array in response should contain nested property:    [included]    [attributes]    name
    And Each array element of array in response should contain nested property:    [included]    [attributes]    isExclusive
    And Each array element of array in response should contain nested property:    [included]    [attributes]    position
    And Each array element of array in response should contain nested property:    [included]    [attributes]    frontEndReference
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Response body parameter should be:    [included][0][id]    ${label_new.id}
    And Response body parameter should be:    [included][0][attributes][name]    ${label_new.name}
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Cart_contains_product_with_upselling_relation_with_include_product_tax_sets
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_with_relations.has_related_products.concrete_sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}/up-selling-products?include=product-tax-sets
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Response include should contain certain entity type:   product-tax-sets
    And Each array element of array in response should contain nested property with value:    [included]    [type]    product-tax-sets
    And Each array element of array in response should contain nested property:    [included]    [attributes]    name
    And Each array element of array in response should contain nested property:    [included]    [attributes][restTaxRates]    name
    And Each array element of array in response should contain nested property:    [included]    [attributes][restTaxRates]    rate
    And Each array element of array in response should contain nested property:    [included]    [attributes][restTaxRates]    country
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Cart_contains_product_with_upselling_relation_with_include_product_options
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_with_relations.has_related_products.concrete_sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}/up-selling-products?include=product-options
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [included]    4
    And Each array element of array in response should contain nested property:    [data]    [relationships][product-options][data]    type
    And Each array element of array in response should contain nested property:    [data]    [relationships][product-options][data]    id
    And Response body parameter should be:    [data][0][relationships][product-options][data][0][id]    ${concrete_of_product_with_relations_upselling.product_options.OP_1.id}
    And Response body parameter should be:    [data][0][relationships][product-options][data][1][id]    ${concrete_of_product_with_relations_upselling.product_options.OP_2.id}
    And Response body parameter should be:    [data][0][relationships][product-options][data][2][id]    ${concrete_of_product_with_relations_upselling.product_options.OP_3.id}
    And Response body parameter should be:    [data][0][relationships][product-options][data][3][id]    ${concrete_of_product_with_relations_upselling.product_options.OP_insurance.id}
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Response include should contain certain entity type:    product-options
    And Each array element of array in response should contain nested property:    [included]    attributes    optionGroupName
    And Each array element of array in response should contain nested property:    [included]    attributes    sku
    And Each array element of array in response should contain nested property:    [included]    attributes    optionName
    And Each array element of array in response should contain nested property:    [included]    attributes    price
    And Each array element of array in response should contain nested property:    [included]    attributes    currencyIsoCode
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Response body parameter should be:    [included][0][id]    ${concrete_of_product_with_relations_upselling.product_options.OP_1.id}
    And Response body parameter should be:    [included][0][attributes][optionGroupName]    ${concrete_of_product_with_relations_upselling.product_options.OP_1.option_group_name}
    And Response body parameter should be:    [included][0][attributes][sku]    ${concrete_of_product_with_relations_upselling.product_options.OP_1.sku}
    And Response body parameter should be:    [included][0][attributes][optionName]    ${concrete_of_product_with_relations_upselling.product_options.OP_1.option_name}
    And Each array element of array in response should contain property with value in:    [included]    [attributes][currencyIsoCode]    ${currency.eur.code}    ${currency.dollar.code}
    And Response body parameter should be:    [included][1][id]    ${concrete_of_product_with_relations_upselling.product_options.OP_2.id}
    And Response body parameter should be:    [included][1][attributes][optionGroupName]    ${concrete_of_product_with_relations_upselling.product_options.OP_2.option_group_name}
    And Response body parameter should be:    [included][1][attributes][sku]    ${concrete_of_product_with_relations_upselling.product_options.OP_2.sku}
    And Response body parameter should be:    [included][1][attributes][optionName]    ${concrete_of_product_with_relations_upselling.product_options.OP_2.option_name}
    And Each array element of array in response should contain property with value in:    [included]    [attributes][currencyIsoCode]    ${currency.eur.code}    ${currency.dollar.code}
    And Response body parameter should be:    [included][2][id]    ${concrete_of_product_with_relations_upselling.product_options.OP_3.id}
    And Response body parameter should be:    [included][2][attributes][optionGroupName]    ${concrete_of_product_with_relations_upselling.product_options.OP_3.option_group_name}
    And Response body parameter should be:    [included][2][attributes][sku]    ${concrete_of_product_with_relations_upselling.product_options.OP_3.sku}
    And Response body parameter should be:    [included][2][attributes][optionName]    ${concrete_of_product_with_relations_upselling.product_options.OP_3.option_name}
    And Each array element of array in response should contain property with value in:    [included]    [attributes][currencyIsoCode]    ${currency.eur.code}    ${currency.dollar.code}
    And Response body parameter should be:    [included][3][id]    ${concrete_of_product_with_relations_upselling.product_options.OP_insurance.id}
    And Response body parameter should be:    [included][3][attributes][optionGroupName]    ${concrete_of_product_with_relations_upselling.product_options.OP_insurance.option_group_name}
    And Response body parameter should be:    [included][3][attributes][sku]    ${concrete_of_product_with_relations_upselling.product_options.OP_insurance.sku}
    And Response body parameter should be:    [included][3][attributes][optionName]    ${concrete_of_product_with_relations_upselling.product_options.OP_insurance.option_name}
    And Each array element of array in response should contain property with value in:    [included]    [attributes][currencyIsoCode]    ${currency.eur.code}    ${currency.dollar.code}
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Cart_contains_product_with_upselling_relation_with_include_product_reviews
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_with_relations.has_related_products.concrete_sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}/up-selling-products?include=product-reviews
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [included]    9
    And Response body parameter should be in:    [data][3][relationships][product-reviews][data][0][id]    ${concrete_of_product_with_relations_upselling.product_reviews.review_1.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_2.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_3.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_4.id}  
    And Response body parameter should be in:    [data][4][relationships][product-reviews][data][0][id]    ${concrete_of_product_with_relations_upselling.product_reviews.review_5.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_6.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_7.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_8.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_9.id}
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Response include should contain certain entity type:    product-reviews
    And Each array element of array in response should contain nested property:    [included]    attributes    rating
    And Each array element of array in response should contain nested property:    [included]    attributes    nickname
    And Each array element of array in response should contain nested property:    [included]    attributes    summary
    And Each array element of array in response should contain nested property:    [included]    attributes    description
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Response body parameter should be in:    [included][0][id]    ${concrete_of_product_with_relations_upselling.product_reviews.review_1.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_2.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_3.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_4.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_5.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_6.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_7.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_8.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_9.id}      
    And Response body parameter should be in:    [included][0][attributes][rating]    ${concrete_of_product_with_relations_upselling.product_reviews.review_1.rating}    ${concrete_of_product_with_relations_upselling.product_reviews.review_2.rating}    ${concrete_of_product_with_relations_upselling.product_reviews.review_4.rating}    ${concrete_of_product_with_relations_upselling.product_reviews.review_6.rating}
    And Response body parameter should be in:    [included][0][attributes][nickname]    ${concrete_of_product_with_relations_upselling.product_reviews.review_1.nickname}    ${concrete_of_product_with_relations_upselling.product_reviews.review_2.nickname}    ${concrete_of_product_with_relations_upselling.product_reviews.review_3.nickname}    ${concrete_of_product_with_relations_upselling.product_reviews.review_4.nickname}    
    And Response body parameter should be in:    [included][0][attributes][summary]    ${concrete_of_product_with_relations_upselling.product_reviews.review_1.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_2.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_3.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_4.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_5.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_6.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_7.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_8.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_9.summary}    
    And Response body parameter should be in:    [included][0][attributes][description]    ${concrete_of_product_with_relations_upselling.product_reviews.review_1.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_2.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_3.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_4.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_5.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_6.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_7.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_8.description}${concrete_of_product_with_relations_upselling.product_reviews.review_9.description}
    And Response body parameter should be in:    [included][3][id]    ${concrete_of_product_with_relations_upselling.product_reviews.review_1.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_2.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_3.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_4.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_5.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_6.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_7.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_8.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_9.id}      
    And Response body parameter should be in:    [included][3][attributes][rating]    ${concrete_of_product_with_relations_upselling.product_reviews.review_1.rating}    ${concrete_of_product_with_relations_upselling.product_reviews.review_2.rating}    ${concrete_of_product_with_relations_upselling.product_reviews.review_4.rating}    ${concrete_of_product_with_relations_upselling.product_reviews.review_6.rating}
    And Response body parameter should be in:    [included][3][attributes][nickname]    ${concrete_of_product_with_relations_upselling.product_reviews.review_1.nickname}    ${concrete_of_product_with_relations_upselling.product_reviews.review_2.nickname}    ${concrete_of_product_with_relations_upselling.product_reviews.review_3.nickname}    ${concrete_of_product_with_relations_upselling.product_reviews.review_4.nickname}    
    And Response body parameter should be in:    [included][3][attributes][summary]    ${concrete_of_product_with_relations_upselling.product_reviews.review_1.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_2.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_3.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_4.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_5.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_6.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_7.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_8.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_9.summary}    
    And Response body parameter should be in:    [included][3][attributes][description]    ${concrete_of_product_with_relations_upselling.product_reviews.review_1.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_2.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_3.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_4.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_5.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_6.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_7.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_8.description}${concrete_of_product_with_relations_upselling.product_reviews.review_9.description}
    And Response body parameter should be in:    [included][8][id]    ${concrete_of_product_with_relations_upselling.product_reviews.review_1.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_2.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_3.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_4.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_5.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_6.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_7.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_8.id}    ${concrete_of_product_with_relations_upselling.product_reviews.review_9.id}      
    And Response body parameter should be in:    [included][8][attributes][rating]    ${concrete_of_product_with_relations_upselling.product_reviews.review_1.rating}    ${concrete_of_product_with_relations_upselling.product_reviews.review_2.rating}    ${concrete_of_product_with_relations_upselling.product_reviews.review_4.rating}    ${concrete_of_product_with_relations_upselling.product_reviews.review_6.rating}
    And Response body parameter should be in:    [included][8][attributes][nickname]    ${concrete_of_product_with_relations_upselling.product_reviews.review_1.nickname}    ${concrete_of_product_with_relations_upselling.product_reviews.review_2.nickname}    ${concrete_of_product_with_relations_upselling.product_reviews.review_3.nickname}    ${concrete_of_product_with_relations_upselling.product_reviews.review_4.nickname}    
    And Response body parameter should be in:    [included][8][attributes][summary]    ${concrete_of_product_with_relations_upselling.product_reviews.review_1.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_2.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_3.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_4.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_5.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_6.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_7.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_8.summary}    ${concrete_of_product_with_relations_upselling.product_reviews.review_9.summary}    
    And Response body parameter should be in:    [included][8][attributes][description]    ${concrete_of_product_with_relations_upselling.product_reviews.review_1.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_2.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_3.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_4.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_5.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_6.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_7.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_8.description}    ${concrete_of_product_with_relations_upselling.product_reviews.review_9.description}
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Cart_contains_product_with_upselling_relation_with_include_category_nodes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_with_relations.has_related_products.concrete_sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}/up-selling-products?include=category-nodes
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [included]    2
    And Response body parameter should be:    [data][0][relationships][category-nodes][data][0][id]    ${concrete_of_product_with_relations_upselling.category_nodes.category_node_25.id}
    And Response body parameter should be:    [data][0][relationships][category-nodes][data][1][id]    ${concrete_of_product_with_relations_upselling.category_nodes.category_node_23.id}
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Response include should contain certain entity type:    category-nodes
    And Each array element of array in response should contain nested property:    [included]    attributes    nodeId
    And Each array element of array in response should contain nested property:    [included]    attributes    name
    And Each array element of array in response should contain nested property:    [included]    attributes    metaTitle
    And Each array element of array in response should contain nested property:    [included]    attributes    metaKeywords
    And Each array element of array in response should contain nested property:    [included]    attributes    metaDescription
    And Each array element of array in response should contain nested property:    [included]    attributes    isActive
    And Each array element of array in response should contain nested property:    [included]    attributes    order
    And Each array element of array in response should contain nested property:    [included]    attributes    url
    And Each array element of array in response should contain nested property:    [included]    attributes    children
    And Each array element of array in response should contain nested property:    [included]    attributes    parents
    And Response body parameter should be:    [included][0][id]    ${concrete_of_product_with_relations_upselling.category_nodes.category_node_25.id}
    And Response body parameter should be:    [included][0][attributes][name]    ${concrete_of_product_with_relations_upselling.category_nodes.category_node_25.name}
    And Response body parameter should be:    [included][1][id]    ${concrete_of_product_with_relations_upselling.category_nodes.category_node_23.id}
    And Response body parameter should be:    [included][1][attributes][name]    ${concrete_of_product_with_relations_upselling.category_nodes.category_node_23.name}
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Cart_contains_multiple_products_with_upselling_relation
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_with_relations.has_related_products.concrete_sku}","quantity": 2}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_with_relations.has_upselling_products.concrete_sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_available_product_with_stock.concrete_available_product.sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}/up-selling-products
    Then Response status code should be:    200
    And Response reason should be:    OK
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
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Cart_contains_no_products_with_upselling_relations
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_available_product_with_stock.concrete_available_product.sku}","quantity": 1}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}/up-selling-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    0
    And Response body has correct self link
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Get_upselling_products_for_empty_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name":"Cart-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    When I send a GET request:    /carts/${cart_id}/up-selling-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    0
    And Response body has correct self link
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204