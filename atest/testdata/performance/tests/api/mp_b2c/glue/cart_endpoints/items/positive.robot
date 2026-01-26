*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource          ../../../../../../resources/common/common_api.robot
Test Tags      glue    spryker-core    cart    product    marketplace-product-options    product-options    non-splittable-products    configurable-product    promotions-discounts    marketplace-promotions-discounts    inventory-management    marketplace-inventory-management

*** Test Cases ***
####POST#####
Add_one_item_to_cart
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
   ...    AND    find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}
   When I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
   Then Response status code should be:    201
   And Response reason should be:    Created
   And Response header parameter should be:    Content-Type    ${default_header_content_type}
   And Response body parameter should be:    [data][id]    ${cart_id}
   And Response body parameter should be:    [data][type]    carts
   And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
   And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
   And Response body parameter should be:    [data][attributes][store]    ${store.de}
   And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
   And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
   And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    1
   And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    1
   And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    1
   And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    1
   And Response body parameter should not be EMPTY:    [data][attributes][discounts]
   And Response body parameter should not be EMPTY:    [data][links][self]
   [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}/items/${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
   ...    AND    Response status code should be:    204


Add_two_items_to_cart_with_included_items_concrete_products_and_abstract_products
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}  
   When I send a POST request:    /carts/${cart_id}/items?include=items,concrete-products,abstract-products    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 2}}}
   Then Response status code should be:    201
   And Response reason should be:    Created
   And Response header parameter should be:    Content-Type    ${default_header_content_type}
   And Response body parameter should be:    [data][id]    ${cart_id}
   And Response body parameter should be:    [data][type]    carts
   And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
   And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
   And Response body parameter should be:    [data][attributes][store]    ${store.de}
   And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
   And Response body parameter should not be EMPTY:    [data][attributes][discounts]
   And Response body parameter should not be EMPTY:    [data][links][self]
   And Response should contain the array of a certain size:    [data][relationships][items][data]    1
   And Response should contain the array of a certain size:    [included]    3
   And Response include should contain certain entity type:    items
   And Response include should contain certain entity type:    concrete-products
   And Response include should contain certain entity type:    abstract-products
   And Response include element has self link:    items
   And Response include element has self link:    concrete-products
   And Response include element has self link:    abstract-products
   And Response body parameter should be:    [included][2][type]    items
   And Response body parameter should be:    [included][2][id]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
   And Response body parameter should be:    [included][2][attributes][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
   And Response body parameter should be:    [included][2][attributes][quantity]    2
   And Response body parameter should be:    [included][2][attributes][groupKey]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
   And Response body parameter should be:    [included][2][attributes][abstractSku]    ${product_availability.abstract_available_with_stock_and_never_out_of_stock}
   And Response body parameter should be:    [included][2][attributes][amount]    None
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitPrice]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumPrice]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][taxRate]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitNetPrice]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumNetPrice]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitGrossPrice]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumGrossPrice]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitTaxAmountFullAggregation]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumTaxAmountFullAggregation]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumSubtotalAggregation]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitSubtotalAggregation]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitProductOptionPriceAggregation]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumProductOptionPriceAggregation]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitDiscountAmountAggregation]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumDiscountAmountAggregation]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitDiscountAmountFullAggregation]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumDiscountAmountFullAggregation]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][unitPriceToPayAggregation]
   And Response body parameter should not be EMPTY:    [included][2][attributes][calculations][sumPriceToPayAggregation]
   And Response should contain the array of a certain size:    [included][2][attributes][selectedProductOptions]    0
   [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}/items/${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
   ...    AND    Response status code should be:    204

Get_a_cart_with_included_items_and_concrete_products
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
   ...    AND    Cleanup all customer carts
   ...    AND    Find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}
   ...    AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 2}}}
   ...    AND    Response status code should be:    201
   When I send a GET request:    /carts/${cart_id}?include=items,concrete-products
   Then Response status code should be:    200
   And Response reason should be:    OK
   And Response header parameter should be:    Content-Type    ${default_header_content_type}
   And Response body parameter should be:    [data][id]    ${cart_id}
   And Response body parameter should be:    [data][type]    carts
   And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
   And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
   And Response body parameter should be:    [data][attributes][store]    ${store.de}
   And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]
   And Response body parameter should not be EMPTY:    [data][attributes][discounts]
   And Response body parameter should not be EMPTY:    [data][links][self]
   And Response should contain the array of a certain size:    [data][relationships][items][data]    1
   And Response should contain the array of a certain size:    [included]    2
   And Response include should contain certain entity type:    items
   And Response include should contain certain entity type:    concrete-products
   And Response include element has self link:    items
   And Response include element has self link:    concrete-products
   And Response body parameter should be:    [included][1][type]    items
   And Response body parameter should be:    [included][1][id]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
   And Response body parameter should be:    [included][1][attributes][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
   And Response body parameter should be:    [included][1][attributes][quantity]    2
   And Response body parameter should be:    [included][1][attributes][groupKey]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
   And Response body parameter should be:    [included][1][attributes][abstractSku]    ${product_availability.abstract_available_with_stock_and_never_out_of_stock}
   And Response body parameter should be:    [included][1][attributes][amount]    None
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitPrice]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumPrice]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][taxRate]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitNetPrice]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumNetPrice]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitGrossPrice]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumGrossPrice]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitTaxAmountFullAggregation]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumTaxAmountFullAggregation]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumSubtotalAggregation]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitSubtotalAggregation]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitProductOptionPriceAggregation]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumProductOptionPriceAggregation]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitDiscountAmountAggregation]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumDiscountAmountAggregation]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitDiscountAmountFullAggregation]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumDiscountAmountFullAggregation]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][unitPriceToPayAggregation]
   And Response body parameter should not be EMPTY:    [included][1][attributes][calculations][sumPriceToPayAggregation]
   And Response should contain the array of a certain size:    [included][1][attributes][selectedProductOptions]    0
   [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}/items/${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
    ...    AND    Response status code should be:    204

Add_five_items_to_cart_with_included_cart_rules_and_promotional_items
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
   ...    AND    find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}
   When I send a POST request:    /carts/${cart_id}/items?include=cart-rules,promotional-items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_concrete_product_alternative.sku}","quantity": 5}}}
   Then Response status code should be:    201
   And Response reason should be:    Created
   And Response header parameter should be:    Content-Type    ${default_header_content_type}
   And Response body parameter should be:    [data][id]    ${cart_id}
   And Response body parameter should be:    [data][type]    carts
   And Response body parameter should not be EMPTY:    [data][links][self]
   And Response should contain the array larger than a certain size:    [data][relationships][cart-rules][data]    0
   And Response should contain the array larger than a certain size:    [included]    2
   And Response include should contain certain entity type:    cart-rules
   And Response include should contain certain entity type:    items
   And Response include element has self link:    cart-rules
   And Response include element has self link:    items
   [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}/items/${concrete_product_with_concrete_product_alternative.sku}
   ...    AND    Response status code should be:    204
