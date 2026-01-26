*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    customer-access    customer-account-management    spryker-core    mailing-notifications


*** Test Cases ***
Update_customer_password_with_all_required_fields_and_valid_data
    [Setup]    Run Keywords    I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${yves_eighth_user.email}","password":"${yves_eighth_user.password}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    token
    When I set Headers:    Authorization=Bearer ${token}
    AND I send a PATCH request:
    ...    /customer-password/${yves_eighth_user.reference}
    ...    {"data":{"type":"customer-password","attributes":{"password":"${yves_eighth_user.password}","newPassword":"${yves_eighth_user.password_new}","confirmPassword":"${yves_eighth_user.password_new}"}}}
    Response status code should be:    204
    And Response reason should be:    No Content
    And I send a POST request:
    ...    /access-tokens
    ...    {"data":{"type":"access-tokens","attributes":{"username":"${yves_eighth_user.email}","password":"${yves_eighth_user.password_new_additional}"}}}
    Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    003
    And Response should return error message:    Failed to authenticate user.
    And I send a POST request:
    ...    /access-tokens
    ...    {"data":{"type":"access-tokens","attributes":{"username":"${yves_eighth_user.email}","password":"${yves_eighth_user.password_new}"}}}
    And Response status code should be:    201
