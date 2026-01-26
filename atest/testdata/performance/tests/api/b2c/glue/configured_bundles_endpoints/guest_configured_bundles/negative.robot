*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    configurable-bundle    spryker-core    cart

*** Test Cases ***
### POST ###
Add_configured_bundle_with_nonexistent_guest_cart_id
    [Setup]    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-carts/not_a_cart/guest-configured-bundles    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle.slot_1.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4001
    And Response should return error message:    There was a problem adding or updating the configured bundle.

Add_configured_bundle_with_empty_anonymous_id
    When I send a POST request:    /guest-carts//guest-configured-bundles    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle.slot_1.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    109
    And Response should return error message:    Anonymous customer unique id is empty.

Add_configured_bundle_with_other_anonymous_id
    [Setup]    Run Keywords    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Create a guest cart:    ${random}    ${product_with_relations.has_upselling_products.concrete_sku}    1
    ...    AND    Response status code should be:    201
    ...    AND    I set Headers:    X-Anonymous-Customer-Unique-Id=222
    When I send a POST request:    /guest-carts/${guest_cart_id}/guest-configured-bundles    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle.slot_1.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4001
    And Response should return error message:    There was a problem adding or updating the configured bundle.
    [Teardown]    Run Keywords     I set Headers:    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}

Add_configured_bundle_with_empty_template_uuid
    [Setup]    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-carts//guest-configured-bundles    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "","items": [{"sku": "${configurable_bundle.slot_1.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4002
    And Response should return error message:    Configurable bundle template not found.

Add_configured_bundle_with_nonexistant_template_uuid
    [Setup]    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-carts//guest-configured-bundles    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "not_uuid","items": [{"sku": "${configurable_bundle.slot_1.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4002
    And Response should return error message:    Configurable bundle template not found.

Add_configured_bundle_with_empty_slot_uuid
    [Setup]    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-carts//guest-configured-bundles    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle.slot_1.product_1}","quantity": 1,"slotUuid": ""}]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4001
    And Response should return error message:    Configured bundle cannot be added to cart.

Add_configured_bundle_with_nonexistant_slot_uuid
    [Setup]    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-carts//guest-configured-bundles    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle.slot_1.product_1}","quantity": 1,"slotUuid": "not_uuid"}]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4001
    And Response should return error message:    Configured bundle cannot be added to cart.

Add_configured_bundle_with_zero_quantity
    [Setup]    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-carts//guest-configured-bundles    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle.slot_1.product_1}","quantity": 0,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4001
    And Response should return error message:    "Wrong quantity for product SKU ${configurable_bundle.slot_1.product_1}."

Add_configured_bundle_with_empty_product_sku
    [Setup]    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-carts//guest-configured-bundles    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "","quantity": 1,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4001
    And Response should return error message:    Product "" not found

Add_configured_bundle_with_invalid_product_sku
    [Setup]    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-carts//guest-configured-bundles    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "not_a_sku","quantity": 1,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4001
    And Response should return error message:    Product "not_a_sku" not found

Add_configured_bundle_with_abstract_product_sku
    [Setup]    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-carts//guest-configured-bundles    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${special_product_abstract_sku.with_multivariant}","quantity": 1,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4001
    And Response should return error message:    Product "${special_product_abstract_sku.with_multivariant}" not found

Add_configured_bundle_with_product_not_in_stock
    [Setup]    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    When I send a POST request:    /guest-carts//guest-configured-bundles    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle.slot_1.product_no_stock}","quantity": 1,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4001
    And Response should return error message:    Item ${configurable_bundle.slot_1.product_no_stock} no longer available.


### PATCH ###

Update_configured_bundle_with_nonexistent_guest_cart_id
    [Setup]    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    When I send a PATCH request:    /guest-carts/not_a_cart/guest-configured-bundles/    {"data":{"type": "guest-configured-bundles","attributes":{"quantity": 2}}}
    Then Response status code should be:    400
    And Response should return error message:    Resource id is not specified.

