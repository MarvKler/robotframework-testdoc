*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    configurable-bundle    cart    spryker-core    promotions-discounts    marketplace-promotions-discounts    non-splittable-products

*** Test Cases ***
### POST ###
Add_configured_bundle_with_1_slot_1_product_new_cart   
    [Setup]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Create a guest cart:    ${random}    ${abstract_available_product_with_stock.concrete_sku}    1
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guest_cart_id}/guest-configured-bundles    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_1_uuid}","items": [{"sku": "${configurable_bundle.slot_1.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_1_uuid}"}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Save value to a variable:    [data][id]    guest_cart_id
    And Response should contain the array larger than a certain size:    [data]    0
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    0
    And Response should contain the array larger than a certain size:    [data][attributes][discounts]    0
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][0][displayName]
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][0][amount]
    And Response body parameter should be:    [data][attributes][discounts][0][code]    None
    And Response should contain the array smaller than a certain size:    [data][attributes][thresholds]    2
    And Response body parameter should be:    [data][links][self]    ${current_url}/guest-carts/${guest_cart_id}
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}

Add_configured_bundle_with_multiple_slots_and_products_to_existing_cart
    [Setup]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Create a guest cart:    ${random}    ${abstract_available_product_with_stock.concrete_sku}    1
    When I send a POST request:    /guest-carts/${guest_cart_id}/guest-configured-bundles?include=guest-cart-items    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    And Save value to a variable:    [included][0][attributes][configuredBundle][groupKey]    bundle_id
    And I send a POST request:    /guest-carts/${guest_cart_id}/guest-configured-bundles/${bundle_id}    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_6.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_6_uuid}"}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response should contain the array larger than a certain size:    [data]    0
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    0
    And Response should contain the array larger than a certain size:    [data][attributes][discounts]    0
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][0][displayName]
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][0][amount]
    And Response body parameter should be:    [data][attributes][discounts][0][code]    None
    And Response should contain the array smaller than a certain size:    [data][attributes][thresholds]    2
    And Response body parameter should be:    [data][links][self]    ${current_url}/guest-carts/${guest_cart_id}
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}

Add_configured_bundle_include_cart_rules
    [Setup]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
     ...    AND    Create a guest cart:    ${random}    ${abstract_available_product_with_stock.concrete_sku}    1
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guest_cart_id}/guest-configured-bundles?include=cart-rules    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Save value to a variable:    [data][id]    guest_cart_id
    And Response should contain the array larger than a certain size:    [data]    0
    And Response body parameter should be:    [data][type]    guest-carts   
    And Response body parameter should be:    [data][links][self]    ${current_url}/guest-carts/${guest_cart_id}
    And Response include should contain certain entity type:     cart-rules
    And Response should contain the array larger than a certain size:    [included]    0
    And Response should contain the array of a certain size:    [data][relationships][cart-rules][data]    1
    And Each array element of array in response should contain property with value:    [data][relationships][cart-rules][data]    type    cart-rules
    And Each array element of array in response should contain property:    [data][relationships][cart-rules][data]    id
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain value:    [included]    amount
    And Each array element of array in response should contain value:    [included]    code
    And Each array element of array in response should contain value:    [included]    discountType
    And Each array element of array in response should contain value:    [included]    displayName
    And Each array element of array in response should contain value:    [included]    isExclusive
    And Each array element of array in response should contain value:    [included]    expirationDateTime
    And Each array element of array in response should contain value:    [included]    discountPromotionAbstractSku
    And Each array element of array in response should contain value:    [included]    discountPromotionQuantity
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}

Add_configured_bundle_include_guest_cart_items
    [Setup]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Create a guest cart:    ${random}    ${abstract_available_product_with_stock.concrete_sku}    1
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guest_cart_id}/guest-configured-bundles?include=guest-cart-items    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Save value to a variable:    [data][id]    guest_cart_id
    And Response should contain the array larger than a certain size:    [data]    0
    And Response body parameter should be:    [data][type]    guest-carts   
    And Response body parameter should be:    [data][links][self]    ${current_url}/guest-carts/${guest_cart_id}
    And Response include should contain certain entity type:     guest-cart-items
    And Response should contain the array larger than a certain size:    [included]    0
    And Response should contain the array of a certain size:    [data][relationships][guest-cart-items][data]    1
    And Each array element of array in response should contain property with value:    [data][relationships][guest-cart-items][data]    type    guest-cart-items
    And Each array element of array in response should contain property:    [data][relationships][guest-cart-items][data]    id
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain value:    [included]    sku
    And Each array element of array in response should contain value:    [included]    quantity
    And Each array element of array in response should contain value:    [included]    groupKey
    And Each array element of array in response should contain value:    [included]    abstractSku
    And Each array element of array in response should contain value:    [included]    amount
    And Each array element of array in response should contain value:    [included]    calculations
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][sumPrice]
    And Response body parameter should not be EMPTY:    [included][0][attributes][calculations][unitPrice] 
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
    And Each array element of array in response should contain value:    [included]    configuredBundle
    And Response body parameter should be:    [included][0][attributes][configuredBundle][quantity]    1
    And Response body parameter should not be EMPTY:    [included][0][attributes][configuredBundle][groupKey]
    And Response body parameter should not be EMPTY:    [included][0][attributes][configuredBundle][template]
    And Response body parameter should be:    [included][0][attributes][configuredBundle][template][uuid]    ${configurable_bundle_template_2_uuid}
    And Response body parameter should not be EMPTY:    [included][0][attributes][configuredBundle][template][name]
    And Each array element of array in response should contain value:    [included]    configuredBundleItem
    And Response body parameter should be:    [included][0][attributes][configuredBundleItem][quantityPerSlot]    1
    And Response body parameter should be:    [included][0][attributes][configuredBundleItem][slot][uuid]    ${configurable_bundle_slot_5_uuid}
    And Response should contain the array of a certain size:    [included][0][attributes][selectedProductOptions]    0
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}

