*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    spryker-core    company-account

*** Test Cases ***
Request_company_by_ID
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    ...    AND    I send a GET request:    /companies/mine
    ...    AND    Save value to a variable:    [data][0][id]    company_id   
    When I send a GET request:    /companies/${company_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    companies
    And Response body parameter should be:    [data][id]    ${company_id}
    And Response body parameter should be:    [data][attributes][name]    ${company_name}
    And Response body parameter should be:    [data][attributes][status]    approved
    And Response body parameter should be:    [data][attributes][isActive]    True
    And Response should contain the array of a certain size:    [data][attributes]    3

Request_company_by_mine
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /companies/mine
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    companies
    And Response body parameter should be:    [data][0][attributes][name]    ${company_name}
    And Response body parameter should be:    [data][0][attributes][status]    approved
    And Response body parameter should be:    [data][0][attributes][isActive]    True
    And Response should contain the array of a certain size:    [data][0][attributes]    3
    And Response body has correct self link





