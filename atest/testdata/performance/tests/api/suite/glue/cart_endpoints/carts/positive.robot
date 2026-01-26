*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    cart    prices    tax    promotions-discounts    marketplace-promotions-discounts    spryker-core    customer-access    multiple-carts

*** Test Cases ***
### GET requests
Get_cart_by_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Cleanup all customer carts
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]    ${cart_id}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][name]    ${test_cart_name}-${random}
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be:    [data][attributes][totals][subtotal]    0
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    0
    And Response body parameter should be:    [data][attributes][totals][priceToPay]    0
    And Response should contain the array of a certain size:    [data][attributes][discounts]    0
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Get_cart_without_cart_id
# Spryker is designed so that we can get all carts same as for /customers/{customerId}/carts request
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    Response status code should be:    201
    When I send a GET request:    /carts
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should contain:    [data]    ${cart_id}
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain nested property:    [data]    attributes    priceMode
    And Each array element of array in response should contain nested property:    [data]    attributes    currency
    And Each array element of array in response should contain nested property:    [data]    attributes    store
    And Each array element of array in response should contain nested property:    [data]    attributes    name
    And Each array element of array in response should contain nested property:    [data]    attributes    isDefault
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    expenseTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    discountTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    taxTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    subtotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    grandTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    priceToPay
    And Each array element of array in response should contain nested property:    [data]    [attributes]    discounts
    And Each array element of array in response should contain property:    [data]    links
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Get_cart_by_cart_id_with_included_items
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_products.sku_1}","quantity": 1}}}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_products.sku_2}","quantity": 1}}}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_products.sku_3}","quantity": 1}}}
    When I send a GET request:    /carts/${cart_id}?include=items
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]    ${cart_id}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][name]    ${test_cart_name}-${random}
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][taxTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][subtotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][totals][priceToPay]
    And Response body should contain:    discounts
    And Response body has correct self link internal
    And Response should contain the array of a certain size:    [data][relationships][items][data]    3
    And Each array element of array in response should contain property with value:    [data][relationships][items][data]    type    items
    And Response body parameter should contain:    [data][relationships][items][data][0][id]    ${concrete_products.sku_1}
    And Response body parameter should contain:    [data][relationships][items][data][1][id]    ${concrete_products.sku_2}
    And Response body parameter should contain:    [data][relationships][items][data][2][id]    ${concrete_products.sku_3}
    And Response should contain the array of a certain size:    [included]    3
    And Each array element of array in response should contain property with value:    [included]    type    items
    And Response body parameter should contain:    [included][0][id]    ${concrete_products.sku_1}
    And Response body parameter should contain:    [included][1][id]    ${concrete_products.sku_2}
    And Response body parameter should contain:    [included][2][id]    ${concrete_products.sku_3}
    And Each array element of array in response should contain property:    [included]    attributes
    And Each array element of array in response should contain property:    [included]    links
    And Response body parameter should be:    [included][0][attributes][sku]    ${concrete_products.sku_1}
    And Response body parameter should be:    [included][0][attributes][quantity]    1
    And Response body parameter should be:    [included][1][attributes][sku]    ${concrete_products.sku_2}
    And Response body parameter should be:    [included][1][attributes][quantity]    1
    And Response body parameter should be:    [included][2][attributes][sku]    ${concrete_products.sku_3}
    And Response body parameter should be:    [included][2][attributes][quantity]    1
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
    And Each array element of array in response should contain value:    [included]    salesUnit
    And Each array element of array in response should contain value:    [included]    selectedProductOptions
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204


Get_cart_by_customer_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    Response status code should be:    201
    When I send a GET request:    /customers/${yves_user.reference}/carts
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should contain:    [data]    ${cart_id}
    And Each array element of array in response should contain property:    [data]    type
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain nested property:    [data]    attributes    priceMode
    And Each array element of array in response should contain nested property:    [data]    attributes    currency
    And Each array element of array in response should contain nested property:    [data]    attributes    store
    And Each array element of array in response should contain nested property:    [data]    attributes    name
    And Each array element of array in response should contain nested property:    [data]    attributes    isDefault
    And Each array element of array in response should contain nested property:    [data]    attributes    totals
    And Each array element of array in response should contain nested property:    [data]    attributes    discounts
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    expenseTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    discountTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    taxTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    subtotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    grandTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][totals]    priceToPay
    And Each array element of array in response should contain nested property:    [data]    [attributes]    discounts
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

###POST requests
Create_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    And Save value to a variable:    [data][id]    cart_id
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]    ${cart_id}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][name]    ${test_cart_name}-${random}
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    None
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    None
    And Response body parameter should be:    [data][attributes][totals][taxTotal]    None
    And Response body parameter should be:    [data][attributes][totals][subtotal]    None
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    None
    And Response body parameter should be:    [data][attributes][totals][priceToPay]    None
    And Response should contain the array of a certain size:    [data][attributes][discounts]    0
    And Response body has correct self link for created entity:    ${cart_id}
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_cart_with_existing_name
# Spryker is designed so that we can send existing name and it will be changed automatically to the unique value on the BE side.
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    When I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    And Save value to a variable:    [data][id]    cart_id_2
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]    ${cart_id_2}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should NOT be:    [data][attributes][name]    ${test_cart_name}-${random}
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    None
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    None
    And Response body parameter should be:    [data][attributes][totals][taxTotal]    None
    And Response body parameter should be:    [data][attributes][totals][subtotal]    None
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    None
    And Response body parameter should be:    [data][attributes][totals][priceToPay]    None
    And Response should contain the array of a certain size:    [data][attributes][discounts]    0
    And Response body has correct self link for created entity:    ${cart_id_2}
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204
    ...  AND    I send a DELETE request:    /carts/${cart_id_2}
    ...  AND    Response status code should be:    204

