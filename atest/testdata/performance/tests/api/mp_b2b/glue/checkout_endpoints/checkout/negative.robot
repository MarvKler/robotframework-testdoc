*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    cart    checkout    shipment    marketplace-shipment    order-management    configurable-bundle    promotions-discounts    marketplace-promotions-discounts    gift-cards    configurable-product    spryker-core

*** Test Cases ***
#POST requests
Create_order_with_invalid_access_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    ...  AND    I set Headers:    Authorization=fake_token
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    401
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.
    And Response should return error code:    001
    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...  AND    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_without_access_token
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    ...  AND    I set Headers:    Authorization=
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error message:    Missing access token.
    And Response should return error code:    002
    [Teardown]    Run Keywords    I set Headers:    Authorization=${token}
    ...  AND    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_invalid_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    When I send a POST request:    /checkout    {"data": {"type": "fake_type","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_empty_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    When I send a POST request:    /checkout    {"data": {"type": "","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Invalid type.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_without_type
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    When I send a POST request:    /checkout    {"data": {"attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Post data is invalid.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_invalid_email
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "fake_email","salutation": "Freulein","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    customer.email => Email is invalid.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_invalid_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "fake_cart_id","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    1103
    And Response should return error message:    Cart not found.

Create_order_with_cart_id_from_another_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Save value to a variable:    [data][attributes][accessToken]    first_user_token
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    ...  AND    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    1103
    And Response should return error message:    Cart not found.
    [Teardown]    Run Keywords    I set Headers:    Authorization=Bearer ${first_user_token}
    ...  AND    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_empty_customer_attributes_and_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "","salutation": "","firstName": "","lastName": ""},"idCart": "","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Array in response should contain property with value:    [errors]    detail    idCart => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    customer.salutation => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    customer.email => Email is invalid.

Create_order_without_customer_attributes_and_cart_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {},"billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Array in response should contain property with value:    [errors]    detail    idCart => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    customer.salutation => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    customer.email => This field is missing.

Create_order_with_invalid_billing_address_data
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "fake_salutation","firstName": "fake_first_name","lastName": "fake_last_name","address1": "fake_address1","address2": "fake_address2","address3": "fake_address3","zipCode": "fake_zipCode","city": "fake_city","iso2Code": "fake_iso2Code","company": "fake_company","phone": "fake_phone","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    1102
    And Response should return error message:    Billing address country not found for country code: fake_iso2Code
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_empty_billing_address_data
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "","firstName": "","lastName": "","address1": "","address2": "","address3": "","zipCode": "","city": "","iso2Code": "","company": "","phone": "","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Array in response should contain property with value:    [errors]    detail    billingAddress.salutation => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.firstName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.lastName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.address1 => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.address2 => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.zipCode => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.city => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.city => This value is too short. It should have 3 characters or more.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.iso2Code => This value should not be blank.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_without_billing_address_data
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Array in response should contain property with value:    [errors]    detail    billingAddress.salutation => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.firstName => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.lastName => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.address1 => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.address2 => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.zipCode => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.city => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    billingAddress.iso2Code => This field is missing.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_invalid_shipping_address_data
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    ...  AND    I send a GET request:    /carts/${cartId}/?include=items
    ...  AND    Save value to a variable:    [included][0][id]    item_group_key
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shipments": [{"requestedDeliveryDate": "2021-09-29", "idShipmentMethod": 1, "items": ["${itemGroupKey}"], "shippingAddress": {"salutation": "fake_salutation","firstName": "fake_first_name","lastName": "fake_last_name","address1": "fake_address1","address2": "fake_address2","address3": "fake_address3","zipCode": "fake_zipCode","city": "fake_city","iso2Code": "fake_iso2Code","company": "fake_company","phone": "fake_phone","isDefaultBilling": false,"isDefaultShipping": false}}],"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    1102
    And Response should return error message:    Shipping address country not found for country code: fake_iso2Code
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_empty_shipping_address_data
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "","firstName": "","lastName": "","address1": "","address2": "","address3": "","zipCode": "","city": "","iso2Code": "","company": "","phone": "","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.salutation => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.firstName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.lastName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.address1 => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.address2 => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.zipCode => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.city => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.city => This value is too short. It should have 3 characters or more.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.iso2Code => This value should not be blank.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_without_shipping_address_data
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.salutation => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.firstName => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.lastName => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.address1 => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.address2 => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.zipCode => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.city => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    shippingAddress.iso2Code => This field is missing.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_invalid_payments
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "fake_provider_name","paymentMethodName": "fake_payment.method_name","paymentSelection": "fake_payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    1102
    And Response should return error message:    Checkout payment is not valid
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_empty_payments
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "","paymentMethodName": "","paymentSelection": ""}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Array in response should contain property with value:    [errors]    detail    payments.0.paymentMethodName => This value should not be blank.
    And Array in response should contain property with value:    [errors]    detail    payments.0.paymentProviderName => This value should not be blank.
    And Response should return error message:    payments.0.paymentMethodName => This value should not be blank.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_without_payments
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{}],"shipment": {"idShipmentMethod": 1},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Array in response should contain property with value:    [errors]    detail    payments.0.paymentMethodName => This field is missing.
    And Array in response should contain property with value:    [errors]    detail    payments.0.paymentProviderName => This field is missing.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_invalid_shipment_method_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 0},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    Shipment method not found.
    And Response should return error code:    1102
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_without_shipment_method_id
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {},"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error message:    shipment.idShipmentMethod => This field is missing.
    And Response should return error code:    901
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_empty_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": []}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    1104
    And Response should return error message:    Cart is empty.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_lower_order_total_price_than_threshold_limit
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_product_with_threshold_limit}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    ...  AND    Response status code should be:    201
    When I send a POST request:    /checkout    {"data": {"type": "checkout","attributes": {"customer": {"email": "${yves_user.email}","salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentProviderName": "${payment.provider_name}","paymentMethodName": "${payment.method_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 1},"items": ["${concrete_product_with_threshold_limit}"]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    1102
    And Response should return error message:    "You should add items for €40.00 to pass a recommended threshold. You cant proceed with checkout"
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_regular_shipment_&_split_shipments
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user.salutation}","email": "${yves_user.email}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentMethodName": "${payment.method_name}","paymentProviderName": "${payment.provider_name}","paymentSelection": "${payment.selection_name}"}],"shipment": {"idShipmentMethod": 0},"shipments": [{"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 2,"requestedDeliveryDate": null},{"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${changed.address1}","address2": "${changed.address2}","address3": "${changed.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${changed.phone}","isDefaultBilling": false,"isDefaultShipping": false},"idShipmentMethod": 4,"requestedDeliveryDate": null}]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4301
    And Response should return error message:    Single and multiple shipments attributes are not allowed in the same request.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_split_shipments_&_invalid_delivery_date
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user.salutation}","email": "${yves_user.email}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentMethodName": "${payment.method_name}","paymentProviderName": "${payment.provider_name}","paymentSelection": "${payment.selection_name}"}],"shipments": [{"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 2,"requestedDeliveryDate": "None"},{"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${changed.address1}","address2": "${changed.address2}","address3": "${changed.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${changed.phone}","isDefaultBilling": false,"isDefaultShipping": false},"idShipmentMethod": 4,"requestedDeliveryDate": "None"}]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Each array element of array in response should contain property with value:    [errors]    code    901
    And Each array element of array in response should contain property with value:    [errors]    status    ${422}
    And Array in response should contain property with value:    [errors]    detail    shipments.0.requestedDeliveryDate => This value is not a valid date.
    And Array in response should contain property with value:    [errors]    detail    shipments.1.requestedDeliveryDate => This value is not a valid date.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_split_shipments_&_invalid_shipping_address
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    ...  AND    I send a POST request:    /carts/${cartId}/items    {"data": {"type": "items","attributes": {"sku": "${abstract_product.product_with_options.concrete_sku}","quantity": 1, "merchantReference" : "${merchants.merchant_spryker_id}"}}}
    ...  AND    I send a GET request:    /carts/${cartId}/?include=items
    ...  AND    Save value to a variable:    [included][0][id]    first_item_group_key
    ...  AND    Save value to a variable:    [included][1][id]    second_item_group_key
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user.salutation}","email": "${yves_user.email}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentMethodName": "${payment.method_name}","paymentProviderName": "${payment.provider_name}","paymentSelection": "${payment.selection_name}"}],"shipments": [{"items": ["${firstItemGroupKey}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 2,"requestedDeliveryDate": "${shipment.delivery_date}"},{"items": ["${secondItemGroupKey}"],"shippingAddress": {"salutation": "fake_salutation","firstName": "fake_first_name","lastName": "fake_last_name","address1": "fake_address1","address2": "fake_address2","address3": "fake_address3","zipCode": "fake_zipCode","city": "fake_city","iso2Code": "fake_iso2Code","company": "fake_company","phone": "fake_phone","isDefaultBilling": false,"isDefaultShipping": false},"idShipmentMethod": 4,"requestedDeliveryDate": null}]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    1102
    And Response should return error message:    Shipping address country not found for country code: fake_iso2Code
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_split_shipments_&_empty_shipping_address
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user.salutation}","email": "${yves_user.email}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentMethodName": "${payment.method_name}","paymentProviderName": "${payment.provider_name}","paymentSelection": "${payment.selection_name}"}],"shipments": [{"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 2,"requestedDeliveryDate": "${shipment.delivery_date}"},{"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"],"shippingAddress": {"salutation": "","firstName": "","lastName": "","address1": "","address2": "","address3": "","zipCode": "","city": "","iso2Code": "","company": "","phone": "","isDefaultBilling": false,"isDefaultShipping": false},"idShipmentMethod": 4,"requestedDeliveryDate": null}]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    4302
    And Response should return error message:    Provided address is not valid. You can either provide address ID or address fields.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204

