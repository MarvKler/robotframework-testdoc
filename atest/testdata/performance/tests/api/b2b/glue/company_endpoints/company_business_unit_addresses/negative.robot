*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    spryker-core    company-account


*** Test Cases ***
Request_business_unit_address_by_wrong_ID
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /company-business-unit-addresses/3456r7t8y8u
    Then Response status code should be:    404
    And Response should return error code:    2001
    And Response reason should be:    Not Found
    And Response body parameter should be:    [errors][0][detail]    Company business unit address not found.

Request_business_unit_address_without_access_token
    When I send a GET request:    /company-business-unit-addresses/${busines_unit_address_id}
    Then Response status code should be:    403
    And Response should return error code:    002
    And Response reason should be:    Forbidden
    And Response body parameter should be:    [errors][0][detail]    Missing access token.

Request_business_unit_address_with_wrong_access_token
    [Setup]    I set Headers:    Authorization=sdrtfuygiuhoi
    When I send a GET request:    /company-business-unit-addresses/${busines_unit_address_id}
    Then Response status code should be:    401
    And Response should return error code:    001
    And Response reason should be:    Unauthorized
    And Response body parameter should be:    [errors][0][detail]    Invalid access token.

Request_business_unit_address_with_mine
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /company-business-unit-addresses/mine
    Then Response status code should be:    404
    And Response should return error code:    2001
    And Response reason should be:    Not Found
    And Response body parameter should be:    [errors][0][detail]    Company business unit address not found.
