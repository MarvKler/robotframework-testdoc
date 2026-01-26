*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    quotation-process    spryker-core    cart    acl    customer-account-management    customer-access    approval-process

*** Test Cases ***
#POST#
Create_quote_request
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    And Save value to a variable:    [data][id]    cart_id
    And I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity": 1}}}
    And I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_2}","quantity": 1}}}
    When I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    quote-requests
    And Response body parameter should not be EMPTY:    [data][id]
    And Save value to a variable:    [data][id]    quote_request_id
    And Response body parameter should contain:    [data][attributes]    quoteRequestReference
    And Response body parameter should contain:    [data][attributes]    status
    And Response body parameter should contain:    [data][attributes]    isLatestVersionVisible
    And Response body parameter should contain:    [data][attributes]    createdAt
    And Response body parameter should contain:    [data][attributes]    validUntil
    And Response body parameter should not be EMPTY:    [data][attributes][versions][0]
    And Response body parameter should contain:    [data][attributes][shownVersion]    version
    And Response body parameter should contain:    [data][attributes][shownVersion]    versionReference
    And Response body parameter should contain:    [data][attributes][shownVersion]    createdAt
    And Response body parameter should be:    [data][attributes][shownVersion][cart][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][currency]    ${currency.eur.code}
    And Response body parameter should not be EMPTY:    [data][attributes][shownVersion][cart][totals][expenseTotal]
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][totals]    discountTotal
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][totals][taxTotal]    tax_rate
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][taxTotal][amount]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][subtotal]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][grandTotal]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][priceToPay]    1
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    billingAddress
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0][groupKey]    ${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][1][groupKey]    ${concrete.available_product.with_stock_and_never_out_of_stock.sku_2}
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    productOfferReference
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    merchantReference
    And Response body parameter should be:    [data][attributes][shownVersion][cart][items][0][sku]    ${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][items][1][sku]    ${concrete.available_product.with_stock_and_never_out_of_stock.sku_2}
    And Each array element of array in response should contain nested property with value:    [data][attributes][shownVersion][cart][items]    quantity    1
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    quantity
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    abstractSku
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    amount
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    configuredBundle
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    configuredBundleItem
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    salesUnit
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    calculations
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    selectedProductOptions
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    discounts
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    shipments
    And Response body has correct self link for created entity:   ${quote_request_id}
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}
    ...    AND    Response status code should be:    204

Create_quote_request_with_included_customers_&_comapny_users_&_company_business_units_and_concrete_products
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    And Save value to a variable:    [data][id]    cart_id
    And I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity": 1}}}
    And I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_2}","quantity": 1}}}
    When I send a POST request:    /quote-requests?include=customers,company-users,company-business-units,concrete-products    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    quote-requests
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should contain:    [data][attributes]    quoteRequestReference
    And Response body parameter should contain:    [data][attributes]    status
    And Response body parameter should contain:    [data][attributes]    isLatestVersionVisible
    And Response body parameter should contain:    [data][attributes]    createdAt
    And Response body parameter should contain:    [data][attributes]    validUntil
    And Response body parameter should not be EMPTY:    [data][attributes][versions][0]
    And Response body parameter should contain:    [data][attributes][shownVersion]    version
    And Response body parameter should contain:    [data][attributes][shownVersion]    versionReference
    And Response body parameter should contain:    [data][attributes][shownVersion]    createdAt
    And Response body parameter should be:    [data][attributes][shownVersion][cart][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][currency]    ${currency.eur.code}
    And Response body parameter should not be EMPTY:    [data][attributes][shownVersion][cart][totals][expenseTotal]
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][totals]    discountTotal
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][totals][taxTotal]    tax_rate
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][taxTotal][amount]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][subtotal]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][grandTotal]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][priceToPay]    1
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    billingAddress
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    groupKey
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    productOfferReference
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    merchantReference
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    sku
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    quantity
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    abstractSku
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    amount
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    configuredBundle
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    configuredBundleItem
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    salesUnit
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    calculations
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    selectedProductOptions
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    discounts
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    shipments
    And Response should contain the array of a certain size:    [data][relationships]    4
    And Response should contain the array of a certain size:    [data][relationships][company-users][data]    1
    And Response should contain the array of a certain size:    [data][relationships][company-business-units][data]    1
    And Response should contain the array of a certain size:    [data][relationships][customers][data]    1
    And Response should contain the array larger than a certain size:    [data][relationships][concrete-products][data]    1
    And Each Array Element Of Array In Response Should Contain Property:    [included]    type
    And Each Array Element Of Array In Response Should Contain Property:    [included]    id
    And Each Array Element Of Array In Response Should Contain Property:    [included]    attributes
    And Each Array Element Of Array In Response Should Contain Property:    [included]    links
    And Response include should contain certain entity type:    company-business-units
    And Response include should contain certain entity type:    customers
    And Response include should contain certain entity type:    company-users
    And Response include should contain certain entity type:    concrete-products
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}
    ...    AND    Response status code should be:    204

