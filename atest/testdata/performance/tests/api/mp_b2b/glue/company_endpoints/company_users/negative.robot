*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    spryker-core    company-account    customer-account-management    customer-access

*** Test Cases ***
Retrieve_list_of_company_users_without_access_token
    When I send a GET request:    /company-users
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Retrieve_list_of_company_users_by_user_without_admin_role
    When I get access token for the customer:    ${yves_shared_shopping_list_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /company-users
    Then Response status code should be:    403
    And Response reason should be:    Forbidden

Retrieve_company_user_by_incorrect_id
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /company-users/qwerty
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    1404
    And Response should return error message:    Company user not found

Retrieve_company_user_with incorrect_token
    When I get access token for the customer:    ${yves_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=qwerty
    And I send a GET request:    /company-users/qwerty
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Retrieve_user_who_doesn't_belong_to_company
    When I get access token for the customer:    ${yves_second_user.email}
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /company-users/
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    1403
    And Response should return error message:    Current company user is not set. You need to select the current company user with \/company-user-access-tokens in order to access the resource collection.