###PATCH requests
Update_cart_by_cart_id_with_all_attributes
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    Save Header value to a variable:    ETag    header_tag
    ...  AND    Response status code should be:    201
    ...  AND    I set Headers:    Authorization=${token}    If-Match=${header_tag}
    When I send a PATCH request:    /carts/${cart_id}    {"data": {"type": "carts","attributes": {"priceMode": "${mode.net}","currency": "${currency.chf.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]    ${cart_id}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.net}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.chf.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][name]    ${test_cart_name}-${random}
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be:    [data][attributes][totals][subtotal]    0
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    0
    And Response body parameter should be:    [data][attributes][totals][priceToPay]    0
    And Response should contain the array of a certain size:    [data][attributes][discounts]    0
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Update_cart_with_empty_priceMod_currency_store
# Spryker is designed so that we can send empty attributes: priceMod, currency, store and it will not be changed to the empty values.
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    Save Header value to a variable:    ETag    header_tag
    ...  AND    Response status code should be:    201
    ...  AND    I set Headers:    Authorization=${token}    If-Match=${header_tag}
    When I send a PATCH request:    /carts/${cart_id}    {"data": {"type": "carts","attributes": {"priceMode": "","currency": "","store": ""}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]    ${cart_id}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][name]    ${test_cart_name}-${random}
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be:    [data][attributes][totals][subtotal]    0
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    0
    And Response body parameter should be:    [data][attributes][totals][priceToPay]    0
    And Response should contain the array of a certain size:    [data][attributes][discounts]    0
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Update_cart_with_name_attribute
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    Save Header value to a variable:    ETag    header_tag
    ...  AND    Response status code should be:    201
    ...  AND    I set Headers:    Authorization=${token}    If-Match=${header_tag}
    When I send a PATCH request:    /carts/${cart_id}    {"data": {"type": "carts","attributes": {"name": "${test_cart_name}-${random}"}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]    ${cart_id}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][name]    ${test_cart_name}-${random}
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be:    [data][attributes][totals][subtotal]    0
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    0
    And Response body parameter should be:    [data][attributes][totals][priceToPay]    0
    And Response should contain the array of a certain size:    [data][attributes][discounts]    0
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Get_cart_with_included_cart_rules
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
       ...  AND    I set Headers:    Authorization=${token}
       ...  AND    Cleanup all customer carts
       ...  AND    Create empty customer cart:    ${mode.gross}    ${currency.eur.code}    ${store.de}    cart_rules
       ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_concrete_product_alternative.sku}", "quantity": 4}}}
       ...  AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}?include=cart-rules
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
    And Response body parameter should be:    [data][attributes][discounts][0][displayName]    10% off minimum order
    ### check discount amount ###
    And Response body parameter should be:    [data][attributes][discounts][0][amount]    3202
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    3202
    ### check grand total with discount ###
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    28818
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][0][amount]
    And Each array element of array in response should contain property with value:    [data][relationships][cart-rules][data]    type    cart-rules
    And Each array element of array in response should contain property:    [data][relationships][cart-rules][data]    id
    And Response body parameter should be:     [included][0][attributes][amount]    3202
    And Response body parameter should not be EMPTY:    [included][0][attributes][amount]
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
       ...  AND    Cleanup all customer carts
       ...  AND    Create empty customer cart:    ${mode.gross}    ${currency.eur.code}    ${store.de}    promotional
       ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_concrete_product_alternative.sku}", "quantity": "8"}}}
       ...  AND    Response status code should be:    201
    When I send a GET request:    /carts/${cart_id}?include=promotional-items
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
    And Response body parameter should be:    [data][attributes][discounts][0][displayName]    10% off minimum order
    And Response body parameter should be:    [data][attributes][discounts][0][amount]    6404
    And Each array element of array in response should contain property with value:    [data][relationships][promotional-items][data]    type    promotional-items
    And Each array element of array in response should contain property:    [data][relationships][promotional-items][data]    id
    And Each array element of array in response should contain property with value:    [included]    type    promotional-items
    And Each array element of array in response should contain property:    [included]    id
    And Each array element of array in response should contain property:    [included]    attributes
    And Response body parameter should be in:    [included][0][attributes][sku]    068    112
    And Response body parameter should be in:    [included][1][attributes][sku]    068    112
    And Response body parameter should be:    [included][0][attributes][quantity]    1
    And Response body parameter should be:    [included][1][attributes][quantity]    1


Update_cart_with_existing_name
# Spryker is designed so that we can send existing name and it will be changed automatically to the unique value on the BE side.
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    Save Header value to a variable:    ETag    header_tag
    ...  AND    Response status code should be:    201
    ...  AND    I set Headers:    Authorization=${token}    If-Match=${header_tag}
    When I send a PATCH request:    /carts/${cart_id}    {"data": {"type": "carts","attributes": {"name": "My Cart"}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][id]    ${cart_id}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should NOT be:    [data][attributes][name]    "My Cart"
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be:    [data][attributes][totals][subtotal]    0
    And Response body parameter should be:    [data][attributes][totals][grandTotal]    0
    And Response body parameter should be:    [data][attributes][totals][priceToPay]    0
    And Response should contain the array of a certain size:    [data][attributes][discounts]    0
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

###DELETE requests
Delete_cart_by_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    Response status code should be:    201
    When I send a DELETE request:    /carts/${cart_id}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    When I send a GET request:    /carts/${cart_id}
    Then Response status code should be:    404
    And Array in response should contain property with value:    [errors]    detail    Cart with given uuid not found.