Create_quote_request_without_delivery_date_and_note
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    And Save value to a variable:    [data][id]    cart_id
    And I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity": 1}}}
    And I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_2}","quantity": 1}}}
    When I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}"}}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    quote-requests
    And Response body parameter should not be EMPTY:    [data][id]
    And Save value to a variable:    [data][id]    quote_request_id
    And Response body parameter should contain:    [data][attributes]    quoteRequestReference
    And Response body parameter should contain:    [data][attributes]    status
    And Response body parameter should contain:    [data][attributes]    isLatestVersionVisible
    And Response body parameter should contain:    [data][attributes]    createdAt
    And Response body parameter should contain:    [data][attributes]    validUntil
    And Response body parameter should not be EMPTY:    [data][attributes][versions][0]
    And Response body parameter should contain:    [data][attributes][shownVersion]    version
    And Response body parameter should contain:    [data][attributes][shownVersion]    versionReference
    And Response body parameter should contain:    [data][attributes][shownVersion]    createdAt
    And Response body parameter should be:    [data][attributes][shownVersion][cart][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][currency]    ${currency.eur.code}
    And Response body parameter should not be EMPTY:    [data][attributes][shownVersion][cart][totals][expenseTotal]
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][totals]    discountTotal
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][totals][taxTotal]    tax_rate
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][taxTotal][amount]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][subtotal]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][grandTotal]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][priceToPay]    1
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    billingAddress
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0][groupKey]    ${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][1][groupKey]    ${concrete.available_product.with_stock_and_never_out_of_stock.sku_2}
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    productOfferReference
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    merchantReference
    And Response body parameter should be:    [data][attributes][shownVersion][cart][items][0][sku]    ${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][items][1][sku]    ${concrete.available_product.with_stock_and_never_out_of_stock.sku_2}
    And Each array element of array in response should contain nested property with value:    [data][attributes][shownVersion][cart][items]    quantity    1
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    quantity
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    abstractSku
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    amount
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    configuredBundle
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    configuredBundleItem
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    salesUnit
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    calculations
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    selectedProductOptions
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    discounts
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    shipments
    And Response body has correct self link for created entity:   ${quote_request_id}
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}
    ...    AND    Response status code should be:    204

Create_quote_request_with_empty_meta_data
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    And Save value to a variable:    [data][id]    cart_id
    And I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity": 1}}}
    And I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_2}","quantity": 1}}}
    When I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"","delivery_date":"","note":""}}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    quote-requests
    And Response body parameter should not be EMPTY:    [data][id]
    And Save value to a variable:    [data][id]    quote_request_id
    And Response body parameter should contain:    [data][attributes]    quoteRequestReference
    And Response body parameter should contain:    [data][attributes]    status
    And Response body parameter should contain:    [data][attributes]    isLatestVersionVisible
    And Response body parameter should contain:    [data][attributes]    createdAt
    And Response body parameter should contain:    [data][attributes]    validUntil
    And Response body parameter should not be EMPTY:    [data][attributes][versions][0]
    And Response body parameter should contain:    [data][attributes][shownVersion]    version
    And Response body parameter should contain:    [data][attributes][shownVersion]    versionReference
    And Response body parameter should contain:    [data][attributes][shownVersion]    createdAt
    And Response body parameter should be:    [data][attributes][shownVersion][cart][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][currency]    ${currency.eur.code}
    And Response body parameter should not be EMPTY:    [data][attributes][shownVersion][cart][totals][expenseTotal]
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][totals]    discountTotal
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][totals][taxTotal]    tax_rate
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][taxTotal][amount]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][subtotal]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][grandTotal]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][priceToPay]    1
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    billingAddress
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    groupKey
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    productOfferReference
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    merchantReference
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    sku
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    quantity
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    abstractSku
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    amount
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    configuredBundle
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    configuredBundleItem
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    salesUnit
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    calculations
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    selectedProductOptions
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    discounts
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    shipments
    And Response body has correct self link for created entity:   ${quote_request_id}
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}
    ...    AND    Response status code should be:    204

