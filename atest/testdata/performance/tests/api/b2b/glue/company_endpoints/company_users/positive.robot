*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    spryker-core    company-account    customer-account-management    customer-access


*** Test Cases ***
Request_company_users
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /company-users
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    12
    And Each array element of array in response should contain property with value:    [data]    type    company-users
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Response should contain the array of a certain size:    [data][0][attributes]    2
    And Response body parameter should be:    [data][0][attributes][isActive]    True
    And Response body parameter should be:    [data][0][attributes][isDefault]    False
    And Response body has correct self link

Request_company_users_by_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /company-users/mine
    ...    AND    Save value to a variable:    [data][id]    company_user_id
    When I send a GET request:    /company-users/${company_user_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    company-users

Request_company_users_by_mine
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /company-users/mine
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    1
    And Response body parameter should be:    [data][0][type]    company-users
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body parameter should be:    [data][0][attributes][isActive]    True
    And Response body parameter should be:    [data][0][attributes][isDefault]    False

Request_company_users_include_customers_and_roles_and_business_units
    [Documentation]    last step need to be fixed, flakery cause one of the array relationship is not contain company-role
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /company-users?include=customers,company-business-units,company-roles
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain property with value:    [data]    type    company-users
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    relationships
    And Response should contain the array larger than a certain size:    [data][0][relationships]    1
    And Response should contain the array smaller than a certain size:    [data][0][relationships]    4
    And Response body parameter should contain:    [data][0][relationships]    company-business-units
    And Response body parameter should contain:    [data][0][relationships]    customers
    And Nested array element should contain sub-array at least once:      [data]    [relationships]    company-roles

Request_companies_users_if_user_has_4_companies
    [Setup]    Run Keywords    I get access token for the customer:    ${user_with_multiple_companies}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I add 'admin' role to company user and get company_user_uuid:    ${user_with_multiple_companies}    BoB-Hotel-Jim    business-unit-jim-1
    ...    AND    I get access token for the company user by uuid:    ${company_user_uuid}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /company-users/mine
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    4
    And Each array element of array in response should contain property with value:    [data]    type    company-users

Request_companies_users_with_include_customers_and_filtered_by_company_role
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /company-roles/mine
    ...    AND    Save value to a variable:    [data][0][id]    company-role-uuid
    When I send a GET request:    /company-users?include=customers&filter[company-roles.id]=${company-role-uuid}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain property with value:    [data]    type    company-users
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    relationships
    And Response should contain the array of a certain size:    [data][0][relationships]    1
    And Response body parameter should contain:    [data][0][relationships]    customers
