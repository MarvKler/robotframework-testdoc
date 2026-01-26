*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    spryker-core    spryker-core-back-office    marketplace-merchantportal-core

*** Test Cases ***
Search_by_abstract_sku_per_store
    [Tags]    dms-on
    When I set Headers:    store=DE
    Then I send a GET request:    /catalog-search?q=${concrete_product_with_alternative.abstract_sku}
    And Response status code should be:    200
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractSku]    ${concrete_product_with_alternative.abstract_sku}
    And Response body parameter should be either:    [data][0][attributes][abstractProducts][0][prices][0][DEFAULT]    [data][0][attributes][abstractProducts][0][prices][1][DEFAULT]    ${concrete_product_with_alternative.price_de}
    When I set Headers:    store=AT
    Then I send a GET request:    /catalog-search?q=${concrete_product_with_alternative.abstract_sku}
    And Response status code should be:    200
    And Response body parameter should be:    [data][0][attributes][abstractProducts][0][abstractSku]    ${concrete_product_with_alternative.abstract_sku}
    And Response body parameter should be either:    [data][0][attributes][abstractProducts][0][prices][0][DEFAULT]    [data][0][attributes][abstractProducts][0][prices][1][DEFAULT]    ${concrete_product_with_alternative.price_at}
