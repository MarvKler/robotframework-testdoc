*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    configurable-bundle

*** Test Cases ***
###### POST ######
Add_configured_bundle_item_to_cart_non_existing_sku
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
      ...  AND    I set Headers:    Authorization=${token}
      ...  AND    Find or create customer cart
      ...  AND    Cleanup all items in the cart:    ${cart_id}
    When I send a POST request:    /carts/${cart_id}/configured-bundles    {"data": {"type": "configured-bundles","attributes": {"quantity": ${configured_bundle_quantity},"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "fake","quantity": 2,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4001
    And Response should return error message:    Product "fake" not found

Add_configured_bundle_item_to_non_existing_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
      ...  AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /carts/fake/configured-bundles    {"data": {"type": "configured-bundles","attributes": {"quantity": ${configured_bundle_quantity},"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle_first_slot_item_sku}","quantity": 2,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4001
    And Response should return error message:    There was a problem adding or updating the configured bundle.

Add_configured_bundle_item_to_missing_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    When I send a POST request:    /carts//configured-bundles    {"data": {"type": "configured-bundles","attributes": {"quantity": ${configured_bundle_quantity},"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle_first_slot_item_sku}","quantity": 2,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    104
    And Response should return error message:    Cart uuid is missing.

Add_configured_bundle_item_to_cart_with_invalid_token
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    Authorization="fake"
    When I send a POST request:    /carts/fake/configured-bundles    {"data": {"type": "configured-bundles","attributes": {"quantity": ${configured_bundle_quantity},"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle_first_slot_item_sku}","quantity": 2,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error code:    001
    And Response should return error message:    Invalid access token.

Add_configured_bundle_item_to_cart_with_missing_token
    When I send a POST request:    /carts/fake/configured-bundles    {"data": {"type": "configured-bundles","attributes": {"quantity": ${configured_bundle_quantity},"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle_first_slot_item_sku}","quantity": 2,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.

Add_configured_bundle_item_to_cart_with_wrong_type
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
       ...  AND    I set Headers:    Authorization=${token}
       ...  AND    Find or create customer cart
       ...  AND    Cleanup all items in the cart:    ${cart_id}
    When I send a POST request:    /carts/${cart_id}/configured-bundles    {"data": {"type": "config","attributes": {"quantity": ${configured_bundle_quantity},"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle_first_slot_item_sku}","quantity": 2,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.

Add_configured_bundle_item_to_cart_with_missing_properties
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    When I send a POST request:    /carts/${cart_id}/configured-bundles    {"data": {"type": "configured-bundles","attributes": {}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4003
    And Response should return error message:    The quantity of the configured bundle should be more than zero.
    
Add_configured_bundle_item_to_cart_with_invalid_properties
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    When I send a POST request:    /carts/${cart_id}/configured-bundles    {"data": {"type": "configured-bundles","attributes": {"quantity": "","templateUuid": "","items": [{"sku": "","quantity": 2,"slotUuid": ""}]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4003
    And Response should return error message:    The quantity of the configured bundle should be more than zero.

Add_configured_bundle_item_to_cart_with_invalid_qty
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    When I send a POST request:    /carts/${cart_id}/configured-bundles    {"data": {"type": "configured-bundles","attributes": {"quantity": "abc"}}}
    Then Response status code should be:    422
    And Response should return error code:     4003
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    The quantity of the configured bundle should be more than zero.

####### PATCH #######
Update_configured_bundle_item_in_cart_with_non_existing_bundle_group_key
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
      ...  AND    I set Headers:    Authorization=${token}
      ...  AND    Find or create customer cart
      ...  AND    Cleanup all items in the cart:    ${cart_id}
    When I send a PATCH request:    /carts/${cart_id}/configured-bundles/fake    {"data": {"type": "configured-bundles","attributes": {"quantity": 1}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    4004
    And Response should return error message:    Configured bundle with provided group key not found in cart.

Update_configured_bundle_item_in_cart_with_invalid_qty
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/configured-bundles?include=items    {"data": {"type": "configured-bundles","attributes": {"quantity": ${configured_bundle_quantity},"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle_first_slot_item_sku}","quantity": 2,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    ...  AND    Save value to a variable:    [included][0][attributes][configuredBundle][groupKey]    bundle_group_key
    ...  AND    Response status code should be:    201
    When I send a PATCH request:    /carts/${cart_id}/configured-bundles/${bundle_group_key}?include=items    {"data": {"type": "configured-bundles","attributes": {"quantity": "abc"}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4003
    And Response should return error message:    The quantity of the configured bundle should be more than zero.

Update_configured_bundle_item_in_cart_with_no_item_id
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
      ...  AND    I set Headers:    Authorization=${token}
      ...  AND    Find or create customer cart
      ...  AND    Cleanup all items in the cart:    ${cart_id}
    When I send a PATCH request:    /carts/${cart_id}/configured-bundles/    {"data": {"type": "configured-bundles","attributes": {"quantity": 1}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Update_configured_bundle_item_in_cart_with_non_existing_cart_id
  
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
      ...  AND    I set Headers:    Authorization=${token}
    When I send a PATCH request:    /carts/fake/configured-bundles/fake    {"data": {"type": "configured-bundles","attributes": {"quantity": 1}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4001
    And Response should return error message:    There was a problem adding or updating the configured bundle.

Update_configured_bundle_item_in_cart_without_cart_id
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
      ...  AND    I set Headers:    Authorization=${token}
    When I send a PATCH request:    /carts//configured-bundles/fake    {"data": {"type": "configured-bundles","attributes": {"quantity": 1}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

####### DELETE #######
Delete_configured_bundle_item_from_the_cart_with_wrong_bundle_group_key
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    When I send a DELETE request:    /carts/${cart_id}/configured-bundles/fake
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    4004
    And Response should return error message:    Configured bundle with provided group key not found in cart.

Delete_configured_bundle_item_from_the_cart_with_empty_bundle_group_key
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    When I send a DELETE request:    /carts/${cart_id}/configured-bundles/
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Delete_configured_bundle_item_from_non_existing_cart
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a DELETE request:    /carts/fake/configured-bundles/fake
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4001
    And Response should return error message:    There was a problem adding or updating the configured bundle.

Delete_configured_bundle_item_without_cart_id
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a DELETE request:    /carts//configured-bundles/fake
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.
