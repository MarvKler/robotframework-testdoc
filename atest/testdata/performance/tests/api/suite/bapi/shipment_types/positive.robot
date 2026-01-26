*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/steps/shipment_type_steps.robot
Test Tags    bapi    shipment    spryker-core    spryker-core-back-office    marketplace-shipment

*** Test Cases ***
Create_shipment_type
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /shipment-types   {"data": {"type": "shipment-types","attributes": {"name": "Some Shipment Type ${random}","key": "some-shipment-type-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    shipment-types
    And Save value to a variable:    [data][id]    shipment_type_id
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][name]    Some Shipment Type ${random}
    And Response body parameter should be:    [data][attributes][key]    some-shipment-type-${random}
    And Response body parameter should be:    [data][attributes][isActive]    True
    And Response body parameter should be in:    [data][attributes][stores]    DE    AT
    And Response body parameter should be in:    [data][attributes][stores]    AT    DE
    And Response body has correct self link for created entity:    ${shipment_type_id}
    [Teardown]     Delete shipment type in DB:    some-shipment-type-${random}

Create_new_shipment_type_with_existing_name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /shipment-types   {"data": {"type": "shipment-types","attributes": {"name": "not_unique_name","key": "new-shipment-type-${random}","isActive": "true","stores": ["AT"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    new_shipment_type_uuid
    # Create new shipment type with existing name
    When I send a POST request:    /shipment-types   {"data": {"type": "shipment-types","attributes": {"name": "not_unique_name","key": "second-shipment-type-${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    shipment-types
    And Save value to a variable:    [data][id]    shipment_type_id
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should be:    [data][attributes][name]    not_unique_name
    And Response body parameter should be:    [data][attributes][key]    second-shipment-type-${random}
    And Response body parameter should be:    [data][attributes][isActive]    True
    And Response body parameter should be in:    [data][attributes][stores]    DE    AT
    And Response body parameter should be in:    [data][attributes][stores]    AT    DE
    And Response body has correct self link for created entity:    ${shipment_type_id}
    # check that first shipment time still exist and not overrided
    And I send a GET request:    /shipment-types/
    And I send a GET request:    /shipment-types/${new_shipment_type_uuid}
    And Response body parameter should be:    [data][attributes][key]    new-shipment-type-${random}
    And Response body parameter should be:    [data][attributes][name]    not_unique_name
    [Teardown]     Run Keywords    Delete shipment type in DB:    new-shipment-type-${random}
    ...    AND    Delete shipment type in DB:    second-shipment-type-${random}

Update_shipment_type_change_name_store_relation_and_deactivate
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "name${random}","key": "update-shipment-type-key${random}","isActive": "true","stores": ["DE"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    shipment_type_uuid
    # Update the Delivery Type with new attributes via PATCH request
    When I send a PATCH request:    /shipment-types/${shipment_type_uuid}
    ...    {"data": {"type": "shipment-types","attributes": {"name": "updated_name${random}","isActive": "false","stores": ["AT"]}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    When I send a GET request:    /shipment-types/${shipment_type_uuid}
    And Response body parameter should be:    [data][attributes][name]    updated_name${random}
    And Response body parameter should be:    [data][attributes][isActive]    False
    And Response body parameter should be:    [data][attributes][stores]    AT
    And Response body has correct self link internal
    [Teardown]     Delete shipment type in DB:    update-shipment-type-key${random}

Retrieve_single_shipment_type_with_valid_token
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "shipment-type${random}","key": "shipment-key${random}","isActive": "true","stores": ["DE", "AT"]}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    delivery_type_uuid
    When I send a GET request:    /shipment-types/${delivery_type_uuid}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    shipment-types
    And Response body parameter should be:    [data][attributes][name]    shipment-type${random}
    And Response body parameter should be:    [data][attributes][key]    shipment-key${random}
    And Response body parameter should be:    [data][attributes][isActive]    True
    And Response body parameter should be in:    [data][attributes][stores]    DE    AT
    And Response body parameter should be in:    [data][attributes][stores]    AT    DE
    And Response body has correct self link internal
    [Teardown]     Delete shipment type in DB:    shipment-key${random}

Retrieve_list_of_shipment_types_with_valid_token_and_pagination
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    #prepare test data
    When I send a POST request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "shipment-type1${random}","key": "shipment-key1${random}","isActive": "true","stores": ["DE", "AT"]}}}
    When I send a POST request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "shipment-type2${random}","key": "shipment-key2${random}","isActive": "true","stores": ["AT"]}}}
    # run get request
    When I send a GET request:    /shipment-types?page[offset]=0&page[limit]=2
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array in response should contain property with NOT EMPTY value:    [data]    id
    And Each array element of array in response should contain property with value:    [data]    type    shipment-types
    And Each array in response should contain property with NOT EMPTY value:    [data]    [attributes][name]
    And Each array in response should contain property with NOT EMPTY value:    [data]    [attributes][key]
    And Each array element of array in response should contain property with value in:    [data]   [attributes][isActive]    True    False
    And Response should contain the array larger than a certain size:    [data][0][attributes][stores]    0
    And Response should contain the array of a certain size:    [data]    2
    And Each array element of the array in response should contain a nested array larger than a certain size:    [data]    [attributes][stores]    0
    [Teardown]     Run Keywords    Delete shipment type in DB:    shipment-key1${random}
    ...    AND    Delete shipment type in DB:    shipment-key2${random}

Retrieve_list_of_shipment_types_with_filtering
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    #prepare test data
    When I send a POST request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "shipment-type1${random}","key": "shipment-key1${random}","isActive": "true","stores": ["DE", "AT"]}}}
    When I send a POST request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "shipment-type2${random}","key": "shipment-key2${random}","isActive": "true","stores": ["AT"]}}}
    When I send a POST request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "shipment-type3${random}","key": "shipment-key3${random}","isActive": "true","stores": ["DE"]}}}
   # run get request
    When I send a GET request:    /shipment-types?filter[shipment-types.stores]=AT
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array in response should contain property with value NOT in:    [data]    [attributes][key]    shipment-key3${random}
    [Teardown]     Run Keywords    Delete shipment type in DB:    shipment-key1${random}
    ...    AND    Delete shipment type in DB:    shipment-key2${random}
    ...    AND    Delete shipment type in DB:    shipment-key3${random}

