*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    search    catalog    product


*** Test Cases ***
##### SEARCH PARAMETERS #####

Search_with_empty_search_criteria_all_default_values_check
    When I send a GET request:    /catalog-search?q=
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][spellingSuggestion]    None
    #Sorting
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][sort][sortParamNames]
    ...    ${default_qty.sorting_options}
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][sort][sortParamLocalizedNames]
    ...    ${default_qty.sorting_options}
    And Response body parameter should contain:    [data][0][attributes]    currentSortParam
    And Response body parameter should contain:    [data][0][attributes]    currentSortOrder
    #Pagination
    And Response body parameter should be in:
    ...    [data][0][attributes][pagination][numFound]
    ...    ${total_number_of_products_in_search}
    ...    ${total_number_of_products_in_search_ssp}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be in:    [data][0][attributes][pagination][maxPage]    ${default_qty.ipp_pages}    ${default_qty.ipp_pages_ssp}
    And Response body parameter should be:    [data][0][attributes][pagination][currentItemsPerPage]    ${ipp.default}
    And Response body parameter should be:
    ...    [data][0][attributes][pagination][config][defaultItemsPerPage]
    ...    ${ipp.default}
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][pagination][config][validItemsPerPageOptions]
    ...    3
    And Response body parameter should contain:
    ...    [data][0][attributes][pagination][config][validItemsPerPageOptions]
    ...    ${ipp.default}
    And Response body parameter should contain:
    ...    [data][0][attributes][pagination][config][validItemsPerPageOptions]
    ...    ${ipp.middle}
    And Response body parameter should contain:
    ...    [data][0][attributes][pagination][config][validItemsPerPageOptions]
    ...    ${ipp.biggest}
    #Abstract products
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Each array element of array in response should contain value:
    ...    [data][0][attributes][abstractProducts]
    ...    abstractSku
    And Each array element of array in response should contain value:
    ...    [data][0][attributes][abstractProducts]
    ...    price
    And Each array element of array in response should contain value:
    ...    [data][0][attributes][abstractProducts]
    ...    abstractName
    And Each array element of array in response should contain value:
    ...    [data][0][attributes][abstractProducts]
    ...    prices
    And Each array element of array in response should contain value:
    ...    [data][0][attributes][abstractProducts]
    ...    images
    And Each array element of array in response should contain value:
    ...    [data][0][attributes][abstractProducts]
    ...    abstractSku
    And Response body parameter should be:
    ...    [data][0][attributes][abstractProducts][0][prices][0][currency][code]
    ...    ${currency.eur.code}
    And Response body parameter should be:
    ...    [data][0][attributes][abstractProducts][0][prices][0][currency][symbol]
    ...    ${currency.eur.symbol}
    And Response body parameter should be:
    ...    [data][0][attributes][abstractProducts][0][prices][0][currency][name]
    ...    ${currency.eur.name}
    And Array element should contain property with value greater than at least once:
    ...    [data][0][attributes][abstractProducts][0][prices]    DEFAULT
    ...    1
    # FIlters - all filters are NOT applied
    And Each array element should contain property with value:    [data][0][attributes][valueFacets]    activeValue    None
    #Filters - category
    And Response body parameter should contain:    [data][0][attributes]    valueFacets
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][name]    category
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][localizedName]    Categories
    And Response should contain the array of size in:
    ...    [data][0][attributes][valueFacets][0][values]
    ...    ${default_qty.categories}
    ...    ${default_qty.categories_ssp}
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][config][isMultiValued]    False
    #Filters - labels
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][name]    label
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][localizedName]    Product Labels
    And Response should contain the array of size in:
    ...    [data][0][attributes][valueFacets][1][values]
    ...    ${default_qty.labels}
    ...    ${default_qty.labels_ssp}
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][config][isMultiValued]    True
    #Filters - color
    And Array element should contain property with value at least once:    [data][0][attributes][valueFacets]    name    farbe
    And Array element should contain property with value at least once:    [data][0][attributes][valueFacets]    localizedName    Color
    And Response should contain a nested array of a certain size at least once:    [data][0][attributes][valueFacets]    values    ${default_qty.colors}
    And Response body parameter should be:    [data][0][attributes][valueFacets][2][config][isMultiValued]    True
    # #Filters - material
    And Array element should contain property with value at least once:    [data][0][attributes][valueFacets]    name    material
    And Array element should contain property with value at least once:    [data][0][attributes][valueFacets]    localizedName    Material
    And Response should contain a nested array of a certain size at least once:    [data][0][attributes][valueFacets]    values    ${default_qty.materials}
    # #Filters - brand
    And Array element should contain property with value at least once:    [data][0][attributes][valueFacets]    name    brand
    And Array element should contain property with value at least once:    [data][0][attributes][valueFacets]    localizedName    Brand
    And Response should contain a nested array of a certain size at least once:    [data][0][attributes][valueFacets]    values    ${default_qty.brands}
    # #Filters - rating
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][name]    rating
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][localizedName]    Product Ratings
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][min]    ${default_rating.min}
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][max]    ${default_rating.max}
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMin]    ${default_rating.min}
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMax]    ${default_rating.max}
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][config][isMultiValued]    False
    # #Filters - category tree
    And Response should contain the array of size in:
    ...    [data][0][attributes][categoryTreeFilter]
    ...    ${category_tree_branches_qty}
    ...    ${category_tree_branches_qty_ssp}
    And Each array element of array in response should contain value:
    ...    [data][0][attributes][categoryTreeFilter]
    ...    nodeId
    And Each array element of array in response should contain value:
    ...    [data][0][attributes][categoryTreeFilter]
    ...    name
    And Each array element of array in response should contain value:
    ...    [data][0][attributes][categoryTreeFilter]
    ...    docCount
    And Each array element of array in response should contain value:
    ...    [data][0][attributes][categoryTreeFilter]
    ...    children
    # #Selflinks
    And Response body has correct self link
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][next]

