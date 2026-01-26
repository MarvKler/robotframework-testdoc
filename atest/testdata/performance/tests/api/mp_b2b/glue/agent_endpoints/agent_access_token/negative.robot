*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    spryker-core    customer-access    acl    agent-assist

*** Test Cases ***
Get_agent_token_for_user_who_is_not_agent
    When I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${non_agent.email}","password": "${non_agent.password}"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4101
    And Response should return error message:    Failed to authenticate an agent.

Get_agent_token_with_invalid_password
    When I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "fake"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4101
    And Response should return error message:    Failed to authenticate an agent.

Get_agent_token_with_non-existent_email
    When I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "fake@spryker.com","password": "${agent.password}"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4101
    And Response should return error message:    Failed to authenticate an agent.

Get_agent_token_with_empty_email
    When I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "","password": "${agent.password}"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4101
    And Response should return error message:    Failed to authenticate an agent.

Get_agent_token_with_empty_password
    When I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": ""}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    4101
    And Response should return error message:    Failed to authenticate an agent.

Get_agent_token_with_wrong_type
    When I send a POST request:    /agent-access-tokens    {"data": {"type": "access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.
