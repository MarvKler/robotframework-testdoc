*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../resources/common/common_api.robot
Test Tags    bapi

*** Test Cases ***
Generate_new_user_token
    When I set Headers:    Content-Type=application/x-www-form-urlencoded
    When I send a POST request:    /token  {"grantType": "${grant_type.password}","username": "${zed_admin.email}","password": "${zed_admin.password}"}
    Then Response status code should be:    200
    And Response body parameter should be:    [token_type]    Bearer
    And Response body parameter should be greater than:    [expires_in]    0
    And Response body parameter should be less than:    [expires_in]    30000
    And Response body parameter should not be EMPTY:    [token_type]
    And Response body parameter should not be EMPTY:    [access_token]
    And Response body parameter should not be EMPTY:    [refresh_token]

#  Generate_new_warehouse_token
#     # needs to be completed as werahouse token can be created only for user who is a warehouse user with assigned and ACTIVE warehouse.
#     # Making user a warehouse user is available now only via Back office frontend.
#     When I set Headers:    Content-Type=application/x-www-form-urlencoded
#     When I send a POST request:    /token  {"grantType": "${grant_type.password}","username": "${zed_admin.email}","password": "${zed_admin.password}"}
#     Then Response status code should be:    200
#     And Save value to a variable:    [access_token]   bapi_token
#     When I set Headers:    Authorization=${bapi_token}    Content-Type=application/x-www-form-urlencoded
#     And I send a POST request:    /warehouse-tokens   {}
#     Then Response status code should be:    201
#     And Response body parameter should be:    [data][type]    warehouse-tokens
#     And Response body parameter should be:    [data][attributes]    Bearer
#     And Response body parameter should be greater than:    [data][attributes][expiresin]    0
#     And Response body parameter should be less than:    [data][attributes][expiresin]    30000
#     And Response body parameter should not be EMPTY:    [data][attributes][tokenType]
#     And Response body parameter should not be EMPTY:    [data][attributes][accessToken]
#     And Response body parameter should not be EMPTY:    [data][attributes][refreshToken]   
#     And Response body has correct self link internal