Search_by_attribute_that_does_not_return_products
    When I send a GET request:    /catalog-search?q=fake
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    0
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    0
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    0
    #categories
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][0][values]    0
    #labels
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][1][values]    0
    #brand
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][4][values]    0
    And Response body has correct self link

Search_by_concrete_sku
    When I send a GET request:    /catalog-search?q=${concrete.alternative_products.product_1.sku}
    Then Response status code should be:    200
    When I send a GET request:    /catalog-search?q=${concrete.alternative_products.product_1.sku}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    1
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    1
    And Response body parameter should be:
    ...    [data][0][attributes][abstractProducts][0][abstractSku]
    ...    ${abstract.alternative_products.product_1.sku}
    And Response body parameter should be:
    ...    [data][0][attributes][abstractProducts][0][abstractName]
    ...    ${abstract.alternative_products.product_1.name}
    And Array element should contain property with value greater than at least once:    [data][0][attributes][abstractProducts][0][prices]    DEFAULT    10
    #categories
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][0][values]    4
    #labels
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][1][values]    2
    #brand
    And Response should contain a nested array of a certain size at least once:    [data][0][attributes][valueFacets]    values    1
    And Response body has correct self link

Search_by_abstract_sku
    When I send a GET request:    /catalog-search?q=${abstract.alternative_products.product_1.sku}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    1
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    1
    And Response body parameter should be:
    ...    [data][0][attributes][abstractProducts][0][abstractSku]
    ...    ${abstract.alternative_products.product_1.sku}
    And Response body parameter should be:
    ...    [data][0][attributes][abstractProducts][0][abstractName]
    ...    ${abstract.alternative_products.product_1.name}
    And Array element should contain property with value greater than at least once:    [data][0][attributes][abstractProducts][0][prices]    DEFAULT    10
    #categories
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][0][values]    4
    #labels
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][1][values]    2
    #brand
    And Response should contain a nested array of a certain size at least once:    [data][0][attributes][valueFacets]    values    1
    And Response body has correct self link

