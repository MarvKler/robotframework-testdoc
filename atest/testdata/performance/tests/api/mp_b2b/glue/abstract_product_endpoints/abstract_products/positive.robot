*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    tax    product-labels    product-options    inventory-management    marketplace-inventory-management

*** Test Cases ***
Get_abstract_product_with_one_concrete
    When I send a GET request:    /abstract-products/${abstract_available_product_with_stock.sku}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    abstract-products
    And Response body parameter should be:    [data][id]    ${abstract_available_product_with_stock.sku}
    And Response body parameter should be:    [data][attributes][sku]    ${abstract_available_product_with_stock.sku}
    And Response body parameter should be:    [data][attributes][merchantReference]    ${abstract_available_product_with_stock.merchant_reference}
    And Response body parameter should have datatype:    [data][attributes][reviewCount]    int
    And Response body parameter should be:    [data][attributes][name]    ${abstract_available_product_with_stock.name}
    And Response body parameter should be:    [data][attributes][description]    ${abstract_available_product_with_stock.description}
    And Response body parameter should be:    [data][attributes][metaTitle]    ${abstract_available_product_with_stock.meta_title}
    And Response body parameter should be:    [data][attributes][metaKeywords]    ${abstract_available_product_with_stock.meta_keywords}
    And Response body parameter should be:    [data][attributes][metaDescription]    ${abstract_available_product_with_stock.meta_description}
    And Response body parameter should be:    [data][attributes][attributeMap][product_concrete_ids][0]    ${abstract_available_product_with_stock.concrete_available_product.sku}
    And Response body parameter should be:    [data][attributes][averageRating]    None
    And Response should contain the array of a certain size:    [data][attributes][superAttributesDefinition]    0
    And Response should contain the array of a certain size:    [data][attributes][attributeMap]    4
    And Response should contain the array of a certain size:    [data][attributes][attributeMap][product_concrete_ids]    1
    And Response body parameter should have datatype:    [data][attributes][attributeMap][attribute_variants]    list
    And Response body parameter should have datatype:    [data][attributes][attributeMap][attribute_variant_map]    dict
    And Response body parameter should contain:    [data][attributes][superAttributes]    ${abstract_available_product_with_stock.superattribute}
    And Response body parameter should not be EMPTY:    [data][attributes][attributeNames]
    And Response body parameter should not be EMPTY:    [data][attributes][url]
    And Response body parameter should not be EMPTY:    [data][attributes][attributes][norm]
    And Response body has correct self link internal

Get_abstract_product_with_category_nodes_included
    When I send a GET request:    /abstract-products/${abstract_available_product_with_stock.sku}?include=category-nodes
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    abstract-products
    And Response body parameter should be:    [data][id]    ${abstract_available_product_with_stock.sku}
    And Response should contain the array of a certain size:    [included]    3
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Each array element of array in response should contain property with value:    [data][relationships][category-nodes][data]    type    category-nodes
    And Each array element of array in response should contain property:    [data][relationships][category-nodes][data]    id
    And Response body parameter should be:    [data][relationships][category-nodes][data][0][id]    ${abstract_available_product_with_stock.category_nodes.category_node_14.id}
    And Response body parameter should be:    [data][relationships][category-nodes][data][1][id]    ${abstract_available_product_with_stock.category_nodes.category_node_12.id}
    And Response body parameter should be:    [data][relationships][category-nodes][data][2][id]    ${abstract_available_product_with_stock.category_nodes.category_node_11.id}
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Each array element of array in response should contain property with value:    [included]    type    category-nodes
    And Response body parameter should be:    [included][0][attributes][name]    ${abstract_available_product_with_stock.category_nodes.category_node_14.name}
    And Response body parameter should be:    [included][1][attributes][name]    ${abstract_available_product_with_stock.category_nodes.category_node_12.name}
    And Response body parameter should be:    [included][2][attributes][name]    ${abstract_available_product_with_stock.category_nodes.category_node_11.name}
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

