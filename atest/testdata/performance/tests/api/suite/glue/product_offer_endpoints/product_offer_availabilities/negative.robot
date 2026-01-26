*** Settings ***
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        API_test_setup
Test Tags    glue    product    marketplace-product-offer    marketplace-product

*** Test Cases ***
Get_product_offer_availabilities_without_offerId
    When I send a GET request:    /product-offers//product-offer-availabilities
    Then Response status code should be:    400
    And Response reason should be:   Bad Request
    And Response should return error code:    3702
    And Response should return error message:    Product offer ID is not specified.

Get_product_offer_availabilities_with_invalid_offerId
    When I send a GET request:    /product-offers/InvalidOfferId/product-offer-availabilities
    Then Response status code should be:    404
    And Response reason should be:   Not Found
    And Response should return error code:    3701
    And Response should return error message:    Product offer was not found.

