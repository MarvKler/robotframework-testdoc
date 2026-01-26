*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    cart    checkout    payments    shipment    spryker-core

*** Test Cases ***
#POST requests

Provide_checkout_data
    [Documentation]    Created a new bug https://spryker.atlassian.net/browse/CC-23077 (not a bug, changed bihavior https://docs.spryker.com/docs/pbc/all/carrier-management/202212.0/manage-via-glue-api/retrieve-shipments-and-shipment-methods-when-submitting-checkout-data.html#response)
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...  AND    Save value to a variable:    [included][0][id]    checkout_item_1
    When I send a POST request:    /checkout-data?include=shipments   {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName":"${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress":{"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipments": [{"items": ["${checkout_item_1}"],"shippingAddress": {"id": "null","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode":"${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 1,"requestedDeliveryDate": "2021-09-29"}]}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    checkout-data
    And Response body parameter should be:    [data][id]    None
    And Response should contain the array of a certain size:    [data][attributes][addresses]    0
    And Response should contain the array of a certain size:    [data][attributes][paymentProviders]    0
    And Response should contain the array of a certain size:    [data][attributes][shipmentMethods]    0
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][id]    1
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][name]    ${shipment.method_name}
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be greater than:    [included][0][attributes][selectedShipmentMethod][price]    0
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][taxRate]    ${tax_rate}
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][deliveryTime]    None
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][currencyIsoCode]    ${currency.eur.code}
    And Response should contain the array of a certain size:    [data][attributes][selectedPaymentMethods]    0
    And Response body has correct self link internal

Provide_checkout_with_only_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data", "attributes": {"idCart": "${cart_id}","payments": []}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    checkout-data
    And Response body parameter should be:    [data][id]    None
    And Response should contain the array of a certain size:    [data][attributes][addresses]    0
    And Response should contain the array of a certain size:    [data][attributes][paymentProviders]    0
    And Response should contain the array of a certain size:    [data][attributes][shipmentMethods]    0
    And Response should contain the array of a certain size:    [data][attributes][selectedShipmentMethods]    0
    And Response should contain the array of a certain size:    [data][attributes][selectedPaymentMethods]    0
    And Response body has correct self link internal


Provide_checkout_data_with_invalid_billing_address_data
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...  AND    Save value to a variable:    [included][0][id]    checkout_item_1
    When I send a POST request:    /checkout-data?include=shipments    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName":"${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress":{"salutation": "fake_salutation","firstName": "fake_first_name","lastName": "fale_last_name","address1": "fake_address1","address2": "fale_address2","address3": "fake_address3","zipCode": "fake_zipCode","city": "fake_city","iso2Code": "fake_isoCode","company": "fake_company","phone": "fake_phone","isDefaultBilling": true,"isDefaultShipping": true},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipments": [{"items": ["${checkout_item_1}"],"shippingAddress": {"id": "null","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode":"${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 1,"requestedDeliveryDate": "2021-09-29"}]}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    checkout-data
    And Response body parameter should be:    [data][id]    None
    And Response should contain the array of a certain size:    [data][attributes][addresses]    0
    And Response should contain the array of a certain size:    [data][attributes][paymentProviders]    0
    And Response should contain the array of a certain size:    [data][attributes][shipmentMethods]    0
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][id]    1
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][name]    ${shipment.method_name}
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be greater than:    [included][0][attributes][selectedShipmentMethod][price]    0
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][taxRate]    ${tax_rate}
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][deliveryTime]    None
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][currencyIsoCode]    ${currency.eur.code}
    And Response should contain the array of a certain size:    [data][attributes][selectedPaymentMethods]    0
    And Response body has correct self link internal

Provide_checkout_data_with_invalid_shipping_address_data
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...  AND    Save value to a variable:    [included][0][id]    checkout_item_1
    When I send a POST request:    /checkout-data?include=shipments     {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName":"${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress":{"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipments": [{"items": ["${checkout_item_1}"],"shippingAddress": {"id": "null","salutation": "fake_salutation","firstName": "fake_first_name","lastName": "fake_last_name","address1": "fake_address1","address2": "fake_address2","address3": "fake_address3","zipCode":"fake_zipcode","city": "fake_city","iso2Code": "fake_iso2code","company": "fake_company","phone": "fake_phone"},"idShipmentMethod": 1,"requestedDeliveryDate": "2021-09-29"}]}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    checkout-data
    And Response body parameter should be:    [data][id]    None
    And Response should contain the array of a certain size:    [data][attributes][addresses]    0
    And Response should contain the array of a certain size:    [data][attributes][paymentProviders]    0
    And Response should contain the array of a certain size:    [data][attributes][shipmentMethods]    0
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][id]    1
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][name]    ${shipment.method_name}
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be greater than:    [included][0][attributes][selectedShipmentMethod][price]    0
    And Response body parameter should be in:    [included][0][attributes][selectedShipmentMethod][taxRate]    ${tax_rate}    ${tax_rate1}
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][deliveryTime]    None
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][currencyIsoCode]    ${currency.eur.code}
    And Response should contain the array of a certain size:    [data][attributes][selectedPaymentMethods]    0
    And Response body has correct self link internal