Search_by_full_name
    When I send a GET request:    /catalog-search?q=${abstract.alternative_products.product_1.name}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be greater than:
    ...    [data][0][attributes][pagination][numFound]
    ...    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Response body parameter should be:
    ...    [data][0][attributes][abstractProducts][0][abstractSku]
    ...    ${abstract.alternative_products.product_1.sku}
    And Response body parameter should be:
    ...    [data][0][attributes][abstractProducts][0][abstractName]
    ...    ${abstract.alternative_products.product_1.name}
    And Array element should contain property with value greater than at least once:    [data][0][attributes][abstractProducts][0][prices]    DEFAULT    10
    #categories
    And Response should contain the array larger than a certain size:
    ...    [data][0][attributes][valueFacets][0][values]
    ...    4
    #labels
    And Response should contain the array larger than a certain size:
    ...    [data][0][attributes][valueFacets][1][values]
    ...    2
    #brand
    And Response should contain the array larger than a certain size:
    ...    [data][0][attributes][valueFacets][4][values]
    ...    1
    And Response body has correct self link

Search_by_name_substring
    When I send a GET request:    /catalog-search?q=USB
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be greater than:
    ...    [data][0][attributes][pagination][numFound]
    ...    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Response body parameter should NOT be:
    ...    [data][0][attributes][abstractProducts][0][abstractSku]
    ...    ${abstract.alternative_products.product_1.sku}
    And Response body parameter should NOT be:
    ...    [data][0][attributes][abstractProducts][0][abstractName]
    ...    ${abstract.alternative_products.product_1.name}
    #categories
    And Response should contain the array larger than a certain size:
    ...    [data][0][attributes][valueFacets][0][values]
    ...    4
    #labels
    And Response should contain the array larger than a certain size:
    ...    [data][0][attributes][valueFacets][1][values]
    ...    2
    #brand
    And Response should contain a nested array of a certain size at least once:    [data][0][attributes][valueFacets]    values    8
    And Response body has correct self link

Search_by_attribute_(brand)
    When I send a GET request:    /catalog-search?q=${brand_1}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    18
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Response body parameter should contain:
    ...    [data][0][attributes][abstractProducts][0][abstractName]
    ...    ${brand_1}
    #brand
    And Response should contain a nested array of a certain size at least once:    [data][0][attributes][valueFacets]    values    1
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][activeValue]    None
    And Response body has correct self link

Search_by_several_attributes
    When I send a GET request:    /catalog-search?q=${color_3}+${material_3}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    20
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}

#### FILTERING #####

Filter_by_rating_only_min
    When I send a GET request:    /catalog-search?q=&rating[min]=3
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    20
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    #rating facets
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMin]    3
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMax]    ${default_rating.max}

Filter_by_rating_only_max
    When I send a GET request:    /catalog-search?q=&rating[max]=${default_rating.min}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    18
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    #rating facets
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMin]    ${default_rating.min}
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMax]    ${default_rating.min}

Filter_by_rating_Min_max
    When I send a GET request:    /catalog-search?q=&rating[min]=3&rating[max]=3
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    0
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    0
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    0
    #rating facets
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMin]    3
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMax]    3

Filter_by_brand_one_brand
    When I send a GET request:    /catalog-search?q=&brand=${brand_1}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    18
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Array element should contain property with value at least once:    [data][0][attributes][valueFacets]    activeValue    ${brand_1}
    And Response body has correct self link

Filter_by_brand_two_brands
    When I send a GET request:    /catalog-search?q=&brand[]=${brand_2}&brand[]=${brand_1}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    38
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Array element should contain property or array value at least once:    [data][0][attributes][valueFacets]    activeValue    ${brand_1}
    And Array element should contain property or array value at least once:    [data][0][attributes][valueFacets]    activeValue    ${brand_2}

Filter_by_brand_empty_brand    
    When I send a GET request:    /catalog-search?q=&brand=
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be in:
    ...    [data][0][attributes][pagination][numFound]
    ...    ${total_number_of_products_in_search}
    ...    ${total_number_of_products_in_search_ssp}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Array element should contain property with value at least once:    [data][0][attributes][valueFacets]    activeValue    ${EMPTY}
    And Response body has correct self link

Filter_by_brand_non_existing_brand
    When I send a GET request:    /catalog-search?q=&brand=test123
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    0
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    0
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    0
    And Array element should contain property with value at least once:    [data][0][attributes][valueFacets]    activeValue    test123
    And Response body has correct self link

Filter_by_label_one_label
    When I send a GET request:    /catalog-search?q=&label=${label.manual}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    5
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    5
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue]    ${label.manual}
    And Response body has correct self link

