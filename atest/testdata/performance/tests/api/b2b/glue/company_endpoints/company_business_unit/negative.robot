*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    spryker-core    company-account


*** Test Cases ***
Request_business_unit_by_wrong_ID
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /company-business-units/45768
    Then Response status code should be:    404
    And Response should return error code:    1901
    And Response reason should be:    Not Found
    And Response body parameter should be:    [errors][0][detail]    Company business unit not found.

Request_business_unit_without_access_token
    When I send a GET request:    /company-business-units/456789
    Then Response status code should be:    403
    And Response should return error code:    002
    And Response reason should be:    Forbidden
    And Response body parameter should be:    [errors][0][detail]    Missing access token.

Request_business_unit_with_wrong_access_token
    [Setup]    I set Headers:    Authorization=sdrtfuygiuhoi
    When I send a GET request:    /company-business-units/mine
    Then Response status code should be:    401
    And Response should return error code:    001
    And Response reason should be:    Unauthorized
    And Response body parameter should be:    [errors][0][detail]    Invalid access token.

Request_business_unit_if_company_belong_to_other_users
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /company-business-units/mine
    ...    AND    Save value to a variable:    [data][0][id]    business_unit_id
    ...    AND    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /company-business-units/${business_unit_id}
    Then Response status code should be:    404
    And Response should return error code:    1901
    And Response reason should be:    Not Found
    And Response body parameter should be:    [errors][0][detail]    Company business unit not found.
