*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    bapi

*** Test Cases ***
 Get_product_abstract_collection_with_childs:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Delete dynamic entity configuration relation in Database:    robotTestsCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductPrices
    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    Delete dynamic entity configuration in Database:    robot-tests-products
    Delete dynamic entity configuration in Database:    robot-tests-product-categories
    Delete dynamic entity configuration in Database:    robot-tests-categories
    Delete dynamic entity configuration in Database:    robot-tests-product-prices
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-categories    spy_product_category     1    {"identifier":"id_product_category","fields":[{"fieldName":"id_product_category","fieldVisibleName":"id_product_category","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_category","fieldVisibleName":"fk_category","isCreatable":true,"isEditable":true,"validation":{"isRequired":true},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"product_order","fieldVisibleName":"product_order","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-categories    spy_category     1    {"identifier":"id_category","fields":[{"fieldName":"id_category","fieldVisibleName":"id_category","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_category_template","fieldVisibleName":"fk_category_template","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"category_key","fieldVisibleName":"category_key","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_clickable","fieldVisibleName":"is_clickable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_in_menu","fieldVisibleName":"is_in_menu","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_searchable","fieldVisibleName":"is_searchable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robot-tests-products    robot-tests-product-categories    robotTestsProductCategories    fk_product_abstract    id_product
    Create dynamic entity configuration relation in Database:    robot-tests-product-categories    robot-tests-categories    robotTestsCategories    id_category    fk_category
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### GET PRODUCT ABSTRACT COLLECTION WITH CHILDS ONE LVEL ###
    Trigger p&s
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-product-abstracts?include=robotTestsProductAbstractProducts
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response should contain the array of a certain size:   [data]    215
    And Response should contain the array of a certain size:   [data][0]    9
    And Response should contain the array of a certain size:   [data][0][robotTestsProductAbstractProducts]    1
    And Each array element of array in response should contain property:    [data]    id_product_abstract
    And Each array element of array in response should contain property:    [data]    sku
    And Each array element of array in response should contain nested property:    [data]    [robotTestsProductAbstractProducts]    id_product
    And Each array element of array in response should contain nested property:    [data]    [robotTestsProductAbstractProducts]    fk_product_abstract
    ### GET PRODUCT ABSTRACT COLLECTION WITH CHILDS AS TREE ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-product-abstracts?include=robotTestsProductAbstractProducts.robotTestsProductCategories.robotTestsCategories
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response should contain the array of a certain size:   [data]    215
    And Response should contain the array of a certain size:   [data][0]    9
    And Response should contain the array of a certain size:   [data][0][robotTestsProductAbstractProducts]    1
    And Response should contain the array of a certain size:   [data][0][robotTestsProductAbstractProducts][0][robotTestsProductCategories]    1
    And Response should contain the array of a certain size:   [data][0][robotTestsProductAbstractProducts][0][robotTestsProductCategories][0][robotTestsCategories]    1

 Get_product_abstract_with_childs_by_id:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Delete dynamic entity configuration relation in Database:    robotTestsCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    Delete dynamic entity configuration in Database:    robot-tests-products
    Delete dynamic entity configuration in Database:    robot-tests-product-categories
    Delete dynamic entity configuration in Database:    robot-tests-categories
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-categories    spy_product_category     1    {"identifier":"id_product_category","fields":[{"fieldName":"id_product_category","fieldVisibleName":"id_product_category","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_category","fieldVisibleName":"fk_category","isCreatable":true,"isEditable":true,"validation":{"isRequired":true},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"product_order","fieldVisibleName":"product_order","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-categories    spy_category     1    {"identifier":"id_category","fields":[{"fieldName":"id_category","fieldVisibleName":"id_category","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_category_template","fieldVisibleName":"fk_category_template","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"category_key","fieldVisibleName":"category_key","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_clickable","fieldVisibleName":"is_clickable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_in_menu","fieldVisibleName":"is_in_menu","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_searchable","fieldVisibleName":"is_searchable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robot-tests-products    robot-tests-product-categories    robotTestsProductCategories    fk_product_abstract    id_product
    Create dynamic entity configuration relation in Database:    robot-tests-product-categories    robot-tests-categories    robotTestsCategories    id_category    fk_category

    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### GET PRODUCT ABSTRACT COLLECTION WITH CHILDS ONE LVEL ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-product-abstracts/130?include=robotTestsProductAbstractProducts
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response should contain the array of a certain size:   [data]    9
    And Response should contain the array of a certain size:   [data][robotTestsProductAbstractProducts]    3
    And Response body parameter should be:    [data][id_product_abstract]    130
    And Response body parameter should be:    [data][sku]    130
    And Response body parameter should be:    [data][robotTestsProductAbstractProducts][0][fk_product_abstract]    130
    And Response body parameter should be:    [data][robotTestsProductAbstractProducts][1][fk_product_abstract]    130
    And Response body parameter should be:    [data][robotTestsProductAbstractProducts][2][fk_product_abstract]    130

    ### GET PRODUCT ABSTRACT COLLECTION WITH CHILDS AS TREE ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-product-abstracts/130?include=robotTestsProductAbstractProducts.robotTestsProductCategories.robotTestsCategories
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response should contain the array of a certain size:   [data]    9
    And Response should contain the array of a certain size:   [data][robotTestsProductAbstractProducts]    3
    And Response should contain the array of a certain size:   [data][robotTestsProductAbstractProducts][0][robotTestsProductCategories]    1
    And Response should contain the array of a certain size:   [data][robotTestsProductAbstractProducts][0][robotTestsProductCategories][0][robotTestsCategories]    1
    And Response should contain the array of a certain size:   [data][robotTestsProductAbstractProducts][1][robotTestsProductCategories]    1
    And Response should contain the array of a certain size:   [data][robotTestsProductAbstractProducts][1][robotTestsProductCategories][0][robotTestsCategories]    1

 Create_and_update_product_abstract_collection_with_child:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Delete dynamic entity configuration relation in Database:    robotTestsCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductCategories
    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    Delete dynamic entity configuration in Database:    robot-tests-products
    Delete dynamic entity configuration in Database:    robot-tests-product-categories
    Delete dynamic entity configuration in Database:    robot-tests-categories
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-prices    spy_price_product     1     {"identifier":"id_price_product","fields":[{"fieldName":"id_price_product","fieldVisibleName":"id_price_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_price_type","fieldVisibleName":"fk_price_type","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"fk_product","fieldVisibleName":"fk_product","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"price","fieldVisibleName":"price","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-product-prices    robotTestsProductPrices    fk_product_abstract    id_product_abstract

    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}

    ### CREATE PRODUCT ABSTRACT WITH CHILD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR"}]}]}
    Then Response status code should be:    201
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][0][sku]    FOO
    And Response body parameter should be:    [data][0][attributes]    FOO
    And Response body parameter should be:    [data][0][robotTestsProductAbstractProducts][0][sku]    FOOBAR
    And Response body parameter should be:    [data][0][robotTestsProductAbstractProducts][0][attributes]    FOOBAR
    Response body parameter should be greater than :    [data][0][id_product_abstract]    0
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    Response body parameter should be greater than :    [data][0][robotTestsProductAbstractProducts][0][id_product]    0
    And Response body parameter should be:    [data][0][robotTestsProductAbstractProducts][0][fk_product_abstract]    ${id_product_abstract}
    [Teardown]    Run Keywords    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductPrices
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-prices

 Create_product_abstract_collection_with_two_childs:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-prices    spy_price_product     1     {"identifier":"id_price_product","fields":[{"fieldName":"id_price_product","fieldVisibleName":"id_price_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_price_type","fieldVisibleName":"fk_price_type","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"fk_product","fieldVisibleName":"fk_product","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"price","fieldVisibleName":"price","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-product-prices    robotTestsProductPrices    fk_product_abstract    id_product_abstract

    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}

    ### CREATE PRODUCT ABSTRACT WITH TWO CHILDS ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO2", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR2"}], "robotTestsProductPrices": [{"fk_price_type": 1, "price": 0}]}]}
    Then Response status code should be:    201
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][0][sku]    FOO2
    And Response body parameter should be:    [data][0][attributes]    FOO
    And Response body parameter should be:    [data][0][robotTestsProductAbstractProducts][0][sku]    FOOBAR2
    And Response body parameter should be:    [data][0][robotTestsProductAbstractProducts][0][attributes]    FOOBAR
    Response body parameter should be greater than :    [data][0][id_product_abstract]    0
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    When Save value to a variable:    [data][0][robotTestsProductPrices][0][id_price_product]    id_price_product
    Response body parameter should be greater than :    [data][0][robotTestsProductAbstractProducts][0][id_product]    0
    And Response body parameter should be:    [data][0][robotTestsProductAbstractProducts][0][fk_product_abstract]    ${id_product_abstract}
    And Response body parameter should be:    [data][0][robotTestsProductPrices][0][fk_product_abstract]    ${id_product_abstract}

    [Teardown]    Run Keywords    Delete product_price by id_price_product in Database:   ${id_price_product}
    ...   AND    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductPrices
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-prices

 Update_product_abstract_collection_with_child:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-prices    spy_price_product     1     {"identifier":"id_price_product","fields":[{"fieldName":"id_price_product","fieldVisibleName":"id_price_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_price_type","fieldVisibleName":"fk_price_type","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"fk_product","fieldVisibleName":"fk_product","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"price","fieldVisibleName":"price","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-product-prices    robotTestsProductPrices    fk_product_abstract    id_product_abstract

    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}

    ### SAVE PRODUCT ABSTRACT WITH CHILD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO2", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR2"}]}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    ### UPDATE PRODUCT ABSTRACT WITH CHILD ###
    And I send a PATCH request:    /dynamic-entity/robot-tests-product-abstracts    {"data": [{"id_product_abstract": ${id_product_abstract}, "fk_tax_set": 1, "attributes": "FOO_UPDATED", "sku": "FOO_UPDATED", "robotTestsProductAbstractProducts": [{"id_product": ${id_product}, "attributes": "FOOBAR_UPDATED", "sku": "FOOBAR_UPDATED"}]}]}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][0][sku]    FOO_UPDATED
    And Response body parameter should be:    [data][0][attributes]    FOO_UPDATED
    And Response body parameter should be:    [data][0][robotTestsProductAbstractProducts][0][sku]    FOOBAR_UPDATED
    And Response body parameter should be:    [data][0][robotTestsProductAbstractProducts][0][attributes]    FOOBAR_UPDATED

    [Teardown]    Run Keywords    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductPrices
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-prices

Upsert_product_abstract_collection_with_child:
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"boolean","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-prices    spy_price_product     1     {"identifier":"id_price_product","fields":[{"fieldName":"id_price_product","fieldVisibleName":"id_price_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_price_type","fieldVisibleName":"fk_price_type","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"fk_product","fieldVisibleName":"fk_product","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"price","fieldVisibleName":"price","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-product-prices    robotTestsProductPrices    fk_product_abstract    id_product_abstract

    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}

    ### SAVE PRODUCT ABSTRACT WITH CHILD ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts  {"data": [{"fk_tax_set": 1, "attributes": "FOO", "sku": "FOO2", "robotTestsProductAbstractProducts": [{"attributes": "FOOBAR", "sku": "FOOBAR2"}]}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    When Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    ### UPDATE PRODUCT ABSTRACT WITH CHILD ###
    And I send a PUT request:    /dynamic-entity/robot-tests-product-abstracts    {"data": [{"id_product_abstract": ${id_product_abstract}, "fk_tax_set": 1, "attributes": "FOO_UPDATED", "sku": "FOO_UPDATED", "robotTestsProductAbstractProducts": [{"id_product": ${id_product}, "fk_product_abstract": ${id_product_abstract},"attributes": "FOOBAR_UPDATED", "sku": "FOOBAR_UPDATED"}]}]}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][0][sku]    FOO_UPDATED
    And Response body parameter should be:    [data][0][approval_status]    None
    And Response body parameter should be:    [data][0][new_to]    None
    And Response body parameter should be:    [data][0][color_code]    None
    And Response body parameter should be:    [data][0][attributes]    FOO_UPDATED
    And Response body parameter should be:    [data][0][robotTestsProductAbstractProducts][0][sku]    FOOBAR_UPDATED
    And Response body parameter should be:    [data][0][robotTestsProductAbstractProducts][0][attributes]    FOOBAR_UPDATED

    [Teardown]    Run Keywords    Delete product by id_product in Database:    ${id_product}
    ...   AND    Delete product_abstract by id_product_abstract in Database:   ${id_product_abstract}
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductPrices
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-prices

Create_and_publish_complex_product_with_child_relations:
    [Documentation]    As the tech dept, we need to adjust this test to check in /catalog-search as well.
    ### SETUP DYNAMIC ENTITY CONFIGURATION AND RELATION ###
    Create dynamic entity configuration in Database:    robot-tests-product-abstracts    spy_product_abstract     1    {"identifier":"id_product_abstract","fields":[{"fieldName":"id_product_abstract","fieldVisibleName":"id_product_abstract","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_tax_set","fieldVisibleName":"fk_tax_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"approval_status","fieldVisibleName":"approval_status","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"new_from","fieldVisibleName":"new_from","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"new_to","fieldVisibleName":"new_to","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"color_code","fieldVisibleName":"color_code","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-products    spy_product     1    {"identifier":"id_product","fields":[{"fieldName":"id_product","fieldVisibleName":"id_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"is_quantity_splittable","fieldVisibleName":"is_quantity_splittable","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"sku","fieldVisibleName":"sku","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-searches    spy_product_search     1    {"identifier":"id_product_search","fields":[{"fieldName":"id_product_search","fieldVisibleName":"id_product_search","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product","fieldVisibleName":"fk_product","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"fk_locale","fieldVisibleName":"fk_locale","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"is_searchable","fieldVisibleName":"is_searchable","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}}]}
    Create dynamic entity configuration in Database:    robot-tests-stock-products   spy_stock_product     1    {"identifier":"id_stock_product","fields":[{"fieldName":"id_stock_product","fieldVisibleName":"id_stock_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product","fieldVisibleName":"fk_product","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"quantity","fieldVisibleName":"quantity","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"is_never_out_of_stock","fieldVisibleName":"is_never_out_of_stock","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_stock","fieldVisibleName":"fk_stock","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-searches   spy_product_search     1    {"identifier":"id_product_search","fields":[{"fieldName":"id_product_search","fieldVisibleName":"id_product_search","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product","fieldVisibleName":"fk_product","type":"integer","isCreatable":true,"isEditable":true,"validation":{"isRequired":true}},{"fieldName":"fk_locale","fieldVisibleName":"fk_locale","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"is_searchable","fieldVisibleName":"is_searchable","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-localized-attributes   spy_product_localized_attributes     1    {"identifier":"id_product_attributes","fields":[{"fieldName":"id_product_attributes","fieldVisibleName":"id_product_attributes","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_locale","fieldVisibleName":"fk_locale","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"fk_product","fieldVisibleName":"fk_product","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"description","fieldVisibleName":"description","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"name","fieldVisibleName":"name","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-abstract-stores   spy_product_abstract_store     1    {"identifier":"id_product_abstract_store","fields":[{"fieldName":"id_product_abstract_store","fieldVisibleName":"id_product_abstract_store","isCreatable":false,"isEditable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"fk_store","fieldVisibleName":"fk_store","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-relations   spy_product_relation     1    {"identifier":"id_product_relation","fields":[{"fieldName":"id_product_relation","fieldVisibleName":"id_product_relation","isCreatable":true,"isEditable":true,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"fk_product_relation_type","fieldVisibleName":"fk_product_relation_type","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"is_active","fieldVisibleName":"is_active","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"is_rebuild_scheduled","fieldVisibleName":"is_rebuild_scheduled","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"product_relation_key","fieldVisibleName":"product_relation_key","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"query_set_data","fieldVisibleName":"query_set_data","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-relation-stores   spy_product_relation_store     1    {"identifier":"id_product_relation_store","fields":[{"fieldName":"id_product_relation_store","fieldVisibleName":"id_product_relation_store","isCreatable":true,"isEditable":true,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_product_relation","fieldVisibleName":"fk_product_relation","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"fk_store","fieldVisibleName":"fk_store","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}}]}
    Create dynamic entity configuration in Database:    robot-tests-price-products   spy_price_product     1    {"identifier":"id_price_product","fields":[{"fieldName":"id_price_product","fieldVisibleName":"id_price_product","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_price_type","fieldVisibleName":"fk_price_type","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"fk_product","fieldVisibleName":"fk_product","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"price","fieldVisibleName":"price","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-price-product-stores   spy_price_product_store     1    {"identifier":"id_price_product_store","fields":[{"fieldName":"id_price_product_store","fieldVisibleName":"id_price_product_store","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_currency","fieldVisibleName":"fk_currency","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"fk_price_product","fieldVisibleName":"fk_price_product","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"fk_store","fieldVisibleName":"fk_store","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"gross_price","fieldVisibleName":"gross_price","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"net_price","fieldVisibleName":"net_price","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}}]}
    Create dynamic entity configuration in Database:    robot-tests-price-product-defaults   spy_price_product_default     1    {"identifier":"id_price_product_default","fields":[{"fieldName":"id_price_product_default","fieldVisibleName":"id_price_product_default","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_price_product_store","fieldVisibleName":"fk_price_product_store","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-categories   spy_product_category     1    {"identifier":"id_product_category","fields":[{"fieldName":"id_product_category","fieldVisibleName":"id_product_category","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_category","fieldVisibleName":"fk_category","isCreatable":true,"isEditable":true,"validation":{"isRequired":true},"type":"integer"},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"product_order","fieldVisibleName":"product_order","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-abstract-localized-attributes   spy_product_abstract_localized_attributes     1    {"identifier":"id_abstract_attributes","fields":[{"fieldName":"id_abstract_attributes","fieldVisibleName":"id_abstract_attributes","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_locale","fieldVisibleName":"fk_locale","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"attributes","fieldVisibleName":"attributes","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"description","fieldVisibleName":"description","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"name","fieldVisibleName":"name","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true}},{"fieldName":"meta_description","fieldVisibleName":"meta_description","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"meta_keywords","fieldVisibleName":"meta_keywords","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"meta_title","fieldVisibleName":"meta_title","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-label-product-abstracts   spy_product_label_product_abstract     1    {"identifier":"id_product_label_product_abstract","fields":[{"fieldName":"id_product_label_product_abstract","fieldVisibleName":"id_product_label_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"fk_product_label","fieldVisibleName":"fk_product_label","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}}]}
    Create dynamic entity configuration in Database:    robot-tests-product-image-sets   spy_product_image_set     1    {"identifier":"id_product_image_set","fields":[{"fieldName":"id_product_image_set","fieldVisibleName":"id_product_image_set","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_locale","fieldVisibleName":"fk_locale","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"fk_product","fieldVisibleName":"fk_product","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}},{"fieldName":"name","fieldVisibleName":"name","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":false}},{"fieldName":"fk_product_abstract","fieldVisibleName":"fk_product_abstract","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}}]}
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-products    robotTestsProductAbstractProducts    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-product-abstract-stores    robotTestsProductAbstractStores    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-product-relations    robotTestsProductRelations    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robot-tests-product-relations    robot-tests-product-relation-stores    robotTestsProductRelationStores    fk_product_relation    id_product_relation
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-price-products    robotTestsProductAbstractPriceProducts    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robot-tests-price-products    robot-tests-price-product-stores    robotTestsPriceProductStores    fk_price_product    id_price_product
    Create dynamic entity configuration relation in Database:    robot-tests-price-product-stores    robot-tests-price-product-defaults    robotTestsPriceProductStoreDefaults    fk_price_product_store    id_price_product_store
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-product-categories    robotTestsProductAbstractCategories    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-product-abstract-localized-attributes    robotTestsProductAbstractLocalizedAttributes    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-product-label-product-abstracts    robotTestsProductLabelProductAbstracts    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robot-tests-product-abstracts    robot-tests-product-image-sets    robotTestsProductImageSets    fk_product_abstract    id_product_abstract
    Create dynamic entity configuration relation in Database:    robot-tests-products  robot-tests-product-searches   robotTestsProductSearch    fk_product    id_product
    Create dynamic entity configuration relation in Database:    robot-tests-products  robot-tests-stock-products   robotTestsProductStocks    fk_product    id_product
    Create dynamic entity configuration relation in Database:    robot-tests-products  robot-tests-product-localized-attributes   robotTestsProductLocalizedAttributes    fk_product    id_product

    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}

    ### SAVE PRODUCT ABSTRACT WITH STOCK ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-tests-product-abstracts    {"data":[{"fk_tax_set":2,"approval_status":"approved","attributes":"{}","new_to":"2028-01-01 00:00:00.000000","sku":"d04e93a4-29ea-4c48-96ab-e87416aefbec","color_code":"#DC2E09","robotTestsProductAbstractProducts":[{"attributes":"d04e93a4-29ea-4c48-96ab-e87416aefbec-1 test attributes","is_active":1,"is_quantity_splittable":1,"sku":"d04e93a4-29ea-4c48-96ab-e87416aefbec-1","robotTestsProductSearch":[{"fk_locale":66,"is_searchable":1}, {"fk_locale":46,"is_searchable":1}],"robotTestsProductStocks":[{"fk_stock":1,"is_never_out_of_stock":1,"quantity":10}],"robotTestsProductLocalizedAttributes":[{"fk_locale":66,"attributes":"d04e93a4-29ea-4c48-96ab-e87416aefbec-1","description":"desc","name":"Test Concrete Product d04e93a4-29ea-4c48-96ab-e87416aefbec-1"}, {"fk_locale":46,"attributes":"d04e93a4-29ea-4c48-96ab-e87416aefbec-1","description":"desc","name":"Test Concrete Product d04e93a4-29ea-4c48-96ab-e87416aefbec-1"}]}],"robotTestsProductAbstractStores":[{"fk_store":1}],"robotTestsProductRelations":[{"fk_product_relation_type":1,"is_active":1,"is_rebuild_scheduled":1,"product_relation_key":"Prk-d04e93a4-29ea-4c48-96ab-e87416aefbec","query_set_data":"","robotTestsProductRelationStores":[{"fk_store":1}]}],"robotTestsProductAbstractPriceProducts":[{"fk_price_type":1,"price":1000,"robotTestsPriceProductStores":[{"fk_currency":93,"fk_store":1,"gross_price":9999,"net_price":8999,"robotTestsPriceProductStoreDefaults":[{}]}]}],"robotTestsProductAbstractCategories":[{"fk_category":5,"product_order":16}],"robotTestsProductAbstractLocalizedAttributes":[{"fk_locale":66,"attributes":"test","description":"Beeindruckende Aufnahmen","meta_description":"Beeindruckende Aufnahmen","meta_keywords":"Entertainment Electronics","meta_title":"test product d04e93a4-29ea-4c48-96ab-e87416aefbec","name":"test product d04e93a4-29ea-4c48-96ab-e87416aefbec"},{"fk_locale":46,"attributes":"test","description":"Beeindruckende Aufnahmen","meta_description":"Beeindruckende Aufnahmen","meta_keywords":"Entertainment Electronics","meta_title":"test product d04e93a4-29ea-4c48-96ab-e87416aefbec","name":"test product d04e93a4-29ea-4c48-96ab-e87416aefbec"}],"robotTestsProductLabelProductAbstracts":[{"fk_product_label":1}],"robotTestsProductImageSets":[{"fk_locale":66,"name":"d04e93a4-29ea-4c48-96ab-e87416aefbec-1"}, {"fk_locale":46,"name":"d04e93a4-29ea-4c48-96ab-e87416aefbec-1"}]}]}
    Then Response status code should be:    201
    And Save value to a variable:    [data][0][id_product_abstract]    id_product_abstract
    And Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][id_product]    id_product
    And Save value to a variable:    [data][0][sku]    abstract_sku
    And Save value to a variable:    [data][0][robotTestsProductAbstractProducts][0][sku]    concrete_sku
    Trigger p&s
    Trigger p&s
    Trigger p&s
    Remove Tags    *
    Set Tags    glue
    API_test_setup
    I set Headers:    Content-Type=application/vnd.api+json    Accept-Language=de-DE, en;q=0.9
    I send a GET request:    /abstract-products/${abstract_sku}/abstract-product-availabilities
    Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][type]    abstract-product-availabilities
    And Response body parameter should be:    [data][0][id]    d04e93a4-29ea-4c48-96ab-e87416aefbec

    I set Headers:    Content-Type=application/vnd.api+json    Accept=application/vnd.api+json    Accept-Language=de-DE, en;q=0.9
    I send a GET request:    /concrete-products/${concrete_sku}
    Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    concrete-products
    And Response body parameter should be:    [data][id]    d04e93a4-29ea-4c48-96ab-e87416aefbec-1
    And Response body parameter should be:    [data][attributes][sku]    d04e93a4-29ea-4c48-96ab-e87416aefbec-1
    Remove Tags    *
    Set Tags    bapi
    API_test_setup
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-tests-product-searches?filter[product-searches.fk_product]=${id_product}
    Then Response status code should be:    200
    And Save value to a variable:    [data][0][id_product_search]    id_product_search_first
    And Save value to a variable:    [data][1][id_product_search]    id_product_search_second
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a PATCH request:    /dynamic-entity/robot-tests-product-searches    {"data": [{"id_product_search": ${id_product_search_first},"is_searchable": 0}, {"id_product_search": ${id_product_search_second},"is_searchable": 0}]}
    Then Response status code should be:    200
    Trigger p&s
    Trigger p&s
    [Teardown]    Run Keywords    Delete complex product by id_product_abstract in Database:   ${id_product_abstract}
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductSearch
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductStocks
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductLocalizedAttributes
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductImageSets
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductLabelProductAbstracts
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractLocalizedAttributes
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractCategories
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsPriceProductStoreDefaults
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsPriceProductStores
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractPriceProducts
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductRelationStores
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductRelations
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractStores
    ...   AND    Delete dynamic entity configuration relation in Database:    robotTestsProductAbstractProducts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-image-sets
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-label-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstract-localized-attributes
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-categories
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-price-product-defaults
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-price-product-stores
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-price-products
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-relation-stores
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-relations
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstract-stores
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-localized-attributes
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-searches
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-stock-products
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-products
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-abstracts
    ...   AND    Delete dynamic entity configuration in Database:    robot-tests-product-searches