Filter_by_label_two_labels
    When I send a GET request:    /catalog-search?q=&label[]=${label.new}&label[]=${label.manual}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    39
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue][0]    ${label.new}
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue][1]    ${label.manual}

Filter_by_label_non_existing_label
    When I send a GET request:    /catalog-search?q=&label[]=test123
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    0
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    0
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    0
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue][0]    test123

Filter_by_label_empty_label
    When I send a GET request:    /catalog-search?q=&label[]=
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be in:
    ...    [data][0][attributes][pagination][numFound]
    ...    ${total_number_of_products_in_search}
    ...    ${total_number_of_products_in_search_ssp}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be in:    [data][0][attributes][pagination][maxPage]    ${default_qty.ipp_pages}    ${default_qty.ipp_pages_ssp}
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue][0]    ${EMPTY}

Filter_by_color_one_color
    When I send a GET request:    /catalog-search?q=&farbe=${color_1}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    4
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    4
    And Array element should contain property with value at least once:    [data][0][attributes][valueFacets]    activeValue    ${color_1}
    #additional checks that other filers react accordingly and reduce the number of available facets to match facets present for the found products
    And Response should contain the array smaller than a certain size:
    ...    [data][0][attributes][valueFacets][0]
    ...    ${default_qty.categories}
    And Response should contain the array smaller than a certain size:
    ...    [data][0][attributes][valueFacets][3]
    ...    ${default_qty.materials}
    And Response should contain the array smaller than a certain size:
    ...    [data][0][attributes][valueFacets][4]
    ...    ${default_qty.brands}
    And Response body has correct self link

Filter_by_color_two_colors
    When I send a GET request:    /catalog-search?q=&farbe[]=${color_1}&farbe[]=${color_2}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    10
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    10
    And Array element should contain property or array value at least once:    [data][0][attributes][valueFacets]    activeValue    ${color_1}
    And Array element should contain property or array value at least once:    [data][0][attributes][valueFacets]    activeValue    ${color_2}

Filter_by_color_non_existing_color
    When I send a GET request:    /catalog-search?q=&farbe[]=test123
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    0
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    0
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    0
    And Array element should contain property or array value at least once:    [data][0][attributes][valueFacets]    activeValue    test123

Filter_by_color_empty_color
    When I send a GET request:    /catalog-search?q=&farbe[]=
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be in:
    ...    [data][0][attributes][pagination][numFound]
    ...    ${total_number_of_products_in_search}
    ...    ${total_number_of_products_in_search_ssp}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be in:    [data][0][attributes][pagination][maxPage]    ${default_qty.ipp_pages}    ${default_qty.ipp_pages_ssp}
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][valueFacets][2][activeValue][0]    ${EMPTY}

Filter_by_material_one_material
    When I send a GET request:    /catalog-search?q=&material=${material_1}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    4
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    4
    And Array element should contain property with value at least once:    [data][0][attributes][valueFacets]    activeValue    ${material_1}
    #additional checks that other filers react accordingly and reduce the number of available facets to match facets present for the found products
    And Response should contain the array smaller than a certain size:
    ...    [data][0][attributes][valueFacets][0]
    ...    ${default_qty.categories}
    And Response should contain the array smaller than a certain size:
    ...    [data][0][attributes][valueFacets][2]
    ...    ${default_qty.colors}
    And Response should contain the array smaller than a certain size:
    ...    [data][0][attributes][valueFacets][4]
    ...    ${default_qty.brands}
    And Response body has correct self link

Filter_by_material_two_materials
    When I send a GET request:    /catalog-search?q=&material[]=${material_1}&material[]=${material_2}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    15
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Array element should contain property or array value at least once:    [data][0][attributes][valueFacets]    activeValue    ${material_1}
    And Array element should contain property or array value at least once:    [data][0][attributes][valueFacets]    activeValue    ${material_2}

Filter_by_material_non_existing_material
    When I send a GET request:    /catalog-search?q=&material[]=test123
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    0
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    0
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    0
    And Array element should contain property or array value at least once:    [data][0][attributes][valueFacets]    activeValue    test123

