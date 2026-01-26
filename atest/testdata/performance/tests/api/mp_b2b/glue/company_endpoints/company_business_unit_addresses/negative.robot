*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    spryker-core    company-account

*** Test Cases ***
Get_business_unit_address_with_empty_access_token
    [Setup]    I set Headers:    Authorization=
    When I send a GET request:    /company-business-unit-addresses/${business_unit.address_id}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Get_business_unit_address_with_invalid_access_token 
    [Setup]    I set Headers:    Authorization=InvalidAccessToken 
    When I send a GET request:    /company-business-unit-addresses/${business_unit.address_id}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
Get_business_unit_address_with_wrong_ID
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /company-business-unit-addresses/WrongId
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    2001
    And Response should return error message:    Company business unit address not found.

Get_business_unit_address_with_mine
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /company-business-unit-addresses/mine
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    2001
    And Response should return error message:    Company business unit address not found.