*** Settings ***
Suite Setup    API_suite_setup
Test Setup        API_test_setup
Test Tags    glue    spryker-core    customer-access    acl    agent-assist
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Not_agent_can't_get_search_for_customers
    When I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${non_agent.email}","password": "${non_agent.password}"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4101
    And Response should return error message:    Failed to authenticate an agent.
    When I send a GET request:    /agent-customer-search
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4103
    And Response should return error message:    Action is available to agent user only.


Agent_can't_get_search_for_customers_without_token
    When I send a GET request:    /agent-customer-search
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4103
    And Response should return error message:    Action is available to agent user only.

Agent_searches_for_customers_with_customer_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a GET request:    /agent-customer-search
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4103
    And Response should return error message:    Action is available to agent user only.
