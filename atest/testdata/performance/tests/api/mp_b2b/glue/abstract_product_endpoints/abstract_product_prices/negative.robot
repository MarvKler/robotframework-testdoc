*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    prices

*** Test Cases ***
Get_abstract_prices_by_concrete_SKU
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /abstract-products/${concrete_product_with_alternative.sku}/abstract-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    307
    And Response should return error message:    Can`t find abstract product prices.

Get_abstract_prices_by_fake_SKU
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /abstract-products/fake/abstract-product-prices
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    307
    And Response should return error message:    Can`t find abstract product prices.

Get_abstract_prices_with_missing_SKU
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}  
    When I send a GET request:    /abstract-products//abstract-product-prices
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    311
    And Response should return error message:    Abstract product sku is not specified.  

Get_abstract_prices_with_missing_token
    When I send a GET request:    /abstract-products/${abstract_product.product_with_original_prices.abstract_sku}/abstract-product-prices
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.  

Get_abstract_prices_with_invalid_token
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    Authorization=fake 
    When I send a GET request:    /abstract-products/${abstract_product.product_with_original_prices.abstract_sku}/abstract-product-prices
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token. 