Create_order_with_split_shipments_&_without_shipping_address
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /carts    {"data": {"type": "carts","attributes": {"priceMode": "${mode.gross}","currency": "${currency.eur.code}","store": "${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Save value to a variable:    [data][id]    cart_id
    When I send a POST request:    /checkout?include=orders    {"data": {"type": "checkout","attributes": {"customer": {"salutation": "${yves_user.salutation}","email": "${yves_user.email}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}"},"idCart": "${cart_id}","billingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}","isDefaultBilling": false,"isDefaultShipping": false},"payments": [{"paymentMethodName": "${payment.method_name}","paymentProviderName": "${payment.provider_name}","paymentSelection": "${payment.selection_name}"}],"shipments": [{"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"],"shippingAddress": {"salutation": "${yves_user.salutation}","firstName": "${yves_user.first_name}","lastName": "${yves_user.last_name}","address1": "${default.address1}","address2": "${default.address2}","address3": "${default.address3}","zipCode": "${default.zipCode}","city": "${default.city}","iso2Code": "${default.iso2Code}","company": "${default.company}","phone": "${default.phone}"},"idShipmentMethod": 2,"requestedDeliveryDate": "${shipment.delivery_date}"},{"items": ["${abstract_product.product_availability.concrete_available_with_stock_and_never_out_of_stock}"],"shippingAddress": {},"idShipmentMethod": 4,"requestedDeliveryDate": null}]}}}
    Then Response status code should be:    ${422}
    And Response reason should be:    Unprocessable Content
    And Response should return error code:    901
    And Response should return error message:    shipments.1.shippingAddress => This value should not be blank.
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...  AND    Response status code should be:    204
