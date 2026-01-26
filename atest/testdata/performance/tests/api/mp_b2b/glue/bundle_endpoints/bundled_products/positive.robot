*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product-bundles    product

*** Test Cases ***
Get_concrete_bundled_products_inside_concrete_bundle
    [Documentation]   no demo data - https://spryker.atlassian.net/browse/MP-6888; product bundles aren`t supported on b2b-mp for now
    [Tags]    skip-due-to-issue 
    When I send a GET request:    /concrete-products/${bundle_product.concrete.sku}/bundled-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    ${bundle_product.products_in_bundle.total_qty_of_products}
    And Each array element of array in response should contain property with value:    [data]    type    bundled-products
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    links
    And Response body parameter should be:    [data][0][attributes][sku]    ${bundle_product.concrete.product_1_sku}
    And Response body parameter should be:    [data][1][attributes][sku]    ${bundle_product.concrete.product_2_sku}
    And Response body parameter should be:    [data][2][attributes][sku]    ${bundle_product.concrete.product_3_sku}
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][quantity]    ${bundle_product.products_in_bundle.qty_of_each_product}
    And Response body has correct self link

Get_concrete_bundled_products_inside_concrete_bundle_with_included_concretes
    [Documentation]   no demo data - https://spryker.atlassian.net/browse/MP-6888; product bundles aren`t supported on b2b-mp for now
    [Tags]    skip-due-to-issue
    When I send a GET request:    /concrete-products/${bundle_product.concrete.sku}/bundled-products?include=concrete-products 
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    ${bundle_product.products_in_bundle.total_qty_of_products}
    And Each array element of array in response should contain property with value:    [data]    type    bundled-products
    And Response body has correct self link
    And Each array element of array in response should contain nested property with value:    [data]    [relationships][concrete-products][data][0][type]    concrete-products
    And Response should contain the array of a certain size:    [included]    ${bundle_product.products_in_bundle.total_qty_of_products}
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:   concrete-products

Get_concrete_bundle_product_with_bundled_products_include
    [Documentation]   no demo data - https://spryker.atlassian.net/browse/MP-6888; product bundles aren`t supported on b2b-mp for now
    [Tags]    skip-due-to-issue
    When I send a GET request:    /concrete-products/${bundle_product.concrete.sku}?include=bundled-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    concrete-products
    And Response body parameter should be:    [data][id]    ${bundle_product.concrete.sku}
    And Response body parameter should be:    [data][attributes][sku]    ${bundle_product.concrete.sku}
    And Response body parameter should be:    [data][attributes][productAbstractSku]    ${bundle_product.abstract.sku}
    And Response body parameter should be:    [data][attributes][name]    ${bundle_product.concrete.name}
    And Response body has correct self link internal
    And Response should contain the array of a certain size:    [data][relationships][bundled-products][data]    ${bundle_product.products_in_bundle.total_qty_of_products}
    And Each array element of array in response should contain property with value:    [data][relationships][bundled-products][data]    type    bundled-products
    And Response should contain the array larger than a certain size:    [included]    ${bundle_product.products_in_bundle.total_qty_of_products}
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    bundled-products
    And Response include element has self link:   concrete-products
    And Response include element has self link:   bundled-products

Get_abstract_bundle_product_with_bundled_products_include
    [Documentation]   no demo data - https://spryker.atlassian.net/browse/MP-6888; product bundles aren`t supported on b2b-mp for now
    [Tags]    skip-due-to-issue
    When I send a GET request:    /abstract-products/${bundle_product.abstract.sku}?include=bundled-products,concrete-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    abstract-products
    And Response body parameter should be:    [data][id]    ${bundle_product.abstract.sku}
    And Response body parameter should be:    [data][attributes][sku]    ${bundle_product.abstract.sku}
    And Response body parameter should be:    [data][attributes][name]    ${bundle_product.abstract.name}
    And Response body parameter should be:    [data][attributes][attributeMap][product_concrete_ids]    ${bundle_product.concrete.sku}
    And Response body has correct self link internal
    And Response should contain the array of a certain size:    [data][relationships][concrete-products][data]    1
    And Response body parameter should be:    [data][relationships][concrete-products][data][0][id]    ${bundle_product.concrete.sku}
    And Response should contain the array larger than a certain size:    [included]    ${bundle_product.products_in_bundle.total_qty_of_products}
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    bundled-products
    And Response include should contain certain entity type:    abstract-products
    And Response include element has self link:   concrete-products
    And Response include element has self link:   bundled-products
    And Response include element has self link:   abstract-products

Get_concrete_bundled_products_for_nonbundle_product
    When I send a GET request:    /concrete-products/${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}/bundled-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    0
    And Response body has correct self link