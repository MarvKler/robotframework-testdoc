*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    configurable-bundle

*** Test Cases ***
Add_configured_bundle_item_to_the_cart_with_included_items
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    When I send a POST request:    /carts/${cart_id}/configured-bundles?include=items    {"data": {"type": "configured-bundles","attributes": {"quantity": ${configured_bundle_quantity},"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle_first_slot_item_sku2}","quantity": 2,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]    ${cart_id}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response should contain the array of a certain size:    [data][relationships][items]   1
    And Each array element of array in response should contain property with value:    [data][relationships][items][data]    type    items
    And Each Array Element Of Array In Response Should Contain Property:    [data][relationships][items][data]    id
    And Each Array Element Of Array In Response Should Contain Property:    [data][relationships][items][data]    id
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should be:    [included][0][type]    items
    And Response body parameter should be:    [included][0][attributes][sku]    ${configurable_bundle_first_slot_item_sku2}
    And Response body parameter should be:    [included][0][attributes][quantity]   2
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][unitPrice]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][sumPrice]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][taxRate]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][unitNetPrice]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][sumNetPrice]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][unitGrossPrice]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][sumGrossPrice]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][unitTaxAmountFullAggregation]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][sumTaxAmountFullAggregation]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][sumSubtotalAggregation]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][unitSubtotalAggregation]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][unitProductOptionPriceAggregation]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][sumProductOptionPriceAggregation]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][unitDiscountAmountAggregation]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][sumDiscountAmountAggregation]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][unitDiscountAmountFullAggregation]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][sumDiscountAmountFullAggregation]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][unitPriceToPayAggregation]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][sumPriceToPayAggregation]

Update_configured_bundle_quantity_in_the cart_to_the_cart
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/configured-bundles?include=items    {"data": {"type": "configured-bundles","attributes": {"quantity": ${configured_bundle_quantity},"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle_first_slot_item_sku2}","quantity": 2,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    ...  AND    Save value to a variable:    [included][0][attributes][configuredBundle][groupKey]    bundle_group_key
    ...  AND    Response status code should be:    201
    When I send a PATCH request:    /carts/${cart_id}/configured-bundles/${bundle_group_key}?include=items    {"data": {"type": "configured-bundles","attributes": {"quantity": 8}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]    ${cart_id}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [included][0][type]    items
    And Response body parameter should be:    [included][0][attributes][sku]    ${configurable_bundle_first_slot_item_sku2}
    And Response body parameter should be:    [included][0][attributes][configuredBundle][quantity]   8
    And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    4
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    1

Delete_configured_bundle_item_from_the_cart
  [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/configured-bundles?include=items    {"data": {"type": "configured-bundles","attributes": {"quantity": ${configured_bundle_quantity},"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle_first_slot_item_sku2}","quantity": 2,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    ...  AND    Save value to a variable:    [included][0][attributes][configuredBundle][groupKey]    bundle_group_key
    ...  AND    Response status code should be:    201
    When I send a DELETE request:    /carts/${cart_id}/configured-bundles/${bundle_group_key}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    And I send a GET request:    /carts/${cart_id}
    And Response body parameter should be:    [data][attributes][totals][priceToPay]    0
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    0
