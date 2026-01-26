*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    spryker-core    company-account


*** Test Cases ***
Request_business_units_address_by_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /company-business-unit-addresses/${busines_unit_address_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    company-business-unit-addresses
    And Response body parameter should be:    [data][id]    ${busines_unit_address_id}
    And Response should contain the array of a certain size:    [data][attributes]    8
    And Response body parameter should not be EMPTY:    [data][attributes][address1]
    And Response body parameter should not be EMPTY:    [data][attributes][address2]
    And Response body parameter should not be EMPTY:    [data][attributes][zipCode]
    And Response body parameter should not be EMPTY:    [data][attributes][city]
    And Response body parameter should not be EMPTY:    [data][attributes][iso2Code]
    And Response body parameter should not be EMPTY:    [data][attributes][comment]
    And Response body parameter should contain:    [data][attributes]    address3
