*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags      glue    product    prices


*** Test Cases ***
Request_product_prices_with_abstract_sku
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /concrete-products/${bundle_product.product_2.abstract_sku}/concrete-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    308
    And Response should return error message:    Can`t find concrete product prices.

Request_product_prices_with_empty_SKU
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /concrete-products//concrete-product-prices
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    312
    And Response should return error message:    Concrete product sku is not specified.

Request_product_prices_with_special_characters
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /concrete-products/~!@#$%^&*()_+/concrete-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:    Concrete product is not found.

Request_product_prices_by_concrete_sku_product_doesn't_exist
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /concrete-products/4567890/concrete-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    308
    And Response should return error message:    Can`t find concrete product prices.

Request_product_prices_without_access_token
    When I send a GET request:    /concrete-products/${concrete.one_image_set.sku}/concrete-product-prices
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Request_product_prices_without_wrong_access_token
    [Setup]    I set Headers:    Authorization=8ur30jfpwoe
    When I send a GET request:    /concrete-products/${concrete.one_image_set.sku}/concrete-product-prices
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.
