*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    cart    prices    tax    promotions-discounts    marketplace-promotions-discounts    spryker-core    customer-access    multiple-carts

*** Test Cases ***    
#GET requests
Get_cart_by_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    When I send a GET request:    /carts/${cart_id}
    Then Response reason should be:    OK
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]    ${cart_id}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
    And Response body parameter should be:    [data][attributes][totals][discountTotal]   0
    And Response body parameter should be:    [data][attributes][totals][taxTotal]    0 
    And Response body parameter should be:    [data][attributes][totals][subtotal]    0 
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    0 
    And Response body parameter should be:    [data][attributes][totals][priceToPay]    0
    And Response body has correct self link internal

Get_cart_without_cart_id
# Spryker is designed so that we can get all carts same as for /customers/{customerId}/carts request
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
       ...  AND    I set Headers:    Authorization=${token}
       ...  AND    Find or create customer cart
    When I send a GET request:    /carts
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should contain:    [data][0][id]    ${cart_id}
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should not be EMPTY:    [data][0][attributes]

Get_cart_by_cart_id_with_included_items
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
       ...  AND    I set Headers:    Authorization=${token}
       ...  AND    Find or create customer cart
       ...  AND    Cleanup all items in the cart:    ${cart_id}
       ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_concrete_product_alternative.sku}", "quantity": "1"}}}
       ...  AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}?include=items
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]   ${cart_id}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][taxTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][subtotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][priceToPay]
    And Response body should contain:    discounts
    And Response body has correct self link internal
    And Each array element of array in response should contain property with value:    [data][relationships][items][data]    type    items
    And Each array element of array in response should contain property:    [data][relationships][items][data]    id
    And Each array element of array in response should contain property with value:    [included]    type    items
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Each array element of array in response should contain value:    [included]    sku
    And Each array element of array in response should contain value:    [included]    quantity
    And Each array element of array in response should contain value:    [included]    groupKey
    And Each array element of array in response should contain value:    [included]    abstractSku
    And Each array element of array in response should contain value:    [included]    amount
    And Each array element of array in response should contain value:    [included]    calculations
    And Each array element of array in response should contain value:    [included]    unitPrice
    And Each array element of array in response should contain value:    [included]    sumPrice
    And Each array element of array in response should contain value:    [included]    taxRate
    And Each array element of array in response should contain value:    [included]    unitNetPrice
    And Each array element of array in response should contain value:    [included]    sumNetPrice
    And Each array element of array in response should contain value:    [included]    unitGrossPrice
    And Each array element of array in response should contain value:    [included]    sumGrossPrice
    And Each array element of array in response should contain value:    [included]    unitTaxAmountFullAggregation
    And Each array element of array in response should contain value:    [included]    sumTaxAmountFullAggregation
    And Each array element of array in response should contain value:    [included]    sumSubtotalAggregation
    And Each array element of array in response should contain value:    [included]    unitSubtotalAggregation
    And Each array element of array in response should contain value:    [included]    unitProductOptionPriceAggregation
    And Each array element of array in response should contain value:    [included]    sumProductOptionPriceAggregation
    And Each array element of array in response should contain value:    [included]    unitDiscountAmountAggregation
    And Each array element of array in response should contain value:    [included]    sumDiscountAmountAggregation
    And Each array element of array in response should contain value:    [included]    unitDiscountAmountFullAggregation
    And Each array element of array in response should contain value:    [included]    sumDiscountAmountFullAggregation
    And Each array element of array in response should contain value:    [included]    unitPriceToPayAggregation
    And Each array element of array in response should contain value:    [included]    sumPriceToPayAggregation
    And Each array element of array in response should contain value:    [included]    selectedProductOptions

Get_cart_by_customer_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
       ...  AND    I set Headers:    Authorization=${token}
       ...  AND    Find or create customer cart
    When I send a GET request:    /customers/${yves_user.reference}/carts
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should contain:    [data]    ${cart_id}
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Response body parameter should not be EMPTY:    [data][0][attributes]

