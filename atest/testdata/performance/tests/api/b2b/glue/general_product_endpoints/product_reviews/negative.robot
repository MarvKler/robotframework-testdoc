*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    product    product-rating-reviews


*** Test Cases ***
Get_a_review_with_non_existent_review_id
    When I send a GET request:    /abstract-products/${abstract.with_review.sku}/product-reviews/fake
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    302
    And Response should return error message:    Product review is not found.

Get_reviews_with_non_existent_abstract_product
    When I send a GET request:    /abstract-products/fake/product-reviews
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    301
    And Response should return error message:    Abstract product is not found.

Get_reviews_with_missing_abstract_product
    When I send a GET request:    /abstract-products//product-reviews
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    311
    And Response should return error message:    Abstract product sku is not specified.

Get_review_by_id_with_missing_abstract_product
    When I send a GET request:    /abstract-products//product-reviews/78
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    311
    And Response should return error message:    Abstract product sku is not specified.

Get_a_reviews_with_non_existent_abstract_product
    When I send a GET request:    /abstract-products/fake/product-reviews/78
    Then Response status code should be:    404
    And Response reason should be:    Not Found
    And Response should return error code:    301
    And Response should return error message:    Abstract product is not found.

Create_a_product_review_without_token
    When I send a POST request:
    ...    /abstract-products/${abstract.with_review.sku}/product-reviews
    ...    {"data": {"type": "product-reviews","attributes": {"rating": ${review.default_rating},"nickname": "${yves_user.first_name}","summary": "${review.title}","description": "${review.text}"}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Create_a_product_review_with_invalid_token
    [Setup]    I set Headers:    Authorization=fake
    When I send a POST request:
    ...    /abstract-products/${abstract.with_review.sku}/product-reviews
    ...    {"data": {"type": "product-reviews","attributes": {"rating": ${review.default_rating},"nickname": "${yves_user.first_name}","summary": "${review.title}","description": "${review.text}"}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Create_a_product_review_with_invalid_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a POST request:
    ...    /abstract-products/${abstract.with_review.sku}/product-reviews
    ...    {"data": {"type": "product-review","attributes": {"rating": ${review.default_rating},"nickname": "${yves_user.first_name}","summary": "${review.title}","description": "${review.text}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.

Create_a_product_review_with_missing_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a POST request:
    ...    /abstract-products/${abstract.with_review.sku}/product-reviews
    ...    {"data": {"attributes": {"rating": ${review.default_rating},"nickname": "${yves_user.first_name}","summary": "${review.title}","description": "${review.text}"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Post data is invalid.

Create_a_product_review_with_empty_fields
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a POST request:
    ...    /abstract-products/${abstract.with_review.sku}/product-reviews
    ...    {"data": {"type": "product-reviews","attributes": {"rating": "","nickname": "","summary": "","description": ""}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Array in response should contain property with value:
    ...    [errors]
    ...    detail
    ...    rating => This value should be of type numeric.
    And Array in response should contain property with value:
    ...    [errors]
    ...    detail
    ...    rating => This value should be greater than or equal to 1.
    And Array in response should contain property with value:
    ...    [errors]
    ...    detail
    ...    summary => This value should not be blank.
    And Array in response should contain property with value:
    ...    [errors]
    ...    detail
    ...    nickname => This value should not be blank.

Create_a_product_review_with_missing_fields
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a POST request:
    ...    /abstract-products/${abstract.with_review.sku}/product-reviews
    ...    {"data": {"type": "product-reviews","attributes": {}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Array in response should contain property with value:    [errors]    detail    rating => This field is missing.
    And Array in response should contain property with value:
    ...    [errors]
    ...    detail
    ...    summary => This field is missing.
    And Array in response should contain property with value:
    ...    [errors]
    ...    detail
    ...    nickname => This field is missing.
