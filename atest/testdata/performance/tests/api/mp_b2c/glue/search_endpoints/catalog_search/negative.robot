*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    search    catalog

*** Test Cases ***
Search_without_query_parameter
    When I send a GET request:    /catalog-search?
    Then Response status code should be:    200

Search_with_invalid_currency
    When I send a GET request:    /catalog-search?q=&currency=InvalidCurrency
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    313
    And Response should return error message:    Currency is invalid.

Search_with_invalid_price_mode
    When I send a GET request:    /catalog-search?q=&priceMode=InvalidPriceMode
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    314
    And Response should return error message:    Price mode is invalid.

Search_with_invalid_rating_min
    When I send a GET request:    /catalog-search?q=&rating[min]=InvalidMinRating5
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    503
    And Response should return error message:    Value of rating.min must be of type integer.

Search_with_invalid_rating_max
    When I send a GET request:    /catalog-search?q=&rating[max]=InvalidMinRating5
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    503
    And Response should return error message:    Value of rating.max must be of type integer.

Search_with_invalid_category
    When I send a GET request:    /catalog-search?q=&category=!@!@!
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    503
    And Response should return error message:    Value of category must be of type integer.