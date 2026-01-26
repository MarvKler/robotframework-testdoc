*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot

Suite Setup     API_suite_setup
Test Setup      API_test_setup

Test Tags    glue    cart    customer-access    spryker-core    acl    shared-carts    multiple-carts


*** Test Cases ***
Get_cart_permission_groups_by_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    Response status code should be:    201
    ...    AND    I send a GET request:    /company-users
    ...    AND    Response status code should be:    200
    ...    AND    Save value to a variable:    [data][0][id]    company_user_id
    ...    AND    I send a POST request:    /carts/${cart_id}/shared-carts    {"data": {"type": "shared-carts","attributes": {"idCompanyUser": "${company_user_id}","idCartPermissionGroup": "2"}}}
    When I send a GET request:    /carts/${cart_id}?include=shared-carts,cart-permission-groups
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]    ${cart_id}
    And Response should contain the array larger than a certain size:    [included]    0
    And Response should contain the array larger than a certain size:    [data][relationships]    0
    And Response body parameter should not be EMPTY:    [data][relationships]
    And Response body parameter should not be EMPTY:    [data][relationships][shared-carts]
    And Each array element of array in response should contain property:
    ...    [data][relationships][shared-carts][data]
    ...    type
    And Each array element of array in response should contain property:
    ...    [data][relationships][shared-carts][data]
    ...    id
    And Response body parameter should not be EMPTY:    [included]
    And Each array element of array in response should contain property:    [included]    type
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain nested property:    [included]    [links]    self
    And Each array element of array in response should contain property with value in:
    ...    [included]
    ...    type
    ...    cart-permission-groups
    ...    shared-carts
    And Response body parameter should be:    [included][0][type]    cart-permission-groups
    And Response body parameter should be:    [included][0][id]    2
    And Response body parameter should not be EMPTY:    [included][0][attributes][name]
    And Response body parameter should not be EMPTY:    [included][0][attributes][isDefault]
    And Response body parameter should be in:    [included][0][attributes][isDefault]    true    false
    And Response body parameter should be:    [included][1][type]    shared-carts
    And Response body parameter should be:    [included][1][attributes][idCompanyUser]    ${company_user_id}
    And Response body parameter should be:    [included][1][attributes][idCartPermissionGroup]    2
    And Response body parameter should not be EMPTY:    [included][1][relationships][cart-permission-groups]
    And Each array element of array in response should contain property:
    ...    [included][1][relationships][cart-permission-groups][data]
    ...    type
    And Each array element of array in response should contain property:
    ...    [included][1][relationships][cart-permission-groups][data]
    ...    id
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204

Get_all_cart_permission_groups
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /cart-permission-groups
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Each array element of array in response should contain property with value:
    ...    [data]
    ...    type
    ...    cart-permission-groups
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain nested property:    [data]    [attributes]    name
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isDefault
    And Each array element of array in response should contain property with value in:
    ...    [data]
    ...    [attributes][isDefault]
    ...    True
    ...    False
    And Each array element of array in response should contain nested property:    [data]    [links]    self
    And Response body has correct self link

Get_cart_permission_groups_by_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /cart-permission-groups/${cart_permission_group_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter Should Be:    [data][type]    cart-permission-groups
    And Response body parameter should Be:    [data][id]    ${cart_permission_group_id}
    And Response body parameter should not be EMPTY:    [data][type]
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    And Response body parameter should not be EMPTY:    [data][attributes][isDefault]
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response body has correct self link internal