# Verifications regarding abstract-products within included are removed as abstract-products should not be in the response body -> CC-12041
Get_abstract_product_with_concrete_products_included
    When I send a GET request:    /abstract-products/${abstract_available_product_with_stock.sku}?include=concrete-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    abstract-products
    And Response body parameter should be:    [data][id]    ${abstract_available_product_with_stock.sku}
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response should contain the array of a certain size:    [data][attributes][attributeMap]    4
    And Response should contain the array of a certain size:    [included][0][attributes]    15
    And Response should contain the array of a certain size:    [included][0][attributes][attributes]    8
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][concrete-products][data][0][type]
    And Response body parameter should not be EMPTY:    [data][relationships][concrete-products][data][0][id]
    And Response body parameter should not be EMPTY:    [data][relationships][concrete-products]
    And Response body parameter should be:    [data][attributes][merchantReference]    ${abstract_available_product_with_stock.merchant_reference}
    And Each Array Element Of Array In Response Should Contain Property:    [data][relationships][concrete-products][data]    type
    And Each Array Element Of Array In Response Should Contain Property:    [data][relationships][concrete-products][data]    id
    And Each Array Element Of Array In Response Should Contain Property:    [included]    type
    And Each Array Element Of Array In Response Should Contain Property:    [included]    id
    And Each Array Element Of Array In Response Should Contain Property:    [included]    attributes
    And Each Array Element Of Array In Response Should Contain Property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Response body parameter should be:    [included][0][type]    concrete-products
    And Response body parameter should be:    [included][0][id]    ${abstract_available_product_with_stock.concrete_available_product.sku}
    And Response body parameter should be:    [included][0][attributes][sku]    ${abstract_available_product_with_stock.concrete_available_product.sku}
    And Response body parameter should not be EMPTY:    [included][0][attributes][isDiscontinued]
    And Response body parameter should be:    [included][0][attributes][discontinuedNote]    None
    And Response body parameter should be:    [included][0][attributes][averageRating]    None
    And Response body parameter should have datatype:    [included][0][attributes][reviewCount]    int
    And Response body parameter should be:    [included][0][attributes][productAbstractSku]    ${abstract_available_product_with_stock.sku}
    And Response body parameter should be:    [included][0][attributes][name]    ${abstract_available_product_with_stock.concrete_available_product.name}
    And Response body parameter should be:    [included][0][attributes][description]    ${abstract_available_product_with_stock.concrete_available_product.description}
    And Response body parameter should be:    [included][0][attributes][metaTitle]    ${abstract_available_product_with_stock.concrete_available_product.meta_title}
    And Response body parameter should be:    [included][0][attributes][metaKeywords]    ${abstract_available_product_with_stock.concrete_available_product.meta_keywords}
    And Response body parameter should be:    [included][0][attributes][metaDescription]    ${abstract_available_product_with_stock.concrete_available_product.meta_description}
    And Response body parameter should contain:    [data][attributes][superAttributes]    ${abstract_available_product_with_stock.superattribute}
    And Response body parameter should not be EMPTY:    [included][0][attributes][attributes]
    And Response body parameter should not be EMPTY:    [included][0][attributes][superAttributesDefinition]
    And Response body parameter should not be EMPTY:    [included][0][attributes][attributeNames]

Get_abstract_product_with_product_options_included
    When I send a GET request:    /abstract-products/${abstract_available_product_with_stock.sku}?include=product-options
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    abstract-products
    And Response body parameter should be:    [data][id]    ${abstract_available_product_with_stock.sku}
    And Response should contain the array of a certain size:    [included]    4
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Each array element of array in response should contain property:    [data][relationships][product-options][data]    type
    And Each array element of array in response should contain property:    [data][relationships][product-options][data]    id
    And Response body parameter should be:    [data][relationships][product-options][data][0][id]    ${abstract_available_product_with_stock.product_options.OP_1.id}
    And Response body parameter should be:    [data][relationships][product-options][data][1][id]    ${abstract_available_product_with_stock.product_options.OP_2.id}
    And Response body parameter should be:    [data][relationships][product-options][data][2][id]    ${abstract_available_product_with_stock.product_options.OP_3.id}
    And Response body parameter should be:    [data][relationships][product-options][data][3][id]    ${abstract_available_product_with_stock.product_options.OP_insurance.id}
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
    And Response body parameter should be:    [included][0][id]    ${abstract_available_product_with_stock.product_options.OP_1.id}
    And Response body parameter should be:    [included][0][attributes][optionGroupName]    ${abstract_available_product_with_stock.product_options.OP_1.option_group_name}
    And Response body parameter should be:    [included][0][attributes][sku]    ${abstract_available_product_with_stock.product_options.OP_1.sku}
    And Response body parameter should be:    [included][0][attributes][optionName]    ${abstract_available_product_with_stock.product_options.OP_1.option_name}
    And Response body parameter should be:    [included][0][attributes][price]    None    
    And Each array element of array in response should contain property with value in:    [included]    [attributes][currencyIsoCode]    ${currency.eur.code}    ${currency.dollar.code}
    And Response body parameter should be:    [included][1][id]    ${abstract_available_product_with_stock.product_options.OP_2.id}
    And Response body parameter should be:    [included][1][attributes][optionGroupName]    ${abstract_available_product_with_stock.product_options.OP_2.option_group_name}
    And Response body parameter should be:    [included][1][attributes][sku]    ${abstract_available_product_with_stock.product_options.OP_2.sku}
    And Response body parameter should be:    [included][1][attributes][optionName]    ${abstract_available_product_with_stock.product_options.OP_2.option_name}
    And Each array element of array in response should contain property with value in:    [included]    [attributes][currencyIsoCode]    ${currency.eur.code}    ${currency.dollar.code}
    And Response body parameter should be:    [included][2][id]    ${abstract_available_product_with_stock.product_options.OP_3.id}
    And Response body parameter should be:    [included][2][attributes][optionGroupName]    ${abstract_available_product_with_stock.product_options.OP_3.option_group_name}
    And Response body parameter should be:    [included][2][attributes][sku]    ${abstract_available_product_with_stock.product_options.OP_3.sku}
    And Response body parameter should be:    [included][2][attributes][optionName]    ${abstract_available_product_with_stock.product_options.OP_3.option_name}
    And Each array element of array in response should contain property with value in:    [included]    [attributes][currencyIsoCode]    ${currency.eur.code}    ${currency.dollar.code}
    And Response body parameter should be:    [included][3][id]    ${abstract_available_product_with_stock.product_options.OP_insurance.id}
    And Response body parameter should be:    [included][3][attributes][optionGroupName]    ${abstract_available_product_with_stock.product_options.OP_insurance.option_group_name}
    And Response body parameter should be:    [included][3][attributes][sku]    ${abstract_available_product_with_stock.product_options.OP_insurance.sku}
    And Response body parameter should be:    [included][3][attributes][optionName]    ${abstract_available_product_with_stock.product_options.OP_insurance.option_name}
    And Each array element of array in response should contain property with value in:    [included]    [attributes][currencyIsoCode]    ${currency.eur.code}    ${currency.dollar.code}