Retrieve_list_of_shipment_types_with_sorting_by_key_ASC
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    #prepare test data
    When I send a POST request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "shipment-type1${random}","key": "aaa_shipment-key1","isActive": "true","stores": ["DE", "AT"]}}}
    When I send a POST request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "shipment-type2${random}","key": "www_shipment-key2","isActive": "true","stores": ["AT"]}}}
    # run get request
    When I send a GET request:    /shipment-types?sort=key
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][attributes][key]    aaa_shipment-key1
    And Response body has correct self link
    [Teardown]     Run Keywords    Delete shipment type in DB:    aaa_shipment-key1
    ...    AND    Delete shipment type in DB:    www_shipment-key2

Retrieve_list_of_shipment_types_with_sorting_by_key_DESC
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    #prepare test data
    When I send a POST request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "shipment-type1${random}","key": "aaa_shipment-key1","isActive": "true","stores": ["DE", "AT"]}}}
    When I send a POST request:    /shipment-types
    ...    {"data": {"type": "shipment-types","attributes": {"name": "shipment-type2${random}","key": "www_shipment-key2","isActive": "true","stores": ["AT"]}}}
    # run get request
    When I send a GET request:    /shipment-types?sort=-key
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][attributes][key]    www_shipment-key2
    And Response body has correct self link
    [Teardown]     Run Keywords    Delete shipment type in DB:    aaa_shipment-key1
    ...    AND    Delete shipment type in DB:    www_shipment-key2