Filter_by_material_empty_material
    When I send a GET request:    /catalog-search?q=&material[]=
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be in:
    ...    [data][0][attributes][pagination][numFound]
    ...    ${total_number_of_products_in_search}
    ...    ${total_number_of_products_in_search_ssp}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be in:    [data][0][attributes][pagination][maxPage]    ${default_qty.ipp_pages}    ${default_qty.ipp_pages_ssp}
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][activeValue][0]    ${EMPTY}

Filter_by_valid_main_category
    When I send a GET request:    /catalog-search?q=&category=${category_lvl1.id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    ${category_lvl1.qty}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][activeValue]    ${category_lvl1.id}
    # check that category tree is correctly updated
    And Response should contain the array of size in:
    ...    [data][0][attributes][categoryTreeFilter]
    ...    ${category_tree_branches_qty}
    ...    ${category_tree_branches_qty_ssp}
    And Response body parameter should be:    [data][0][attributes][categoryTreeFilter][0][docCount]    0
    And Response body parameter should be either:
    ...    [data][0][attributes][categoryTreeFilter][3][docCount]
    ...    [data][0][attributes][categoryTreeFilter][4][docCount]
    ...    ${category_lvl1.qty}
    And Response body parameter should be either:
    ...    [data][0][attributes][categoryTreeFilter][3][children][0][docCount]
    ...    [data][0][attributes][categoryTreeFilter][4][children][0][docCount]
    ...    56
    And Response body parameter should be either:
    ...    [data][0][attributes][categoryTreeFilter][3][children][1][docCount]
    ...    [data][0][attributes][categoryTreeFilter][4][children][1][docCount]
    ...    39
    And Response body parameter should be either:
    ...    [data][0][attributes][categoryTreeFilter][3][children][0][children][0][docCount]
    ...    [data][0][attributes][categoryTreeFilter][4][children][0][children][0][docCount]
    ...    28
    And Response body has correct self link

Filter_by_valid_subcategory
    When I send a GET request:    /catalog-search?q=&category=${category_lvl2.id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be greater than:    [data][0][attributes][pagination][numFound]    ${category_lvl2.qty_approx}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][activeValue]    ${category_lvl2.id}
    # check that category tree is correctly updated
    And Response should contain the array of size in:
    ...    [data][0][attributes][categoryTreeFilter]
    ...    ${category_tree_branches_qty}
    ...    ${category_tree_branches_qty_ssp}
    And Response body parameter should be:    [data][0][attributes][categoryTreeFilter][0][docCount]    0
    And Array element should contain property or array value at least once:    [data][0][attributes][categoryTreeFilter]    docCount    ${category_lvl2.qty}
    And Response body parameter should be either:
    ...    [data][0][attributes][categoryTreeFilter][3][children][0][docCount]
    ...    [data][0][attributes][categoryTreeFilter][4][children][0][docCount]
    ...    ${category_lvl2.qty}
    And Response body parameter should be either:    [data][0][attributes][categoryTreeFilter][3][children][1][docCount]    [data][0][attributes][categoryTreeFilter][4][children][1][docCount]    0
    And Response body parameter should be either:
    ...    [data][0][attributes][categoryTreeFilter][3][children][0][children][0][docCount]
    ...    [data][0][attributes][categoryTreeFilter][4][children][0][children][0][docCount]
    ...    28
    And Response body parameter should be either:
    ...    [data][0][attributes][categoryTreeFilter][3][children][0][children][0][docCount]
    ...    [data][0][attributes][categoryTreeFilter][4][children][0][children][0][docCount]
    ...    28
    And Response body has correct self link

