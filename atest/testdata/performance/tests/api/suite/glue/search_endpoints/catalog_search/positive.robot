*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    search    catalog   product


*** Test Cases ***
Search_with_empty_search_criteria_all_default_values_check
    When I send a GET request:    /catalog-search?q=
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][spellingSuggestion]    None
    #Sorting
    And Response should contain the array of a certain size:    [data][0][attributes][sort][sortParamNames]    ${default_qty.sorting_options}
    And Response should contain the array of a certain size:    [data][0][attributes][sort][sortParamLocalizedNames]    ${default_qty.sorting_options}
    And Response body parameter should contain:    [data][0][attributes]    currentSortParam
    And Response body parameter should contain:    [data][0][attributes]    currentSortOrder
    #Pagination
    And Response body parameter should be greater than:    [data][0][attributes][pagination][numFound]    ${min_number_of_products_in_search}
    And Response body parameter should be less than:    [data][0][attributes][pagination][numFound]    ${max_number_of_products_in_search}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    ${default_qty.ipp_pages}
    And Response body parameter should be:    [data][0][attributes][pagination][currentItemsPerPage]    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][pagination][config][defaultItemsPerPage]    ${ipp.default}
    And Response should contain the array of a certain size:    [data][0][attributes][pagination][config][validItemsPerPageOptions]    3
    And Response body parameter should contain:    [data][0][attributes][pagination][config][validItemsPerPageOptions]    ${ipp.default}
    And Response body parameter should contain:    [data][0][attributes][pagination][config][validItemsPerPageOptions]    ${ipp.middle}
    And Response body parameter should contain:    [data][0][attributes][pagination][config][validItemsPerPageOptions]    ${ipp.biggest}
    #Abstract products
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.default}
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    abstractSku
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    price
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    abstractName
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    prices
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    images
    And Each array element of array in response should contain value:    [data][0][attributes][abstractProducts]    abstractSku
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][prices][0][currency][code]    ${currency.eur.code}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][prices][0][currency][symbol]    ${currency.eur.symbol}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][prices][0][currency][name]    ${currency.eur.name}
    And Array element should contain property with value greater than at least once:    [data][0][attributes][abstractProducts][0][prices]    DEFAULT    1
    #Filters - category
    And Response body parameter should contain:    [data][0][attributes]    valueFacets
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][name]    category
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][localizedName]    Categories
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][0][values]    ${default_qty.categories}
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][config][isMultiValued]    False
    #Filters - labels
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][name]    label
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][localizedName]    Product Labels
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][1][values]    ${default_qty.labels}
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][config][isMultiValued]    True
    #Filters - product class
    And Response body parameter should be in:    [data][0][attributes][valueFacets][2][name]    Product Class    product-class
    And Response body parameter should be in:    [data][0][attributes][valueFacets][2][localizedName]    Product Class    Product Classes
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][2][values]    ${default_qty.product_classes}
    And Response body parameter should be:    [data][0][attributes][valueFacets][2][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][2][config][isMultiValued]    True
    #Filters - color
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][name]    color
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][localizedName]    Color
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][3][values]    ${default_qty.colors}
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][config][isMultiValued]    True
    #Filters - material
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][name]    storage_capacity
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][localizedName]    Storage Capacity
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][4][values]    ${default_qty.material}
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][4][config][isMultiValued]    True
    #Filters - brand
    And Response body parameter should be:    [data][0][attributes][valueFacets][5][name]    brand
    And Response body parameter should be:    [data][0][attributes][valueFacets][5][localizedName]    Brand
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][5][values]    ${default_qty.brands}
    And Response body parameter should be:    [data][0][attributes][valueFacets][5][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][5][config][isMultiValued]    False
    #Filters - rating
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][name]    price-DEFAULT-EUR-GROSS_MODE
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][localizedName]    Price range
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][min]    ${default_price_range.min}
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][max]    ${default_price_range.max}
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMin]    ${default_price_range.min}
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMax]    ${default_price_range.max}
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][config][isMultiValued]    False
    #Filters - category tree
    And Response should contain the array of a certain size:    [data][0][attributes][categoryTreeFilter]    ${category_tree_branches_qty}
    And Each array element of array in response should contain value:    [data][0][attributes][categoryTreeFilter]   nodeId
    And Each array element of array in response should contain value:    [data][0][attributes][categoryTreeFilter]   name
    And Each array element of array in response should contain value:    [data][0][attributes][categoryTreeFilter]   docCount
    And Each array element of array in response should contain value:    [data][0][attributes][categoryTreeFilter]   children
    #Selflinks
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
    When I send a GET request:    /catalog-search?q=${concrete_product_with_alternative.sku}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    1
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    1
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractSku]    ${concrete_product_with_alternative.abstract_sku}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractName]    ${concrete_product_with_alternative.name}
    And Array element should contain property with value greater than at least once:    [data][0][attributes][abstractProducts][0][prices]    DEFAULT    10
    #categories
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][0][values]    4
    #labels
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][1][values]    1
    #brand
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][5][values]    1
    And Response body has correct self link

