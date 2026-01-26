*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    alternative-products    product    product-labels    discontinued-products


*** Test Cases ***
#####POST#####
Get_manual_product_label_by_id
    When I send a GET request:    /product-labels/${labels.id_manual}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${labels.id_manual}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${labels.name_manual}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should not be EMPTY:    [data][attributes][frontEndReference]
    And Response body has correct self link internal

Get_new_product_label_by_id
    When I send a GET request:    /product-labels/${labels.id_new}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${labels.id_new}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${labels.name_new}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should not be EMPTY:    [data][attributes][frontEndReference]
    And Response body has correct self link internal

Get_sale_product_label_by_id
    When I send a GET request:    /product-labels/${labels.id_sale}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${labels.id_sale}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${labels.name_sale}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should not be EMPTY:    [data][attributes][frontEndReference]
    And Response body has correct self link internal

Get_discontinued_product_label_by_id
    When I send a GET request:    /product-labels/${labels.id_discontinued}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${labels.id_discontinued}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${labels.name_discontinued}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should not be EMPTY:    [data][attributes][frontEndReference]
    And Response body has correct self link internal

Get_alternative_product_label_by_id
    When I send a GET request:    /product-labels/${labels.id_alternative}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${labels.id_alternative}
    And Response body parameter should be:    [data][type]    product-labels
    And Response body parameter should be:    [data][attributes][name]    ${labels.name_alternative}
    And Response body parameter should be:    [data][attributes][isExclusive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][position]
    And Response body parameter should not be EMPTY:    [data][attributes][frontEndReference]
    And Response body has correct self link internal