# 
Add_product_with_options_to_cart
       [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete_product_with_concrete_product_alternative.sku}","quantity":1,"merchantReference":"${merchant.sony_experts.merchant_id}"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${cart_id}
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]
    And Response body parameter should not be EMPTY:   [data][attributes][totals][discountTotal]
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    1
    And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    1
    And Response body parameter should not be EMPTY:    [data][links][self]
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}/items/${concrete_product_with_concrete_product_alternative.sku}
    ...    AND    Response status code should be:    204
Add_item_with_storage_category_and_2_discounts
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
   ...    AND    find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}
   When I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product.product_without_relations}","quantity": 2}}}
   Then Response status code should be:    201
   And Response reason should be:    Created
   And Response header parameter should be:    Content-Type    ${default_header_content_type}
   And Response body parameter should be:    [data][id]    ${cart_id}
   And Response body parameter should be:    [data][type]    carts
   And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
   And Response body parameter should be:    [data][attributes][totals][discountTotal]    ${discount_concrete_product.product_1.total_sum_of_discounts}
   And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    0
   And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    0
   And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    0
   And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    0
   And Response body parameter should be:    [data][attributes][discounts][0][displayName]    ${discount_2.name}
   And Response body parameter should be:    [data][attributes][discounts][0][amount]    ${discount_concrete_product.product_1.with_discount_20_percentage_off_storage}
   And Response body parameter should be:    [data][attributes][discounts][0][code]    None
   And Response body parameter should be:    [data][attributes][discounts][1][displayName]    ${discount_1.name}
   And Response body parameter should be:    [data][attributes][discounts][1][amount]    ${discount_concrete_product.product_1.with_discount_10_percentage_off_minimum_order}
   And Response body parameter should be:    [data][attributes][discounts][1][code]    None
   And Response body parameter should not be EMPTY:    [data][links][self]
   [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}/items/${concrete_product.product_without_relations}
   ...    AND    Response status code should be:    204

