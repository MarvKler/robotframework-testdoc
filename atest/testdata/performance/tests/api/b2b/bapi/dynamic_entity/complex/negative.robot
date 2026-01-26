*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    bapi

*** Test Cases ***
Get_product_abstract_collection_with_invalid_query_parameter:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Delete dynamic entity configuration relation in Database:    robotTestsCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    Delete dynamic entity configuration in Database:    robot-tests-products
    Delete dynamic entity configuration in Database:    robot-tests-product-categories
    Delete dynamic entity configuration in Database:    robot-tests-categories
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-categories    spy_product_category     1    {"identifier":"id_product_category","fields":[{"fieldName":"id_product_category","fieldVisibleName":"id_product_category","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_category","fieldVisibleName":"fk_category","isCreatable":true,"isEditable":true,"validation":{"isRequired":true},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"product_order","fieldVisibleName":"product_order","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-categories    spy_category     1    {"identifier":"id_category","fields":[{"fieldName":"id_category","fieldVisibleName":"id_category","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_category_template","fieldVisibleName":"fk_category_template","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"category_key","fieldVisibleName":"category_key","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_clickable","fieldVisibleName":"is_clickable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_in_menu","fieldVisibleName":"is_in_menu","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_searchable","fieldVisibleName":"is_searchable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robot-tests-products    robot-tests-product-categories    robotTestsProductCategories    fk_product_abstract    id_product
    Create dynamic entity configuration relation in Database:    robot-tests-product-categories    robot-tests-categories    robotTestsCategories    id_category    fk_category

    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### GET PRODUCT ABSTRACT COLLECTION WITH CHILDS ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-product-abstracts?include=test
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1313

Create_product_abstract_collection_with_invalid_child:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Delete dynamic entity configuration relation in Database:    robotTestsCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    Delete dynamic entity configuration in Database:    robot-tests-products
    Delete dynamic entity configuration in Database:    robot-tests-product-categories
    Delete dynamic entity configuration in Database:    robot-tests-categories
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH INVALID CHILD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProductsInvalid": [{"attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1313
    And Response body parameter should be:    [0][message]    Relation `robotTestsProductAbstractProductsInvalid` not found. Please check the requested relation name and try again.
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products

Create_product_abstract_collection_with_child_contained_invalid_field:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH CHILD CONTAINED INVALID FIELD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR", "invalid_field": "invalid"}]}]}
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1311
    And Response body parameter should be:    [0][message]    The provided `robot-tests-product-abstracts0.robot-tests-products0.invalid_field` is incorrect or invalid.
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products

Create_product_abstract_collection_with_child_contained_invalid_field_non_transactional:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH CHILD CONTAINED INVALID FIELD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}    X-Is-Transactional=false
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR", "invalid_field": "invalid"}]}]}
    Then Response status code should be:    400
    And Response body parameter should be:    [errors][0][status]    400
    And Response body parameter should be:    [errors][0][code]    1311
    And Response body parameter should be:    [errors][0][message]    The provided `robot-tests-product-abstracts0.robot-tests-products0.invalid_field` is incorrect or invalid.
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products

Create_product_abstract_collection_with_correct_child_and_child_contained_invalid_field_non_transactional:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH CHILD CONTAINED INVALID FIELD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}    X-Is-Transactional=false
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR", "invalid_field": "invalid"}]}, {"fk_tax_set": 1, "attributes": "FOO1", "sku": "FOO1", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR1", "sku": "FOOBAR1"}]}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    And Response body parameter should be:    [errors][0][status]    400
    And Response body parameter should be:    [errors][0][code]    1311
    And Response body parameter should be:    [errors][0][message]    The provided `robot-tests-product-abstracts0.robot-tests-products0.invalid_field` is incorrect or invalid.
    And Response body parameter should be:    [data][0][sku]    FOO1
    And Response body parameter should be:    [data][0][attributes]    FOO1
    ### GET PRODUCT ABSTRACT WITH CHILDREN ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-product-abstracts/${id_product_abstract}?include=robotTestsProductAbstractProducts
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][id_product_abstract]    ${id_product_abstract}
    And Response body parameter should be:    [data][sku]    FOO1
    And Response body parameter should be:    [data][robotTestsProductAbstractProducts][0][fk_product_abstract]    ${id_product_abstract}
    And Response body parameter should be:    [data][robotTestsProductAbstractProducts][0][id_product]    ${id_product}
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}