Create_quote_request_for_cart_with_full_access_permissions
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    Save value to a variable:    [data][attributes][accessToken]    userToken
    ...    AND    I set Headers:    Authorization=${token}  
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cartId
    ...    AND    I send a POST request:    /carts/${cartId}/items    {"data":{"type":"items","attributes":{"sku":"${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity":1}}}
    ...    AND    Response status code should be:    201
    ...    AND    I send a GET request:    /company-users
    ...    AND    Get company user id by customer reference:    ${yves_fifth_user.reference}
    ## Giving_full_cart_access_to_the_User_by_using_quote_request.cart_permission_id ##
    ...    AND    I send a POST request:    /carts/${cartId}/shared-carts    {"data":{"type":"shared-carts","attributes":{"idCompanyUser":"${companyUserId}","idCartPermissionGroup":${quote_request.cart_permission_id}}}}
    ...    AND    Save value to a variable:    [data][id]    shared_cart_id
    ...    AND    I get access token for the customer:    ${yves_fifth_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a GET request:    /carts/${shared_cart_id}?include=cart-permission-groups
    When I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    quote-requests
    And Response body parameter should not be EMPTY:    [data][id]
    And Save value to a variable:    [data][id]    quote_request_id
    And Response body parameter should contain:    [data][attributes]    quoteRequestReference
    And Response body parameter should contain:    [data][attributes]    status
    And Response body parameter should contain:    [data][attributes]    isLatestVersionVisible
    And Response body parameter should contain:    [data][attributes]    createdAt
    And Response body parameter should contain:    [data][attributes]    validUntil
    And Response body parameter should not be EMPTY:    [data][attributes][versions][0]
    And Response body parameter should contain:    [data][attributes][shownVersion]    version
    And Response body parameter should contain:    [data][attributes][shownVersion]    versionReference
    And Response body parameter should contain:    [data][attributes][shownVersion]    createdAt
    And Response body parameter should be:    [data][attributes][shownVersion][cart][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][currency]    ${currency.eur.code}
    And Response body parameter should not be EMPTY:    [data][attributes][shownVersion][cart][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][shownVersion][cart][totals][discountTotal]
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][totals][taxTotal]    tax_rate
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][taxTotal][amount]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][subtotal]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][grandTotal]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][priceToPay]    1
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    billingAddress
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    groupKey
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    productOfferReference
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    merchantReference
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    sku
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    quantity
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    abstractSku
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    amount
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    configuredBundle
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    configuredBundleItem
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    salesUnit
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    calculations
    And Each array element of array in response should contain property:    [data][attributes][shownVersion][cart][items]    selectedProductOptions
    And Response body has correct self link for created entity:   ${quote_request_id}
    [Teardown]    Run Keywords    I set Headers:    Authorization=Bearer ${userToken}
    ...    AND    I send a DELETE request:    /carts/${cartId}
    ...    AND    Response status code should be:    204
    ...    AND    Response reason should be:    No Content

# #GET#
Retrieves_quote_request_list_when_no_RFQ
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_sixth_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /quote-requests
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response should contain the array of a certain size:    [data]    0
    And Response body has correct self link

