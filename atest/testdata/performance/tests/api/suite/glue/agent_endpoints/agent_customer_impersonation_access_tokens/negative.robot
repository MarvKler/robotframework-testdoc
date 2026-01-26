*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    spryker-core    customer-access    acl    agent-assist

*** Test Cases ***
Agent_cannot_impersonate_customer_with_no_agent_token
    When I send a POST request:    /agent-customer-impersonation-access-tokens    {"data": {"type": "agent-customer-impersonation-access-tokens","attributes":{"customerReference": "${yves_user.reference}"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4103
    And Response should return error message:    Action is available to agent user only.

Agent_cannot_impersonate_customer_with_wrong_token_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a POST request:    /agent-customer-impersonation-access-tokens    {"data": {"type": "agent-customer-impersonation-access-tokens","attributes":{"customerReference": "${yves_user.reference}"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4103
    And Response should return error message:    Action is available to agent user only.

Agent_cannot_impersonate_customer_with_invalid_token
    [Setup]    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer fake
    When I send a POST request:    /agent-customer-impersonation-access-tokens    {"data": {"type": "agent-customer-impersonation-access-tokens","attributes":{"customerReference": "${yves_user.reference}"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Agent_cannot_impersonate_customer_with_wrong_type
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a POST request:    /agent-customer-impersonation-access-tokens    {"data": {"type": "agent-customer-impersonation-access-token","attributes":{"customerReference": "${yves_user.reference}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.

Agent_cannot_impersonate_customer_with_invalid_customer_reference
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a POST request:    /agent-customer-impersonation-access-tokens    {"data": {"type": "agent-customer-impersonation-access-tokens","attributes":{"customerReference": "fake"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4104
    And Response should return error message:    Failed to impersonate a customer.

Agent_cannot_impersonate_customer_with_empty_customer_reference
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a POST request:    /agent-customer-impersonation-access-tokens    {"data": {"type": "agent-customer-impersonation-access-tokens","attributes":{"customerReference": ""}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4104
    And Response should return error message:    Failed to impersonate a customer.

Agent_cannot_impersonate_customer_with_missing_customer_reference
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a POST request:    /agent-customer-impersonation-access-tokens    {"data": {"type": "agent-customer-impersonation-access-tokens","attributes":{}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4104
    And Response should return error message:    Failed to impersonate a customer.