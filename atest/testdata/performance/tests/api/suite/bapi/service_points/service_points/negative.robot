*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/api_service_point_steps.robot
Test Tags    bapi    spryker-core    spryker-core-back-office    service-points    shipment-service-points    product-offer-service-points    service-points-cart    product-offer-service-points-availability    marketplace-merchant-product-offer-service-points-availability    shipment-product-offer-service-points-availability    marketplace-merchant-portal-product-offer-service-points    inventory-management    marketplace-inventory-management 

*** Test Cases ***
Create_Service_Point_With_Existing_Key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Service Point Name1","key": "service-point${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][attributes][key]    service_point_key
    And Save value to a variable:    [data][id]    service_point_id
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Service Point Name2","key": "service-point${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    400
    And Response should return error code:    5404
    And Response should return error message:    A service point with the same key already exists.
    [Teardown]    Deactivate service point via BAPI    ${service_point_id}

Create_Service_Point_With_Invalid_Key_Length
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Incorrect key lenghth","key": "fihslafnkjskdjfnskadfkafkjsadfkjsdjnnkfjsdkfjdskdjfhnjdksbfjhdsbfjkdsfbjsdfjksdfjksdfhdjksfhkdsf jkdsfhjdhsfjhdsjfhdsfjhsjkfhkshkjdsahf78348937489137489yewhkjdsfildksh9832urqewdiosjakrj3982diasjif8d3j89siojfdisakjfdiksdjfkasdjfhkjdashfjkldsahfldchgjhjjghjg2","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    400
    And Response should return error code:    5405
    And Response should return error message:    A service point key must have length from 1 to 255 characters.

Create_Service_Point_With_Empty_Key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "New Service Point", "key": "", "isActive": "true", "stores": ["DE", "AT"]}}}
    Then Response status code should be:    400
    And Response should return error code:    5405
    And Response should return error message:    A service point key must have length from 1 to 255 characters.

Create_Service_Point_Without_Authorization
    [Setup]    I set Headers:    Authorization=
    When I send a POST request:    /service-points   {"name": "New Service Point", "key": "new_service_point", "isActive": "true", "stores": ["DE", "AT"]}
    Then Response status code should be:    403

Create_Service_Point_With_Empty_Name
    [Documentation]    https://spryker.atlassian.net/browse/FRW-1597
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points   {"name": "", "key": "invalid_name_length", "isActive": "true", "stores": ["DE", "AT"]}
    Then Response status code should be:    400
    And Response should return error code:    5407
    And Response should return error message:    A service point name must have length from 0 to 255 characters.

Create_Service_Point_With_Invalid_Store
    [Documentation]     https://spryker.atlassian.net/browse/FRW-1597
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points   {"name": "Invalid Store Service Point", "key": "invalid_store", "isActive": "true", "stores": ["Invalid_Store"]}
    Then Response status code should be:    400
    And Response should return error code:    5401
    And Response should return error message:    Wrong request body.

Create_Service_Point_With_Empty_Body
    [Documentation]    https://spryker.atlassian.net/browse/FRW-1597
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points   {}
    Then Response status code should be:    400
    And Response should return error code:    5401
    And Response should return error message:    Wrong request body.

Create_Service_Point_With_Invalid_Content_Type
    [Documentation]    https://spryker.atlassian.net/browse/FRW-6312
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=text/plain   Authorization=Bearer ${token}
    When I send a POST request:    /service-points   {"name": "Invalid Content Type", "key": "invalid_content_type", "isActive": "true", "stores": ["DE", "AT"]}
    Then Response status code should be:    400
    And Response should return error code:    5401
    And Response should return error message:    Wrong request body.

Create_Service_Point_With_Invalid_Token
    [Setup]    I set Headers:    Authorization=Bearer InvalidToken
    When I send a POST request:    /service-points   {"name": "Invalid Token", "key": "invalid_token", "isActive": "true", "stores": ["DE", "AT"]}
    Then Response status code should be:    401