Retrieves_quote_request_list
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity": 1}}}
    ...    AND    I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    ...    AND    Response status code should be:    201
    When I send a GET request:    /quote-requests
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Each array element of array in response should contain nested property with value:    [data]    [type]    quote-requests
    And Each array element of array in response should contain property:    [data]    id
    And Each array element of array in response should contain property:    [data]    attributes
    And Each array element of array in response should contain nested property:    [data]    [attributes]    quoteRequestReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    status
    And Each array element of array in response should contain nested property:    [data]    [attributes]    quoteRequestReference
    And Each array element of array in response should contain nested property:    [data]    [attributes]    isLatestVersionVisible
    And Each array element of array in response should contain nested property:    [data]    [attributes]    createdAt
    And Each array element of array in response should contain nested property:    [data]    [attributes]    validUntil
    And Each array element of array in response should contain nested property:    [data]    [attributes]    versions
    And Each array element of array in response should contain nested property:    [data]    [attributes]    shownVersion
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion]    version
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion]    versionReference
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion]    createdAt
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion]    metadata
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion]    cart
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][shownVersion][cart][priceMode]    ${mode.gross}
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][shownVersion][cart][store]    ${store.de}
    And Each array element of array in response should contain nested property with value:    [data]    [attributes][shownVersion][cart][currency]    ${currency.eur.code}
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart][totals]    expenseTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart][totals]    discountTotal
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart][totals]    taxTotal
    And Each array element of array in response should be greater than:    [data]    [attributes][shownVersion][cart][totals][subtotal]    0
    And Each array element of array in response should be greater than:    [data]    [attributes][shownVersion][cart][totals][grandTotal]    0
    And Each array element of array in response should be greater than:    [data]    [attributes][shownVersion][cart][totals][priceToPay]    0
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart]    billingAddress
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart]    items
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart][items][0]    groupKey
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart][items][0]    productOfferReference
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart][items][0]    merchantReference
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart][items][0]    sku
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart][items][0]    quantity
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart][items][0]    abstractSku
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart][items][0]    amount
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart][items][0]    configuredBundle
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart][items][0]    configuredBundleItem
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart][items][0]    salesUnit
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart][items][0]    calculations
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart][items][0]    selectedProductOptions
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart]    discounts
    And Each array element of array in response should contain nested property:    [data]    [attributes][shownVersion][cart]    shipments
    And Each array element of array in response should contain property:    [data]    links
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}
    ...    AND    Response status code should be:    204

Retrieves_quote_request_by_requestId
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity": 1}}}
    ...    AND    I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    quoteRequestId
    When I send a GET request:    /quote-requests/${quoteRequestId}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    quote-requests
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should contain:    [data][attributes]    quoteRequestReference
    And Response body parameter should contain:    [data][attributes]    status
    And Response body parameter should contain:    [data][attributes]    isLatestVersionVisible
    And Response body parameter should contain:    [data][attributes]    createdAt
    And Response body parameter should contain:    [data][attributes]    validUntil
    And Response body parameter should not be EMPTY:    [data][attributes][versions][0]
    And Response body parameter should contain:    [data][attributes][shownVersion]    version
    And Response body parameter should contain:    [data][attributes][shownVersion]    versionReference
    And Response body parameter should contain:    [data][attributes][shownVersion]    createdAt
    And Response body parameter should be:    [data][attributes][shownVersion][cart][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][currency]    ${currency.eur.code}
    And Response body parameter should not be EMPTY:    [data][attributes][shownVersion][cart][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][shownVersion][cart][totals][discountTotal]
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][totals][taxTotal]    tax_rate
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][taxTotal][amount]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][subtotal]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][grandTotal]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][priceToPay]    1
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    billingAddress
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    groupKey
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    productOfferReference
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    merchantReference
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    sku
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    quantity
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    abstractSku
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    amount
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    configuredBundle
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    configuredBundleItem
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    salesUnit
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    calculations
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    selectedProductOptions
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    discounts
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    shipments
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}
    ...    AND    Response status code should be:    204