Add_item_without_storage_category_and_2_discounts
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}
   When I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_concrete_product_alternative.sku}","quantity": 1}}}
   Then Response status code should be:    201
   And Response reason should be:    Created
   And Response header parameter should be:    Content-Type    ${default_header_content_type}
   And Response body parameter should be:    [data][id]    ${cart_id}
   And Response body parameter should be:    [data][type]    carts
   And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
   And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    0
   And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    0
   And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    0
   And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    0
   And Response body parameter should not be EMPTY:    [data][links][self]
   [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}/items/${concrete_product_with_concrete_product_alternative.sku}
   ...    AND    Response status code should be:    204

# ###### PATCH #######
Change_item_qty_in_cart
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
   ...    AND    find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}
   ...    AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 3}}}
   ...    AND    Save value to a variable:    [included][0][id]    item_uid
   ...    AND    Save value to a variable:    [included][0][attributes][calculations][sumPriceToPayAggregation]    item_total_price
   When I send a PATCH request:    /carts/${cart_id}/items/${item_uid}?include=items    {"data":{"type": "items","attributes":{"quantity": 2}}}
   Then Response status code should be:    200
   And Response reason should be:    OK
   And Response header parameter should be:    Content-Type    ${default_header_content_type}
   And Response body parameter should be:    [data][id]    ${cart_id}
   And Response body parameter should be:    [data][type]    carts
   And Response body parameter should be:    [included][0][id]    ${item_uid}
   And Response body parameter should be:    [included][0][attributes][quantity]    2
   And Response body parameter should be less than:    [included][0][attributes][calculations][sumPriceToPayAggregation]    ${item_total_price}
   [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}/items/${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
   ...    AND    Response status code should be:    204

Change_item_amount_in_cart
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
   ...    AND    find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}
   ...    AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 3}}}
   ...    AND    Save value to a variable:    [included][0][id]    item_uid
   ...    AND    Save value to a variable:    [included][0][attributes][calculations][sumPriceToPayAggregation]    item_total_price
   When I send a PATCH request:    /carts/${cart_id}/items/${item_uid}?include=items    {"data":{"type": "items","attributes":{"quantity": 2}}}
   Then Response status code should be:    200
   And Response reason should be:    OK
   And Response header parameter should be:    Content-Type    ${default_header_content_type}
   And Response body parameter should be:    [data][id]    ${cart_id}
   And Response body parameter should be:    [data][type]    carts
   And Response body parameter should be:    [included][0][id]    ${item_uid}
   And Response body parameter should be:    [included][0][attributes][quantity]    2
   And Response body parameter should be:    [included][0][attributes][amount]    None
   And Response body parameter should be less than:    [included][0][attributes][calculations][sumPriceToPayAggregation]    ${item_total_price}
   [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}/items/${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
   ...    AND    Response status code should be:    204

####### DELETE #######
Delete_item_form_cart
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    ...    AND    find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}
   ...    AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
   ...    AND    Save value to a variable:    [included][0][id]    item_uid
   When I send a DELETE request:    /carts/${cart_id}/items/${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
   Then Response status code should be:    204
   And Response reason should be:    No Content
   And I send a GET request:    /carts/${cart_id}
   And Response body parameter should be:    [data][attributes][totals][grandTotal]    0

Add_a_configurable_product_to_the_cart
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
   ...    AND    Find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}
   I send a POST request:    /carts/${cart_id}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${configurable_product.sku_1}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    201
   And Save value to a variable:    [data][id]    CartItemId
   And Response body parameter should be:    [included][0][attributes][sku]    ${configurable_product.sku_1}
   And Response body parameter should be:    [included][0][attributes][quantity]    3
   And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"09.09.2050\"}
   And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][isComplete]  True
   When I send a GET request:    /carts/${cart_id}?include=items,concrete-products
   Then Response status code should be:    200
   And Response reason should be:    OK
   And Response body parameter should be:  [data][type]    carts
   And Response body parameter should be:  [data][id]    ${cart_id}
   And Response body parameter should be:  [data][attributes][priceMode]    ${mode.gross}
   And Response body parameter should be:  [data][attributes][currency]    ${currency.eur.code}
   And Response body parameter should be:  [included][0][type]    concrete-products
   And Response body parameter should be:  [included][0][id]    ${configurable_product.sku_1}
   And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
   And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
   And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    0
   And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    0
   And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    0
   And Response body parameter should not be EMPTY:    [data][attributes][discounts][0][amount]
   And Response body parameter should be:    [data][attributes][discounts][0][code]    None
   And Response body parameter should not be EMPTY:    [data][links][self]

