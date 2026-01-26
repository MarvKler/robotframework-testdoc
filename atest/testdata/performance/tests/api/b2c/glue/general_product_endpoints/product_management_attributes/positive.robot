*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product

*** Test Cases ***
Get_all_product_management_attributes
    When I send a GET request:    /product-management-attributes
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array larger than a certain size:    [data]    50
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body parameter should be:    [data][0][type]    product-management-attributes
    And Response body parameter should not be EMPTY:    [data][0][attributes][key]
    And Response body parameter should not be EMPTY:    [data][0][attributes][inputType]
    And Response body parameter should not be EMPTY:    [data][0][attributes][allowInput]
    And Response body parameter should be in:    [data][0][attributes][allowInput]    True    False
    And Response body parameter should be in:    [data][0][attributes][isSuper]    True    False
    And Response body parameter should not be EMPTY:    [data][0][attributes][localizedKeys]
    And Response body parameter should not be EMPTY:    [data][0][attributes][values]
    And Response body parameter should not be EMPTY:    [data][0][attributes][values][0][value]
    And Response body parameter should not be EMPTY:    [data][0][links][self]
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain property with value in:    [data]    [attributes][allowInput]    True    False
    And Each array element of array in response should contain property with value in:    [data]    [attributes][isSuper]    True    False
    And Each array element of nested array should contain property with value in:    [data]    [attributes][localizedKeys]   localeName    ${locale.DE.name}    ${locale.EN.name}
    And Each array element of array in response should contain nested property:    [data]    [attributes][localizedKeys]    translation
    And Each array element of nested array should contain property with value NOT in:    [data]    [attributes][localizedKeys]    translation    None
    And Each array element of array in response should contain nested property:    [data]    [attributes]    values
    And Each array element of array in response should contain nested property:    [data]    [attributes][values]    value
    And Each array element of array in response should contain nested property:    [data]    [attributes][values]    localizedValues
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link

Get_product_management_attribute_by_id_superattribute
    When I send a GET request:    /product-management-attributes/${product_management.superattribute_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${product_management.superattribute_id}
    And Response body parameter should be:    [data][type]    product-management-attributes
    And Response body parameter should be:    [data][attributes][key]    ${product_management.superattribute_id}
    And Response body parameter should be:    [data][attributes][inputType]    text
    And Response body parameter should be:    [data][attributes][allowInput]    False
    And Response body parameter should be:    [data][attributes][isSuper]    False
    And Response body parameter should not be EMPTY:    [data][attributes][localizedKeys][0][translation]
    And Response body parameter should be in:    [data][attributes][localizedKeys][0][localeName]    ${locale.EN.name}    ${locale.DE.name}
    And Response body parameter should not be EMPTY:    [data][attributes][values][0][localizedValues][0][localeName]
    And Response body parameter should not be EMPTY:    [data][attributes][values][0][localizedValues][0][translation]
    And Each array element of array in response should contain property:    [data][attributes][localizedKeys]    translation
    And Each array element of array in response should contain property:    [data][attributes][localizedKeys]    localeName
    And Each array element of array in response should contain property:    [data][attributes][values]    value
    And Each array element of array in response should contain property:    [data][attributes][values]    localizedValues
    And Each array element of array in response should contain property:    [data][attributes][values][0][localizedValues]    localeName
    And Each array element of array in response should contain property:    [data][attributes][values][0][localizedValues]    translation
    And Response body has correct self link internal

Get_product_management_attribute_by_id_normal_editable_attribute
    When I send a GET request:    /product-management-attributes/${product_management.attribute_free_input_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${product_management.attribute_free_input_id}
    And Response body parameter should be:    [data][type]    product-management-attributes
    And Response body parameter should be:    [data][attributes][key]    ${product_management.attribute_free_input_id}
    And Response body parameter should be:    [data][attributes][inputType]    text
    And Response body parameter should be:    [data][attributes][allowInput]    True
    And Response body parameter should be:    [data][attributes][isSuper]    False
    And Response body parameter should not be EMPTY:    [data][attributes][localizedKeys][0][translation]
    And Response body parameter should be in:    [data][attributes][localizedKeys][0][localeName]    ${locale.EN.name}    ${locale.DE.name}
    And Each array element of array in response should contain property:    [data][attributes][localizedKeys]    translation
    And Each array element of array in response should contain property:    [data][attributes][localizedKeys]    localeName
    And Each array element of array in response should contain property:    [data][attributes][values]    value
    And Each array element of array in response should contain property:    [data][attributes][values]    localizedValues
    And Each array element of array in response should contain property:    [data][attributes][values][0][localizedValues]    localeName
    And Each array element of array in response should contain property:    [data][attributes][values][0][localizedValues]    translation
    And Response body has correct self link internal

Get_product_management_attribute_by_id_normal_non_editable_attribute
    When I send a GET request:    /product-management-attributes/${product_management.attribute_no_input_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${product_management.attribute_no_input_id}
    And Response body parameter should be:    [data][type]    product-management-attributes
    And Response body parameter should be:    [data][attributes][key]    ${product_management.attribute_no_input_id}
    And Response body parameter should be:    [data][attributes][inputType]    text
    And Response body parameter should be:    [data][attributes][allowInput]    False
    And Response body parameter should be:    [data][attributes][isSuper]    False
    And Response body parameter should not be EMPTY:    [data][attributes][localizedKeys][0][translation]
    And Response body parameter should be in:    [data][attributes][localizedKeys][0][localeName]    ${locale.EN.name}    ${locale.DE.name}
    And Each array element of array in response should contain property:    [data][attributes][localizedKeys]    translation
    And Each array element of array in response should contain property:    [data][attributes][localizedKeys]    localeName
    And Each array element of array in response should contain property:    [data][attributes][values]    value
    And Each array element of array in response should contain property:    [data][attributes][values]    localizedValues
    And Each array element of array in response should contain property:    [data][attributes][values][0][localizedValues]    localeName
    And Each array element of array in response should contain property:    [data][attributes][values][0][localizedValues]    translation
    And Response body has correct self link internal