Add_configured_bundle_include_concrete_products
    [Setup]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Create a guest cart:    ${random}    ${abstract_available_product_with_stock.concrete_sku}    1
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guest_cart_id}/guest-configured-bundles?include=concrete-products,guest-cart-items    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Save value to a variable:    [data][id]    guest_cart_id
    And Response should contain the array larger than a certain size:    [data]    0
    And Response body parameter should be:    [data][type]    guest-carts   
    And Response body parameter should be:    [data][links][self]    ${current_url}/guest-carts/${guest_cart_id}
    And Response include should contain certain entity type:     concrete-products
    And Response should contain the array larger than a certain size:    [included]    0
    And Response body parameter should be:    [included][0][type]    concrete-products
    And Response body parameter should be:    [included][0][id]    ${configurable_bundle.slot_5.product_1}
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain property:    [included]    attributes
    And Response body parameter should not be EMPTY:    [included][0][attributes][sku]
    And Response body parameter should not be EMPTY:    [included][0][attributes][isDiscontinued]
    And Response body parameter should be:    [included][0][attributes][discontinuedNote]    None
    And Response body parameter should be:   [included][0][attributes][averageRating]    None
    And Response body parameter should be:    [included][0][attributes][reviewCount]    0
    And Response body parameter should not be EMPTY:    [included][0][attributes][productAbstractSku]
    And Response body parameter should not be EMPTY:    [included][0][attributes][name]
    And Response body parameter should not be EMPTY:    [included][0][attributes][description]
    And Response body parameter should not be EMPTY:    [included][0][attributes][attributes]
    And Response body parameter should not be EMPTY:    [included][0][attributes][superAttributesDefinition]
    And Response body parameter should not be EMPTY:    [included][0][attributes][metaTitle]
    And Response body parameter should not be EMPTY:    [included][0][attributes][metaKeywords]
    And Response body parameter should not be EMPTY:    [included][0][attributes][metaDescription]
    And Response body parameter should not be EMPTY:    [included][0][attributes][attributeNames]
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}

Add_configured_bundle_include_bundle_items
    [Setup]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Create a guest cart:    ${random}    ${bundle_product.concrete.product_4_sku}    1   
    When I send a POST request:    /guest-carts/${guest_cart_id}/guest-configured-bundles?include=bundle-items    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response should contain the array larger than a certain size:    [data]    0
    And Response body parameter should be:    [data][type]    guest-carts   
    And Response body parameter should be:    [data][links][self]    ${current_url}/guest-carts/${guest_cart_id}
    And Response include should contain certain entity type:     bundle-items
    And Response should contain the array larger than a certain size:    [included]    0
    And Response should contain the array of a certain size:    [data][relationships][bundle-items][data]    1
    And Each array element of array in response should contain property with value:    [data][relationships][bundle-items][data]    type    bundle-items
    And Each array element of array in response should contain property:    [data][relationships][bundle-items][data]    id
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain value:    [included]    sku
    And Each array element of array in response should contain value:    [included]    quantity
    And Each array element of array in response should contain value:    [included]    groupKey
    And Each array element of array in response should contain value:    [included]    abstractSku
    And Each array element of array in response should contain value:    [included]    amount
    And Each array element of array in response should contain value:    [included]    calculations
    And Response body parameter should be:    [included][0][attributes][configuredBundle]    None  
    And Response body parameter should be:    [included][0][attributes][configuredBundleItem]    None 
    And Each array element of array in response should contain value:    [included]    selectedProductOptions   
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}


Add_same_configured_bundle_again_to_check_quantity_not_merged
    [Setup]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Create a guest cart:    ${random}    ${abstract_available_product_with_stock.concrete_sku}    1
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guest_cart_id}/guest-configured-bundles    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    And Save value to a variable:    [data][id]    guest_cart_id
    And I send a POST request:    /guest-carts/${guest_cart_id}/guest-configured-bundles?include=guest-cart-items    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    Then Response status code should be:    201   
    And Response should contain the array larger than a certain size:    [data]    0
    And Response body parameter should be:    [data][type]    guest-carts   
    And Response body parameter should be:    [data][links][self]    ${current_url}/guest-carts/${guest_cart_id}
    And Response include should contain certain entity type:     guest-cart-items
    And Response should contain the array of a certain size:    [data][relationships][guest-cart-items][data]    2   
    And Response should contain the array of a certain size:    [included]    2
    And Each array element of array in response should contain nested property with value:    [included]    [attributes][sku]    ${configurable_bundle.slot_5.product_1}
    And Each array element of array in response should contain nested property with value:    [included]    [attributes][quantity]    1
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}

