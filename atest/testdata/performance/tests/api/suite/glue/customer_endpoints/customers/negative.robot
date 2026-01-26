*** Settings ***
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    customer-access    customer-account-management    spryker-core    mailing-notifications

*** Test Cases ***
Create_a_customer_with_already_existing_email
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"${gender.male}","salutation":"${yves_third_user.salutation}","email":"${yves_user.email}","password":"${yves_user.password_new}","confirmPassword":"${yves_user.password_new}","acceptedTerms":true}}}
    Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    400
    And Response should return error message:    If this email address is already in use, you will receive a password reset link. Otherwise you must first validate your e-mail address to finish registration. Please check your e-mail.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Create_a_customer_with_too_short_password
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"${gender.male}","salutation":"${yves_third_user.salutation}","email":"${yves_user.email}","password":"Test12!","confirmPassword":"Test12!","acceptedTerms":true}}}
    Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    password => This value is too short. It should have 12 characters or more.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Create_a_customer_with_too_long_password
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"${gender.male}","salutation":"${yves_third_user.salutation}","email":"${yves_user.email}","password":"Change!23456pqwertyuiopqwertyuiopqwertyuiopqwertyuiopqwertyuiopqwertyuioppqwertyuiopqwertyuiopqwertyuiopqwertyuiopqwertyuiopqwert","confirmPassword":"Change!23456pqwertyuiopqwertyuiopqwertyuiopqwertyuiopqwertyuiopqwertyuioppqwertyuiopqwertyuiopqwertyuiopqwertyuiopqwertyuiopqwert","acceptedTerms":true}}}
    Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    password => This value is too long. It should have 128 characters or less.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Create_a_customer_with_not_equal_passwords
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"${gender.male}","salutation":"${yves_third_user.salutation}","email":"${yves_user.email}","password":"${yves_user.password_new}","confirmPassword":"1234567890123","acceptedTerms":true}}}
    Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    406
    And Response should return error message:    Value in field password should be identical to value in the confirmPassword field.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Create_a_customer_with_not_accepted_terms_and_coditions
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"${gender.male}","salutation":"${yves_third_user.salutation}","email":"${yves_user.email}","password":"${yves_user.password_new}","confirmPassword":"${yves_user.password_new}","acceptedTerms":false}}}
    Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    acceptedTerms => This value should be true.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Create_a_customer_with_empty_type
    I send a POST request:    /customers/    {"data":{"type":"","attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"${gender.male}","salutation":"${yves_third_user.salutation}","email":"${yves_user.email}","password":"${yves_user.password}","confirmPassword":"${yves_user.password}","acceptedTerms":false}}}
    Response status code should be:    400
    And Response reason should be:   Bad Request
    And Response should return error message:    Invalid type.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Create_a_customer_with_empty_values_for_required_fields
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"","lastName":"","gender":"","salutation":"","email":"","password":"","confirmPassword":"","acceptedTerms":""}}}
    Response status code should be:    422
    And Response reason should be:   Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    firstName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    lastName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    gender => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    gender => The value you selected is not a valid choice.
    And Array in response should contain property with value:    [errors]    detail    salutation => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    salutation => The value you selected is not a valid choice.
    And Array in response should contain property with value:    [errors]    detail    email => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    password => This value is too short. It should have 12 characters or more.
    And Array in response should contain property with value:    [errors]    detail    confirmPassword => This value is too short. It should have 12 characters or more.
    And Array in response should contain property with value:    [errors]    detail    acceptedTerms => This value should be true.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Create_a_customer_with_absent_type
    I send a POST request:    /customers/    {"data":{"attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"${gender.male}","salutation":"${yves_third_user.salutation}","email":"${yves_third_user.first_name}@spryker.com","password":"${yves_user.password}","confirmPassword":"${yves_user.password}","acceptedTerms":true}}}
    Response status code should be:    400
    And Response reason should be:   Bad Request
    And Response should return error message:    Post data is invalid.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Create_a_customer_with_wrong_email_format
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"${gender.male}","salutation":"${yves_third_user.salutation}","email":"test.com","password":"${yves_user.password}","confirmPassword":"${yves_user.password}","acceptedTerms":true}}}
    Response status code should be:    422
    And Response reason should be:   Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    email => This value is not a valid email address.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Create_a_customer_with_missing_required_fields
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{}}}
    Response status code should be:    422
    And Response reason should be:   Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    email => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    salutation => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    firstName => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    lastName => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    password => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    confirmPassword => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    acceptedTerms => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    gender => This field is missing.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Create_a_customer_with_wrong_gender
    I send a POST request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"test","salutation":"test","email":"${yves_third_user.first_name}@spryker.com","password":"${yves_user.password}","confirmPassword":"${yves_user.password}","acceptedTerms":true}}}
    Response status code should be:    422
    And Response reason should be:   Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    gender => The value you selected is not a valid choice.
    And Array in response should contain property with value:    [errors]    detail    salutation => The value you selected is not a valid choice.

