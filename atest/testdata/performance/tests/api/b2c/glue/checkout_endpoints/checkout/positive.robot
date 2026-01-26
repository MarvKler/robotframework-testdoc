*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    spryker-core    cart    checkout    shipment    order-management    configurable-bundle    promotions-discounts    gift-cards    configurable-product    payments    inventory-management     default-run-feature

*** Test Cases ***
#POST requests
Create_order
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body has correct self link internal

Create_order_for_guest_user
    [Setup]    Run Keywords    I set Headers:    X-Anonymous-Customer-Unique-Id=${x_anonymous_prefix}${random}
    ...  AND    I send a POST request:    /guest-cart-items    {"data": { "type": "guest-cart-items", "attributes": {"sku":"${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}", "quantity": "1"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body has correct self link internal

Create_order_include_orders
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body has correct self link internal
    #totals
    And Response body parameter should be:    [data][relationships][orders][data][0][type]    orders
    And Response body parameter should contain:    [data][relationships][orders][data][0][id]    ${store.de}--
    And Response body parameter should be:    [included][0][type]    orders
    And Response body parameter should contain:    [included][0][id]    ${store.de}--
    And Response body parameter should not be EMPTY:    [included][0][attributes][createdAt]
    And Response body parameter should be:    [included][0][attributes][currencyIsoCode]    ${currency.eur.code}
    And Response body parameter should be:    [included][0][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be greater than:    [included][0][attributes][totals][expenseTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][grandTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][canceledTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][remunerationTotal]    0
    #billingAddress
    And Response body parameter should be:    [included][0][attributes][billingAddress][salutation]    ${yves_user.salutation}
    And Response body parameter should be:    [included][0][attributes][billingAddress][firstName]    ${yves_user.first_name}
    And Response body parameter should be:    [included][0][attributes][billingAddress][middleName]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][lastName]    ${yves_user.last_name}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address1]    ${default.address1}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address2]    ${default.address2}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address3]    ${default.address3}
    And Response body parameter should be:    [included][0][attributes][billingAddress][company]    ${default.company}
    And Response body parameter should be:    [included][0][attributes][billingAddress][city]    ${default.city}
    And Response body parameter should be:    [included][0][attributes][billingAddress][zipCode]    ${default.zipCode}
    And Response body parameter should be:    [included][0][attributes][billingAddress][poBox]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][phone]    ${default.phone}
    And Response body parameter should be:    [included][0][attributes][billingAddress][cellPhone]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][description]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][comment]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][email]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][country]    ${default.country}
    And Response body parameter should be:    [included][0][attributes][billingAddress][iso2Code]    ${default.iso2Code}
    #shippingAddress
    And Response body parameter should be:    [included][0][attributes][shippingAddress][salutation]    ${yves_user.salutation}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][firstName]    ${yves_user.first_name}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][middleName]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][lastName]    ${yves_user.last_name}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address1]    ${default.address1}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address2]    ${default.address2}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address3]    ${default.address3}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][company]    ${default.company}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][city]    ${default.city}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][zipCode]    ${default.zipCode}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][poBox]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][phone]    ${default.phone}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][cellPhone]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][description]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][comment]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][email]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][country]    ${default.country}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][iso2Code]    ${default.iso2Code}
    #items
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumPrice]    0
    And Response body parameter should be:    [included][0][attributes][items][0][quantity]    1
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][taxRate]    0
    And Response body parameter should be:    [included][0][attributes][items][0][unitNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][items][0][sumNetPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitTaxAmountFullAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumTaxAmountFullAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][refundableAmount]    0
    And Response body parameter should be:    [included][0][attributes][items][0][canceledAmount]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumSubtotalAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitSubtotalAggregation]    0
    And Response body parameter should be:    [included][0][attributes][items][0][unitProductOptionPriceAggregation]    0
    And Response body parameter should be:    [included][0][attributes][items][0][sumProductOptionPriceAggregation]    0
    And Response body parameter should be:    [included][0][attributes][items][0][unitExpensePriceAggregation]    0
    And Response body parameter should be:    [included][0][attributes][items][0][sumExpensePriceAggregation]    None
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitDiscountAmountAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumDiscountAmountAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitDiscountAmountFullAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumDiscountAmountFullAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitPriceToPayAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumPriceToPayAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][taxRateAverageAggregation]    0
    And Response body parameter should be:    [included][0][attributes][items][0][taxAmountAfterCancellation]    None
    And Response body parameter should be:    [included][0][attributes][items][0][orderReference]    None
    And Response body parameter should not be EMPTY:    [included][0][attributes][items][0][uuid]
    And Response body parameter should be:    [included][0][attributes][items][0][isReturnable]    False
    And Response body parameter should be greater than:    [included][0][attributes][items][0][idShipment]    0
    And Response body parameter should be:    [included][0][attributes][items][0][bundleItemIdentifier]    None
    And Response body parameter should be:    [included][0][attributes][items][0][relatedBundleItemIdentifier]    None
    And Response should contain the array of a certain size:    [included][0][attributes][items][0][metadata][superAttributes]    0
    And Response body parameter should not be EMPTY:    [included][0][attributes][items][0][metadata][image]
    And Response body parameter should be greater than:    [included][0][attributes][items][0][calculatedDiscounts][0][unitAmount]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][calculatedDiscounts][0][sumAmount]    0
    And Response body parameter should not be EMPTY:    [included][0][attributes][items][0][calculatedDiscounts][0][displayName]
    And Response body parameter should not be EMPTY:    [included][0][attributes][items][0][calculatedDiscounts][0][description]
    And Response body parameter should be:    [included][0][attributes][items][0][calculatedDiscounts][0][voucherCode]    None
    And Response body parameter should be:    [included][0][attributes][items][0][calculatedDiscounts][0][quantity]    1
    And Response should contain the array of a certain size:    [included][0][attributes][items][0][productOptions]    0
    #expenses
    And Response body parameter should be:    [included][0][attributes][expenses][0][type]    SHIPMENT_EXPENSE_TYPE
    And Response body parameter should be:    [included][0][attributes][expenses][0][name]    ${shipment.method_name}
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][sumPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][unitGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][sumGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][taxRate]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][canceledAmount]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitDiscountAmountAggregation]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumDiscountAmountAggregation]    None
    And Response body parameter should not be EMPTY:    [included][0][attributes][expenses][0][unitTaxAmount]
    And Response body parameter should not be EMPTY:    [included][0][attributes][expenses][0][sumTaxAmount]
    And Response body parameter should not be EMPTY:    [included][0][attributes][expenses][0][unitPriceToPayAggregation]
    And Response body parameter should not be EMPTY:    [included][0][attributes][expenses][0][sumPriceToPayAggregation]
    And Response body parameter should be:    [included][0][attributes][expenses][0][taxAmountAfterCancellation]    None
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][idShipment]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][idSalesExpense]    0
    #payments
    And Response body parameter should be greater than:    [included][0][attributes][payments][0][amount]    0
    And Response body parameter should be:    [included][0][attributes][payments][0][paymentProvider]    ${payment.provider_name}
    And Response body case-insensitive parameter should be:    [included][0][attributes][payments][0][paymentMethod]    ${payment.method_name}
    #shipments
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment.method_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [included][0][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][currencyIsoCode]    ${currency.eur.code}
    #calculatedDiscounts
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    unitAmount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    sumAmount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    displayName
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    description
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    voucherCode
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    quantity

