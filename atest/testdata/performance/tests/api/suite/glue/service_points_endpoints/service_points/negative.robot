*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/steps/api_service_point_steps.robot
Test Tags    glue    service-points    shipment-service-points    product-offer-service-points

*** Test Cases ***
Retrieves_list_of_service_points_by_incorrect_url
    When I send a GET request:    /service-point
    Then Response status code should be:    404
    And Response should return error message:    Not Found

Retrieves_a_service_point_by_incorrect_url
    Create dynamic service with all data via BAPI if doesn't exist
    Switch to Glue
    When I send a GET request:    /service-point/${dynamic_service_point_uuid}
    Then Response status code should be:    404
    And Response should return error message:    Not Found

Retrieves_a_service_point_by_not_existing_id
    When I send a GET request:    /service-points/NonExistId
    Then Response status code should be:    404
    And Response should return error code:    5401
    And Response should return error message:    Service point entity was not found.
