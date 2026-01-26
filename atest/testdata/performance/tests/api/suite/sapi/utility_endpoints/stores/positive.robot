*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Test Tags    sapi    spryker-core    spryker-core-back-office

*** Test Cases ***
Get_all_availiable_stores
    And I set Headers:    Content-Type=${default_header_content_type}
    When I send a GET request:    /stores
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain nested property:    [data]    [attributes]    defaultCurrency
    And Each array element of array in response should contain nested property:    [data]    [attributes]    currencies
    And Each array element of array in response should contain nested property:    [data]    [attributes]    locales
    And Each array element of array in response should contain nested property:    [data]    [attributes]    countries
    And Each array element of array in response should contain nested property:    [data]    [attributes]    defaultCurrency
    And Each array element of nested array should contain property with value in:    [data]    [attributes][currencies]    code    ${currency.eur.code}    ${currency.dollar.code}    ${currency.chf.code}
    And Each array element of nested array should contain property with value in:    [data]    [attributes][currencies]    name    ${currency.eur.name}    ${currency.dollar.name}    ${currency.chf.name}
    And Each array element of array in response should contain nested property:    [data]    [attributes][currencies]    code
    And Each array element of array in response should contain nested property:    [data]    [attributes][currencies]    name
    And Each array element of nested array should contain property with value in:    [data]    [attributes][locales]    name    ${locale.DE.name}    ${locale.EN.name}
    And Each array element of array in response should contain nested property:    [data]    [attributes][locales]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    iso2Code
    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    iso3Code
    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    postalCodeMandatory
    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    postalCodeRegex
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link

Get_store_by_id
    And I set Headers:    Content-Type=${default_header_content_type}
    When I send a GET request:    /stores/${store.de}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    stores
    And Response body parameter should be:    [data][id]    ${store.de}
    And Response body parameter should not be EMPTY:    [data][attributes]
    And Response body parameter should have datatype:    [data][attributes][currencies]   list
    And Response body parameter should have datatype:    [data][attributes][locales]   list
    And Response body parameter should have datatype:    [data][attributes][countries]   list
    And Each array element of array in response should contain property with value in:    [data][attributes][currencies]    name    ${currency.eur.name}    ${currency.dollar.name}    ${currency.chf.name}
    And Each array element of array in response should contain property with value in:    [data][attributes][currencies]    code    ${currency.eur.code}    ${currency.dollar.code}    ${currency.chf.code}
    And Each array element of array in response should contain property:    [data][attributes][currencies]    name
    And Each array element of array in response should contain property:    [data][attributes][currencies]    code
    And Each array element of array in response should contain property with value in:    [data][attributes][locales]    name    ${locale.DE.name}    ${locale.EN.name}
    And Each array element of array in response should contain property:    [data][attributes][locales]    name
    And Each array element of array in response should contain property:    [data][attributes][countries]    iso2Code
    And Each array element of array in response should contain property:    [data][attributes][countries]    iso3Code
    And Each array element of array in response should contain property:    [data][attributes][countries]    name
    And Each array element of array in response should contain property:    [data][attributes][countries]    postalCodeMandatory
    And Each array element of array in response should contain property:    [data][attributes][countries]    postalCodeRegex
    And Response body has correct self link internal