Get_a_customer_with_wrong_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a GET request:    /customers/DE35
    Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    402
    And Response should return error message:    Customer not found.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Get_a_cusomer_without_access_token
    I send a GET request:    /customers/DE35
    Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Get_a_customer_with_access_token_from_another_user
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a GET request:    /customers/${yves_second_user.reference}
    Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    402
    And Response should return error message:    Customer not found.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_a_customer_with_wrong_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a PATCH request:    /customers/DE--30   {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"${gender.male}","salutation":"${yves_third_user.salutation}","email":"${yves_third_user.first_name}@spryker.com","password":"${yves_user.password_new}","confirmPassword":"${yves_user.password_new}","acceptedTerms":true}}}
    Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    411
    And Response should return error message:    Unauthorized request.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_a_customer_with_empty_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a PATCH request:    /customers/${yves_user.reference}    {"data":{"type":"","attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"${gender.male}","salutation":"${yves_third_user.salutation}","email":"${yves_third_user.first_name}@spryker.com","password":"${yves_user.password}","confirmPassword":"${yves_user.password}","acceptedTerms":true}}}
    Response status code should be:    400
    And Response reason should be:   Bad Request
    And Response should return error message:    Invalid type.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_a_customer_with_empty_values_for_required_fields
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a PATCH request:    /customers/${yves_user.reference}    {"data":{"type":"customers","attributes":{"firstName":"","lastName":"","gender":"","salutation":"","email":"","password":"","confirmPassword":"","acceptedTerms":false}}}
    Response status code should be:    422
    And Response reason should be:   Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    firstName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    lastName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    gender => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    gender => The value you selected is not a valid choice.
    And Array in response should contain property with value:    [errors]    detail    salutation => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    salutation => The value you selected is not a valid choice.
    And Array in response should contain property with value:    [errors]    detail    email => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    password => This value is too short. It should have 12 characters or more.
    And Array in response should contain property with value:    [errors]    detail    confirmPassword => This value is too short. It should have 12 characters or more.
     And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_a_customer_with_absent_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a PATCH request:    /customers/${yves_user.reference}    {"data":{"attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"${gender.male}","salutation":"${yves_third_user.salutation}","email":"${yves_third_user.first_name}@spryker.com","password":"${yves_user.password}","confirmPassword":"${yves_user.password}","acceptedTerms":true}}}
    Response status code should be:    400
    And Response reason should be:   Bad Request
    And Response should return error message:    Post data is invalid.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_a_customer_with_invalid_data
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a PATCH request:    /customers/${yves_user.reference}    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"test","salutation":"test","email":"${yves_third_user.first_name}@spryker.com","password":"${yves_user.password}","confirmPassword":"${yves_user.password}","acceptedTerms":true}}}
       Response status code should be:    422
    And Response reason should be:   Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    gender => The value you selected is not a valid choice.
    And Array in response should contain property with value:    [errors]    detail    salutation => The value you selected is not a valid choice.

Update_a_customer_without_access_token
    I send a PATCH request:    /customers/DE--35    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"${gender.male}","salutation":"${yves_third_user.salutation}","email":"${yves_third_user.first_name}@spryker.com","password":"${yves_user.password}","confirmPassword":"${yves_user.password}","acceptedTerms":true}}}
    Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Update_a_customer_without_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a PATCH request:    /customers/    {"data":{"type":"customers","attributes":{"firstName":"${yves_third_user.first_name}","lastName":"${yves_third_user.last_name}","gender":"${gender.male}","salutation":"${yves_third_user.salutation}","email":"${yves_third_user.first_name}@spryker.com","password":"${yves_user.password}","confirmPassword":"${yves_user.password}","acceptedTerms":true}}}
    Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Delete_a_cusomer_without_access_token
    I send a DELETE request:    /customers/DE--35
    Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Delete_a_customer_without_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a DELETE request:    /customers/
    Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
Delete_a_customer_with_access_token_from_another
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a DELETE request:    /customers/DE--30
    Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    411
    And Response should return error message:    Unauthorized request.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Delete_a_customer_with_invalid_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    I send a DELETE request:    /customers/fake-id
    Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    411
    And Response should return error message:    Unauthorized request.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
