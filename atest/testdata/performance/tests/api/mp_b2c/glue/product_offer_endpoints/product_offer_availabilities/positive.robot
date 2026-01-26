*** Settings ***
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        API_test_setup
Test Tags    glue    product    marketplace-product-offer    marketplace-product

*** Test Cases ***

Get_product_offer_availabilities
    I send a GET request:    /concrete-products/${merchant.spryker.concrete_product_with_offer_sku}/product-offers
    AND Save value to a variable:    [data][0][id]    offerId
    When I send a GET request:    /product-offers/${offerId}/product-offer-availabilities
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property with value:    [data]    type    product-offer-availabilities
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isNeverOutOfStock
    And Each array element of array in response should contain nested property:    [data]    [attributes]    availability
    And Each array element of array in response should contain nested property:    [data]    [attributes]    quantity
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][isNeverOutOfStock]    bool
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][availability]    bool
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][quantity]    str
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link