Search_by_abstract_sku
    When I send a GET request:    /catalog-search?q=${concrete_product_with_alternative.abstract_sku}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    1
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    1
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractSku]    ${concrete_product_with_alternative.abstract_sku}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractName]    ${concrete_product_with_alternative.name}
    And Array element should contain property with value greater than at least once:    [data][0][attributes][abstractProducts][0][prices]    DEFAULT    10
    #categories
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][0][values]    4
    #labels
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][1][values]    1
    #brand
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][5][values]    1
    And Response body has correct self link

Search_by_full_name
    When I send a GET request:    /catalog-search?q=${concrete_product_with_alternative.name}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be greater than:    [data][0][attributes][pagination][numFound]    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractSku]    ${concrete_product_with_alternative.abstract_sku}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractName]    ${concrete_product_with_alternative.name}
    And Array element should contain property with value greater than at least once:    [data][0][attributes][abstractProducts][0][prices]    DEFAULT    10
    #categories
    And Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][0][values]    4
    #labels
    And Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][1][values]    0
    #brand
    And Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][5][values]    1
    And Response body has correct self link

Search_by_name_substring
    When I send a GET request:    /catalog-search?q=ACER
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be greater than:    [data][0][attributes][pagination][numFound]    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.default}
    And Response body parameter should NOT be:    [data][0][attributes][abstractProducts][0][abstractSku]    ${concrete_product_with_alternative.abstract_sku}
    And Response body parameter should NOT be:   [data][0][attributes][abstractProducts][0][abstractName]    ${concrete_product_with_alternative.name}
    #categories
    And Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][0][values]    4
    #labels
    And Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][1][values]    0
    #brand
    And Response should contain the array larger than a certain size:    [data][0][attributes][valueFacets][5][values]    1
    And Response body has correct self link

Search_by_attribute_(brand)
    When I send a GET request:    /catalog-search?q=${brand_1}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    21
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.default}
    And Response body parameter should contain:   [data][0][attributes][abstractProducts][0][abstractName]    ${brand_1}
    #brand
    And Response should contain the array of a certain size:    [data][0][attributes][valueFacets][5][values]    2
    And Response body parameter should be:    [data][0][attributes][valueFacets][5][activeValue]    None
    And Response body parameter should be:    [data][0][attributes][valueFacets][5][values][0][value]    ${brand_1}
    And Response body has correct self link

Search_by_several_attributes
    When I send a GET request:    /catalog-search?q=${color_3}+${material_3}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    2
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    2

# FILTERING #

Filter_by_rating_only_min
    When I send a GET request:    /catalog-search?q=&rating[min]=3
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    6
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.default_3}
    #rating facets
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMin]    ${default_active.min}
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMax]    ${default_active.max}
    And Response body parameter should not be EMPTY:    [data][0][attributes][rangeFacets][0][activeMin]
    And Response body parameter should not be EMPTY:    [data][0][attributes][rangeFacets][0][activeMax]


Filter_by_rating_only_max
    When I send a GET request:    /catalog-search?q=&rating[max]=${default_price_range.max}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    6
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.default_3}
    #rating facets
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMin]    ${default_active.min}
    And Response body parameter should be:    [data][0][attributes][rangeFacets][0][activeMax]    ${default_active.max}
    And Response body parameter should not be EMPTY:    [data][0][attributes][rangeFacets][0][activeMin]
    And Response body parameter should not be EMPTY:    [data][0][attributes][rangeFacets][0][activeMax]


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
    And Response body parameter should be:    [data][0][attributes][rangeFacets][1][activeMin]    3
    And Response body parameter should be:    [data][0][attributes][rangeFacets][1][activeMax]    3

Filter_by_brand_one_brand
    When I send a GET request:    /catalog-search?q=&brand=${brand_1}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    19
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][valueFacets][5][activeValue]    ${brand_1}
    And Response body has correct self link

Filter_by_brand_two_brands
    When I send a GET request:    /catalog-search?q=&brand[]=${brand_2}&brand[]=${brand_1}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    19
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][valueFacets][5][activeValue][0]    ${brand_2}
    And Response body parameter should be:    [data][0][attributes][valueFacets][5][activeValue][1]    ${brand_1}

