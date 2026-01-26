*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/steps/api_service_point_steps.robot
Test Tags    glue    service-points    shipment-service-points    product-offer-service-points

*** Test Cases ***
Retrieves_a_service_point_address_by_id
    Create dynamic service with all data via BAPI if doesn't exist
    Switch to Glue
    When I send a GET request:    /service-points/${dynamic_service_point_uuid}/service-point-addresses/${dynamic_service_point_address_uuid}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][id]    ${dynamic_service_point_address_uuid}
    And Response body parameter should be:    [data][type]    service-point-addresses
    And Response body parameter should be:    [data][attributes][countryIso2Code]    ${dynamic_service.service_point_address_country}
    And Response body parameter should be:    [data][attributes][address1]    ${dynamic_service.service_point_address_line_1}
    And Response body parameter should be:    [data][attributes][address2]    ${dynamic_service.service_point_address_line_2}
    And Response body parameter should be:    [data][attributes][city]    ${dynamic_service.service_point_address_city}
    And Response body parameter should be:    [data][attributes][zipCode]    ${dynamic_service.service_point_address_zip_code}
    And Response body has correct self link internal