Create_order_with_bundle_product
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${bundle_product.concrete_sku}","quantity": 1}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${bundle_product.concrete_sku}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    #items
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${bundled.product_1.concrete_sku}
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${bundled.product_1.concrete_name}
    And Response body parameter should be:    [included][0][attributes][items][1][sku]    ${bundled.product_2.concrete_sku}
    And Response body parameter should be:    [included][0][attributes][items][1][name]    ${bundled.product_2.concrete_name}
    And Response body parameter should be:    [included][0][attributes][items][2][sku]    ${bundled.product_3.concrete_sku}
    And Response body parameter should be:    [included][0][attributes][items][2][name]    ${bundled.product_3.concrete_name}
    And Response body has correct self link internal

Create_order_with_chf_currency_&_express_shipment_method
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    Save Header value to a variable:    ETag    header_tag
    ...  AND    I set Headers:    Authorization=${token}    If-Match=${header_tag}
    ...  AND    I send a PATCH request:    /carts/${cart_id}    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.chf.code}","store": "${store.de}"}}}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 20}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 5},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body parameter should be:    [included][0][attributes][currencyIsoCode]    ${currency.chf.code}
    And Response body parameter should be:    [included][0][attributes][priceMode]    ${mode.gross}
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment.method_name_5}
    And Response body has correct self link internal