Get_cart_with_included_cart_rules
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
       ...  AND    I set Headers:    Authorization=${token}
       ...  AND    Find or create customer cart
       ...  AND    Cleanup all items in the cart:    ${cart_id}
       ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_concrete_product_alternative.sku}", "quantity": 4}}}
       ...  AND    Response status code should be:    201
    When I send a GET request:    /carts?include=cart-rules
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][type]    carts
    And Response body parameter should be:    [data][0][id]   ${cart_id}
    And Response body parameter should be:    [data][0][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][0][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][0][attributes][store]    ${store.de}
    And Response body parameter should not be EMPTY:    [data][0][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][0][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][0][attributes][totals][taxTotal]
    And Response body parameter should not be EMPTY:    [data][0][attributes][totals][subtotal]
    And Response body parameter should not be EMPTY:    [data][0][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][0][attributes][totals][priceToPay]
    And Response body should contain:    discounts
    And Response body parameter should be:    [data][0][attributes][discounts][0][displayName]    10% off minimum order
    And Response body parameter should be:    [data][0][attributes][discounts][0][amount]    3202
    And Each array element of array in response should contain property with value:    [data][0][relationships][cart-rules][data]    type    cart-rules
    And Each array element of array in response should contain property:    [data][0][relationships][cart-rules][data]    id
    And Response body parameter should be:     [included][0][attributes][amount]    3202
    And Each array element of array in response should contain property with value:    [included]    type    cart-rules
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

Get_cart_with_included_promotional_items
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
       ...  AND    I set Headers:    Authorization=${token}
       ...  AND    Find or create customer cart
       ...  AND    Cleanup all items in the cart:    ${cart_id}
       ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_concrete_product_alternative.sku}", "quantity": "8"}}}
       ...  AND    Response status code should be:    201
    When I send a GET request:    /carts?include=promotional-items
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][type]    carts
    And Response body parameter should be:    [data][0][id]   ${cart_id}
    And Response body parameter should be:    [data][0][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][0][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][0][attributes][store]    ${store.de}
    And Response body parameter should not be EMPTY:    [data][0][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][0][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][0][attributes][totals][taxTotal]
    And Response body parameter should not be EMPTY:    [data][0][attributes][totals][subtotal]
    And Response body parameter should not be EMPTY:    [data][0][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][0][attributes][totals][priceToPay]
    And Response body should contain:    discounts
    And Response body parameter should be:    [data][0][attributes][discounts][0][displayName]    10% off minimum order
    And Response body parameter should be:    [data][0][attributes][discounts][0][amount]    6404
    And Each array element of array in response should contain property with value:    [data][0][relationships][promotional-items][data]    type    promotional-items
    And Each array element of array in response should contain property:    [data][0][relationships][promotional-items][data]    id
    And Each array element of array in response should contain property with value:    [included]    type    promotional-items
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Response body parameter should be in:    [included][0][attributes][sku]    112    068
    And Response body parameter should be:    [included][0][attributes][quantity]    1

#PATCH requests
Update_cart_by_cart_id_with_all_attributes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
        ...  AND    I set Headers:    Authorization=${token}
        ...  AND    Find or create customer cart
        ...  AND    Cleanup all items in the cart:    ${cart_id}
        ...  AND    Get ETag header value from cart
        ...  AND    I set Headers:    Authorization=${token}    If-Match=${Etag}
    When I send a PATCH request:    /carts/${cart_id}    {"data": {"type": "carts","attributes": {"priceMode": "${mode.net}","currency": "${currency.eur.code}","store": "${store.de}"}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]    ${cart_id}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.net}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should contain:    [data][attributes][totals]    expenseTotal
    And Response body parameter should contain:    [data][attributes][totals]    discountTotal
    And Response body parameter should contain:    [data][attributes][totals]    taxTotal
    And Response body parameter should contain:    [data][attributes][totals]    subtotal
    And Response body parameter should contain:    [data][attributes][totals]    grandTotal
    And Response body parameter should contain:    [data][attributes][totals]    priceToPay
    And Response body has correct self link internal
    [Teardown]    Run Keywords    Get ETag header value from cart
        ...  AND    I set Headers:    Authorization=${token}    If-Match=${ETag}
        ...  AND    I send a PATCH request:    /carts/${cart_id}    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}"}}}
        ...  AND    Response status code should be:    200
Update_cart_with_empty_priceMod_currency_store
# Spryker is designed so that we can send empty attributes: priceMod, currency, store and it will not be changed to the empty values.
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
        ...  AND    I set Headers:    Authorization=${token}
        ...  AND    Find or create customer cart
        ...  AND    Cleanup all items in the cart:    ${cart_id}
        ...  AND    Get ETag header value from cart
        ...  AND    I set Headers:    Authorization=${token}    If-Match=${Etag}
    When I send a PATCH request:    /carts/${cart_id}    {"data": {"type": "carts","attributes": {"priceMode": "","currency": "","store": ""}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]    ${cart_id}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should contain:    [data][attributes][totals]    expenseTotal
    And Response body parameter should contain:    [data][attributes][totals]    discountTotal
    And Response body parameter should contain:    [data][attributes][totals]    taxTotal
    And Response body parameter should contain:    [data][attributes][totals]    subtotal
    And Response body parameter should contain:    [data][attributes][totals]    grandTotal
    And Response body parameter should contain:    [data][attributes][totals]    priceToPay
    And Response body has correct self link internal