Add_configured_bundle_to_cart_that_contains_same_product
    [Setup]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Create a guest cart:    ${random}    ${configurable_bundle.slot_5.product_1}    1
    When I send a POST request:    /guest-carts/${guest_cart_id}/guest-configured-bundles?include=guest-cart-items    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    Then Response status code should be:    201
    And Response should contain the array larger than a certain size:    [data]    0
    And Response body parameter should be:    [data][type]    guest-carts   
    And Response body parameter should be:    [data][links][self]    ${current_url}/guest-carts/${guest_cart_id}
    And Response include should contain certain entity type:     guest-cart-items
    And Response should contain the array of a certain size:    [data][relationships][guest-cart-items][data]    2   
    And Response should contain the array of a certain size:    [included]    2
    And Each array element of array in response should contain nested property with value:    [included]    [attributes][sku]    ${configurable_bundle.slot_5.product_1}
    And Each array element of array in response should contain nested property with value:    [included]    [attributes][quantity]    1
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}

Add_other_configured_bundle_product_with_same_template
    [Setup]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Create a guest cart:    ${random}    ${abstract_available_product_with_stock.concrete_sku}    1
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guest_cart_id}/guest-configured-bundles    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    And Save value to a variable:    [data][id]    guest_cart_id
    And I send a POST request:    /guest-carts/${guest_cart_id}/guest-configured-bundles?include=guest-cart-items    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_2}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    Then Response status code should be:    201   
    And Response should contain the array larger than a certain size:    [data]    0
    And Response body parameter should be:    [data][type]    guest-carts   
    And Response body parameter should be:    [data][links][self]    ${current_url}/guest-carts/${guest_cart_id}
    And Response include should contain certain entity type:     guest-cart-items
    And Response should contain the array of a certain size:    [data][relationships][guest-cart-items][data]    2   
    And Response should contain the array of a certain size:    [included]    2
    And Each array element of array in response should contain nested property with value:    [included]    [attributes][quantity]    1
    And Response body parameter should be:    [included][0][attributes][sku]    ${configurable_bundle.slot_5.product_1}
    And Response body parameter should be:    [included][1][attributes][sku]    ${configurable_bundle.slot_5.product_2}
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}



### PATCH ###
Update_configured_bundle_product_quantity  
    [Setup]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Create a guest cart:    ${random}    ${abstract_available_product_with_stock.concrete_sku}    1
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}
    ...    AND    I send a POST request:    /guest-carts/${guest_cart_id}/guest-configured-bundles?include=guest-cart-items    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][configuredBundle][groupKey]    bundle_id
    When I send a PATCH request:    /guest-carts/${guest_cart_id}/guest-configured-bundles/${bundle_id}?include=guest-cart-items    {"data":{"type": "guest-configured-bundles","attributes":{"quantity": 2}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array larger than a certain size:    [data]    0
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    0
    And Response should contain the array larger than a certain size:    [data][attributes][discounts]    0
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][0][displayName]
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][0][amount]
    And Response body parameter should be:    [data][attributes][discounts][0][code]    None
    And Response should contain the array smaller than a certain size:    [data][attributes][thresholds]    2
    And Response body parameter should be:    [data][links][self]    ${current_url}/guest-carts/${guest_cart_id}
    And Response body parameter should be:    [included][0][attributes][sku]    ${configurable_bundle.slot_5.product_1} 
    And Response body parameter should be:    [included][0][attributes][quantity]    2
    [Teardown]    Run Keyword    Cleanup all items in the guest cart:    ${guest_cart_id}


### DELETE ###
Delete_configured_bundle_from_cart 
    [Setup]    Run Keywords    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    ...    AND    Create a guest cart:    ${random}    ${abstract_available_product_with_stock.concrete_sku}    1
    ...    AND    Cleanup all items in the guest cart:    ${guest_cart_id}
    ...    AND    I send a POST request:    /guest-carts/${guest_cart_id}/guest-configured-bundles?include=guest-cart-items    {"data": {"type": "guest-configured-bundles","attributes": {"quantity": 1,"templateUuid": "${configurable_bundle_template_2_uuid}","items": [{"sku": "${configurable_bundle.slot_5.product_1}","quantity": 1,"slotUuid": "${configurable_bundle_slot_5_uuid}"}]}}}
    ...    AND    Save value to a variable:    [included][0][attributes][configuredBundle][groupKey]    bundle_id
    When I send a DELETE request:    /guest-carts/${guest_cart_id}/guest-configured-bundles/${bundle_id}
    Then Response status code should be:    204
    And Response reason should be:    No Content
