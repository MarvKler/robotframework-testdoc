*** Settings ***
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        API_test_setup
Test Tags    glue    customer-access    customer-account-management    spryker-core    mailing-notifications

*** Test Cases ***
Restore_password_without_customer_id
    I send a PATCH request:    /customer-restore-password/   {"data":{"type":"customer-restore-password","attributes":{"restorePasswordKey":"5ec608df9c0dd57c3dd08b540d4a68da","password":"${yves_user.password}","confirmPassword":"${yves_user.password}"}}}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Restore_password_with_empty_type
    I send a PATCH request:    /customer-restore-password/${yves_user.reference}   {"data":{"type":"","attributes":{"restorePasswordKey":"5ec608df9c0dd57c3dd08b540d4a68da","password":"${yves_user.password}","confirmPassword":"${yves_user.password}"}}}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Restore_password_with_incorrect_type
    I send a PATCH request:    /customer-restore-password/${yves_user.reference}   {"data":{"type":"fake","attributes":{"restorePasswordKey":"5ec608df9c0dd57c3dd08b540d4a68da","password":"${yves_user.password}","confirmPassword":"${yves_user.password}"}}}
    And Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Restore_password_without_restorePasswordKey
    I send a PATCH request:    /customer-restore-password/${yves_user.reference}   {"data":{"type":"customer-restore-password","attributes":{"restorePasswordKey":"","password":"${yves_user.password}","confirmPassword":"${yves_user.password}"}}}
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    restorePasswordKey => This value should not be blank.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Restore_password_with_empty_new_password_value
    I send a PATCH request:    /customer-restore-password/${yves_user.reference}   {"data":{"type":"customer-restore-password","attributes":{"restorePasswordKey":"a46b40a8e1befff4cf0df9c7c2ace5f2","password":"","confirmPassword":"${yves_user.password}"}}}
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Array in response should contain property with value:    [errors]    detail    password => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    password => This value is too short. It should have 12 characters or more.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Restore_password_with_empty_new_confirmation_password_value
    I send a PATCH request:    /customer-restore-password/${yves_user.reference}   {"data":{"type":"customer-restore-password","attributes":{"restorePasswordKey":"a46b40a8e1befff4cf0df9c7c2ace5f2","password":"${yves_user.password}","confirmPassword":""}}}
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Array in response should contain property with value:    [errors]    detail    confirmPassword => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    confirmPassword => This value is too short. It should have 12 characters or more.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Restore_password_with_too_short_new_password
    I send a PATCH request:    /customer-restore-password/${yves_user.reference}   {"data":{"type":"customer-restore-password","attributes":{"restorePasswordKey":"a46b40a8e1befff4cf0df9c7c2ace5f2","password":"test","confirmPassword":"test"}}}
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Array in response should contain property with value:    [errors]    detail    password => This value is too short. It should have 12 characters or more.
    And Array in response should contain property with value:    [errors]    detail    confirmPassword => This value is too short. It should have 12 characters or more.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Restore_password_with_too_long_new_password
    I send a PATCH request:    /customer-restore-password/${yves_user.reference}   {"data":{"type":"customer-restore-password","attributes":{"restorePasswordKey":"a46b40a8e1befff4cf0df9c7c2ace5f2","password":"Change!23456pqwertyuiopqwertyuiopqwertyuiopqwertyuiopqwertyuiopqwertyuioppqwertyuiopqwertyuiopqwertyuiopqwertyuiopqwertyuiopqwert","confirmPassword":"Change!23456pqwertyuiopqwertyuiopqwertyuiopqwertyuiopqwertyuiopqwertyuioppqwertyuiopqwertyuiopqwertyuiopqwertyuiopqwertyuiopqwert"}}}
    And Response status code should be:    422
    And Response should return error code:    901
    And Response reason should be:    Unprocessable Content
    And Array in response should contain property with value:    [errors]    detail    password => This value is too long. It should have 128 characters or less.
    And Array in response should contain property with value:    [errors]    detail    confirmPassword => This value is too long. It should have 128 characters or less.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Restore_password_with_not_equal_new_password_and_confirm_password
    I send a PATCH request:    /customer-restore-password/${yves_user.reference}   {"data":{"type":"customer-restore-password","attributes":{"restorePasswordKey":"aa2fbd68447da919fcb7da1a8d2d3c7a","password":"${yves_user.password_new_additional}","confirmPassword":"${yves_user.password_new}"}}}
    And Response status code should be:    422
    And Response should return error code:    406
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    Value in field password should be identical to value in the confirmPassword field.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}

Restore_password_with_incorrect_url
    I send a PATCH request:    /customer-restorepassword/${yves_user.reference}   {"data":{"type":"customer-restore-password","attributes":{"restorePasswordKey":"aa2fbd68447da919fcb7da1a8d2d3c7a","password":"${yves_user.password}","confirmPassword":"${yves_user.password_new}"}}}
    And Response status code should be:    404
    And Response reason should be:    Not Found
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
