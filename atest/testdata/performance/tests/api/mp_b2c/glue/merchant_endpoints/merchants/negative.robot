*** Settings ***

Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        API_test_setup
Test Tags    glue    merchant    marketplace-merchant

*** Test Cases ***    
Retrieves_merchant_with_non_existent_id
    When I send a GET request:    /merchants/NonExistId
    Then Response status code should be:    404
    And Response should return error code:    3501
    And Response should return error message:    Merchant not found.   
