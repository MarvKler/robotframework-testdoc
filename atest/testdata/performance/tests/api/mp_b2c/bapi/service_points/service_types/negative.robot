*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/api_service_point_steps.robot
Test Tags    bapi

*** Test Cases ***
Create_Service_Type_With_Maximum_Length_Key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "dsfhkjndfjknjknfksdnfkjnsdjkfndskjfndsfjnsdkfnk2374qe69ady78huijkndsfhkjndfjknjknfksdnfkjnsdjkfndskjfndsfjnsdkfnk2374qe69ady78huijkndsfhkjndfjknjknfksdnfkjnsdjkfndskjfndsfjnsdkfnk2374qe69ady78huijkndsfhkjndfjknjknfksdnfkjnsdjkfndskjfndsfjnsdkfnk2374333asss"}}}
    Then Response status code should be:    400
    And Response should return error code:    5420
    And Response should return error message:    A service type key must have length from 1 to 255 characters.

Create_Service_Type_With_256_Length_Name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "dsfhkjndfjknjknfksdnfkjnsdjkfndskjfndsfjnsdkfnk2374qe69ady78huijkndsfhkjndfjknjknfksdnfkjnsdjkfndskjfndsfjnsdkfnk2374qe69ady78huijkndsfhkjndfjknjknfksdnfkjnsdjkfndskjfndsfjnsdkfnk2374qe69ady78huijkndsfhkjndfjknjknfksdnfkjnsdjkfndskjfndsfjnsdkfnk2374333asss", "key": "service1-test${random}"}}}
    Then Response status code should be:    400
    And Response should return error code:    5422
    And Response should return error message:    A service type name must have length from 1 to 255 characters.

Create_Duplicate_Service_Type_Key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    Create service type in DB    uuid=with-duplicate-key    name=Duplicate key     key=with-duplicate-key
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Another Service 2 ${random}", "key": "with-duplicate-key"}}}
    Then Response status code should be:    400
    And Response should return error code:    5419
    And Response should return error message:    A service type with the same key already exists.
    [Teardown]    Delete service type in DB    with-duplicate-key

Create_Service_Type_With_Duplicate_Name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    Create service type in DB    uuid=with-duplicate-name${random}    name=Duplicate Service     key=with-duplicate-name${random}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Duplicate Service", "key": "another-key${random}"}}}
    Then Response status code should be:    400
    And Response should return error code:    5425
    And Response should return error message:    A service type with the same name already exists.
    [Teardown]    Delete service type in DB    with-duplicate-name${random}

Create_Service_Type_With_Empty_Key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Invalid Key Length", "key": ""}}}
    Then Response status code should be:    400
    And Response should return error code:    5420
    And Response should return error message:    A service type key must have length from 1 to 255 characters.

Create_Service_Type_With_Empty_Name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "", "key": "invalid-name-length"}}}
    Then Response status code should be:    400
    And Response should return error code:    5422
    And Response should return error message:    A service type name must have length from 1 to 255 characters.

Create_Service_Type_without_Auth
    And I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "service1-test${random}"}}}
    Then Response status code should be:    403

Create_Service_Type_with_incorrect_Auth
    And I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer incorrect
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "service1-test${random}"}}}
    Then Response status code should be:    401

Update_Service_Type_Key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    Create service type in DB    uuid=update-service-type-key${random}    name=update-service-type-key     key=update-service-type-key${random}
    When I send a PATCH request:    /service-types/update-service-type-key${random}    {"data": {"type": "service-types", "attributes": {"key": "new-key"}}}
    Then Response status code should be:    400
    And Response should return error code:    5423
    And Response should return error message:    The service type key is immutable.
    [Teardown]    Delete service type in DB    update-service-type-key${random}

Update_Not_Existing_Service_Type
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a PATCH request:    /service-types/not-existing-service-type    {"data": {"type": "service-types", "attributes": {"name": "Updated Service Name ${random}","key": "original-key${random}"}}}
    Then Response status code should be:    404
    And Response should return error code:    5418
    And Response should return error message:    The service type entity was not found.

Update_Service_Type_with_incorrect_type
    [Documentation]    https://spryker.atlassian.net/browse/FRW-6312
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    Create service type in DB    uuid=serv-ty${random}    name=New Service     key=serv-ty${random}
    When I send a PATCH request:    /service-types/serv-ty${random}    {"data": {"type": "incorrect-types", "attributes": {"name": "Updated Service", "key": "serv-ty${random}"}}}
    Then Response status code should be:    400
    [Teardown]    Delete service type in DB    serv-ty${random}

Update_Service_Type_without_Auth
    When Create service type in DB    12345678${random}    test    test
    And I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer
    When I send a PATCH request:    /service-types/12345678${random}    {"data": {"type": "service-types", "attributes": {"name": "Updated Service Name","key": "12345678${random}"}}}
    Then Response status code should be:    403
    [Teardown]    Delete service type in DB    12345678${random}

Get_Service_Types_No_Auth
    I set Headers:    Content-Type=${default_header_content_type}
    When I send a GET request:    /service-types
    Then Response status code should be:    403
    And Response should return error message:    Unauthorized request.

Get_Service_Types_Invalid_Auth
    When I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer InvalidToken
    When I send a GET request:    /service-types
    Then Response status code should be:    401
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Get_Service_Type_By_ID_No_Auth
    I set Headers:    Content-Type=${default_header_content_type}
    Create service type in DB    uuid=service-by-id${random}    name=service-by-id     key=service-by-id${random}
    When I send a GET request:    /service-types/service-by-id${random}
    Then Response status code should be:    403
    And Response should return error message:    Unauthorized request.
    [Teardown]    Delete service type in DB    service-by-id${random}

Get_Service_Type_By_ID_invalid_Auth
    I set Headers:    Content-Type=${default_header_content_type}
    Create service type in DB    uuid=service-invalid${random}    name=service-invalid     key=service-invalid${random}
    When I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer InvalidToken
    When I send a GET request:    /service-types/service-invalid${random}
    Then Response status code should be:    401
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
    [Teardown]    Delete service type in DB    service-invalid${random}

Get_Nonexistent_Service_Type
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a GET request:    /service-types/nonexistent_id
    Then Response status code should be:    404
    And Response should return error code:    5418
    And Response should return error message:    The service type entity was not found.