*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    customer-access    customer-account-management    spryker-core


*** Test Cases ***
##### all negative and positive tests for this endpoint are already covered with other tests (e.g. abstract-product-prices checks that without token process are not accessible)
Get_resources_customer_can_access
    When I send a GET request:    /customer-access
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    customer-access
    And Response should contain the array of a certain size:
    ...    [data][0][attributes][resourceTypes]
    ...    ${restricted_content_qty}
    And Response body parameter should be:    [data][0][attributes][resourceTypes][0]    abstract-product-prices
    And Response body parameter should be:    [data][0][attributes][resourceTypes][1]    concrete-product-prices
    And Response body parameter should be:    [data][0][attributes][resourceTypes][2]    checkout
    And Response body parameter should be:    [data][0][attributes][resourceTypes][3]    checkout-data
    And Response body parameter should be:    [data][0][attributes][resourceTypes][4]    guest-cart-items
    And Response body has correct self link

Access_restricted_resource_as_authorized_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /abstract-products/${abstract.volume_prices.sku}/abstract-product-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][id]    ${abstract.volume_prices.sku}
    And Response body parameter should be greater than:    [data][0][attributes][price]    100
    And Response body has correct self link
