*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    alternative-products    product    product-labels    discontinued-products

*** Test Cases ***
Get_new_product_label_by_id
    When I send a GET request:    /product-labels/${label.new.id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${label.new.id}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${label.new.name}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should not be EMPTY:    [data][attributes][frontEndReference]
    And Response body has correct self link internal

Get_sale_product_label_by_id
    When I send a GET request:    /product-labels/${label.sale.id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${label.sale.id}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${label.sale.name}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should not be EMPTY:    [data][attributes][frontEndReference]
    And Response body has correct self link internal   

Get_discontinued_product_label_by_id
    When I send a GET request:    /product-labels/${label.discontinued.id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${label.discontinued.id}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${label.discontinued.name}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should not be EMPTY:    [data][attributes][frontEndReference]
    And Response body has correct self link internal  

Get_alternatives_product_label_by_id
    When I send a GET request:    /product-labels/${label.alternatives.id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${label.alternatives.id}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${label.alternatives.name}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should not be EMPTY:    [data][attributes][frontEndReference]
    And Response body has correct self link internal           