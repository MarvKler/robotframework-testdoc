*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    merchant    marketplace-merchant    marketplace-merchantportal-core    merchant-opening-hours

*** Test Cases ***
Retrieves_merchant_opening_hours
    When I send a GET request:  /merchants/${merchants.sony_experts.merchant_reference}/merchant-opening-hours
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][id]    ${merchants.sony_experts.merchant_reference}
    And Response body parameter should be:    [data][0][type]    merchant-opening-hours
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    merchant-opening-hours
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][weekdaySchedule]    list
    And Each array element of array in response should contain nested property with datatype:    [data]    [attributes][dateSchedule]    list
    And Each array element of array in response should contain nested property:    [data]    [attributes][weekdaySchedule]    day
    And Each array element of array in response should contain nested property:    [data]    [attributes][weekdaySchedule]    timeFrom
    And Each array element of array in response should contain nested property:    [data]    [attributes][weekdaySchedule]    timeTo
    And Each array element of array in response should contain nested property:    [data]    [attributes][dateSchedule]    date
    And Each array element of array in response should contain nested property:    [data]    [attributes][dateSchedule]    timeFrom
    And Each array element of array in response should contain nested property:    [data]    [attributes][dateSchedule]    timeTo
    And Each array element of array in response should contain nested property:    [data]    [attributes][dateSchedule]    noteGlossaryKey
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link



Retrieves_merchant_with_include_merchant_opening_hours
    When I send a GET request:  /merchants/${merchants.sony_experts.merchant_reference}?include=merchant-opening-hours
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    merchants
    And Response body parameter should be:    [data][id]    ${merchants.sony_experts.merchant_reference}
    And Response should contain the array of a certain size:    [included][0][attributes][weekdaySchedule]    8
    And Response should contain the array of a certain size:    [included][0][attributes][dateSchedule]    154
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][merchant-opening-hours]
    And Each array element of array in response should contain property:    [data][relationships][merchant-opening-hours][data]    type
    And Each array element of array in response should contain property:    [data][relationships][merchant-opening-hours][data]    id
    And Response body parameter should not be EMPTY:    [included]
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Each array element of array in response should contain property with value:    [included]    type    merchant-opening-hours
    And Each array element of array in response should contain nested property:    [included]    [attributes][weekdaySchedule]    day
    And Each array element of array in response should contain nested property:    [included]    [attributes][weekdaySchedule]    timeFrom
    And Each array element of array in response should contain nested property:    [included]    [attributes][weekdaySchedule]    timeTo
    And Each array element of array in response should contain nested property:    [included]    [attributes][dateSchedule]    date
    And Each array element of array in response should contain nested property:    [included]    [attributes][dateSchedule]    timeFrom
    And Each array element of array in response should contain nested property:    [included]    [attributes][dateSchedule]    timeTo
    And Each array element of array in response should contain nested property:    [included]    [attributes][dateSchedule]    noteGlossaryKey
    And Response body parameter should be:    [included][0][attributes][weekdaySchedule][0][day]    MONDAY
    And Response body parameter should be:    [included][0][attributes][weekdaySchedule][0][timeFrom]    07:00:00.000000
    And Response body parameter should be:    [included][0][attributes][weekdaySchedule][0][timeTo]    13:00:00.000000
    And Response body parameter should be:    [included][0][attributes][dateSchedule][0][date]    2024-01-01
    And Response body parameter should be:    [included][0][attributes][dateSchedule][0][noteGlossaryKey]    "New Years Day"