Filter_by_valid_sub_subcategory
    When I send a GET request:    /catalog-search?q=&category=${category_lvl3.id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    ${category_lvl3.qty}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][activeValue]    ${category_lvl3.id}
    # check that category tree is correctly updated
    And Response should contain the array of size in:
    ...    [data][0][attributes][categoryTreeFilter]
    ...    ${category_tree_branches_qty}
    ...    ${category_tree_branches_qty_ssp}
    And Response body parameter should be:    [data][0][attributes][categoryTreeFilter][0][docCount]    0
    And Response body parameter should be either:
    ...    [data][0][attributes][categoryTreeFilter][3][docCount]
    ...    [data][0][attributes][categoryTreeFilter][4][docCount]
    ...    ${category_lvl3.qty}
    And Response body parameter should be either:
    ...    [data][0][attributes][categoryTreeFilter][3][children][0][docCount]
    ...    [data][0][attributes][categoryTreeFilter][4][children][0][docCount]
    ...    ${category_lvl3.qty}
    And Response body parameter should be either:    [data][0][attributes][categoryTreeFilter][3][children][1][docCount]    [data][0][attributes][categoryTreeFilter][4][children][1][docCount]    0
    And Response body parameter should be either:
    ...    [data][0][attributes][categoryTreeFilter][3][children][0][children][0][docCount]
    ...    [data][0][attributes][categoryTreeFilter][4][children][0][children][0][docCount]
    ...    ${category_lvl3.qty}
    And Response body parameter should be either:
    ...    [data][0][attributes][categoryTreeFilter][3][children][0][children][1][docCount]
    ...    [data][0][attributes][categoryTreeFilter][4][children][0][children][1][docCount]
    ...    0
    And Response body has correct self link

Search_with_specific_currency
    When I send a GET request:    /catalog-search?q=&currency=${currency.chf.code}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be in:
    ...    [data][0][attributes][pagination][numFound]
    ...    ${total_number_of_products_in_search}
    ...    ${total_number_of_products_in_search_ssp}
    ...    416
    And Response body parameter should be greater than:    [data][0][attributes][pagination][numFound]    1
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Response body parameter should be:
    ...    [data][0][attributes][abstractProducts][0][prices][0][currency][code]
    ...    ${currency.chf.code}
    And Response body parameter should be:
    ...    [data][0][attributes][abstractProducts][0][prices][0][currency][symbol]
    ...    ${currency.chf.symbol}
    And Response body parameter should be:
    ...    [data][0][attributes][abstractProducts][0][prices][0][currency][name]
    ...    ${currency.chf.name}
    And Array element should contain property with value greater than at least once:    [data][0][attributes][abstractProducts][0][prices]    DEFAULT    1
    And Response body has correct self link

##### PAGINATION AND SORTING #####

Search_set_specific_page_with_ipp.default
    # here page 4 is selected using offset because 36/12=3 full pages, search shows the next page after the offset
    When I send a GET request:    /catalog-search?q=&page[limit]=${ipp.default}&page[offset]=36
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be in:
    ...    [data][0][attributes][pagination][numFound]
    ...    ${total_number_of_products_in_search}
    ...    ${total_number_of_products_in_search_ssp}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    4
    And Response body parameter should be in:    [data][0][attributes][pagination][maxPage]    ${default_qty.ipp_pages}    ${default_qty.ipp_pages_ssp}
    And Response body parameter should be:
    ...    [data][0][attributes][pagination][config][defaultItemsPerPage]
    ...    ${ipp.default}
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Response body parameter should not be EMPTY:    [links][self]
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][prev]
    And Response body parameter should not be EMPTY:    [links][next]

Search_set_specific_page_and_nonipp.default
    When I send a GET request:    /catalog-search?q=&page[limit]=${ipp.middle}&page[offset]=36
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be in:
    ...    [data][0][attributes][pagination][numFound]
    ...    ${total_number_of_products_in_search}
    ...    ${total_number_of_products_in_search_ssp}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    2
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    18
    And Response body parameter should be:
    ...    [data][0][attributes][pagination][config][defaultItemsPerPage]
    ...    ${ipp.default}
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.middle}
    And Response body parameter should not be EMPTY:    [links][self]
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][prev]
    And Response body parameter should not be EMPTY:    [links][next]

Search_set_last_page_and_nonipp.default
    When I send a GET request:
    ...    /catalog-search?q=&page[limit]=${ipp.biggest}&page[offset]=${total_number_of_products_in_search}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be in:
    ...    [data][0][attributes][pagination][numFound]
    ...    ${total_number_of_products_in_search}
    ...    ${total_number_of_products_in_search_ssp}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    12
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    12
    And Response body parameter should be:
    ...    [data][0][attributes][pagination][config][defaultItemsPerPage]
    ...    ${ipp.default}
    And Response should contain the array larger than a certain size:    [data][0][attributes][abstractProducts]    1
    And Response body parameter should not be EMPTY:    [links][self]
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][prev]

