*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Test Tags    glue    spryker-core

*** Test Cases ***
#get
Get_all_available_stores
    [Tags]    dms-off
    When I send a GET request:    /stores
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain nested property:    [data]    [attributes]    timeZone
    And Each array element of array in response should contain nested property:    [data]    [attributes]    defaultCurrency
    And Each array element of array in response should contain nested property:    [data]    [attributes]    currencies
    And Each array element of array in response should contain nested property:    [data]    [attributes]    locales
    And Each array element of array in response should contain nested property:    [data]    [attributes]    countries
    And Each array element of array in response should contain nested property:    [data]    [attributes]    defaultCurrency
    And Each array element of nested array should contain property with value in:    [data]    [attributes][currencies]    code    ${currency.eur.code}    ${currency.dollar.code}    ${currency.chf.code}
    And Each array element of nested array should contain property with value in:    [data]    [attributes][currencies]    name    ${currency.eur.name}    ${currency.dollar.name}    ${currency.chf.name}
    And Each array element of array in response should contain nested property:    [data]    [attributes][currencies]    code
    And Each array element of array in response should contain nested property:    [data]    [attributes][currencies]    name
    And Each array element of nested array should contain property with value in:    [data]    [attributes][locales]    code    ${locale.DE.code}    ${locale.EN.code}
    And Each array element of nested array should contain property with value in:    [data]    [attributes][locales]    name    ${locale.DE.name}    ${locale.EN.name}
    And Each array element of array in response should contain nested property:    [data]    [attributes][locales]    code
    And Each array element of array in response should contain nested property:    [data]    [attributes][locales]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    iso2Code
    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    iso3Code
    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    postalCodeMandatory
    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    postalCodeRegex
    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    regions
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link

Get_all_available_stores_dms_on
    [Tags]    dms-on
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
    And Each array element of array in response should contain nested property:    [data]    [attributes][countries]    regions
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link

Get_store_by_id
    [Tags]    dms-off
    When I send a GET request:    /stores/${store.de}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    stores
    And Response body parameter should be:    [data][id]    ${store.de}
    And Response body parameter should not be EMPTY:    [data][attributes]
    And Response body parameter should not be EMPTY:    [data][attributes][timeZone]
    And Response body parameter should not be EMPTY:    [data][attributes][timeZone]
    And Response body parameter should have datatype:    [data][attributes][timeZone]   str
    And Response body parameter should have datatype:    [data][attributes][currencies]   list
    And Response body parameter should have datatype:    [data][attributes][locales]   list
    And Response body parameter should have datatype:    [data][attributes][countries]   list
    And Each array element of array in response should contain property with value in:    [data][attributes][currencies]    name    ${currency.eur.name}    ${currency.dollar.name}    ${currency.chf.name}
    And Each array element of array in response should contain property with value in:    [data][attributes][currencies]    code    ${currency.eur.code}    ${currency.dollar.code}    ${currency.chf.code}
    And Each array element of array in response should contain property:    [data][attributes][currencies]    name
    And Each array element of array in response should contain property:    [data][attributes][currencies]    code
    And Each array element of array in response should contain property with value in:    [data][attributes][locales]    code    ${locale.DE.code}    ${locale.EN.code}
    And Each array element of array in response should contain property with value in:    [data][attributes][locales]    name    ${locale.DE.name}    ${locale.EN.name}
    And Each array element of array in response should contain property:    [data][attributes][locales]    name
    And Each array element of array in response should contain property:    [data][attributes][locales]    code
    And Each array element of array in response should contain property:    [data][attributes][countries]    iso2Code
    And Each array element of array in response should contain property:    [data][attributes][countries]    iso3Code
    And Each array element of array in response should contain property:    [data][attributes][countries]    name
    And Each array element of array in response should contain property:    [data][attributes][countries]    postalCodeMandatory
    And Each array element of array in response should contain property:    [data][attributes][countries]    postalCodeRegex
    And Each array element of array in response should contain property:    [data][attributes][countries]    regions
    And Response body has correct self link internal

Get_store_by_id_dms_on
    [Tags]    dms-on
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
    And Each array element of array in response should contain property:    [data][attributes][currencies]    name
    And Each array element of array in response should contain property with value in:    [data][attributes][locales]    name    ${locale.DE.name}    ${locale.EN.name}
    And Each array element of array in response should contain property:    [data][attributes][locales]    name
    And Each array element of array in response should contain property:    [data][attributes][countries]    iso2Code
    And Each array element of array in response should contain property:    [data][attributes][countries]    iso3Code
    And Each array element of array in response should contain property:    [data][attributes][countries]    name
    And Each array element of array in response should contain property:    [data][attributes][countries]    postalCodeMandatory
    And Each array element of array in response should contain property:    [data][attributes][countries]    postalCodeRegex
    And Each array element of array in response should contain property:    [data][attributes][countries]    regions
    And Response body has correct self link internal