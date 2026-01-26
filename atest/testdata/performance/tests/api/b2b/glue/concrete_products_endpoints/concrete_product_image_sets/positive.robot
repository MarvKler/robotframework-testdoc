*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    product


*** Test Cases ***
Request_concrete_product_with_one_image_set
    When I send a GET request:    /concrete-products/${concrete.one_image_set.sku}/concrete-product-image-sets
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body has correct self link
    And Response body parameter should be:    [data][0][id]    ${concrete.one_image_set.sku}
    And Response body parameter should be:    [data][0][type]    concrete-product-image-sets
    And Response body parameter should be:    [data][0][attributes][imageSets][0][name]    default
    And Response body parameter should contain:    [data][0][attributes]    imageSets
    And Response should contain the array of a certain size:    [data][0][attributes][imageSets]    1
    And Response should contain the array of a certain size:    [data][0][attributes][imageSets][0][images]    1
    And Response body parameter should not be EMPTY:
    ...    [data][0][attributes][imageSets][0][images][0][externalUrlLarge]
    And Response body parameter should not be EMPTY:
    ...    [data][0][attributes][imageSets][0][images][0][externalUrlSmall]

Request_concrete_product_with_5_image_sets
    When I send a GET request:    /concrete-products/${concrete.multiple_image_set.sku}/concrete-product-image-sets
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body has correct self link
    And Response body parameter should be:    [data][0][id]    ${concrete.multiple_image_set.sku}
    And Response body parameter should be:    [data][0][type]    concrete-product-image-sets
    And Response body parameter should be:    [data][0][attributes][imageSets][0][name]    default
    And Response body parameter should contain:    [data][0][attributes]    imageSets
    And Response should contain the array of a certain size:    [data][0][attributes][imageSets][0][images]    5
    And Response body parameter should not be EMPTY:
    ...    [data][0][attributes][imageSets][0][images][0][externalUrlLarge]
    And Response body parameter should not be EMPTY:
    ...    [data][0][attributes][imageSets][0][images][0][externalUrlSmall]
