*** Settings ***
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    customer-access    customer-account-management    spryker-core    mailing-notifications

*** Test Cases ***
Create_customer
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"${gender.male}","salutation":"${yves_third_user.salutation}","email":"${email.name}+${random}${email.domain}","password":"${yves_user.password_new}","confirmPassword":"${yves_user.password_new}","acceptedTerms":true}}}
    Response status code should be:    201
    And Save value to a variable:    [data][id]    user_id
    And Save value to a variable:    [data][attributes][email]    userEmail
    And Save the result of a SELECT DB query to a variable:  select registration_key from spy_customer where customer_reference = '${user_id}'    confirmation_key
    And I send a POST request:    /customer-confirmation    {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"${confirmation_key}"}}}
    And I get access token for the customer:    ${userEmail}    ${yves_user.password_new}
    And I set Headers:    Authorization=${token}
    And I send a GET request:    /customers/${user_id}
    And Response reason should be:    OK
    And Response status code should be:    200
    And Response body parameter should be:    [data][type]    customers
    And Response body parameter should be:    [data][id]    ${user_id}
    And Response body parameter should be:    [data][attributes][firstName]    ${yves_third_user.first_name}
    And Response body parameter should be:    [data][attributes][lastName]    ${yves_third_user.last_name}
    And Response body parameter should be:    [data][attributes][email]    ${userEmail}
    And Response body parameter should be:    [data][attributes][gender]    ${gender.male}
    And Response body parameter should be:    [data][attributes][salutation]    ${yves_third_user.salutation}
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should not be EMPTY:    [data][attributes][updatedAt]
    [Teardown]    Run Keywords    I send a DELETE request:    /customers/${user_id}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

New_customer_can_login_after_confirmation
    [Setup]    Run Keywords    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"${gender.male}","salutation":"${yves_third_user.salutation}","email":"${email.name}${random}${email.domain}","password":"${yves_user.password_new}","confirmPassword":"${yves_user.password_new}","acceptedTerms":true}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    userId
    ...    AND    Save value to a variable:    [data][attributes][email]    userEmail
    ...    AND    Save the result of a SELECT DB query to a variable:  select registration_key from spy_customer where customer_reference = '${userId}'    confirmation_key
    I send a POST request:    /customer-confirmation   {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"${confirmation_key}"}}}
    And Response status code should be:    204
    And Response reason should be:    No Content
    I send a POST request:    /access-tokens    {"data":{"type":"access-tokens","attributes":{"username":"${userEmail}","password":"${yves_user.password_new}"}}}
    And Response status code should be:    201
    And Save value to a variable:    [data][attributes][accessToken]    token
    And Response reason should be:    Created
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I get access token for the customer:    ${userEmail}    ${yves_user.password_new}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a DELETE request:    /customers/${userId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

Get_customer_contains_all_available_fields
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a GET request:    /customers/${yves_user.reference}
    Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    customers
    And Response body parameter should be:    [data][id]    ${yves_user.reference}
    And Response body parameter should be:    [data][attributes][firstName]    ${yves_user.first_name}
    And Response body parameter should be:    [data][attributes][lastName]    ${yves_user.last_name}
    And Response body parameter should be:    [data][attributes][email]    ${yves_user.email}
    And Response body parameter should be:    [data][attributes][gender]    ${gender.female}
    And Response body parameter should be:    [data][attributes][salutation]    ${yves_user.salutation}
    And Response body parameter should not be EMPTY:    [data][attributes][createdAt]
    And Response body parameter should not be EMPTY:    [data][attributes][updatedAt]
    And Response body has correct self link internal

Update_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a PATCH request:    /customers/${yves_user.reference}    {"data":{"type":"customers","attributes":{"firstName":"${yves_second_user.first_name}","lastName":"${yves_second_user.last_name}","gender":"${gender.male}","salutation":"${yves_second_user.salutation}","email":"${yves_user.email}","password":"${yves_user.password_new}","confirmPassword":"${yves_user.password_new}","acceptedTerms":true}}}
    Response status code should be:    200
    And Response body has correct self link internal
    And I send a GET request:    /customers/${yves_user.reference}
    Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][attributes][salutation]    ${yves_second_user.salutation}
    And Response body parameter should be:    [data][attributes][firstName]    ${yves_second_user.first_name}
    And Response body parameter should be:    [data][attributes][lastName]    ${yves_second_user.last_name}
    And Response body parameter should be:    [data][attributes][gender]    ${gender.male}
    [Teardown]    Run Keywords    I send a PATCH request:    /customers/${yves_user.reference}    {"data":{"type":"customers","attributes":{"firstName":"${yves_user.first_name}","lastName":"${yves_user.last_name}","gender":"${gender.female}","salutation":"${yves_user.salutation}","email":"${yves_user.email}","password":"${yves_user.password_new}","confirmPassword":"${yves_user.password_new}","acceptedTerms":true}}}
    ...    AND    Response status code should be:    200
    ...    AND    Response body parameter should be:    [data][attributes][salutation]    ${yves_user.salutation}

Get_customer_array_contains_all_available_fields
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a GET request:    /customers/
    And Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][type]    customers
    And Response body parameter should be:    [data][0][id]    ${yves_user.reference}
    And Response body parameter should be:    [data][0][attributes][firstName]    ${yves_user.first_name}
    And Response body parameter should be:    [data][0][attributes][lastName]    ${yves_user.last_name}
    And Response body parameter should be:    [data][0][attributes][email]    ${yves_user.email}
    And Response body parameter should be:    [data][0][attributes][gender]    ${gender.female}
    And Response body parameter should be:    [data][0][attributes][salutation]    ${yves_user.salutation}
    And Response body parameter should not be EMPTY:    [data][0][attributes][createdAt]
    And Response body parameter should not be EMPTY:    [data][0][attributes][updatedAt]

Delete_customer
    [Setup]    Run Keywords    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"${gender.male}","salutation":"${yves_third_user.salutation}","email":"${email.name}+${random}${email.domain}","password":"${yves_user.password_new}","confirmPassword":"${yves_user.password_new}","acceptedTerms":true}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    userId
    ...    AND    Save value to a variable:    [data][attributes][email]    userEmail
    ...    AND     Save the result of a SELECT DB query to a variable:  select registration_key from spy_customer where customer_reference = '${userId}'    confirmation_key
    ...    AND    I send a POST request:    /customer-confirmation    {"data":{"type":"customer-confirmation","attributes":{"registrationKey":"${confirmation_key}"}}}
    ...    AND    I get access token for the customer:    ${userEmail}    ${yves_user.password_new}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a DELETE request:    /customers/${userId}
    And Response status code should be:    204
    And Response reason should be:    No Content