Filter_by_brand_empty_brand
    When I send a GET request:    /catalog-search?q=&brand=
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be greater than:    [data][0][attributes][pagination][numFound]    ${min_number_of_products_in_search}
    And Response body parameter should be less than:    [data][0][attributes][pagination][numFound]    ${max_number_of_products_in_search}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][valueFacets][5][activeValue]    ${EMPTY}
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
    And Response body parameter should be:    [data][0][attributes][valueFacets][5][activeValue]    test123
    And Response body has correct self link

Filter_by_label_one_label
    When I send a GET request:    /catalog-search?q=&label=${label.new}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    5
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    5
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue]    ${label.new}
    And Response body has correct self link

Filter_by_label_two_labels
    When I send a GET request:    /catalog-search?q=&label[]=${label.new}&label[]=${label.sale}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be greater than:    [data][0][attributes][pagination][numFound]    65
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue][0]    ${label.new}
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue][1]    ${label.sale}

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
    And Response body parameter should be greater than:    [data][0][attributes][pagination][numFound]    ${min_number_of_products_in_search}
    And Response body parameter should be less than:    [data][0][attributes][pagination][numFound]    ${max_number_of_products_in_search}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    ${default_qty.ipp_pages}
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][valueFacets][1][activeValue][0]    ${EMPTY}

Filter_by_color_one_color
    When I send a GET request:    /catalog-search?q=&color=${color_2}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    10
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    10
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][activeValue]    ${color_2}
    #additional checks that other filers react accordingly and reduce the number of available facets to match facets present for the found products
    And Response should contain the array smaller than a certain size:   [data][0][attributes][valueFacets][0]    ${default_qty.categories}
    And Response should contain the array smaller than a certain size:   [data][0][attributes][valueFacets][3]    ${default_qty.materials}
    And Response should contain the array smaller than a certain size:    [data][0][attributes][valueFacets][5]    ${default_qty.brands}
    And Response body has correct self link

Filter_by_color_two_colors
    When I send a GET request:    /catalog-search?q=&color[]=${color_1}&color[]=${color_2}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    10
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    10
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][activeValue][0]    ${color_1}
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][activeValue][1]    ${color_2}

Filter_by_color_non_existing_color
    When I send a GET request:    /catalog-search?q=&color[]=test123
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    0
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    0
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    0
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    0
    And Response body parameter should be:    [data][0][attributes][valueFacets][3][activeValue][0]    test123

Filter_by_color_empty_color
    When I send a GET request:    /catalog-search?q=&color[]=
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be greater than:    [data][0][attributes][pagination][numFound]    ${min_number_of_products_in_search}
    And Response body parameter should be less than:    [data][0][attributes][pagination][numFound]    ${max_number_of_products_in_search}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    ${default_qty.ipp_pages}
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.default}
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
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][activeValue]    ${category_lvl1.id}
    # check that category tree is correctly updated
    And Response should contain the array of a certain size:    [data][0][attributes][categoryTreeFilter]    ${category_tree_branches_qty}
    And Response body parameter should be:    [data][0][attributes][categoryTreeFilter][0][docCount]    0
    And Array element should contain property with value at least once:    [data][0][attributes][categoryTreeFilter]    docCount    ${${category_lvl1.qty}}
    And Array element should contain nested array with property and value at least once:    [data][0][attributes][categoryTreeFilter]    [children]    docCount    ${category_lvl2.qty}
    And Response body has correct self link

Filter_by_valid_subcategory
    When I send a GET request:    /catalog-search?q=&category=${category_lvl2.id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][pagination][numFound]    ${category_lvl2.qty}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][valueFacets][0][activeValue]    ${category_lvl2.id}
    # check that category tree is correctly updated
    And Response should contain the array of a certain size:    [data][0][attributes][categoryTreeFilter]    ${category_tree_branches_qty}
    And Response body parameter should be:    [data][0][attributes][categoryTreeFilter][0][docCount]    0
    And Array element should contain property with value at least once:    [data][0][attributes][categoryTreeFilter]    docCount    ${${category_lvl2.qty}}
    And Array element should contain nested array with property and value at least once:    [data][0][attributes][categoryTreeFilter]    [children]    docCount    ${category_lvl2.qty}
    And Response body parameter should be less than:    [data][0][attributes][categoryTreeFilter][3][children][0][children][0][docCount]    ${category_lvl2.qty}
    And Response body has correct self link

Search_with_specific_currency
    When I send a GET request:    /catalog-search?q=&currency=${currency.chf.code}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be greater than:    [data][0][attributes][pagination][numFound]    1
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be greater than:    [data][0][attributes][pagination][maxPage]    1
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.default}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][prices][0][currency][code]    ${currency.chf.code}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][prices][0][currency][symbol]    ${currency.chf.symbol}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][prices][0][currency][name]    ${currency.chf.name}
    And Array element should contain property with value greater than at least once:    [data][0][attributes][abstractProducts][0][prices]    DEFAULT    1
    And Response body has correct self link