Update_product_abstract_collection_with_invalid_child:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH CHILD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    ### UPDATE PRODUCT ABSTRACT WITH INVALID CHILD###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a PATCH request:   /dynamic-entity/robot-tests-product-abstracts  {"data": [{"id_product_abstract": ${id_product_abstract}, "fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProductsInvalid": [{"id_product": ${id_product}, "attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1313
    And Response body parameter should be:    [0][message]    Relation `robotTestsProductAbstractProductsInvalid` not found. Please check the requested relation name and try again.
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}

Update_product_abstract_collection_with_child_contained_invalid_field:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH CHILD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    ### UPDATE PRODUCT ABSTRACT WITH INVALID CHILD CONTAINED INVALID FIELD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a PATCH request:   /dynamic-entity/robot-tests-product-abstracts  {"data": [{"id_product_abstract": ${id_product_abstract}, "fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"id_product": ${id_product}, "attributes": "FOOBAR", "sku": "FOOBAR", "invalid_field": "invalid"}]}]}
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1311
    And Response body parameter should be:    [0][message]    The provided `robot-tests-product-abstracts0.robot-tests-products0.invalid_field` is incorrect or invalid.
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}

Update_product_abstract_collection_with_missing_required_field:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH CHILD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    ### UPDATE PRODUCT ABSTRACT WITH INVALID CHILD CONTAINED INVALID FIELD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a PATCH request:   /dynamic-entity/robot-tests-product-abstracts  {"data": [{"id_product_abstract": ${id_product_abstract}, "fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"fk_product_abstract": ${id_product_abstract}, "attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1310
    And Response body parameter should be:    [0][message]    Incomplete Request - missing identifier for `robot-tests-product-abstracts0.robot-tests-products0`
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}

Upsert_product_abstract_collection_with_invalid_child:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH CHILD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    ### UPDATE PRODUCT ABSTRACT WITH INVALID CHILD###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a PUT request:   /dynamic-entity/robot-tests-product-abstracts  {"data": [{"id_product_abstract": ${id_product_abstract}, "fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProductsInvalid": [{"id_product": ${id_product}, "attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1313
    And Response body parameter should be:    [0][message]    Relation `robotTestsProductAbstractProductsInvalid` not found. Please check the requested relation name and try again.
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}

Upsert_product_abstract_collection_with_child_contained_invalid_field:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH CHILD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    ### UPDATE PRODUCT ABSTRACT WITH INVALID CHILD CONTAINED INVALID FIELD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a PUT request:   /dynamic-entity/robot-tests-product-abstracts  {"data": [{"id_product_abstract": ${id_product_abstract}, "fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"id_product": ${id_product}, "fk_product_abstract": ${id_product_abstract}, "attributes": "FOOBAR", "sku": "FOOBAR", "invalid_field": "invalid"}]}]}
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1311
    And Response body parameter should be:    [0][message]    The provided `robot-tests-product-abstracts0.robot-tests-products0.invalid_field` is incorrect or invalid.
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}

Upsert_product_abstract_collection_with_missing_required_field:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE PRODUCT ABSTRACT WITH CHILD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    ### UPDATE PRODUCT ABSTRACT WITH INVALID CHILD CONTAINED INVALID FIELD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a PUT request:   /dynamic-entity/robot-tests-product-abstracts  {"data": [{"id_product_abstract": ${id_product_abstract}, "fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"fk_product_abstract": ${id_product_abstract}, "attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    400
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should be:    [0][code]    1309
    And Response body parameter should be:    [0][message]    Failed to persist the data for `robot-tests-product-abstracts0.robot-tests-products0.sku`. Please verify the provided data and try again. Entry is duplicated.
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}

