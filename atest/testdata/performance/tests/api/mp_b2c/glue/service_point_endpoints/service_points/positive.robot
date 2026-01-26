*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/steps/api_service_point_steps.robot
Test Tags    glue    service-points    shipment-service-points    product-offer-service-points

*** Test Cases ***    
Retrieves_list_of_service_points
    Create dynamic service with all data via BAPI if doesn't exist
    Switch to Glue
    When I send a GET request:    /service-points
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array larger than a certain size:    [data]    0
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    service-points
    And Each array element of array in response should NOT be empty:    [data]    id
    And Each array element of array in response should NOT be empty:    [data]    attributes
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body should contain:    "key": "${dynamic_service.service_point_key}"
    And Response body should contain:    "name": "${dynamic_service.service_point_name}"
    And Response body has correct self link

Retrieves_list_of_service_points_filtered_by_service_type_key
    Create dynamic service with all data via BAPI if doesn't exist
    Switch to Glue
    When I send a GET request:    /service-points?filter[service-points.serviceTypeKey]=${dynamic_service.service_type_key}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    1
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    service-points
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body parameter should be:    [data][0][id]    ${dynamic_service_point_uuid}

Retrieves_list_of_service_points_filtered_by_name_using_full_text_search
    Create dynamic service with all data via BAPI if doesn't exist
    Switch to Glue
    When I send a GET request:    /service-points?q=${dynamic_service.service_point_name}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    1
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    service-points
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body parameter should be:    [data][0][id]    ${dynamic_service_point_uuid}

Retrieves_list_of_service_points_filtered_by_address_line_1_using_full_text_search
    Create dynamic service with all data via BAPI if doesn't exist
    Switch to Glue
    When I send a GET request:    /service-points?q=${dynamic_service.service_point_address_line_1}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    1
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    service-points
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body parameter should be:    [data][0][id]    ${dynamic_service_point_uuid}

Retrieves_list_of_service_points_sort_by_city_asc
    Create dynamic service with all data via BAPI if doesn't exist
    Switch to Glue
    When I send a GET request:    /service-points?sort=city
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array larger than a certain size:    [data]    0
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    service-points
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body parameter should be:    [data][2][id]    ${dynamic_service_point_uuid}
    And Response body has correct self link

Retrieves_list_of_service_points_sort_by_city_desc
    Create dynamic service with all data via BAPI if doesn't exist
    Switch to Glue
    When I send a GET request:    /service-points?sort=-city
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array larger than a certain size:    [data]    0
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    service-points
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body parameter should be:    [data][0][id]    ${dynamic_service_point_uuid}
    And Response body has correct self link

Retrieves_list_of_service_points_with_addresses_relations
    Create dynamic service with all data via BAPI if doesn't exist
    Switch to Glue
    When I send a GET request:    /service-points?include=service-point-addresses&sort=-city
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain property with value:    [data]    type    service-points
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    key
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response should contain the array larger than a certain size:    [included]    0
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain property with value:    [included]    type    service-point-addresses
    And Each array element of array in response should contain nested property:    [included]    [attributes]    countryIso2Code
    And Each array element of array in response should contain nested property:    [included]    [attributes]    address1
    And Each array element of array in response should contain nested property:    [included]    [attributes]    address2
    And Each array element of array in response should contain nested property:    [included]    [attributes]    address3
    And Each array element of array in response should contain nested property:    [included]    [attributes]    zipCode
    And Each array element of array in response should contain nested property:    [included]    [attributes]    city
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Response body parameter should be:    [included][0][id]    ${dynamic_service_point_address_uuid}
    And Response body parameter should be:    [included][0][attributes][countryIso2Code]    ${dynamic_service.service_point_address_country}
    And Response body parameter should be:    [included][0][attributes][address1]    ${dynamic_service.service_point_address_line_1}
    And Response body parameter should be:    [included][0][attributes][address2]    ${dynamic_service.service_point_address_line_2}
    And Response body parameter should be:    [included][0][attributes][city]    ${dynamic_service.service_point_address_city}
    And Response body parameter should be:    [included][0][attributes][zipCode]    ${dynamic_service.service_point_address_zip_code}
    And Response body has correct self link

Retrieves_a_service_point_by_id
    Create dynamic service with all data via BAPI if doesn't exist
    Switch to Glue
    When I send a GET request:    /service-points/${dynamic_service_point_uuid}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][id]    ${dynamic_service_point_uuid}
    And Response body parameter should be:    [data][type]    service-points
    And Response body parameter should be:    [data][attributes][name]    ${dynamic_service.service_point_name}
    And Response body parameter should be:    [data][attributes][key]    ${dynamic_service.service_point_key}
    And Response body has correct self link internal

Retrieves_a_service_point_by_id_with_address_relation
    Create dynamic service with all data via BAPI if doesn't exist
    Switch to Glue
    When I send a GET request:    /service-points/${dynamic_service_point_uuid}?include=service-point-addresses
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][id]    ${dynamic_service_point_uuid}
    And Response body parameter should be:    [data][type]    service-points
    And Response body parameter should be:    [data][attributes][name]    ${dynamic_service.service_point_name}
    And Response body parameter should be:    [data][attributes][key]    ${dynamic_service.service_point_key}
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should be:    [included][0][id]    ${dynamic_service_point_address_uuid}
    And Response body parameter should be:    [included][0][attributes][countryIso2Code]    ${dynamic_service.service_point_address_country}
    And Response body parameter should be:    [included][0][attributes][address1]    ${dynamic_service.service_point_address_line_1}
    And Response body parameter should be:    [included][0][attributes][address2]    ${dynamic_service.service_point_address_line_2}
    And Response body parameter should be:    [included][0][attributes][city]    ${dynamic_service.service_point_address_city}
    And Response body parameter should be:    [included][0][attributes][zipCode]    ${dynamic_service.service_point_address_zip_code}
    And Response body has correct self link internal

Retrieves_a_service_point_by_id_with_empty_address_relation
    Create dynamic service with all data via BAPI if doesn't exist
    Switch to Glue
    When I send a GET request:    /service-points/${dynamic_service_point_uuid}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][id]    ${dynamic_service_point_uuid}
    And Response body parameter should be:    [data][type]    service-points
    And Response body parameter should be:    [data][attributes][name]    ${dynamic_service.service_point_name}
    And Response body parameter should be:    [data][attributes][key]    ${dynamic_service.service_point_key}
    And Response body should not contain:    included
    And Response body has correct self link internal