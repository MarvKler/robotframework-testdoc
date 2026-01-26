*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/api_service_point_steps.robot
Test Tags    bapi

*** Test Cases ***
Create_Service_Point_Address_Without_Authentication
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=
    When I send a POST request:    /service-points/${spryker_main_store.uuid}/service-point-addresses    {"data":{"type":"service-point-addresses","attributes":{"address1":"Park Avenue","address2":"Building №2","address3":"address3","city":"Dreamtown","zipCode":"30-221","countryIso2Code":"DE"}}}
    Then Response status code should be:    403
    And Response should return error message:    Missing access token.

Create_Service_Point_Address_With_Incorrect_Token
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
     ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer IncorrectToken
    When I send a POST request:    /service-points/${spryker_main_store.uuid}/service-point-addresses    {"data":{"type":"service-point-addresses","attributes":{"address1":"Park Avenue","address2":"Building №2","address3":"address3","city":"Dreamtown","zipCode":"30-221","countryIso2Code":"DE"}}}
    Then Response status code should be:    401
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Create_Duplicate_Service_Point_Address
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points/${spryker_main_store.uuid}/service-point-addresses    {"data":{"type":"service-point-addresses","attributes":{"address1":"Park Avenue","address2":"Building №2","address3":"address3","city":"Dreamtown","zipCode":"30-221","countryIso2Code":"DE"}}}
    Then Response status code should be:    400
    And Response should return error code:    5417
    And Response should return error message:    A service point address for the service point already exists.

Create_Service_Point_address_without_address
    [Documentation]    https://spryker.atlassian.net/browse/CC-29310
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points/${spryker_main_store.uuid}/service-point-addresses    {"data": {"type": "service-point-addresses", "attributes": {"countryIso2Code": "DE", "address2": "Building №2", "zipCode": "30-221", "city": "Dreamtown"}}}
    Then Response status code should be:    400
    
Create_Service_Point_address_with_empty_address
    [Documentation]    https://spryker.atlassian.net/browse/CC-29310
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points/${spryker_main_store.uuid}/service-point-addresses    {"data": {"type": "service-point-addresses", "attributes": {"countryIso2Code": "DE", "address":"", "address2": "Building №2", "zipCode": "30-221", "city": "Dreamtown"}}}
    Then Response status code should be:    400

Create_Service_Point_address_with_not_existing_region
    [Documentation]     https://spryker.atlassian.net/browse/CC-29310
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][attributes][key]    service_point_key
    And Save value to a variable:    [data][id]    service_point_id
    When I send a POST request:    /service-points/${service_point_id}/service-point-addresses    {"data": {"type": "service-point-addresses", "attributes": {"regionUuid": "not-existing-rigion-uuid", "countryIso2Code": "DE", "address":"", "address2": "Building №2", "zipCode": "30-221", "city": "Dreamtown"}}}
    Then Response status code should be:    400
    And Response should return error code:    5410
    And Response should return error message:    	Region with uuid 'not-existing-rigion-uuid' does not exist for country with iso2 code 'DE'.
    [Teardown]    Deactivate service point via BAPI    ${service_point_id}

Create_Service_Point_address_with_not_existing_country
    [Documentation]     https://spryker.atlassian.net/browse/CC-29310
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-45${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][attributes][key]    service_point_key
    And Save value to a variable:    [data][id]    service_point_id
    When I send a POST request:    /service-points/${spryker_main_store.uuid}/service-point-addresses    {"data": {"type": "service-point-addresses", "attributes": {"countryIso2Code": "NOTEXIST", "address":"", "address2": "Building №2", "zipCode": "30-221", "city": "Dreamtown"}}}
    Then Response status code should be:    400
    And Response should return error code:    5409
    And Response should return error message:    Country with iso2 code 'DE' does not exist.
    [Teardown]    Deactivate service point via BAPI    ${service_point_id}

 Create_Service_Point_address_with_zip_more_than_15
    [Documentation]     https://spryker.atlassian.net/browse/CC-29310
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "Some Service Point ${random}","key": "some-service-point-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][attributes][key]    service_point_key
    And Save value to a variable:    [data][id]    service_point_id
    When I send a POST request:    /service-points/${spryker_main_store.uuid}/service-point-addresses    {"data": {"type": "service-point-addresses", "attributes": {"countryIso2Code": "DE", "address":"", "address2": "Building №2", "zipCode": "30-22111111111112", "city": "Dreamtown"}}}
    Then Response status code should be:    400
    And Response should return error code:    5415
    And Response should return error message:    A service point address zip code must have length from 1 to 15 characters.
    [Teardown]    Deactivate service point via BAPI    ${service_point_id}

