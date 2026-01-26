*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    configurable-bundle

*** Test Cases ***
Get_configurable_bundle_templates
    When I send a GET request:    /configurable-bundle-templates
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    2
    And Each array element of array in response should contain property with value:    [data]    type    configurable-bundle-templates
    And Each Array Element Of Array In Response Should Contain Property:    [data]    id
    And Each Array Element Of Array In Response Should Contain Property:    [data]    attributes
    And Each Array Element Of Array In Response Should Contain Property:    [data]    links
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link

Get_configurable_bundle_templates_with_uuid
    When I send a GET request:    /configurable-bundle-templates/${configurable_bundle_template_1_uuid}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]   configurable-bundle-templates
    And Response body parameter should not be EMPTY:     [data][id]
    And Response body parameter should not be EMPTY:     [data][attributes]
    And Response body parameter should be:    [data][attributes][name]    ${configurable_bundle_template_name_1}
    And Response body has correct self link internal

Get_configurable_bundle_templates_including_configurable_bundle_template_slots
    When I send a GET request:    /configurable-bundle-templates?include=configurable-bundle-template-slots
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    2
    And Each array element of array in response should contain property with value:    [data]    type    configurable-bundle-templates
    And Each Array Element Of Array In Response Should Contain Property:    [data]    id
    And Each Array Element Of Array In Response Should Contain Property:    [data]    attributes
    And Each Array Element Of Array In Response Should Contain Property:    [data]    links
    And Each array element of array in response should contain nested property:    [data]    relationships    configurable-bundle-template-slots
    And Each array element of array in response should contain property with value:    [included]    type    configurable-bundle-template-slots
    And Each Array Element Of Array In Response Should Contain Property:    [included]    id
    And Each Array Element Of Array In Response Should Contain Property:    [included]    links
    And Response body has correct self link

Get_configurable_bundle_templates_including_configurable_bundle_template_image_sets
    When I send a GET request:    /configurable-bundle-templates?include=configurable-bundle-template-image-sets
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    2
    And Each array element of array in response should contain property with value:    [data]    type    configurable-bundle-templates
    And Each Array Element Of Array In Response Should Contain Property:    [data]    id
    And Each Array Element Of Array In Response Should Contain Property:    [data]    attributes
    And Each Array Element Of Array In Response Should Contain Property:    [data]    links
    And Each array element of array in response should contain nested property:    [data]    relationships    configurable-bundle-template-image-sets
    And Each array element of array in response should contain nested property:    [included]    attributes    name
    And Each array element of array in response should contain nested property:    [included]    attributes    images
    And Each array element of array in response should contain nested property:    [included]    [attributes][images]    externalUrlLarge
    And Each array element of array in response should contain nested property:    [included]    [attributes][images]    externalUrlSmall
    And Each array element of array in response should contain property with value:    [included]    type    configurable-bundle-template-image-sets
    And Each Array Element Of Array In Response Should Contain Property:    [included]    id
    And Each Array Element Of Array In Response Should Contain Property:    [included]    links
    And Response body has correct self link

Get_configurable_bundle_templates_by_configurable_bundle_template_1_uuid
    When I send a GET request:    /configurable-bundle-templates/${configurable_bundle_template_1_uuid}?include=configurable-bundle-template-slots,configurable-bundle-template-image-sets
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    configurable-bundle-templates
    And Response body parameter should be:    [data][id]    ${configurable_bundle_template_1_uuid}
    And Response body parameter should be:    [data][attributes][name]    ${configurable_bundle_template_name_1}
    And Response should contain the array of a certain size:    [data][relationships][configurable-bundle-template-slots][data]    4
    And Each array element of array in response should contain property with value:    [data][relationships][configurable-bundle-template-slots][data]    type    configurable-bundle-template-slots
    And Each array element of array in response should contain property:    [data][relationships][configurable-bundle-template-slots][data]    id
    And Response should contain the array of a certain size:    [data][relationships][configurable-bundle-template-image-sets][data]    1
    And Each array element of array in response should contain property with value:    [data][relationships][configurable-bundle-template-image-sets][data]    type    configurable-bundle-template-image-sets
    And Each array element of array in response should contain property:    [data][relationships][configurable-bundle-template-slots][data]    id
    And Response body has correct self link internal
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain nested property:    [included]    attributes    name
    And Response include should contain certain entity type:    configurable-bundle-template-slots
    And Response include should contain certain entity type:    configurable-bundle-template-image-sets        
    And Each array element of array in response should contain property:    [included][4][attributes][images]    externalUrlLarge
    And Each array element of array in response should contain property:    [included][4][attributes][images]    externalUrlSmall

Get_configurable_bundle_templates_including_concrete_products_concrete_product_prices_concrete_product_image_sets
    When I send a GET request:    /configurable-bundle-templates/${configurable_bundle_template_1_uuid}?include=configurable-bundle-template-slots,concrete-products,concrete-product-prices,concrete-product-image-sets
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    configurable-bundle-templates
    And Response body parameter should be:    [data][id]    ${configurable_bundle_template_1_uuid}
    And Response body parameter should be:    [data][attributes][name]   ${configurable_bundle_template_name_1}
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response should contain the array larger than a certain size:    [data][relationships][configurable-bundle-template-slots][data]    3
    And Each array element of array in response should contain property with value:    [data][relationships][configurable-bundle-template-slots][data]    type    configurable-bundle-template-slots
    And Each array element of array in response should contain property:    [data][relationships][configurable-bundle-template-slots][data]    id
    And Response include should contain certain entity type:    configurable-bundle-template-slots
    And Response include should contain certain entity type:    concrete-product-image-sets
    And Response include should contain certain entity type:    concrete-product-prices
    And Response include should contain certain entity type:    concrete-products
    And Response include element has self link:   concrete-product-image-sets
    And Response include element has self link:   concrete-product-prices
    And Response include element has self link:   concrete-products
    And Response include element has self link:   configurable-bundle-template-slots