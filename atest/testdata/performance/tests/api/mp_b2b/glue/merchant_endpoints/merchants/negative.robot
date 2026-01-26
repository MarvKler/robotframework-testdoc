*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    merchant    marketplace-merchant



*** Test Cases ***    
Retrieves_merchant_by_non_exist_id
    When I send a GET request:    /merchants/NonExistId
    Then Response status code should be:    404
    And Response should return error code:    3501
    And Response should return error message:    Merchant not found.