Update_configurable_product_quantity_in_the_cart
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
   ...    AND    Find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}
   I send a POST request:    /carts/${cart_id}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${configurable_product.sku_1}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":false,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    201
   And Save value to a variable:    [included][0][id]    item_uid
   And Save value to a variable:    [included][0][attributes][calculations][sumPriceToPayAggregation]    item_total_price
   And Response body parameter should be:    [included][0][attributes][sku]    ${configurable_product.sku_1}
   And Response body parameter should be:    [included][0][attributes][quantity]    3
   And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"09.09.2050\"}
   And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][isComplete]  False
   And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][configuration]  {\"time_of_day\":\"4\"}
   When I send a PATCH request:    /carts/${cart_id}/items/${item_uid}?include=items    {"data":{"type":"items","attributes":{"sku":"${configurable_product.sku_1}","quantity":2,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":false,"quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   Then Response status code should be:    200
   And Response reason should be:    OK
   And Response header parameter should be:    Content-Type    ${default_header_content_type}
   And Response body parameter should be:    [data][id]    ${cart_id}
   And Response body parameter should be:    [data][type]    carts
   And Response body parameter should be:    [included][0][id]    ${item_uid}
   And Response body parameter should be:    [included][0][attributes][quantity]    2
   And Response body parameter should be:    [included][0][attributes][amount]    None
   And Response body parameter should be:    [included][0][attributes][calculations][sumPriceToPayAggregation]    76504
   And Response body parameter should not be EMPTY:    [data][links][self]

Delete_configurable_product_item_form_the_cart
   [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
   ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
   ...    AND    Find or create customer cart
   ...    AND    Cleanup all items in the cart:    ${cart_id}
   I send a POST request:    /carts/${cart_id}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${configurable_product.sku_1}","quantity":3,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":false,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    201
   And Save value to a variable:    [included][0][id]    item_uid
   When I send a DELETE request:    /carts/${cart_id}/items/${item_uid}
   Then Response status code should be:    204
   And Response reason should be:    No Content
   And I send a GET request:    /carts/${cart_id}?include=items
   And Response body parameter should be:    [data][attributes][totals][grandTotal]    0