Create_order_with_product_options
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product.with_options.sku}","quantity": 1, "productOptions": [{"sku": "${product.option_1}"}]}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}", "${concrete_product.with_options.sku}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response should contain the array of a certain size:    [included][0][attributes][items]    2
    And Response body has correct self link internal
    #product_1
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
    And Response should contain the array of a certain size:    [included][0][attributes][items][0][productOptions]    0
    And Response body parameter should be:    [included][0][attributes][items][0][quantity]    1
    #product_2
    And Response body parameter should be:    [included][0][attributes][items][1][name]    ${concrete_product.with_options.name}
    And Response body parameter should be:    [included][0][attributes][items][1][sku]    ${concrete_product.with_options.sku}
    And Response body parameter should be:    [included][0][attributes][items][1][productOptions][0][optionGroupName]    Warranty
    And Response body parameter should be:    [included][0][attributes][items][1][productOptions][0][sku]    ${product.option_1}
    And Response body parameter should be:    [included][0][attributes][items][1][productOptions][0][optionName]    ${product.option_1_name}
    And Response body parameter should be greater than:    [included][0][attributes][items][1][productOptions][0][price]    0
    And Response body parameter should be:    [included][0][attributes][items][1][quantity]    1

Create_order_with_split_shipments
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product.with_options.sku}","quantity": 1}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user.salutation}","email": "${yves_user.email}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentMethodName": "${payment.method_name}","paymentProviderName": "${payment.provider_name}"}],"shipments": [{"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 2,"requestedDeliveryDate": "${shipment.delivery_date}"},{"items": ["${concrete_product.with_options.sku}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${changed.address1}","address2": "${changed.address2}","address3": "${changed.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${changed.phone}","isDefaultBilling": false,"isDefaultShipping": false},"idShipmentMethod": 4,"requestedDeliveryDate": null}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress]    None
    And Response body has correct self link internal
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
    And Response body parameter should be:    [included][0][attributes][items][0][quantity]    1
    And Response body parameter should be greater than:    [included][0][attributes][items][0][idShipment]    0
    And Response body parameter should be:    [included][0][attributes][items][1][name]    ${concrete_product.with_options.name}
    And Response body parameter should be:    [included][0][attributes][items][1][sku]    ${concrete_product.with_options.sku}
    And Response body parameter should be:    [included][0][attributes][items][1][quantity]    1
    And Response body parameter should be greater than:    [included][0][attributes][items][1][idShipment]    0
    And Response should contain the array of a certain size:    [included][0][attributes][shipments]    0
    And Response should contain certain number of values:    [included][0][attributes][expenses]    idShipment    2

Create_order_with_split_shipments_&_same_shipping_address
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product.with_options.sku}","quantity": 1}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user.salutation}","email": "${yves_user.email}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentMethodName": "${payment.method_name}","paymentProviderName": "${payment.provider_name}"}],"shipments": [{"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 1,"requestedDeliveryDate": null},{"items": ["${concrete_product.with_options.sku}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 1,"requestedDeliveryDate": null}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body has correct self link internal
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
    And Response body parameter should be:    [included][0][attributes][items][0][quantity]    1
    And Response body parameter should be:    [included][0][attributes][items][1][name]    ${concrete_product.with_options.name}
    And Response body parameter should be:    [included][0][attributes][items][1][sku]    ${concrete_product.with_options.sku}
    And Response body parameter should be:    [included][0][attributes][items][1][quantity]    1
    And Response should contain certain number of values:    [included][0][attributes]    shipments    1
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment.method_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [included][0][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][currencyIsoCode]    ${currency.eur.code}

Create_order_with_same_items_in_different_shipments
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user.salutation}","email": "${yves_user.email}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentMethodName": "${payment.method_name}","paymentProviderName": "${payment.provider_name}"}],"shipments": [{"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 2,"requestedDeliveryDate": null},{"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${changed.address1}","address2": "${changed.address2}","address3": "${changed.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${changed.phone}","isDefaultBilling": false,"isDefaultShipping": false},"idShipmentMethod": 1,"requestedDeliveryDate": null}]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress]    None
    And Response body has correct self link internal
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}
    And Response body parameter should be:    [included][0][attributes][items][0][quantity]    1
    And Response body parameter should be greater than:    [included][0][attributes][items][0][idShipment]    0
    And Response should contain certain number of values:    [included][0][attributes]    shipments    1
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment.method_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [included][0][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][currencyIsoCode]    ${currency.eur.code}
    And Response should contain certain number of values:    [included][0][attributes][expenses]    idShipment    1

