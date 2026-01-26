*** Settings ***
Resource    ../../../../../../resources/common/common_api.robot
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    product    marketplace-product-offer    marketplace-product-offer-prices    prices    marketplace-product    merchant    marketplace-merchant

*** Test Cases ***
Get_product_offer_prices_without_offer_id
    When I send a GET request:    /product-offers//product-offer-prices
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    3702
    And Response should return error message:    Product offer ID is not specified.

Get_product_offers_price_without_complete_url
    When I send a GET request:    /product-offers
    Then Response status code should be:    400
    And Response should return error code:    3702
    And Response reason should be:    Bad Request
    And Response should return error message:    Product offer ID is not specified.

Get_not_existing_concrete_product_offers_price   
    When I send a GET request:    /concrete-products/123456789/product-offers?include=product-offer-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    0

Get_product_offer_with_volume_prices_included_for_inactive_product_offer
    When I send a GET request:    /product-offers/${inactive_offer_with_volume_price}/product-offer-prices
    Then Response status code should be:    404
    And Response should return error code:    3701
    And Response reason should be:    Not Found
    And Response should return error message:    Product offer not found.

Get_product_offer_with_volume_prices_included_for_waiting_for_approval_product_offer
    When I send a GET request:    /product-offers/${waiting_for_approval_offer_with_volume_price}/product-offer-prices
    Then Response status code should be:    404
    And Response should return error code:    3701
    And Response reason should be:    Not Found
    And Response should return error message:    Product offer not found.

Get_product_offer_with_volume_prices_included_for_denied_product_offer 
    When I send a GET request:    /product-offers/${denied_offer_with_volume_price}/product-offer-prices
    Then Response status code should be:    404
    And Response should return error code:    3701
    And Response reason should be:    Not Found
    And Response should return error message:    Product offer not found. 


Get_product_offer_prices_with_invaild_offer_id
    When I send a GET request:    /product-offers/test/product-offer-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    3701
    And Response should return error message:    Product offer not found.