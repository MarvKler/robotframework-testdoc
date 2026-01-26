*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    customer-access    customer-account-management    spryker-core    mailing-notifications

*** Test Cases ***
Customer_confirmation_with_wrong_confirmation_key
    When I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"39085d16b04b34265910c7ea2a35367ggh"}}}
    Then Response status code should be:    422
    And Response should return error message:    This email confirmation code is invalid or has been already used.
    And Response should return error code:    423
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Customer_confirmation_with_empty_confirmation_key
    When I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":""}}}
    Then Response status code should be:    422
    And Response should return error code:    901
    And Response should return error message:    registrationKey => This value should not be blank.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Customer_confirmation_without_confirmation_key
    When I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{}}}
    Then Response status code should be:    422
    And Response should return error code:    901
    And Response should return error message:    registrationKey => This field is missing.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Customer_confirmation_with_empty_type
    When I send a POST request:    /customer-confirmation   {"data":{"type":"","attributes":{"registrationKey":"607a17d1c673f461ca40002ea79fddc0"}}}
    Then Response status code should be:    400
    And Response should return error message:    Invalid type.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Customer_confirmation_with_already_used_confirmation_key
    [Setup]    Run Keywords    I send a POST request:    /customers    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"${gender.male}","salutation":"${yves_third_user.salutation}","email":"${yves_third_user.first_name}.${yves_third_user.last_name}${random}@spryker.com","password":"${yves_third_user.password_new}","confirmPassword":"${yves_third_user.password_new}","acceptedTerms":true}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    user_reference_id
    ...    AND    Save the result of a SELECT DB query to a variable:    select registration_key from spy_customer where customer_reference = '${user_reference_id}'    confirmation_key
    ...    AND    I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"${confirmation_key}"}}}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content
    When I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"${confirmation_key}"}}}
    Then Response status code should be:    422
    And Response should return error code:    423
    And Response should return error message:    This email confirmation code is invalid or has been already used.
    [Teardown]    Run Keywords    I get access token for the customer:    ${yves_third_user.first_name}.${yves_third_user.last_name}${random}@spryker.com    ${yves_third_user.password_new}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a DELETE request:    /customers/${user_reference_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content