Create_order_with_free_shipping_discount
    [Documentation]    change sub total cause product price is 26.25 (sub total could not be greater than 200.00)
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 3}}}
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"]}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should be:    [included][0][attributes][totals][expenseTotal]    ${discount.discount_1.total_sum}
    And Response body parameter should be greater than:    [included][0][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][subtotal]    7800
    And Save value to a variable:    [included][0][attributes][totals][discountTotal]    discount_total_sum
    And Save value to a variable:    [included][0][attributes][totals][subtotal]    sub_total_sum
    And Perform arithmetical calculation with two arguments:    grand_total_sum    ${sub_total_sum}    -    ${discount_total_sum}
    And Perform arithmetical calculation with two arguments:    grand_total_sum    ${grand_total_sum}    +    ${discount.discount_1.total_sum}
    And Response body parameter with rounding should be:    [included][0][attributes][totals][grandTotal]    ${grand_total_sum}
    And Response body parameter should be:    [included][0][attributes][totals][canceledTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][remunerationTotal]    0
    And Response should contain the array of a certain size:    [included][0][attributes][items]    3
    #shipments
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment.method_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultGrossPrice]    ${discount.discount_1.total_sum}
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][currencyIsoCode]    ${currency.eur.code}
    #calculatedDiscounts - "Free standard delivery" discount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    unitAmount: None
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    sumAmount: ${discount.discount_1.total_sum}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    displayName: ${discount.discount_1.name}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    description: ${discount.discount_1.description}
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    voucherCode: None
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    quantity: 1


