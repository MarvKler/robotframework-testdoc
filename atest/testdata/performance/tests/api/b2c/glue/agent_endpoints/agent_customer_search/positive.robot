*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    spryker-core    customer-access    acl    agent-assist    customer-account-management

*** Test Cases ***
Agent_can_get_search_for_customers_without_search_parameters
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    agent-customer-search
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    10
    And Response should contain the array of a certain size:    [data][0][attributes][customers][0]    4
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    customerReference
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    email
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    firstName
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    lastName
    And Response body parameter should not be EMPTY:    [data][0][attributes][customers][0][customerReference]
    And Response body parameter should not be EMPTY:    [data][0][attributes][customers][0][email]
    And Response body parameter should not be EMPTY:    [data][0][attributes][customers][0][firstName]
    And Response body parameter should not be EMPTY:    [data][0][attributes][customers][0][lastName]
    And Response body has correct self link

Agent_can_get_search_for_customers_by_email
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?q=${yves_user.email}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    agent-customer-search
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    1
    And Response should contain the array of a certain size:    [data][0][attributes][customers][0]    4
    And Response body parameter should contain:    [data][0][attributes][customers][0][customerReference]    DE--21
    And Response body parameter should contain:    [data][0][attributes][customers][0][email]    sonia@spryker.com
    And Response body parameter should contain:    [data][0][attributes][customers][0][firstName]    Sonia
    And Response body parameter should contain:    [data][0][attributes][customers][0][lastName]    Wagner
    And Response body has correct self link

Agent_can_get_search_for_customers_by_first_name
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?q=${yves_second_user.first_name}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    agent-customer-search
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    1
    And Response should contain the array of a certain size:    [data][0][attributes][customers][0]    4
    And Response body parameter should contain:    [data][0][attributes][customers][0][customerReference]    DE--4
    And Response body parameter should contain:    [data][0][attributes][customers][0][email]    bill.martin@spryker.co
    And Response body parameter should contain:    [data][0][attributes][customers][0][firstName]    Bill
    And Response body parameter should contain:    [data][0][attributes][customers][0][lastName]    Martin
    And Response body has correct self link

Agent_can_get_search_for_customers_by_last_name
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?q=${yves_second_user.last_name}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    agent-customer-search
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    1
    And Response should contain the array of a certain size:    [data][0][attributes][customers][0]    4
    And Response body parameter should contain:    [data][0][attributes][customers][0][customerReference]    DE--4
    And Response body parameter should contain:    [data][0][attributes][customers][0][email]    bill.martin@spryker.co
    And Response body parameter should contain:    [data][0][attributes][customers][0][firstName]    Bill
    And Response body parameter should contain:    [data][0][attributes][customers][0][lastName]    Martin
    And Response body has correct self link

Agent_can_get_search_for_customers_with_changed_page_limit
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?page[offset]=0&page[limit]=20
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    agent-customer-search
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    20
    And Response should contain the array of a certain size:    [data][0][attributes][customers][0]    4
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    customerReference
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    email
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    firstName
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    lastName
    And Response body parameter should not be EMPTY:    [data][0][attributes][customers][0][customerReference]
    And Response body parameter should not be EMPTY:    [data][0][attributes][customers][0][email]
    And Response body parameter should not be EMPTY:    [data][0][attributes][customers][0][firstName]
    And Response body parameter should not be EMPTY:    [data][0][attributes][customers][0][lastName]

Agent_can_get_search_for_customers_by_substring 
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?q=mar
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    agent-customer-search
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    2
    And Response should contain the array of a certain size:    [data][0][attributes][customers][0]    4
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    customerReference
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    email
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    firstName
    And Each array element of array in response should contain property:    [data][0][attributes][customers]    lastName
    And Response body parameter should not be EMPTY:    [data][0][attributes][customers][0][customerReference]
    And Response body parameter should not be EMPTY:    [data][0][attributes][customers][0][email]
    And Response body parameter should not be EMPTY:    [data][0][attributes][customers][0][firstName]
    And Response body parameter should not be EMPTY:    [data][0][attributes][customers][0][lastName]
    And Response body parameter should be:    [data][0][attributes][customers][0][customerReference]    DE--2
    And Response body parameter should be:    [data][0][attributes][customers][0][email]    maria.williams@spryker.com
    And Response body parameter should be:    [data][0][attributes][customers][1][customerReference]    DE--4
    And Response body parameter should be:    [data][0][attributes][customers][1][email]    bill.martin@spryker.com
    And Response body has correct self link

Agent_can_get_search_for_customers_by_incorrect_keyword 
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Response reason should be:    Created
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a GET request:    /agent-customer-search?q=qqqq
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    agent-customer-search
    And Response should contain the array of a certain size:    [data][0][attributes][customers]    0
    And Response body has correct self link