Provide_checkout_data_with_invalid_payments
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items?include=items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    ...  AND    Save value to a variable:    [included][0][id]    checkout_item_1
    When I send a POST request:    /checkout-data?include=shipments    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName":"${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress":{"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"payments": [{"paymentProviderName": "fake_provider_name","paymentMethodName": "fake_provider_method"}],"shipments": [{"items": ["${checkout_item_1}"],"shippingAddress": {"id": "null","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode":"${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 1,"requestedDeliveryDate": "2021-09-29"}]}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    checkout-data
    And Response body parameter should be:    [data][id]    None
    And Response should contain the array of a certain size:    [data][attributes][addresses]    0
    And Response should contain the array of a certain size:    [data][attributes][paymentProviders]    0
    And Response should contain the array of a certain size:    [data][attributes][shipmentMethods]    0
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][id]    1
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][name]    ${shipment.method_name}
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be greater than:    [included][0][attributes][selectedShipmentMethod][price]    0
    And Response body parameter should be in:    [included][0][attributes][selectedShipmentMethod][taxRate]    ${tax_rate}    ${tax_rate1}
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][deliveryTime]    None
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][currencyIsoCode]    ${currency.eur.code}
    And Response should contain the array of a certain size:    [data][attributes][selectedPaymentMethods]    0
    And Response body has correct self link internal



Provide_checkout_data_with_invalid_shipment_method_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}","quantity": 1}}}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 0},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"]}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    checkout-data
    And Response body parameter should be:    [data][id]    None
    And Response should contain the array of a certain size:    [data][attributes][addresses]    0
    And Response should contain the array of a certain size:    [data][attributes][paymentProviders]    0
    And Response should contain the array of a certain size:    [data][attributes][shipmentMethods]    0
    And Response should contain the array of a certain size:    [data][attributes][selectedShipmentMethods]    0
    And Response should contain the array of a certain size:    [data][attributes][selectedPaymentMethods]    0
    And Response body has correct self link internal


Provide_checkout_data_with_empty_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    When I send a POST request:    /checkout-data    {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${product_availability.concrete_available_with_stock_and_never_out_of_stock_sku}"]}}}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    checkout-data
    And Response body parameter should be:    [data][id]    None
    And Response should contain the array of a certain size:    [data][attributes][addresses]    0
    And Response should contain the array of a certain size:    [data][attributes][paymentProviders]    0
    And Response should contain the array of a certain size:    [data][attributes][shipmentMethods]    0
    And Response should contain the array of a certain size:    [data][attributes][selectedShipmentMethods]    0
    And Response should contain the array of a certain size:    [data][attributes][selectedPaymentMethods]    0
    And Response body has correct self link internal


Provide_checkout_data_with_bundle_product
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Find or create customer cart
    ...  AND    Cleanup all items in the cart:    ${cart_id}
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${bundle_product.concrete_sku}","quantity": 1}}}
    When I send a POST request:    /checkout-data?include=shipments   {"data": {"type": "checkout-data","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName":"${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress":{"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": true,"isDefaultShipping": true},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}"}],"shipments": [{"items": ["${bundle_product.concrete_sku}"],"shippingAddress": {"id": "null","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode":"${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 1,"requestedDeliveryDate": "2021-09-29"}]}}}    
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][type]    checkout-data
    And Response body parameter should be:    [data][id]    None
    And Response should contain the array of a certain size:    [data][attributes][addresses]    0
    And Response should contain the array of a certain size:    [data][attributes][paymentProviders]    0
    And Response should contain the array of a certain size:    [data][attributes][shipmentMethods]    0
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][id]    1
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][name]    ${shipment.method_name}
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][carrierName]    ${shipment.carrier_name}
    And Response body parameter should be greater than:    [included][0][attributes][selectedShipmentMethod][price]    0
    And Response body parameter should be in:    [included][0][attributes][selectedShipmentMethod][taxRate]    ${tax_rate}    ${tax_rate1}
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][deliveryTime]    None
    And Response body parameter should be:    [included][0][attributes][selectedShipmentMethod][currencyIsoCode]    ${currency.eur.code}
    And Response should contain the array of a certain size:    [data][attributes][selectedPaymentMethods]    0
    And Response body has correct self link internal
