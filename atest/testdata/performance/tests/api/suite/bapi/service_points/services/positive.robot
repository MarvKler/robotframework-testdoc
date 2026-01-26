*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/api_service_point_steps.robot
Test Tags    bapi    spryker-core    spryker-core-back-office    service-points    shipment-service-points    product-offer-service-points    service-points-cart    product-offer-service-points-availability    marketplace-merchant-product-offer-service-points-availability    shipment-product-offer-service-points-availability    marketplace-merchant-portal-product-offer-service-points    inventory-management    marketplace-inventory-management 

*** Test Cases ***
Get_Services_List
    [Setup]
    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a GET request:    /services
    Then Response status code should be:    200
    And Array in response should contain property with value:    [data]  type    services
    And Response should contain the array larger than a certain size:    [data]    1
    And Response body parameter should not be EMPTY:    [data][0][attributes][uuid]
    And Response body parameter should not be EMPTY:    [data][1][attributes][uuid]
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body parameter should not be EMPTY:    [data][1][id]
    And Response body parameter should be:    data[0][attributes][isActive]    True
    And Response body parameter should be:    data[1][attributes][isActive]    True
    And Response body parameter should be in:    data[0][attributes][key]    s1    s2    robot
    And Response body parameter should be in:    data[1][attributes][key]    s1    s2    robot
    And Response body has correct self link

Create_Service
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    #create a service point
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-new-${random}","isActive":"true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][attributes][key]    service_point_key
    And Save value to a variable:    [data][id]    service_point_id
    # #create a service type
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "service1-test${random}"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_type_id
    #  #create a service
    When I send a POST request:    /services    {"data": {"type": "services", "attributes": {"serviceTypeUuid": "${service_type_id}", "servicePointUuid": "${service_point_id}", "isActive":"true", "key": "service-point-1-collect${random}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    Then Save value to a variable:    [data][id]    service_id
    And Response body parameter should be:    [data][type]    services
    And Response body parameter should be:    [data][attributes][isActive]    True
    And Response body parameter should not be EMPTY:    [data][attributes][uuid]
    And Response body parameter should be:    [data][attributes][key]    service-point-1-collect${random}
    And Response body has correct self link for created entity:    ${service_id}
    [Teardown]     Run Keywords    Delete service point in DB    ${service_point_id}
    ...    AND    Delete service type in DB    ${service_type_id}

Update_Service
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    #create a service point
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-new-${random}","isActive":"true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][attributes][key]    service_point_key
    And Save value to a variable:    [data][id]    service_point_id
    # #create a service type
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "service1-test${random}"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_type_id
    #  #create a service
    When I send a POST request:    /services    {"data": {"type": "services", "attributes": {"serviceTypeUuid": "${service_type_id}", "servicePointUuid": "${service_point_id}", "isActive":"true", "key": "service-point-1-collect${random}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    Then Save value to a variable:    [data][id]    service_id
    #  #update a service
    When I send a PATCH request:    /services/${service_id}    {"data": {"type": "services", "attributes": {"isActive": "false"}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][attributes][isActive]    False
    And Response body parameter should not be EMPTY:    [data][attributes][uuid]
    And Response body parameter should be:    [data][attributes][key]    service-point-1-collect${random}
    [Teardown]     Run Keywords    Delete service point in DB    ${service_point_id}
    ...    AND    Delete service type in DB    ${service_type_id}

Get_Service_By_ID
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    #create a service point
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-new1-${random}","isActive":"true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][attributes][key]    service_point_key
    And Save value to a variable:    [data][id]    service_point_id
    # #create a service type
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service1 ${random}", "key": "service1-test1${random}"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_type_id
    #  #create a service
    When I send a POST request:    /services    {"data": {"type": "services", "attributes": {"serviceTypeUuid": "${service_type_id}", "servicePointUuid": "${service_point_id}", "isActive":"true", "key": "service-point-1-collecta${random}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    Then Save value to a variable:    [data][id]    service_id
    When I send a GET request:    /services/${service_id}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][type]    services
    And Response body parameter should be:    [data][attributes][isActive]    True
    And Response body parameter should not be EMPTY:    [data][attributes][uuid]
    And Response body parameter should not be EMPTY:    [data][id]
    [Teardown]     Run Keywords    Delete service point in DB    ${service_point_id}
    ...    AND    Delete service type in DB    ${service_type_id}