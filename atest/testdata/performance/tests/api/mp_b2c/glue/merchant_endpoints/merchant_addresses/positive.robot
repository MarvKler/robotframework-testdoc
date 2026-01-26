*** Settings ***
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        API_test_setup
Test Tags    glue    merchant    marketplace-merchant    marketplace-merchantportal-core

*** Test Cases ***
Retrieves_merchant_addresses
    When I send a GET request:  /merchants/${merchant.sony_experts.merchant_id}/merchant-addresses
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${merchant.sony_experts.merchant_id}
    And Response body parameter should be:    [data][0][type]    merchant-addresses
    And Response body parameter should be:    [data][0][attributes][addresses][0][countryName]    ${default.country}
    And Response body parameter should be:    [data][0][attributes][addresses][0][city]    ${merchant.sony_experts.addresses.city_munchen}
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    merchant-addresses
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    countryName
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    address1
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    address2
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    address3
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    city
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    zipCode
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    latitude
    And Each array element of array in response should contain nested property:    [data]    [attributes][addresses]    longitude
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link


Retrieves_merchant_with_include_merchant_addresses
    When I send a GET request:    /merchants/${merchant.sony_experts.merchant_id}?include=merchant-addresses
    Then Response status code should be:    200
    And Response reason should be:    OK    
    And Response body parameter should be:    [data][type]    merchants
    And Response body parameter should be:    [data][id]    ${merchant.sony_experts.merchant_id}
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should have datatype:    [data][relationships]    dict
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][merchant-addresses]
    And Each array element of array in response should contain property:    [data][relationships][merchant-addresses][data]    type
    And Each array element of array in response should contain property:    [data][relationships][merchant-addresses][data]    id
    And Response body parameter should not be EMPTY:    [included]
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Each array element of array in response should contain property with value:    [included]    type    merchant-addresses
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    countryName
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    address1
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    address1
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    address3
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    city
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    zipCode
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    latitude
    And Each array element of array in response should contain nested property:    [included]    [attributes][addresses]    longitude
    And Response body parameter should be:    [included][0][attributes][addresses][0][countryName]    ${default.country}
    And Response body parameter should be:    [included][0][attributes][addresses][0][city]    ${merchant.sony_experts.addresses.city_munchen}
    And Response body parameter should be:    [included][0][attributes][addresses][0][address1]    ${merchant.sony_experts.addresses.address1}
