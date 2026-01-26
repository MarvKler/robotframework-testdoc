*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    customer-access    customer-account-management    spryker-core
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Resources_list_which_customer_can_access
    I send a GET request:    /customer-access
    Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should contain:    [data][0][type]    customer-access
    And Response should contain the array of a certain size:    [data][0][attributes] [resourceTypes]    2
    And Response body parameter should be:    [data][0][attributes][resourceTypes][0]    wishlists
    And Response body parameter should be:    [data][0][attributes][resourceTypes][1]    wishlist-items
    And Response body has correct self link

Access_restricted_resource_as_authorized_customer   
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    I send a POST request:    /wishlists    {"data": {"type": "wishlists","attributes": {"name": "${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    wishlist_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a POST request:    /wishlists/${wishlist_id}/wishlist-items    {"data": {"type": "wishlist-items","attributes": {"sku": "${concrete_available_product.with_label}"}}}
    ...    AND    Response status code should be:    201
    I send a GET request:    /wishlists
    Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should contain:    [data][0][type]    wishlists
    And Response body parameter should be:    [data][0][id]    ${wishlist_id}
    And Response body parameter should be:    [data][0][attributes][numberOfItems]    1
    And Response body parameter should be:    [data][0][attributes][name]    ${random}
    And Response body has correct self link
    [Teardown]    Run Keywords    I send a DELETE request:    /wishlists/${wishlist_id}
    ...  AND    Response status code should be:    204