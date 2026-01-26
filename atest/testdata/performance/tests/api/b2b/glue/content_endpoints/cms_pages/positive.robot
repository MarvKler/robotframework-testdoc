*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/cms_steps.robot
Test Tags    glue    cms    content-item

*** Test Cases ***
Get_cms_pages_list
    When I send a GET request:    /cms-pages
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    ${cms_page.qty}
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body array element should contain property with value at least once:    [data]    [attributes][name]    ${cms_page.name}
    And Response body array element should contain property with value at least once:    [data]    [attributes][url]    ${cms_page.url_en}
    And Each array element of array in response should contain property with value:    [data]    type    cms-pages
    And Each array element of array in response should contain nested property with value:
    ...    [data]
    ...    [attributes][isSearchable]
    ...    True
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    links
    And Each array element of array in response should contain value:    [data]    pageKey
    And Each array element of array in response should contain value:    [data]    name
    And Each array element of array in response should contain value:    [data]    validTo
    And Each array element of array in response should contain value:    [data]    url
    And Response body has correct self link

Get_specific_cms_page
    [Setup]    Run Keywords    I send a GET request:    /cms-pages
    ...    AND    Response status code should be:    200
    ...    AND    Save value to a variable:    [data][0][id]    cms_page_id
    API_test_setup
    When I send a GET request:    /cms-pages/${cms_page_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cms_page_id}
    And Response body parameter should be:    [data][type]    cms-pages
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    And Response body parameter should not be EMPTY:    [data][attributes][url]
    And Response body parameter should not be EMPTY:    [data][attributes][isSearchable]
    And Response body should contain:    pageKey
    And Response body should contain:    validTo
    And Response body has correct self link internal

Get_specific_cms_with_includes
    [Setup]    Add content product abstract list to cms page in DB    ${cms_page.product_lists_id}
    API_test_setup
    When I send a GET request:    /cms-pages/${cms_page.product_lists_id}?include=content-product-abstract-lists
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cms_page.product_lists_id}
    And Response body parameter should be:    [data][type]    cms-pages
    And Response body parameter should be:    [data][attributes][name]    ${cms_page.product_lists_name}
    And Response body has correct self link internal
    And Response should contain the array of a certain size:    [data][relationships][content-product-abstract-lists][data]    1
    And Response should contain the array of a certain size:    [included]    1
    And Response include should contain certain entity type:    content-product-abstract-lists
    And Response include element has self link:    content-product-abstract-lists
    [Teardown]    Run Keyword    Delete latest cms page version by uuid from DB    ${cms_page.product_lists_id}
