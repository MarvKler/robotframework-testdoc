*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    spryker-core    company-account

*** Test Cases ***    
Request_business_unit_with_empty_access_token
    [Setup]    I set Headers:    Authorization=
    When I send a GET request:    /company-business-units/456789
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Request_business_unit_with_Invalid_access_token 
    [Setup]    I set Headers:    Authorization=InvalidAccessToken 
    When I send a GET request:    /company-business-units/mine
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Request_business_unit_by_wrong_ID
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /company-business-units/wrongId
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    1901
    And Response should return error message:    Company business unit not found.

Request_business_unit_if_company_belong_to_other_users 
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a GET request:    /company-business-units/mine
    ...    AND    Save value to a variable:    [data][0][id]    business_unit_id
    ...    AND    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    When I send a GET request:    /company-business-units/${business_unit_id}
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    1901
    And Response should return error message:    Company business unit not found.

Request_business_unit_with_customer_has_no_company_assignement
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /company-business-units/mine
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    1903
    And Response should return error message:    Current company user is not set. You need to select the current company user with /company-user-access-tokens in order to access the resource collection.