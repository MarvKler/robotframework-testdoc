*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/api_service_point_steps.robot
Test Tags    bapi

*** Test Cases ***
Create_Service_Type
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "service1-test${random}"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_type_id
    And Response body parameter should be:    [data][type]    service-types
    And Response body parameter should be:    [data][attributes][name]    Test Service ${random}
    And Response body parameter should be:    [data][attributes][key]    service1-test${random}
    And Response body has correct self link for created entity:    ${service_type_id}
    [Teardown]    Delete service type in DB    ${service_type_id}

Update_Service_Type
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Test Service ${random}", "key": "original-key${random}"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_type_id
    When I send a PATCH request:    /service-types/${service_type_id}    {"data": {"type": "service-types", "attributes": {"name": "Updated Service Name","key": "original-key${random}"}}}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][type]    service-types
    And Response body parameter should be:    [data][attributes][name]    Updated Service Name
    And Response body parameter should be:    [data][attributes][key]    original-key${random}
    [Teardown]    Delete service type in DB    ${service_type_id}

Get_Service_Type_by_id
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "Collect Service${random}", "key": "collect${random}"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    service_type_id
    When I send a GET request:    /service-types/${service_type_id}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][type]    service-types
    And Response body parameter should be:    [data][attributes][name]    Collect Service${random}
    And Response body parameter should be:    [data][attributes][key]    collect${random}
    [Teardown]    Delete service type in DB    ${service_type_id}

Get_Service_Types_List
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    When I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "S_type${random}", "key": "s_type${random}"}}}
    And Save value to a variable:    [data][id]    service_type_id
    When I send a GET request:    /service-types
    Then Response status code should be:    200
    And Array in response should contain property with value:    [data]  type    service-types
    And Response should contain the array larger than a certain size:    [data]    1
    And Response body parameter should be in:    data[0][attributes][name]    Pickup    S_type${random}
    And Response body parameter should be in:    data[1][attributes][name]    Pickup    S_type${random}
    And Response body parameter should be in:    data[0][attributes][key]    pickup    s_type${random}
    And Response body parameter should be in:    data[0][attributes][key]    pickup    s_type${random}
    [Teardown]    Delete service type in DB    ${service_type_id}