Search_set_invalid_ipp
    When I send a GET request:    /catalog-search?q=&page[limit]=18&page[offset]=1
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be in:
    ...    [data][0][attributes][pagination][numFound]
    ...    ${total_number_of_products_in_search}
    ...    ${total_number_of_products_in_search_ssp}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be in:    [data][0][attributes][pagination][maxPage]    ${default_qty.ipp_pages}    ${default_qty.ipp_pages_ssp}
    And Response body parameter should be:
    ...    [data][0][attributes][pagination][config][defaultItemsPerPage]
    ...    ${ipp.default}
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][abstractProducts]
    ...    ${ipp.default}
    And Response body parameter should not be EMPTY:    [links][self]
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][next]

Search_sort_by_name_asc
    When I send a GET request:    /catalog-search?q=&sort=name_asc
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][sort][currentSortParam]    name_asc
    And Response body parameter should be:    [data][0][attributes][sort][currentSortOrder]    asc
    And Response body parameter should start with:    [data][0][attributes][abstractProducts][0][abstractName]    A
    And Response body has correct self link

Search_sort_by_name_desc
    When I send a GET request:    /catalog-search?q=&sort=name_desc
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][sort][currentSortParam]    name_desc
    And Response body parameter should be:    [data][0][attributes][sort][currentSortOrder]    desc
    And Response body parameter should start with:    [data][0][attributes][abstractProducts][0][abstractName]    X
    And Response body has correct self link

Search_sort_by_rating
    When I send a GET request:    /catalog-search?q=&sort=rating
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][sort][currentSortParam]    rating
    And Response body parameter should be:    [data][0][attributes][sort][currentSortOrder]    desc
    And Response body parameter should be:
    ...    [data][0][attributes][abstractProducts][0][abstractSku]
    ...    ${abstract_sku_highest_rating}
    And Response body has correct self link

Search_sort_by_price_asc
    When I send a GET request:    /catalog-search?q=&sort=price_asc
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][sort][currentSortParam]    price_asc
    And Response body parameter should be:    [data][0][attributes][sort][currentSortOrder]    asc
    And Array element should contain property with value less than at least once:    [data][0][attributes][abstractProducts][0][prices]    DEFAULT    50
    And Response body has correct self link

Search_sort_by_price_desc
    When I send a GET request:    /catalog-search?q=&sort=price_desc
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][sort][currentSortParam]    price_desc
    And Response body parameter should be:    [data][0][attributes][sort][currentSortOrder]    desc
    And Array element should contain property with value greater than at least once:    [data][0][attributes][abstractProducts][0][prices]    DEFAULT    10000
    And Response body has correct self link

Search_sort_by_price_filter_query_parameter_and_pagination
    When I send a GET request:
    ...    /catalog-search?q=soe&sort=price_desc&brand=${brand_1}&page[limit]=${ipp.middle}&page[offset]=1
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][sort][currentSortParam]    price_desc
    And Response body parameter should be:    [data][0][attributes][sort][currentSortOrder]    desc
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    18
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    18
    And Array element should contain property with value at least once:    [data][0][attributes][valueFacets]    activeValue    ${brand_1}
    And Array element should contain property with value greater than at least once:    [data][0][attributes][abstractProducts][0][prices]    DEFAULT    5000

Search_by_abstract_sku_with_abstract_include
    When I send a GET request:
    ...    /catalog-search?q=${abstract.alternative_products.product_1.sku}&include=abstract-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    1
    And Response body parameter should be:
    ...    [data][0][attributes][abstractProducts][0][abstractSku]
    ...    ${abstract.alternative_products.product_1.sku}
    And Response body parameter should be:
    ...    [data][0][attributes][abstractProducts][0][abstractName]
    ...    ${abstract.alternative_products.product_1.name}
    And Response should contain the array of a certain size:    [data][0][relationships][abstract-products][data]    1
    And Response should contain the array of a certain size:    [included]    1
    And Response include should contain certain entity type:    abstract-products
    And Response include element has self link:    abstract-products
    And Response body parameter should be:    [included][0][id]    ${abstract.alternative_products.product_1.sku}
    And Response body has correct self link