Update_configured_bundle_with_empty_anonymous_id
    When I send a PATCH request:    /guest-carts//guest-configured-bundles/    {"data":{"type": "guest-configured-bundles","attributes":{"quantity": 2}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Update_configured_bundle_with_other_anonymous_id
    [Setup]    Run Keywords    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    I send a POST request:    /guest-carts//guest-configured-bundles?include=guest-cart-items    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    ...    AND    Save value to a variable:    [data][id]    guest_cart_id
    ...    AND    Save value to a variable:    [included][0][attributes][configuredBundle][groupKey]    bundle_id
    ...    AND    I set Headers:    X-Anonymous-Customer-Unique-Id=222
    When I send a PATCH request:    /guest-carts/${guest_cart_id}/guest-configured-bundles/${bundle_id}    {"data":{"type": "guest-configured-bundles","attributes":{"quantity": 2}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4001
    And Response should return error message:    There was a problem adding or updating the configured bundle.
    [Teardown]    Run Keywords     I set Headers:    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}


Update_configured_bundle_quantity_to_zero
    [Setup]    Run Keywords    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    I send a POST request:    /guest-carts//guest-configured-bundles?include=guest-cart-items    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    ...    AND    Save value to a variable:    [data][id]    guest_cart_id
    ...    AND    Save value to a variable:    [included][0][attributes][configuredBundle][groupKey]    bundle_id
    When I send a PATCH request:    /guest-carts/${guest_cart_id}/guest-configured-bundles/${bundle_id}    {"data":{"type": "guest-configured-bundles","attributes":{"quantity": 0}}}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4003
    And Response should return error message:    The quantity of the configured bundle should be more than zero.
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}

Update_configured_bundle_with_empty_bundle_id
   [Setup]    Run Keywords    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    I send a POST request:    /guest-carts//guest-configured-bundles?include=guest-cart-items    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    ...    AND    Save value to a variable:    [data][id]    guest_cart_id
    When I send a PATCH request:    /guest-carts/${guest_cart_id}/guest-configured-bundles/    {"data":{"type": "guest-configured-bundles","attributes":{"quantity": 1}}}
    Then Response status code should be:    400
    And Response should return error message:    Resource id is not specified.
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}

Update_configured_bundle_with_invalid_bundle_id
    [Setup]    Run Keywords    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    I send a POST request:    /guest-carts//guest-configured-bundles?include=guest-cart-items    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    ...    AND    Save value to a variable:    [data][id]    guest_cart_id
    When I send a PATCH request:    /guest-carts/${guest_cart_id}/guest-configured-bundles/not_a_bundle    {"data":{"type": "guest-configured-bundles","attributes":{"quantity": 1}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    4004
    And Response should return error message:    Configured bundle with provided group key not found in cart.
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}


### DELETE ###

Delete_configured_bundle_with_nonexistent_guest_cart_id
    [Setup]    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    When I send a DELETE request:    /guest-carts/not_a_cart/guest-configured-bundles/
    Then Response status code should be:    400
    And Response should return error message:    Resource id is not specified.

Delete_configured_bundle_with_empty_anonymous_id
    When I send a DELETE request:    /guest-carts//guest-configured-bundles/
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Resource id is not specified.

Delete_configured_bundle_with_other_anonymous_id
    [Setup]    Run Keywords    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    I send a POST request:    /guest-carts//guest-configured-bundles?include=guest-cart-items    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    ...    AND    Save value to a variable:    [data][id]    guest_cart_id
    ...    AND    Save value to a variable:    [included][0][attributes][configuredBundle][groupKey]    bundle_id
    ...    AND    I set Headers:    X-Anonymous-Customer-Unique-Id=222
    When I send a DELETE request:    /guest-carts/${guest_cart_id}/guest-configured-bundles/${bundle_id}
    Then Response status code should be:    422
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4001
    And Response should return error message:    There was a problem adding or updating the configured bundle.
    [Teardown]    Run Keywords     I set Headers:    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}


Delete_configured_bundle_with_empty_bundle_id
   [Setup]    Run Keywords    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    I send a POST request:    /guest-carts//guest-configured-bundles?include=guest-cart-items    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    ...    AND    Save value to a variable:    [data][id]    guest_cart_id
    When I send a DELETE request:    /guest-carts/${guest_cart_id}/guest-configured-bundles/
    Then Response status code should be:    400
    And Response should return error message:    Resource id is not specified.
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}

Delete_configured_bundle_with_invalid_bundle_id
    [Setup]    Run Keywords    I set Headers:   Content-Type=${default_header_content_type}     X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    I send a POST request:    /guest-carts//guest-configured-bundles?include=guest-cart-items    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    ...    AND    Save value to a variable:    [data][id]    guest_cart_id
    When I send a DELETE request:    /guest-carts/${guest_cart_id}/guest-configured-bundles/not_a_bundle
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error code:    4004
    And Response should return error message:    Configured bundle with provided group key not found in cart.
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}