Update_Service_Point_Address_Without_Authentication
    [Documentation]    https://spryker.atlassian.net/browse/FRW-5850 in response 400, expected 403
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=
    When I send a PATCH request:    /service-points/${spryker_main_store.uuid}/service-point-addresses/${service_point_address.uuid}    {"data": {"type": "service-point-addresses", "attributes": {"address1": "New Address", "zipCode": "40-123", "city": "New City"}}}
    Then Response status code should be:    403
    And Response should return error message:    Missing access token.

Update_Service_Point_Address_With_Incorrect_Token
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=IncorrectToken
    When I send a PATCH request:    /service-points/${spryker_main_store.uuid}/service-point-addresses/${service_point_address.uuid}      {"data": {"type": "service-point-addresses", "attributes": {"address1": "New Address", "zipCode": "40-123", "city": "New City"}}}
    Then Response status code should be:    403
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Update_Nonexistent_Service_Point_Address
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a PATCH request:    /service-points/not-existing-service-point/service-point-addresses/NonexistentID    {"data": {"type": "service-point-addresses", "attributes": {"address1": "New Address", "zipCode": "40-123", "city": "New City"}}}
    Then Response status code should be:    400
    And Response should return error code:    5400
    And Response should return error message:    Service point address entity was not found.

Update_Service_Point_Address_Invalid_Content_Type
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/json   Authorization=Bearer ${token}
    When I send a PATCH request:    /service-points/${spryker_main_store.uuid}/service-point-addresses/${service_point_address.uuid}      {"data": {"type": "invalid", "attributes": {"address1": "New Address", "zipCode": "40-123", "city": "New City"}}}
    Then Response status code should be:    404

Update_Service_Point_Address_Nonexistent_Service_Point
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a PATCH request:    /service-points/NonexistentID/service-point-addresses/${service_point_address.uuid}      {"data": {"type": "service-point-addresses", "attributes": {"address1": "New Address", "zipCode": "40-123", "city": "New City"}}}
    Then Response status code should be:    404
    And Response should return error code:    5403
    And Response should return error message:    Service point entity was not found.

Update_Service_Point_Address_Invalid_Region
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a PATCH request:    /service-points/${spryker_main_store.uuid}/service-point-addresses/${service_point_address.uuid}      {"data": {"type": "service-point-addresses", "attributes": {"regionUuid": "InvalidRegion", "address1": "New Address", "zipCode": "40-123", "city": "New City"}}}
    Then Response status code should be:    400
    And Response should return error code:    5410

Update_Service_Point_Address_Empty_Zip_Code
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a PATCH request:    /service-points/${spryker_main_store.uuid}/service-point-addresses/${service_point_address.uuid}     {"data": {"type": "service-point-addresses", "attributes": {"address1": "New Address", "zipCode": "", "city": "New City"}}}
    Then Response status code should be:    400
    And Response should return error code:    5415
    And Response should return error message:    A service point address zip code must have length from 4 to 15 characters.

Retrieve_address_for_Nonexistent_Service_Point
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a GET request:    /service-points/NonexistentID/service-point-addresses
    Then Response status code should be:    404
    And Response should return error code:    5403
    And Response should return error message:    Service point entity was not found.

Read_Service_Point_Address_No_Authentication
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer
    When I send a GET request:    /service-points/${spryker_main_store.uuid}/service-point-addresses
    Then Response status code should be:    403
    And Response should return error message:    Missing access token.