Delete_country_collection_with_existing_child_entity
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:    robot-test-countries    spy_country     1    {"identifier":"id_country","isDeletable": true,"fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE TEST COUNTRIES ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-test-countries   {"data":[{"iso2_code":"XA","iso3_code":"XXA","name":"Country XA"},{"iso2_code":"XB","iso3_code":"XXB","name":"Country XB"},{"iso2_code":"XC","iso3_code":"XXC","name":"Country XC","postal_code_regex":"\\\\d{5}"}]}
    Then Response status code should be:    201
    And Response body parameter should be:    [data][2][iso2_code]    XC
    And Response body parameter should be:    [data][2][iso3_code]    XXC
    And Response body parameter should be:    [data][2][name]    Country XC
    Response body parameter should be greater than :    [data][2][id_country]    200
    When Save value to a variable:    [data][0][iso2_code]    xxa_iso2_code
    When Save value to a variable:    [data][0][name]    xxa_name
    When Save value to a variable:    [data][1][iso2_code]    xxb_iso2_code
    When Save value to a variable:    [data][1][name]    xxb_name
    When Save value to a variable:    [data][2][iso2_code]    xxc_iso2_code
    When Save value to a variable:    [data][2][name]    xxc_name
    ### GET COUNTRY COLLECTION WITH FILTER ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-test-countries?filter[countries.iso2_code]={"in": ["${xxa_iso2_code}","${xxb_iso2_code}","${xxc_iso2_code}"]}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][0][iso2_code]    ${xxa_iso2_code}
    And Response body parameter should be:    [data][0][name]    ${xxa_name}
    And Response body parameter should be:    [data][1][iso2_code]    ${xxb_iso2_code}
    And Response body parameter should be:    [data][1][name]    ${xxb_name}
    And Response body parameter should be:    [data][2][iso2_code]    ${xxc_iso2_code}
    And Response body parameter should be:    [data][2][name]    ${xxc_name}
    #### DELETE COUNTRY COLLECTION ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a DELETE request:    /dynamic-entity/robot-test-countries?filter[countries.iso2_code]={"in": ["${xxa_iso2_code}","${xxb_iso2_code}","${xxc_iso2_code}"]}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-test-countries?filter[countries.iso2_code]={"in": ["${xxa_iso2_code}","${xxb_iso2_code}","${xxc_iso2_code}"]}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response should contain the array of a certain size:   $    1
    And Response should contain the array of a certain size:   [data]    0
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-test-countries
    ...   AND    Delete country by iso2_code in Database:   XA
    ...   AND    Delete country by iso2_code in Database:   XB
    ...   AND    Delete country by iso2_code in Database:   XC

Delete_product_abstract_by_id_with_existing_child_entity:
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","isDeletable": true,"fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","isDeletable": true,"fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE TEST PRODUCT ABSTRACT ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO2", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR2"}]}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    ### GET PRODUCT ABSTRACT BY ID ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-product-abstracts/${id_product_abstract}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][id_product_abstract]    ${id_product_abstract}
    #### DELETE PRODUCT ABSTRACT BY ID ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a DELETE request:    /dynamic-entity/robot-tests-product-abstracts/${id_product_abstract}
    Then Response status code should be:    400
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][message]    Failed to delete the data for `robot-tests-product-abstracts.id_product_abstract = ${id_product_abstract}`. The entity has a child entity and can not be deleted. Child entity: `spy_product`.
    And Response body parameter should be:    [0][code]    1317
    And Response body parameter should be:    [0][status]    400
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-product-abstracts/${id_product_abstract}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][id_product_abstract]    ${id_product_abstract}
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}

Delete_product_abstract_collection_with_existing_child_entity:
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","isDeletable": true,"fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","isDeletable": true,"fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### GET PRODUCT ABSTRACT BY ID ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-product-abstracts?filter[product-abstracts.id_product_abstract]={"in": ["1","2", "3"]}
    Then Response status code should be:    200
    And Response should contain the array of a certain size:   [data]    3
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    #### DELETE PRODUCT ABSTRACT BY ID ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a DELETE request:    /dynamic-entity/robot-tests-product-abstracts?filter[product-abstracts.id_product_abstract]={"in": ["1","2", "3"]}
    Then Response status code should be:    400
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][message]    Failed to delete the data for `robot-tests-product-abstracts.id_product_abstract = ${id_product_abstract}`. The entity has a child entity and can not be deleted. Child entity: `spy_price_product`.
    And Response body parameter should be:    [0][code]    1317
    And Response body parameter should be:    [0][status]    400
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-product-abstracts?filter[product-abstracts.id_product_abstract]={"in": ["1","2", "3"]}
    Then Response status code should be:    200
    And Response should contain the array of a certain size:   [data]    3
    [Teardown]    Run Keywords    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
