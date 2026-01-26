*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    merchant    marketplace-merchant    marketplace-merchantportal-core    merchant-opening-hours


*** Test Cases ***
Retrieves_merchant_opening_hours_by_non_exist_merchant_id
    When I send a GET request:    /merchants/NonExistId/merchant-opening-hours
    Then Response status code should be:    404
    And Response should return error code:    3501
    And Response should return error message:    Merchant not found.


Retrieves_merchant_addresses_witout_pass_merchant_id
    When I send a GET request:    /merchants//merchant-opening-hours
    Then Response status code should be:    400
    And Response should return error code:    3502
    And Response should return error message:    Merchant identifier is not specified. 