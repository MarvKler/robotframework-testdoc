*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    spryker-core    company-account    customer-account-management    customer-access

*** Test Cases ***
Request_access_token_by_invalid_company_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    When I send a POST request:    /company-user-access-tokens    {"data":{"type":"company-user-access-tokens","attributes":{"idCompanyUser":"35235"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    idCompanyUser => This is not a valid UUID.

Request_access_token_by_empty_company_id
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    When I send a POST request:    /company-user-access-tokens    {"data":{"type":"company-user-access-tokens","attributes":{"idCompanyUser":""}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    idCompanyUser => This value should not be blank.

Request_access_token_with_invalid_type
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    When I send a POST request:    /company-user-access-tokens    {"data":{"type":"company-access-tokens","attributes":{"idCompanyUser":""}}}
   Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.

Request_access_token_with_empty_type
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token} 
    When I send a POST request:    /company-user-access-tokens    {"data":{"type":"","attributes":{"idCompanyUser":""}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.

Request_access_token_using_invalid_token
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=546789
    When I send a POST request:    /company-user-access-tokens    {"data":{"type":"company-user-access-tokens","attributes":{"idCompanyUser":"35235"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Request_access_token_with_missing_token
    When I send a POST request:    /company-user-access-tokens    {"data":{"type":"company-user-access-tokens","attributes":{"idCompanyUser":"35235"}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Request_access_token_if_user_belong_to_other_company
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    Save value to a variable:    [data][attributes][idCompanyUser]    company_user
    ...    AND    I get access token for the customer:    ${yves_second_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a POST request:    /company-user-access-tokens    {"data":{"type":"company-user-access-tokens","attributes":{"idCompanyUser":"${company_user}"}}}
    Then Response status code should be:    401
    And Response should return error code:    003
    And Response reason should be:    Unauthorized
    And Response body parameter should be:    [errors][0][detail]    Failed to authenticate user.