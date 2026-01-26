*** Settings ***
Suite Setup       API_suite_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Setup        API_test_setup
Test Tags    glue    cart    spryker-core    product    configurable-product    product-bundles    non-splittable-products    prices

*** Test Cases ***
### Important CHECKOUT and CHECKOUT-DATA endpoints require Item ID and NOT intem sku. To get item id and include to the cart endpoint.
### Example:  
### I send a GET request:    /guest-carts/${guestCartId}?include=guest-cart-items
### Save value to a variable:    [included][0][id]    test
### I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name_1}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${test}"]}}}


Add_an_item_to_the_guest_cart
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product.with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    Cleanup All Items In The Guest Cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guestCartId}/guest-cart-items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${concrete_available_product.with_offer}","quantity":"1"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${guestCartId}
    And Response body parameter should be:    [data][type]    guest-carts
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
    And Each array element of array in response should contain property:    [data][attributes][discounts]    displayName
    And Each array element of array in response should contain property:    [data][attributes][discounts]    amount
    And Each array element of array in response should contain property:    [data][attributes][discounts]    code
    And Response body parameter should contain:    [data][attributes]    thresholds
    And Response body parameter should not be EMPTY:    [data][links][self]

Add_an_item_to_the_guest_cart_with_items_include
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product.with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    Cleanup All Items In The Guest Cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guestCartId}/guest-cart-items?include=items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${concrete_product_with_concrete_product_alternative.sku}","quantity":"1"}}}
    Save value to a variable:    [included][0][id]    sku_1_id
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should be:    [data][id]    ${guestCartId}
    And Response body parameter should be:    [data][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][currency]    ${currency.eur.code}
    And Response body parameter should be:    [data][attributes][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][isDefault]    True
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
    And Response body parameter should be:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    0
    And Response should contain the array of a certain size:    [data][attributes][discounts]    0
    And Response should contain the array of a certain size:    [data][attributes][thresholds]    1
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should be:    [included][0][type]    guest-cart-items
    And Response body parameter should be:    [included][0][id]    ${sku_1_id}
    And Response body parameter should be:    [included][0][attributes][sku]    ${concrete_product_with_concrete_product_alternative.sku}
    And Response body parameter should be:    [included][0][attributes][quantity]    1
    And Response body parameter should be:    [included][0][attributes][groupKey]    ${sku_1_id}
    And Response body parameter should be:    [included][0][attributes][amount]    None
    And Response body parameter should be:    [included][0][attributes][productOfferReference]    None
    And Response body parameter should be:    [included][0][attributes][merchantReference]    None
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
    And Response body parameter should be:    [included][0][attributes][configuredBundle]    None 
    And Response body parameter should be:    [included][0][attributes][configuredBundleItem]    None 
    And Response body parameter should be:    [included][0][attributes][productConfigurationInstance]    None 
    And Response body parameter should be:    [included][0][attributes][salesUnit]    None 
    And Response should contain the array of a certain size:    [included][0][attributes][selectedProductOptions]    0 
    And Response body parameter should not be EMPTY:    [data][links][self]

