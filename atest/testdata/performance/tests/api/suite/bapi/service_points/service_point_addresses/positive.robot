*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/api_service_point_steps.robot
Test Tags    bapi    spryker-core    spryker-core-back-office    service-points    shipment-service-points    product-offer-service-points    service-points-cart    product-offer-service-points-availability    marketplace-merchant-product-offer-service-points-availability    shipment-product-offer-service-points-availability    marketplace-merchant-portal-product-offer-service-points    inventory-management    marketplace-inventory-management 

*** Test Cases ***
Create_Service_Point_Address
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][attributes][key]    service_point_key
    And Save value to a variable:    [data][id]    service_point_id
    When I send a POST request:    /service-points/${service_point_id}/service-point-addresses    {"data":{"type":"service-point-addresses","attributes":{"address1":"Park Avenue","address2":"Building №22","city":"Dreamtown","zipCode":"30-221","countryIso2Code":"DE"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_point_address_id
    And Response body parameter should be:    [data][type]    service-point-addresses
    And Response body parameter should be:    [data][attributes][countryIso2Code]    DE
    And Response body parameter should be:    [data][attributes][address1]    Park Avenue
    And Response body parameter should be:    [data][attributes][address2]    Building №22
    And Response body parameter should be:    [data][attributes][zipCode]    30-221
    And Response body parameter should be:    [data][attributes][city]    Dreamtown
    And Response body has correct self link for created entity:    ${service_point_address_id}
    [Teardown]    Deactivate service point via BAPI    ${service_point_id}

Create_Service_Point_Address_with_address_3
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-2${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][attributes][key]    service_point_key
    And Save value to a variable:    [data][id]    service_point_id
    When I send a POST request:    /service-points/${service_point_id}/service-point-addresses    {"data":{"type":"service-point-addresses","attributes":{"address1":"Park Avenue","address2":"Building №2","address3":"address3","city":"Dreamtown","zipCode":"30-221","countryIso2Code":"DE"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_point_address_id
    And Response body parameter should be:    [data][attributes][address3]    address3
    [Teardown]    Deactivate service point via BAPI    ${service_point_id}

Create_Service_Point_Address_with_region_uuid
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-3${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][attributes][key]    service_point_key
    And Save value to a variable:    [data][id]    service_point_id
    And Create region in DB:    60    DE    Germany    123456789
    When I send a POST request:    /service-points/${service_point_id}/service-point-addresses    {"data":{"type":"service-point-addresses","attributes":{"regionUuid":"123456789","address1":"Park Avenue","address2":"Building №2","address3":"address3","city":"Dreamtown","zipCode":"30-221","countryIso2Code":"DE"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_point_address_id
    And Response body parameter should be:    [data][attributes][regionUuid]    123456789
    [Teardown]    Deactivate service point via BAPI    ${service_point_id}

Update_Service_Point_Address
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-update-4${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][attributes][key]    service_point_key
    And Save value to a variable:    [data][id]    service_point_id
    When I send a POST request:    /service-points/${service_point_id}/service-point-addresses    {"data":{"type": "service-point-addresses","attributes":{"regionUuid":"123456789", "countryIso2Code": "DE", "address1": "Park Avenue", "address2": "Building №2", "address3": "7th floor", "zipCode": "30-221", "city": "Dreamtown"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_point_address_id
    When I send a PATCH request:    /service-points/${service_point_id}/service-point-addresses/${service_point_address_id}    {"data": {"type": "service-point-addresses", "attributes": {"address1": "New Address","address2": "new address2", "address3": "new address3", "zipCode": "40-123", "city": "New City"}}}
    Then Response status code should be:    200
    And Save value to a variable:    [data][id]    service_point_address_id
    And Response body parameter should not be EMPTY:    [data][attributes][uuid]
    And Response body parameter should be:    [data][type]    service-point-addresses
    And Response body parameter should be:    [data][attributes][countryIso2Code]    DE
    And Response body parameter should be:    [data][attributes][regionUuid]    123456789
    And Response body parameter should be:    [data][attributes][address1]    New Address
    And Response body parameter should be:    [data][attributes][address2]    new address2
    And Response body parameter should be:    [data][attributes][address3]    new address3
    And Response body parameter should be:    [data][attributes][zipCode]    40-123
    And Response body parameter should be:    [data][attributes][city]    New City
    And Response body has correct self link internal
    [Teardown]    Deactivate service point via BAPI    ${service_point_id}

Retrieve_Service_Point_Address
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a GET request:    /service-points/${demo_service_point.spryker_main_store.uuid2}/service-point-addresses
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][type]    service-point-addresses
    And Response body parameter should be:    [data][0][id]    ${service_point_address.uuid2}
    And Response body parameter should be:    [data][0][attributes][countryIso2Code]    DE
    And Response body parameter should be:    [data][0][attributes][uuid]    ${service_point_address.uuid2} 
    And Response body parameter should be:    [data][0][attributes][address1]    ${service_point_address.address1}
    And Response body parameter should be:    [data][0][attributes][address2]    ${service_point_address.address2}
    And Response body parameter should be:    [data][0][attributes][address3]    ${service_point_address.address3}
    And Response body parameter should be:    [data][0][attributes][zipCode]    ${service_point_address.zip}
    And Response body parameter should be:    [data][0][attributes][city]    ${service_point_address.city}
    And Response body has correct self link




