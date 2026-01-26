*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    spryker-core    navigation    category-management
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
To_retrieve_a_navigation_tree
    When I send a GET request:    /navigations/MAIN_NAVIGATION
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    navigations
    And Response body parameter should be:    [data][id]    MAIN_NAVIGATION
    And Response Body parameter should have datatype:    [data][attributes][name]    str
    And Response Body parameter should have datatype:    [data][attributes][isActive]    bool
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    resourceId
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    nodeType
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    isActive
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    title
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    url
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    cssClass
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    validFrom
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    validTo
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes]    children
    And Response Body parameter should have datatype:    [data][attributes][nodes][0][nodeType]    str
    And Response Body parameter should have datatype:    [data][attributes][nodes][0][title]    str
    And Response Body parameter should have datatype:    [data][attributes][nodes][0][children]    list
    And Response body parameter should not be EMPTY:    [data][attributes][nodes][0][nodeType]
    And Response body parameter should not be EMPTY:    [data][attributes][nodes][0][title]
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes][0][children]   resourceId
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes][0][children]   nodeType
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes][0][children]   isActive
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes][0][children]   title
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes][0][children]   url
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes][0][children]   cssClass
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes][0][children]   validFrom
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes][0][children]   validTo
    And Each Array Element Of Array In Response Should Contain Property:    [data][attributes][nodes][0][children]   children
    And Response body has correct self link internal

Get_navigation_tree_using_valid_navigation_key_with_category_nodes_included
    When I send a GET request:    /navigations/MAIN_NAVIGATION?include=category-nodes
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    navigations
    And Response body parameter should be:    [data][id]    MAIN_NAVIGATION
    And Response Should Contain The Array Larger Than a Certain Size:    [included]    0
    And Response Should Contain The Array Larger Than a Certain Size:    [data][relationships]    0
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][category-nodes]
    And Each Array Element Of Array In Response Should Contain Property:    [data][relationships][category-nodes][data]    type
    And Each Array Element Of Array In Response Should Contain Property:    [data][relationships][category-nodes][data]    id
    And Response body parameter should not be EMPTY:    [included]
    And Each Array Element Of Array In Response Should Contain Property:    [included]    type
    And Each Array Element Of Array In Response Should Contain Property:    [included]    id
    And Each Array Element Of Array In Response Should Contain Property:    [included]    attributes
    And Each Array Element Of Array In Response Should Contain Property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Each Array Element Of Array In Response Should Contain Property With Value:    [included]    type    category-nodes
    And Each Array Element Of Array In Response Should Contain Nested Property:    [included]    attributes    nodeId
    And Each Array Element Of Array In Response Should Contain Nested Property:    [included]    attributes    name
    And Each Array Element Of Array In Response Should Contain Nested Property:    [included]    attributes    metaTitle
    And Each Array Element Of Array In Response Should Contain Nested Property:    [included]    attributes    metaKeywords
    And Each Array Element Of Array In Response Should Contain Nested Property:    [included]    attributes    metaDescription
    And Each Array Element Of Array In Response Should Contain Nested Property:    [included]    attributes    isActive
    And Each Array Element Of Array In Response Should Contain Nested Property:    [included]    attributes    order
    And Each Array Element Of Array In Response Should Contain Nested Property:    [included]    attributes    url
    And Each Array Element Of Array In Response Should Contain Nested Property:    [included]    attributes    children
    And Each Array Element Of Array In Response Should Contain Nested Property:    [included]    attributes    parents