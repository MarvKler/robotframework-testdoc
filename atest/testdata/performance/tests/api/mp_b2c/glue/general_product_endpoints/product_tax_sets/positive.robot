*** Settings ***
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        API_test_setup
Test Tags    glue    product    tax

*** Test Cases ***
Get_product_tax sets
    When I send a GET request:    /abstract-products/${abstract_product.product_with_reviews.sku}/product-tax-sets
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    1
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body parameter should be:    [data][0][type]    product-tax-sets
    And Response body parameter should not be EMPTY:    [data][0][attributes][name]
    And Response should contain the array larger than a certain size:    [data][0][attributes][restTaxRates]    1
    And Response body parameter should not be EMPTY:    [data][0][links][self]
    And Each array element of array in response should contain property:    [data][0][attributes][restTaxRates]    name
    And Each array element of array in response should contain property:    [data][0][attributes][restTaxRates]    rate
    And Each array element of array in response should contain property:    [data][0][attributes][restTaxRates]    country
    And Response body has correct self link
