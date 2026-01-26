*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/api_service_point_steps.robot
Test Tags    bapi    spryker-core    spryker-core-back-office    service-points    shipment-service-points    product-offer-service-points    service-points-cart    product-offer-service-points-availability    marketplace-merchant-product-offer-service-points-availability    shipment-product-offer-service-points-availability    marketplace-merchant-portal-product-offer-service-points    inventory-management    marketplace-inventory-management 

*** Test Cases ***
Create_Service_No_Auth
    And Create service point in DB    uuid=262feb9d-33a7${random}    name=TestSP${random}    key=sp11${random}    isActive=true    storeName=DE
    Then Create service type in DB    uuid=33a7-5c55-9b04${random}    name=TestType${random}    key=sp11${random}
    When I send a POST request:    /services    {"data": {"type": "services", "attributes": {"serviceTypeUuid": "33a7-5c55-9b04${random} ", "servicePointUuid": "262feb9d-33a7${random}", "isActive": "true", "key": "service-point-1-collect"}}}
    Then Response status code should be:    404
    [Teardown]     Run Keywords    Delete service point in DB    262feb9d-33a7${random}
    ...    AND    Delete service type in DB    33a7-5c55-9b04${random}

Create_Service_Invalid_Auth
    Create service point in DB    uuid=262feb9d-33a7${random}    name=TestSP1${random}    key=sp11${random}    isActive=true    storeName=DE
    Create service type in DB    uuid=33a7-5c55-9b04${random}    name=TestType1${random}    key=sp11${random}
    When I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer invalid
    When I send a POST request:    /services    {"data": {"type": "services", "attributes": {"serviceTypeUuid": "33a7-5c55-9b04${random}", "servicePointUuid": "262feb9d-33a7${random}", "isActive": "true", "key": "service-point-1-collect"}}}
    Then Response status code should be:    401
    [Teardown]     Run Keywords    Delete service point in DB    262feb9d-33a7${random}
     ...    AND    Delete service type in DB    33a7-5c55-9b04${random}

Get_Service_By_ID__No_Auth
    When Create service point in DB    uuid=262feb9d-33a7${random}    name=TestSP2${random}    key=sp11${random}    isActive=true    storeName=DE
    And Create service type in DB    uuid=33a7-5c55-9b04${random}    name=TestType2${random}     key=sp11${random}
    Then Create service in DB    servicePointUuid=262feb9d-33a7${random}    serviceTypeUuid=33a7-5c55-9b04${random}    uuid=262feb1fd22067e${random}    key=s1f${random}    isActive=true
    And I send a GET request:    /services/262feb1fd22067e${random}
    Then Response status code should be:    404
    [Teardown]     Run Keywords    Delete service point in DB    262feb9d-33a7${random}
    ...    AND    Delete service type in DB    33a7-5c55-9b04${random}

Get_Nonexistent_Service
    When I get access token by user credentials:   ${zed_admin.email}
    And I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a GET request:    /services/nonexistent_id
    Then Response status code should be:    400
    And Response should return error code:    5400
    And Response should return error message:    The service entity was not found.

Get_Services_No_Auth
    When Create service point in DB    uuid=262feb9d-33a7${random}    name=TestSP2a${random}    key=sp11a${random}    isActive=true    storeName=DE
    And Create service type in DB    uuid=33a7-5c55-9b04${random}    name=TestType2a${random}     key=sp11a${random}
    Then Create service in DB    servicePointUuid=262feb9d-33a7${random}    serviceTypeUuid=33a7-5c55-9b04${random}    uuid=262feb1fd22067e${random}    key=s1f${random}    isActive=true
    When I send a GET request:    /services
    Then Response status code should be:    404
    [Teardown]     Run Keywords    Delete service point in DB    262feb9d-33a7${random}
    ...    AND    Delete service type in DB    33a7-5c55-9b04${random}

Create_Duplicate_Service_Point_Service_Relation
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    #create a service point
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Points ${random}","key": "some-service-point-news-${random}","isActive":"true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][attributes][key]    service_point_key
    And Save value to a variable:    [data][id]    service_point_id
    # #create a service type
    Create service type in DB    uuid=36796774${random}    name=TestTypeNewQ${random}     key=test-key-goes-here${random}
    #  #create a service
    When I send a POST request:    /services    {"data": {"type": "services", "attributes": {"serviceTypeUuid": "${36796774${random}}", "servicePointUuid": "${service_point_id}", "isActive":"true", "key": "service2-point-1-collects${random}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    Then Save value to a variable:    [data][id]    service_id
    When I send a POST request:    /services    {"data": {"type": "services", "attributes": {"serviceTypeUuid": "${36796774${random}}", "servicePointUuid": "${service_point_id}", "isActive":"true", "key": "new-key2${random}"}}}
    When Response status code should be:    400
    And Response should return error code:    5429
    And Response should return error message:    A service with defined relation of service point and service type already exists.
    [Teardown]     Run Keywords    Delete service point in DB    ${service_point_id}
    ...    AND    Delete service type in DB    ${36796774${random}}