# PAGINATION AND SORTING #

Search_set_specific_page_with_default_ipp
    # here page 4 is selected using offset because 36/12=3 full pages, search shows the next page after the offset
    When I send a GET request:    /catalog-search?q=&page[limit]=${ipp.default}&page[offset]=36
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be greater than:    [data][0][attributes][pagination][numFound]    ${min_number_of_products_in_search}
    And Response body parameter should be less than:    [data][0][attributes][pagination][numFound]    ${max_number_of_products_in_search}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    4
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    ${default_qty.ipp_pages}
    And Response body parameter should be:    [data][0][attributes][pagination][config][defaultItemsPerPage]    ${ipp.default}
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.default}
    And Response body parameter should not be EMPTY:    [links][self]
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][prev]
    And Response body parameter should not be EMPTY:    [links][next]


Search_set_specific_page_and_nondefault_ipp
    When I send a GET request:    /catalog-search?q=&page[limit]=${ipp.middle}&page[offset]=36
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be greater than:    [data][0][attributes][pagination][numFound]    ${min_number_of_products_in_search}
    And Response body parameter should be less than:    [data][0][attributes][pagination][numFound]    ${max_number_of_products_in_search}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    2
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    10
    And Response body parameter should be:    [data][0][attributes][pagination][config][defaultItemsPerPage]    ${ipp.default}
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.middle}
    And Response body parameter should not be EMPTY:    [links][self]
    And Response body parameter should not be EMPTY:    [links][last]
    And Response body parameter should not be EMPTY:    [links][first]
    And Response body parameter should not be EMPTY:    [links][prev]
    And Response body parameter should not be EMPTY:    [links][next]

Search_set_last_page_and_nondefault_ipp
    When I send a GET request:    /catalog-search?q=&page[limit]=${ipp.biggest}&page[offset]=${total_number_of_products_in_search}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be greater than:    [data][0][attributes][pagination][numFound]    ${min_number_of_products_in_search}
    And Response body parameter should be less than:    [data][0][attributes][pagination][numFound]    ${max_number_of_products_in_search}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    7
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    7
    And Response body parameter should be:    [data][0][attributes][pagination][config][defaultItemsPerPage]    ${ipp.default}
    And Response should contain the array larger than a certain size:    [data][0][attributes][abstractProducts]    0
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
    And Response body parameter should be greater than:    [data][0][attributes][pagination][numFound]    ${min_number_of_products_in_search}
    And Response body parameter should be less than:    [data][0][attributes][pagination][numFound]    ${max_number_of_products_in_search}
    And Response body parameter should be:    [data][0][attributes][pagination][currentPage]    1
    And Response body parameter should be:    [data][0][attributes][pagination][maxPage]    ${default_qty.ipp_pages}
    And Response body parameter should be:    [data][0][attributes][pagination][config][defaultItemsPerPage]    ${ipp.default}
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    ${ipp.default}
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
    And Response body parameter should start with:    [data][0][attributes][abstractProducts][0][abstractName]    V
    And Response body has correct self link

Search_sort_by_rating
    When I send a GET request:    /catalog-search?q=&sort=rating
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][sort][currentSortParam]    rating
    And Response body parameter should be:    [data][0][attributes][sort][currentSortOrder]    desc
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractSku]    ${abstract_sku_highest_rating}
    And Response body has correct self link


Search_sort_by_price_asc
    When I send a GET request:    /catalog-search?q=&sort=price_asc
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response body parameter should be:    [data][0][attributes][sort][currentSortParam]    price_asc
    And Response body parameter should be:    [data][0][attributes][sort][currentSortOrder]    asc
    And Array element should contain property with value less than at least once:    [data][0][attributes][abstractProducts][0][prices]    DEFAULT    170
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

Search_by_abstract_sku_with_abstract_include
    When I send a GET request:    /catalog-search?q=${concrete_product_with_alternative.abstract_sku}&include=abstract-products
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    catalog-search
    And Response should contain the array of a certain size:    [data][0][attributes][abstractProducts]    1
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractSku]    ${concrete_product_with_alternative.abstract_sku}
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractName]    ${concrete_product_with_alternative.name}
    And Response should contain the array of a certain size:    [data][0][relationships][abstract-products][data]    1
    And Response should contain the array of a certain size:    [included]    1
    And Response include should contain certain entity type:    abstract-products
    And Response include element has self link:   abstract-products
    And Response body parameter should be:    [included][0][id]  ${concrete_product_with_alternative.abstract_sku}
    And Response body has correct self link