Get_abstract_product_with_product_labels_included
    [Setup]    Trigger product labels update
    When I send a GET request:    /abstract-products/${abstract_product.abstract_product_with_label.sku}?include=product-labels
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    abstract-products
    And Response body parameter should be:    [data][id]    ${abstract_product.abstract_product_with_label.sku}
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][product-labels]
    And Response include should contain certain entity type:    product-labels
    And Each array element of array in response should contain property:    [data][relationships][product-labels][data]    type
    And Each array element of array in response should contain property:    [data][relationships][product-labels][data]    id
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Response body parameter should be:    [included][0][id]    ${label_new.id}
    And Response body parameter should be:    [included][0][type]    product-labels    
    And Response body parameter should be:    [included][0][attributes][name]    ${label_new.name}
    And Response body parameter should be:    [included][0][attributes][isExclusive]    False
    And Response body parameter should be:    [included][0][attributes][position]    2
    And Response body parameter should be:    [included][0][attributes][frontEndReference]    new
    
Get_abstract_product_with_merchants_included
    When I send a GET request:    /abstract-products/${abstract_available_product_with_stock.sku}?include=merchants
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    abstract-products
    And Response body parameter should be:    [data][id]    ${abstract_available_product_with_stock.sku}
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    merchants
    And Each array element of array in response should contain property:    [data][relationships][merchants][data]    type
    And Each array element of array in response should contain property:    [data][relationships][merchants][data]    id
    And Response body parameter should be:    [data][relationships][merchants][data][0][type]    merchants
    And Response body parameter should be:    [data][relationships][merchants][data][0][id]    ${merchants.merchant_spryker_id}
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Response body parameter should be:    [included][0][id]    ${merchants.merchant_spryker_id}
    And Response body parameter should be:    [included][0][type]    merchants
    And Response body parameter should be:    [included][0][attributes][merchantName]    ${merchants.merchant_spryker_name}
    And Response body parameter should be:    [included][0][attributes][merchantUrl]    ${merchants.merchant_spryker_url}
    And Response body parameter should be:    [included][0][attributes][contactPersonRole]    ${merchants.contact_spryker_person_role}
    And Response body parameter should be:    [included][0][attributes][contactPersonTitle]    ${merchants.contact_spryker_person_title}
    And Response body parameter should be:    [included][0][attributes][contactPersonFirstName]    ${merchants.contact_spryker_person_first_name}
    And Response body parameter should be:    [included][0][attributes][contactPersonLastName]    ${merchants.contact_spryker_person_last_name}
    And Response body parameter should be:    [included][0][attributes][contactPersonPhone]    ${merchants.contact_spryker_person_phone}
    And Response body parameter should be:    [included][0][attributes][publicEmail]    ${merchants.spryker_public_email}
    And Response body parameter should be:    [included][0][attributes][publicPhone]    ${merchants.spryker_public_phone}
    And Response body parameter should be:    [included][0][attributes][description]    ${merchants.description_spryker}

Abstract_product_in_different_locales_languages
    When I set Headers:    Accept-Language=de-DE
    And I send a GET request:    /abstract-products/${abstract_product.product_in_different_locales.sku}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should contain:    [data][attributes][description]    ${abstract_product.product_in_different_locales.description_de}
    When I set Headers:    Accept-Language=en-US
    And I send a GET request:    /abstract-products/${abstract_product.product_in_different_locales.sku}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should contain:    [data][attributes][description]    ${abstract_product.product_in_different_locales.description_en}