Add_an_item_to_the_guest_cart_with_concrete_products_and_abstract_products_includes
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    Cleanup All Items In The Guest Cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guestCartId}/guest-cart-items?include=concrete-products,abstract-products    {"data":{"type":"guest-cart-items","attributes":{"sku":"${concrete_product_with_concrete_product_alternative.sku}","quantity":"1"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response should contain the array of a certain size:    [included]    4
    And Response include should contain certain entity type:    concrete-products
    And Response include should contain certain entity type:    abstract-products
    And Response include should contain certain entity type:    guest-cart-items
    And Response include element has self link:   guest-cart-items
    And Response include element has self link:   abstract-products
    And Response include element has self link:   concrete-products

Add_an_item_to_the_guest_cart_with_cart_rules_includes
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    Cleanup All Items In The Guest Cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guestCartId}/guest-cart-items?include=cart-rules   {"data":{"type":"guest-cart-items","attributes":{"sku":"${concrete_product_with_concrete_product_alternative.sku}","quantity": 10}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${guestCartId}
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response should contain the array of a certain size:    [data][relationships][cart-rules][data]    1
    And Response should contain the array of a certain size:    [included]    2
    And Response include should contain certain entity type:    cart-rules
    And Response include should contain certain entity type:    guest-cart-items
    And Response include element has self link:   cart-rules
    And Response include element has self link:   guest-cart-items

Add_an_item_to_the_guest_cart_with_bundle_items_include
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    Cleanup All Items In The Guest Cart:    ${guest_cart_id}
    When I send a POST request:    /guest-carts/${guestCartId}/guest-cart-items?include=bundle-items,bundled-items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${bundled_product.concrete.product_1_sku}","quantity":"1"}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response body parameter should be:    [included][0][attributes][sku]    ${bundled_product.concrete.product_2_sku}
    And Response body parameter should be:    [included][1][attributes][sku]    ${bundled_product.concrete.product_3_sku}
    And Response body parameter should be:    [included][2][attributes][sku]    ${bundled_product.concrete.product_4_sku}
    And Response body parameter should be:    [included][3][attributes][sku]    ${bundled_product.concrete.product_1_sku}
    And Response body parameter should be:    [included][3][attributes][quantity]    1
    And Response body parameter should be:    [included][3][attributes][groupKey]    ${bundled_product.concrete.product_1_sku}
    And Response body parameter should be:    [included][3][attributes][abstractSku]    ${bundle_product.abstract.sku}
    And Response should contain the array of a certain size:    [included]    4
    And Response include should contain certain entity type:    bundled-items
    And Response include should contain certain entity type:    bundle-items
    And Response include element has self link:   bundled-items
    And Response include element has self link:   bundle-items

Update_an_item_quantity_at_the_guest_cart_with_items_include
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product.with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    I send a GET request:    /guest-carts/${guestCartId}?include=guest-cart-items
    ...    AND    Save value to a variable:    [included][0][id]    item_id_guest
    When I send a PATCH request:    /guest-carts/${guestCartId}/guest-cart-items/${item_id_guest}?include=items    {"data":{"type":"guest-cart-items","attributes":{"quantity":"2"}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${guestCartId}
    And Response body parameter should be:    [data][type]    guest-carts
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
    And Each array element of array in response should contain property:    [data][attributes][discounts]    displayName
    And Each array element of array in response should contain property:    [data][attributes][discounts]    amount
    And Each array element of array in response should contain property:    [data][attributes][discounts]    code
    And Response body parameter should contain:    [data][attributes]    thresholds
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response body parameter should be:    [included][0][type]    guest-cart-items
    And Response body parameter should contain:    [included][0][id]    ${concrete_available_product.with_offer}
    And Response should contain the array of a certain size:    [included]    1
    And Response body parameter should be:    [included][0][attributes][quantity]    2
    And Response body parameter should not be EMPTY:    [data][links][self]

Remove_an_item_from_the_guest_cart
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}    ${concrete_available_product.with_offer}    1
    ...    AND    Save value to a variable:    [data][id]    guestCartId
    ...    AND    I send a GET request:    /guest-carts/${guestCartId}?include=guest-cart-items
    ...    AND    Save value to a variable:    [included][0][id]    item_id_guest1
    When I send a DELETE request:    /guest-carts/${guestCartId}/guest-cart-items/${item_id_guest1}
    Then Response status code should be:    204
    And Response reason should be:    No Content



Add_a_configurable_product_to_the_cart
   [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
   Run Keywords    Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
   ...    AND    Save value to a variable:    [data][id]    guestCartId
   ...    AND    Cleanup All Items In The Guest Cart:    ${guest_cart_id}
   When I send a POST request:    /guest-carts/${guestCartId}/guest-cart-items?include=items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${configurable_product.sku}","quantity":1,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   Then Response status code should be:    201
   And Response reason should be:    Created
   And Response body parameter should be:    [included][0][attributes][sku]    ${configurable_product.sku}
   And Response body parameter should be:    [included][0][attributes][quantity]    1
   And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"09.09.2050\"}
   And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][isComplete]  True
   And Response body parameter should be:  [data][type]    guest-carts
   And Response body parameter should be:  [data][id]    ${guestCartId}
   And Response body parameter should be:  [data][attributes][priceMode]    ${mode.gross}
   And Response body parameter should be:  [data][attributes][currency]    ${currency.eur.code}
   And Response body parameter should be:  [included][0][type]    guest-cart-items
   And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
   And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]
   And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    0
   And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    0
   And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    0
   And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    0
   And Response body parameter should be:    [data][attributes][discounts][0][displayName]    ${discount_1.name}
   And Response body parameter should not be EMPTY:    [data][attributes][discounts][0][amount]
   And Response body parameter should be:    [data][attributes][discounts][0][code]    None
   And Response body parameter should not be EMPTY:    [data][links][self]


Change_configuration_and_quantity_in_the_cart
   [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
   Run Keywords    Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
   ...    AND    Save value to a variable:    [data][id]    guestCartId
   ...    AND    Cleanup All Items In The Guest Cart:    ${guest_cart_id}
   When I send a POST request:    /guest-carts/${guestCartId}/guest-cart-items?include=items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${configurable_product.sku}","quantity":1,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":1,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   And Response status code should be:    201
   And Save value to a variable:    [included][0][id]    item_uid
   And Save value to a variable:    [included][0][attributes][calculations][sumPriceToPayAggregation]    item_total_price
   And Response body parameter should be:    [included][0][attributes][sku]    ${configurable_product.sku}
   And Response body parameter should be:    [included][0][attributes][quantity]    1
   And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"09.09.2050\"}
   And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][isComplete]  True
   And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][configuration]  {\"time_of_day\":\"4\"}
   When I send a PATCH request:    /guest-carts/${guestCartId}/guest-cart-items/${item_uid}?include=items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${configurable_product.sku}","quantity":2,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Morning\\\",\\\"Date\\\":\\\"01.01.2025\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"${productConfigurationInstance.configuratorKey}","isComplete":false,"quantity":2,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   Then Response status code should be:    200
   And Response reason should be:    OK
   And Response header parameter should be:    Content-Type    ${default_header_content_type}
   And Response body parameter should be:    [data][id]    ${guestCartId}
   And Response body parameter should be:    [data][type]    guest-carts
   And Response body parameter should be:    [included][0][id]    ${item_uid}
   And Response body parameter should be:    [included][0][attributes][quantity]    2
   And Response body parameter should be:    [included][0][attributes][amount]    None
   And Response body parameter should be:    [included][0][attributes][calculations][sumPriceToPayAggregation]    76504
   And Response body parameter should not be EMPTY:    [data][links][self]

Delete_configurable_product_item_form_the_cart
   [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
   Run Keywords    Create a guest cart:    ${random}    ${concrete_product_with_concrete_product_alternative.sku}    1
   ...    AND    Save value to a variable:    [data][id]    guestCartId
   ...    AND    Cleanup All Items In The Guest Cart:    ${guest_cart_id}
   When I send a POST request:    /guest-carts/${guestCartId}/guest-cart-items?include=items    {"data":{"type":"guest-cart-items","attributes":{"sku":"${configurable_product.sku}","quantity":1,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":3,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
   Then Response status code should be:    201
   And Response reason should be:    Created
   And Response body parameter should be:    [included][0][attributes][sku]    ${configurable_product.sku}
   And Save value to a variable:    [included][0][id]     item_id2
   When I send a DELETE request:    /guest-carts/${guestCartId}/guest-cart-items/${item_id2}
   Then Response status code should be:    204
   And Response reason should be:    No Content
   And I send a GET request:    /guest-carts/${guestCartId}?include=guest-cart-items
   And Response body parameter should be:    [data][attributes][totals][grandTotal]    0