Create_order_with_configurable_product
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}    
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data":{"type":"items","attributes":{"sku":"${configurable_product.sku_1}","quantity":1,"productConfigurationInstance":{"displayData":"{\\\"Preferred time of the day\\\":\\\"Afternoon\\\",\\\"Date\\\":\\\"09.09.2050\\\"}","configuration":"{\\\"time_of_day\\\":\\\"4\\\"}","configuratorKey":"DATE_TIME_CONFIGURATOR","isComplete":true,"quantity":1,"availableQuantity":4,"prices":[{"priceTypeName":"DEFAULT","netAmount":23434,"grossAmount":42502,"currency":{"code":"EUR","name":"Euro","symbol":"€"},"volumePrices":[{"netAmount":150,"grossAmount":165,"quantity":5},{"netAmount":145,"grossAmount":158,"quantity":10},{"netAmount":140,"grossAmount":152,"quantity":20}]}]}}}}
    And Save value to a variable:    [data][id]    CartItemId
    And Response body parameter should be:    [included][0][attributes][sku]    ${configurable_product.sku_1}
    And Response body parameter should be:    [included][0][attributes][quantity]    1
    And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"09.09.2050\"}
    And Response body parameter should be:    [included][0][attributes][productConfigurationInstance][isComplete]  True
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${configurable_product.sku_1}"]}}}
    And Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    checkout
    And Response body parameter should be:    [data][id]    None
    And Response body parameter should contain:    [data][attributes][orderReference]    ${store.de}--
    And Response body parameter should be:    [data][attributes][redirectUrl]    None
    And Response body parameter should be:    [data][attributes][isExternalRedirect]    None
    And Response body has correct self link internal
    And Response body parameter should be:    [data][relationships][orders][data][0][type]    orders
    And Response body parameter should contain:    [data][relationships][orders][data][0][id]    ${store.de}--
    And Response body parameter should be:    [included][0][type]    orders
    And Response body parameter should contain:    [included][0][id]    ${store.de}--
    And Response body parameter should not be EMPTY:    [included][0][attributes][createdAt]
    And Response body parameter should be:    [included][0][attributes][currencyIsoCode]    ${currency.eur.code}
    And Response body parameter should be:    [included][0][attributes][priceMode]    ${mode.gross}
    #totals
    And Response body parameter should be greater than:    [included][0][attributes][totals][expenseTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][discountTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [included][0][attributes][totals][grandTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][canceledTotal]    0
    And Response body parameter should be:    [included][0][attributes][totals][remunerationTotal]    0
    #billingAddress
    And Response body parameter should be:    [included][0][attributes][billingAddress][salutation]    ${yves_user.salutation}
    And Response body parameter should be:    [included][0][attributes][billingAddress][firstName]    ${yves_user.first_name}
    And Response body parameter should be:    [included][0][attributes][billingAddress][middleName]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][lastName]    ${yves_user.last_name}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address1]    ${default.address1}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address2]    ${default.address2}
    And Response body parameter should be:    [included][0][attributes][billingAddress][address3]    ${default.address3}
    And Response body parameter should be:    [included][0][attributes][billingAddress][company]    ${default.company}
    And Response body parameter should be:    [included][0][attributes][billingAddress][city]    ${default.city}
    And Response body parameter should be:    [included][0][attributes][billingAddress][zipCode]    ${default.zipCode}
    And Response body parameter should be:    [included][0][attributes][billingAddress][poBox]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][phone]    ${default.phone}
    And Response body parameter should be:    [included][0][attributes][billingAddress][cellPhone]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][description]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][comment]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][email]    None
    And Response body parameter should be:    [included][0][attributes][billingAddress][country]    ${default.country}
    And Response body parameter should be:    [included][0][attributes][billingAddress][iso2Code]    ${default.iso2Code}
    #shippingAddress
    And Response body parameter should be:    [included][0][attributes][shippingAddress][salutation]    ${yves_user.salutation}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][firstName]    ${yves_user.first_name}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][middleName]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][lastName]    ${yves_user.last_name}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address1]    ${default.address1}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address2]    ${default.address2}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][address3]    ${default.address3}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][company]    ${default.company}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][city]    ${default.city}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][zipCode]    ${default.zipCode}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][poBox]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][phone]    ${default.phone}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][cellPhone]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][description]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][comment]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][email]    None
    And Response body parameter should be:    [included][0][attributes][shippingAddress][country]    ${default.country}
    And Response body parameter should be:    [included][0][attributes][shippingAddress][iso2Code]    ${default.iso2Code}
    # #items
    And Response body parameter should be:    [included][0][attributes][items][0][name]    ${configurable_product.name}
    And Response body parameter should be:    [included][0][attributes][items][0][sku]    ${configurable_product.sku_1}
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumPrice]    0
    And Response body parameter should be:    [included][0][attributes][items][0][quantity]    1
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumGrossPrice]    0
    And Response body parameter should be:    [included][0][attributes][items][0][unitNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][items][0][sumNetPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitPrice]    0
    And Response body parameter should be:    [included][0][attributes][items][0][unitTaxAmountFullAggregation]    0
    And Response body parameter should be:    [included][0][attributes][items][0][sumTaxAmountFullAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][refundableAmount]    0
    And Response body parameter should be:    [included][0][attributes][items][0][canceledAmount]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumSubtotalAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitSubtotalAggregation]    0
    And Response body parameter should be:    [included][0][attributes][items][0][unitProductOptionPriceAggregation]    0
    And Response body parameter should be:    [included][0][attributes][items][0][sumProductOptionPriceAggregation]    0
    And Response body parameter should be:    [included][0][attributes][items][0][unitExpensePriceAggregation]    0
    And Response body parameter should be:    [included][0][attributes][items][0][sumExpensePriceAggregation]    None
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitDiscountAmountAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumDiscountAmountAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitDiscountAmountFullAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumDiscountAmountFullAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][unitPriceToPayAggregation]    0
    And Response body parameter should be greater than:    [included][0][attributes][items][0][sumPriceToPayAggregation]    0
    And Response body parameter should be:    [included][0][attributes][items][0][taxRateAverageAggregation]    0.00
    And Response body parameter should be:    [included][0][attributes][items][0][taxAmountAfterCancellation]    None
    And Response body parameter should be:    [included][0][attributes][items][0][orderReference]    None
    And Response body parameter should not be EMPTY:    [included][0][attributes][items][0][uuid]
    And Response body parameter should be:    [included][0][attributes][items][0][isReturnable]    False
    And Response body parameter should be greater than:    [included][0][attributes][items][0][idShipment]    0
    And Response body parameter should be:    [included][0][attributes][items][0][bundleItemIdentifier]    None
    And Response body parameter should be:    [included][0][attributes][items][0][relatedBundleItemIdentifier]    None
    And Response should contain the array of a certain size:    [included][0][attributes][items][0][metadata][superAttributes]    1
    And Response body parameter should not be EMPTY:    [included][0][attributes][items][0][metadata][image]
    And Response body parameter should be:    [included][0][attributes][items][0][salesOrderItemConfiguration][displayData]  {\"Preferred time of the day\":\"Afternoon\",\"Date\":\"09.09.2050\"}
    And Each array element of array in response should contain property:    [included][0][attributes][items]    calculatedDiscounts
    #expenses
    And Response body parameter should be:    [included][0][attributes][expenses][0][type]    SHIPMENT_EXPENSE_TYPE
    And Response body parameter should be:    [included][0][attributes][expenses][0][name]    ${shipment.method_name}
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][sumPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][unitGrossPrice]    0
    And Response body parameter should be greater than:    [included][0][attributes][expenses][0][sumGrossPrice]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][expenses][0][canceledAmount]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][unitDiscountAmountAggregation]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][sumDiscountAmountAggregation]    None
    And Response body parameter should be:    [included][0][attributes][expenses][0][taxAmountAfterCancellation]    None
    And Response body parameter should not be EMPTY:    [included][0][attributes][expenses][0][idShipment]
    And Response body parameter should not be EMPTY:   [included][0][attributes][expenses][0][idSalesExpense]
    #payments
    And Response body parameter should be greater than:    [included][0][attributes][payments][0][amount]    0
    And Response body parameter should be:    [included][0][attributes][payments][0][paymentProvider]    ${payment.provider_name}
    And Response body case-insensitive parameter should be:    [included][0][attributes][payments][0][paymentMethod]    ${payment.method_name}
    #shipments
    And Response body parameter should be:    [included][0][attributes][shipments][0][shipmentMethodName]    ${shipment.method_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be:    [included][0][attributes][shipments][0][deliveryTime]    None
    And Response body parameter should be greater than:    [included][0][attributes][shipments][0][defaultGrossPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][defaultNetPrice]    0
    And Response body parameter should be:    [included][0][attributes][shipments][0][currencyIsoCode]    ${currency.eur.code}
    #calculatedDiscounts
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    unitAmount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    sumAmount
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    displayName
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    description
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    voucherCode
    And Response body parameter should contain:    [included][0][attributes][calculatedDiscounts]    quantity