Create_Service_Point_With_Missing_Required_Fields
    [Documentation]    https://spryker.atlassian.net/browse/FRW-1597
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points   {"isActive": "true", "stores": ["DE", "AT"]}
    Then Response status code should be:    400
    And Response should return error code:    5401
    And Response should return error message:    Wrong request body.

Update_Service_Point_With_Wrong_type
    [Documentation]    https://spryker.atlassian.net/browse/FRW-6312
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Initial Service Point ${random}","key": "initial-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    ...    AND    Save value to a variable:    [data][attributes][key]    service_point_key
    ...    AND    Save value to a variable:    [data][id]    service_point_id
    When I send a PATCH request:    /service-points/${service_point_id}    {"data": {"type": "invalid-type","attributes": {"key": "initial-service-point-${random}","stores": ["DE"],"isActive": "false","name": "Updated Service Point"}}}
    Then Response status code should be:    400
    And Response should return error code:    5401
    And Response should return error message:    Wrong request body
    [Teardown]    Deactivate service point via BAPI    ${service_point_id}

Update_Service_Point_Without_Authorization
    [Setup]    I set Headers:    Authorization=
    When I send a PATCH request:    /service-points/random-id    {"data": {"type": "service-points","attributes": {"name": "Unauthorized Update","key": "unauthorized-update-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    403

Update_Service_Point_With_Nonexistent_ID
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a PATCH request:    /service-points/nonexistent-id    {"data": {"type": "service-points","attributes": {"name": "Nonexistent ID","key": "nonexistent-id-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    404
    And Response should return error code:    5403
    And Response should return error message:    Service point entity was not found.

Update_Service_Point_With_incorrect_token
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer incorrect
    When I send a PATCH request:    /service-points/random-id    {"data": {"type": "service-points","attributes": {"name": "Unauthorized Update","key": "unauthorized-update-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    401

Update_Service_Point_With_Empty_Name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Initial Service Point ${random}","key": "initial-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    ...    AND    Save value to a variable:    [data][attributes][key]    service_point_key
    ...    AND    Save value to a variable:    [data][id]    service_point_id
    When I send a PATCH request:    /service-points/${service_point_id}    {"data": {"type": "service-points","attributes": {"key": "Initial Service Point ${random}","stores": ["DE"],"isActive": "true","name": ""}}}
    Then Response status code should be:    400
    And Response should return error code:    5407
    And Response should return error message:    A service point name must have length from 1 to 255 characters.
    [Teardown]    Deactivate service point via BAPI    ${service_point_id}

Update_Service_Point_With_not_existing_key
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    ...    AND    I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Non Existing Initial Service Point ${random}","key": "non-existing-initial-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    ...    AND    Save value to a variable:    [data][id]    service_point_id
    When I send a PATCH request:    /service-points/${service_point_id}    {"data": {"type": "service-points","attributes": {"key": "not-existing-key${random}","stores": ["DE"],"isActive": "true","name": "test"}}}
    Then Response status code should be:    200
    Save value to a variable:    [data][attributes][key]    service_point_key
    # duplicate key is not possible
    Then I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Initial Service Point ${random}","key": "not-existing-key${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    400
    [Teardown]    Deactivate service point via BAPI    ${service_point_id}

Get_Service_Points_Without_Authentication
    [Setup]    I set Headers:    Authorization=
    When I send a GET request:    /service-points
    Then Response status code should be:    403

Get_Service_Points_With_Incorrect_Token
    [Setup]    I set Headers:    Authorization=Bearer IncorrectToken
    When I send a GET request:    /service-points
    Then Response status code should be:    401

Get_Service_Point_By_Nonexistent_ID
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a GET request:    /service-points/NonexistentID
    Then Response status code should be:    404
    And Response should return error code:    5403
    And Response should return error message:    Service point entity was not found.

