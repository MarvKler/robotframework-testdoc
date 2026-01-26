*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    spryker-core    customer-access    acl    agent-assist


*** Test Cases ***
Agent_can_get_customer_impersonation_token
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    When I send a POST request:
    ...    /agent-customer-impersonation-access-tokens
    ...    {"data": {"type": "agent-customer-impersonation-access-tokens","attributes":{"customerReference": "${yves_user.reference}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should be:    [data][type]    agent-customer-impersonation-access-tokens
    And Response body parameter should be:    [data][attributes][tokenType]    Bearer
    And Response body parameter should be greater than:    [data][attributes][expiresIn]    25000
    And Response body parameter should not be EMPTY:    [data][attributes][accessToken]
    And Response body parameter should not be EMPTY:    [data][attributes][refreshToken]
    And Response body has correct self link internal

Customer_impersonation_token_can_be_used
    [Setup]    Run Keywords    I send a POST request:    /agent-access-tokens    {"data": {"type": "agent-access-tokens","attributes": {"username": "${agent.email}","password": "${agent.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    agent_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${agent_token}
    ...    AND    I send a POST request:    /agent-customer-impersonation-access-tokens    {"data": {"type": "agent-customer-impersonation-access-tokens","attributes":{"customerReference": "${yves_user.reference}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    impersonation_token
    ...    AND    I Set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${impersonation_token}
    When I send a POST request:
    ...    /carts
    ...    {"data": {"type": "carts","attributes": {"name": "cart${random}","priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    cart_uid
    And I send a POST request:
    ...    /carts/${cart_uid}/items
    ...    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku}","quantity": 1}}}
    And Response status code should be:    201
    When I get access token for the customer:    ${yves_user.email}
    And I Set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    Then I send a GET request:    /carts/${cart_uid}?include=items
    And Response status code should be:    200
    And Response body parameter should be:    [data][id]    ${cart_uid}
    And Response body parameter should be:
    ...    [included][0][attributes][sku]
    ...    ${concrete.available_product.with_stock_and_never_out_of_stock.sku}
