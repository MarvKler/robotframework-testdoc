*** Settings ***
Test Setup    API_test_setup
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    spryker-core    company-account

*** Test Cases ***
Request_company_role_by_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /company-roles/mine
    ...    AND    Save value to a variable:    [data][0][id]    company_role_id
    When I send a GET request:    /company-roles/${company_role_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    company-roles
    And Response body parameter should be:    [data][id]    ${company_role_id}
    And Response body parameter should be in:    [data][attributes][name]    Buyer    Admin
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response body has correct self link internal

Request_company_role_by_mine
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /company-roles/mine
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]  3
    And Each array element of array in response should contain property with value:    [data]    type   company-roles
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body parameter should not be EMPTY:    [data][1][id]
    And Response body parameter should be in:    [data][0][attributes][name]    Buyer    Admin
    And Response body parameter should be in:    [data][1][attributes][name]    Admin    Buyer
    And Response body parameter should be in:    [data][0][attributes][isDefault]    True    False
    And Response body parameter should be in:    [data][1][attributes][isDefault]    False    True
    And Response body has correct self link

Request_company_role_by_mine_with_include_companies
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /company-roles/mine?include=companies
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]  3
    And Each array element of array in response should contain property with value:    [data]    type   company-roles
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body parameter should be in:    [data][0][attributes][name]    Buyer    Admin
    And Response body parameter should be in:    [data][1][attributes][name]    Admin    Buyer
    And Response body parameter should be in:    [data][0][attributes][isDefault]    True    False
    And Response body parameter should be in:    [data][1][attributes][isDefault]    False    True
    And Response should contain the array of a certain size:    [data][0][relationships]    1
    And Response body parameter should be:    [data][0][relationships][companies][data][0][type]    companies
    And Response body parameter should not be EMPTY:    [data][0][relationships][companies][data][0][id]
    And Response include should contain certain entity type:    companies
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain nested property:    [included]    attributes    isActive
    And Each array element of array in response should contain nested property:    [included]    attributes    name
    And Each array element of array in response should contain nested property:    [included]    attributes    status
    And Response body has correct self link

Request_company_role_by_id_with_include_companies
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a GET request:    /company-roles/mine
    ...    AND    Save value to a variable:    [data][0][id]    company_role_id
    When I send a GET request:    /company-roles/${company_role_id}?include=companies
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    company-roles
    And Response body parameter should be:    [data][id]    ${company_role_id}
    And Response body parameter should be in:    [data][attributes][name]    Buyer    Admin
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response should contain the array of a certain size:    [data][relationships]  1
    And Response body parameter should be:    [data][relationships][companies][data][0][type]    companies
    And Response body parameter should not be EMPTY:    [data][relationships][companies][data][0][id]
    And Response include should contain certain entity type:    companies
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain nested property:    [included]    attributes    isActive
    And Each array element of array in response should contain nested property:    [included]    attributes    name
    And Each array element of array in response should contain nested property:    [included]    attributes    status
    And Response body has correct self link internal