Retrieve_quote_request_version
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity": 1}}}
    ...    AND    I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    quoteRequestId
    ...    AND    Save value to a variable:    [data][attributes][shownVersion][versionReference]    quote_request_version
    When I send a GET request:    /quote-requests/${quoteRequestId}?quoteRequestVersionReference=${quote_request_version}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    quote-requests
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should contain:    [data][attributes]    quoteRequestReference
    And Response body parameter should contain:    [data][attributes]    status
    And Response body parameter should contain:    [data][attributes]    isLatestVersionVisible
    And Response body parameter should contain:    [data][attributes]    createdAt
    And Response body parameter should contain:    [data][attributes]    validUntil
    And Response body parameter should not be EMPTY:    [data][attributes][versions][0]
    And Response body parameter should contain:    [data][attributes][shownVersion]    version
    And Response body parameter should contain:    [data][attributes][shownVersion]    versionReference
    And Response body parameter should contain:    [data][attributes][shownVersion]    createdAt
    And Response body parameter should be:    [data][attributes][shownVersion][cart][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][currency]    ${currency.eur.code}
    And Response body parameter should not be EMPTY:    [data][attributes][shownVersion][cart][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][shownVersion][cart][totals][discountTotal]
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][totals][taxTotal]    tax_rate
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][taxTotal][amount]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][subtotal]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][grandTotal]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][priceToPay]    1
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    billingAddress
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    groupKey
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    productOfferReference
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    merchantReference
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    sku
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    quantity
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    abstractSku
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    amount
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    configuredBundle
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    configuredBundleItem
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    salesUnit
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    calculations
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    selectedProductOptions
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    discounts
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    shipments
    And Response body has correct self link internal
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}
    ...    AND    Response status code should be:    204


#PATCH#
Update_quote_request
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...    AND    I set Headers:    Authorization=${token}
    ...    AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...    AND    Save value to a variable:    [data][id]    cart_id
    ...    AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete.available_product.with_stock_and_never_out_of_stock.sku_1}","quantity": 1}}}
    ...    AND    I send a POST request:    /quote-requests    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"purchase_order_number":"${quote_request.purchase_order_number}","delivery_date":"${quote_request.delivery_date}","note":"${quote_request.note}"}}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [data][id]    quoteRequestId
    When I send a PATCH request:    /quote-requests/${quoteRequestId}    {"data":{"type":"quote-requests","attributes":{"cartUuid":"${cart_id}","meta":{"note":"Test1"}}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][type]    quote-requests
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should contain:    [data][attributes]    quoteRequestReference
    And Response body parameter should contain:    [data][attributes]    status
    And Response body parameter should contain:    [data][attributes]    isLatestVersionVisible
    And Response body parameter should contain:    [data][attributes]    createdAt
    And Response body parameter should contain:    [data][attributes]    validUntil
    And Response body parameter should not be EMPTY:    [data][attributes][versions][0]
    And Response body parameter should contain:    [data][attributes][shownVersion]    version
    And Response body parameter should contain:    [data][attributes][shownVersion]    versionReference
    And Response body parameter should contain:    [data][attributes][shownVersion]    createdAt
    And Response body parameter should be:    [data][attributes][shownVersion][cart][priceMode]    ${mode.gross}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][store]    ${store.de}
    And Response body parameter should be:    [data][attributes][shownVersion][cart][currency]    ${currency.eur.code}
    And Response body parameter should not be EMPTY:    [data][attributes][shownVersion][cart][totals][expenseTotal]
    And Response body parameter should not be EMPTY:    [data][attributes][shownVersion][cart][totals][discountTotal]
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][totals][taxTotal]    tax_rate
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][taxTotal][amount]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][subtotal]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][grandTotal]    1
    And Response body parameter should be greater than:    [data][attributes][shownVersion][cart][totals][priceToPay]    1
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    billingAddress
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    groupKey
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    productOfferReference
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    merchantReference
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    sku
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    quantity
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    abstractSku
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    amount
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    configuredBundle
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    configuredBundleItem
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    salesUnit
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    calculations
    And Response body parameter should contain:    [data][attributes][shownVersion][cart][items][0]    selectedProductOptions
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    discounts
    And Response body parameter should contain:    [data][attributes][shownVersion][cart]    shipments
    [Teardown]    Run Keywords    I send a DELETE request:     /carts/${cart_id}
    ...    AND    Response status code should be:    204