*** Settings ***
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        API_test_setup
Test Tags    glue    spryker-core

*** Test Cases ***
Get_url_collections_by_url_paramater_of_category_nodes
    When I send a GET request:    /url-resolver?url=${url_resolver.category_nodes_url}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Array in response should contain property with value:    [data]    type    url-resolver
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should be:    [data][0][attributes][entityType]    ${url_resolver.category_nodes_entity}
    And Response body parameter should be:    [data][0][attributes][entityId]    ${url_resolver.category_nodes_id}
    And Each array element of array in response should contain nested property:    [data]     links    self
    And Response body has correct self link

Get_url_collections_by_url_paramater_of_product
    When I send a GET request:    /url-resolver?url=${url_resolver.abstract_product}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Array in response should contain property with value:    [data]    type    url-resolver
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should be:    [data][0][attributes][entityType]    ${url_resolver.product_entity}
    And Response body parameter should be:    [data][0][attributes][entityId]    ${url_resolver.product_id}
    And Each array element of array in response should contain nested property:    [data]     links    self
    And Response body has correct self link

Get_url_collections_by_url_paramater_of_cms_page
    When I send a GET request:    /url-resolver?url=${url_resolver.cms_url}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Array in response should contain property with value:    [data]    type    url-resolver
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should be:    [data][0][attributes][entityType]    ${url_resolver.cms_entity}
    And Response body parameter should be:    [data][0][attributes][entityId]    ${url_resolver.cms_id}
    And Each array element of array in response should contain nested property:    [data]     links    self
    And Response body has correct self link

Get_url_collections_by_url_parameters_returns_id
   [Documentation]   CC-16595 API: ID is missing from url resolver.
   [Tags]    skip-due-to-issue
    When I send a GET request:    /url-resolver?url=${url_resolver.category_nodes_url}
    Then Response status code should be:    200
    And Response body parameter should not be EMPTY:    [data][id]
    When I send a GET request:    /url-resolver?url=${url_resolver.abstract_product}
    Then Response status code should be:    200
    And Response body parameter should not be EMPTY:    [data][id]
    When I send a GET request:    /url-resolver?url=${url_resolver.cms_url}
    Then Response status code should be:    200
    And Response body parameter should not be EMPTY:    [data][id]