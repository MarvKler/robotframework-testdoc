*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    product-labels    alternative-products    discontinued-products

*** Test Cases *** 
Get_manual_product_label_by_id
    [Documentation]   https://spryker.atlassian.net/browse/CC-25716
    [Tags]    skip-due-to-issue  
    When I send a GET request:    /product-labels/${label_standard.id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${label_standard.id}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${label_standard.name}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should contain:    [data][attributes]    frontEndReference
    And Response body has correct self link internal

Get_new_product_label_by_id
    When I send a GET request:    /product-labels/${label_new.id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${label_new.id}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${label_new.name}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should not be EMPTY:    [data][attributes][frontEndReference]
    And Response body has correct self link internal

Get_sale_product_label_by_id
    When I send a GET request:    /product-labels/${label_sale.id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${label_sale.id}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${label_sale.name}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should not be EMPTY:    [data][attributes][frontEndReference]
    And Response body has correct self link internal

Get_discontinued_product_label_by_id
    When I send a GET request:    /product-labels/${label_discontinued.id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${label_discontinued.id}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${label_discontinued.name}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should not be EMPTY:    [data][attributes][frontEndReference]
    And Response body has correct self link internal

Get_alternative_product_label_by_id
    When I send a GET request:    /product-labels/${label_alternative.id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${label_alternative.id}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${label_alternative.name}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should not be EMPTY:    [data][attributes][frontEndReference]
    And Response body has correct self link internal