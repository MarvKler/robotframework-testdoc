*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    spryker-core    company-account    customer-account-management    customer-access
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Retrieve_list_of_company_users
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /company-users
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    12
    And Response should contain the array of a certain size:    [data][0]    4
    And Each array element of array in response should contain value:    [data]    type
    And Each array element of array in response should contain property with value:    [data]    type    company-users
    And Each array element of array in response should contain value:    [data]    id
    And Each array element of array in response should contain property with value NOT in:    [data]    [id]    None
    And Response should contain the array of a certain size:    [data][0][attributes]    2
    And Each array element of array in response should contain property with value in:    [data]    attributes.isActive    True    False
    And Each array element of array in response should contain property with value in:    [data]    attributes.isDefault    True    False
    And Response body has correct self link

Retrieve_company_user_by_id
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /company-users/${company_user_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    4
    And Response body parameter should contain:    [data][type]    company-users
    And Response body parameter should contain:    [data][id]    ${company_user_id}
    And Response should contain the array of a certain size:    [data][attributes]    2
    And Response body parameter should be in:    [data][attributes][isActive]    True    False
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response body has correct self link internal

Retrieve_company_user_including_customers
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /company-users?include=customers
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain property with value:    [data]    type    company-users
    And Each array element of array in response should contain value:    [data]    id
    And Each array element of array in response should contain property with value NOT in:    [data]    [id]    None
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isActive
    And Response should contain the array of a certain size:    [data][0][relationships][customers][data]    1
    And Response should contain the array larger than a certain size:    [included]    11
    And Response include should contain certain entity type:    customers
    And Response include element has self link:  customers

Retrieve_company_user_including_company_business_units
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /company-users?include=company-business-units
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain property with value:    [data]    type    company-users
    And Each array element of array in response should contain value:    [data]    id
    And Each array element of array in response should contain property with value NOT in:    [data]    [id]    None
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isActive
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isDefault
    And Each array element of array in response should contain property with value:    [data][0][relationships][company-business-units][data]    type    company-business-units
    And Response should contain the array of a certain size:    [data][0][relationships][company-business-units][data]    1
    And Response should contain the array larger than a certain size:    [included]    6
    And Response include should contain certain entity type:    company-business-units
    And Response include element has self link:    company-business-units

Retrieve_company_user_including_company_roles
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /company-users?include=company-roles
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain property with value:    [data]    type    company-users
    And Each array element of array in response should contain value:    [data]    id
    And Each array element of array in response should contain property with value NOT in:    [data]    [id]    None
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isActive
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isDefault
    And Array element should contain nested array at least once:    [data]    [relationships]
    And Response should contain the array of a certain size:    [included]    6
    And Response include should contain certain entity type:    company-roles
    And Response include element has self link:    company-roles

Retrieve_company_user_including_companies
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /company-users?include=companies
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain property with value:    [data]    type    company-users
    And Each array element of array in response should contain value:    [data]    id
    And Each array element of array in response should contain property with value NOT in:    [data]    [id]    None
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isActive
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isDefault
    And Response should contain the array of a certain size:    [data][0][relationships][companies][data]    1
    And Response should contain the array of a certain size:    [included]    1
    And Response include should contain certain entity type:    companies
    And Response include element has self link:    companies

Retrieve_company_users_by_mine
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /company-users/mine
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]  1
    And Response body parameter should be:    [data][0][type]   company-users
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body parameter should be:    [data][0][attributes][isActive]    True
    And Response body parameter should be:    [data][0][attributes][isDefault]    False
    And Response body has correct self link

Retrieve_list_of_company_users_with_include_customers_and_filtered_by_company_role
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /company-roles/mine
    ...    AND    Save value to a variable:    [data][0][id]    company-role-uuid
    When I send a GET request:    /company-users?include=customers&filter[company-roles.id]=${company-role-uuid}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain property with value:    [data]    type   company-users
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property:    [data]    relationships
    And Response should contain the array of a certain size:    [data][0][relationships]  1
    And Response body parameter should contain:    [data][0][relationships]    customers

Retrieve_list_of_company_users_if_user_has_4_companies
    When I get access token for the customer:    ${user_with_multiple_companies}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I add 'admin' role to company user and get company_user_uuid:    ${user_with_multiple_companies}    BoB-Hotel-Jim    business-unit-jim-1
    And I get access token for the company user by uuid:    ${company_user_uuid}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /company-users/mine
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    4
    And Each array element of array in response should contain property with value:    [data]   type    company-users

