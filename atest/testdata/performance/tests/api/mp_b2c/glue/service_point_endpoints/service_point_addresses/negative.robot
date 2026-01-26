*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/steps/api_service_point_steps.robot
Test Tags    glue    service-points    shipment-service-points    product-offer-service-points

*** Test Cases ***
Retrieves_list_of_service_point_addresses
    Create dynamic service with all data via BAPI if doesn't exist
    Switch to Glue
    When I send a GET request:    /service-points/${dynamic_service_point_uuid}/service-point-addresses
    Then Response status code should be:    404
    And Response should return error message:    The endpoint is not found.

Retrieves_a_service_point_address_by_not_existing_service_point_and_service_point_address_ids
    When I send a GET request:    /service-points/NonExistId/service-point-addresses/NonExistId
    Then Response status code should be:    404
    And Response should return error code:    5402
    And Response should return error message:    Service point address entity was not found.

Retrieves_a_service_point_address_by_existing_service_point_and_not_existing_service_point_address_ids
    Create dynamic service with all data via BAPI if doesn't exist
    Switch to Glue
    When I send a GET request:    /service-points/${dynamic_service_point_uuid}/service-point-addresses/NonExistId
    Then Response status code should be:    404
    And Response should return error code:    5402
    And Response should return error message:    Service point address entity was not found.

Retrieves_a_service_point_address_by_not_existing_service_point_and_existing_service_point_address_ids
    Create dynamic service with all data via BAPI if doesn't exist
    Switch to Glue
    When I send a GET request:    /service-points/NonExistId/service-point-addresses/${dynamic_service_point_address_uuid}
    Then Response status code should be:    404
    And Response should return error code:    5402
    And Response should return error message:    Service point address entity was not found.

Retrieves_a_service_point_address_by_incorrect_url
    Create dynamic service with all data via BAPI if doesn't exist
    Switch to Glue
    When I send a GET request:    /service-point/${dynamic_service_point_uuid}/service-point-addresses/${dynamic_service_point_address_uuid}
    Then Response status code should be:    404
    And Response should return error message:    Not Found