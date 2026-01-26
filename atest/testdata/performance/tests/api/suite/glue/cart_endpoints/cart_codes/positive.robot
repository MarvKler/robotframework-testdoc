*** Settings ***
Suite Setup    API_suite_setup
Test Setup    API_test_setup
Test Tags    glue    cart    gift-cards    spryker-core    customer-access    acl    promotions-discounts    marketplace-promotions-discounts    prices
Resource    ../../../../../../resources/common/common_api.robot

*** Test Cases ***
Add_gift_card_code_to_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Create giftcode in Database:    normal_${random}    ${gift_card.amount}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items   {"data": {"type": "items","attributes": {"sku": "${concrete_available_product.with_label}","quantity": 1}}}
    When I send a POST request:    /carts/${cart_id}/cart-codes?include=gift-cards    {"data": {"type": "cart-codes","attributes": {"code": "normal_${random}"}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should not be EMPTY:    [data][id] 
    And Response body parameter should be:    [data][attributes][priceMode]   GROSS_MODE
    And Response body parameter should be:    [data][attributes][currency]     EUR
    And Response body parameter should be:    [data][attributes][store]     DE
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    And Response body parameter should be:    [data][attributes][isDefault]     True
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    0
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][0][displayName]
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][0][amount]
    And Response body parameter should not be EMPTY:    [data][attributes][thresholds][0][type]
    And Response body parameter should not be EMPTY:    [data][attributes][thresholds][0][threshold]
    And Response body parameter should not be EMPTY:    [data][attributes][thresholds][0][fee]
    And Response body parameter should not be EMPTY:    [data][attributes][thresholds][0][deltaWithSubtotal]
    And Response body parameter should not be EMPTY:    [data][attributes][thresholds][0][message]
    And Response body parameter should be:    [data][attributes][discounts][0][code]  None
    And Response body parameter should not be EMPTY:    [data][id]
    And Response include should contain certain entity type:    gift-cards
    And Response include element has self link:   gift-cards
    And Response body parameter should be:    [data][relationships][gift-cards] [data][0][type]    gift-cards
    And Response body parameter should not be EMPTY:   [data][relationships][gift-cards][data][0][id]
    And Response body parameter should be:    [included][0][type]    gift-cards
    And Response body parameter should not be EMPTY:   [included][0][id]
    And Response body parameter should not be EMPTY:   [included][0][attributes][code]
    And Response body parameter should not be EMPTY:   [included][0][attributes][name]
    And Response body parameter should be:   [included][0][attributes][value]    ${gift_card.amount}
    And Response body parameter should be:   [included][0][attributes][currencyIsoCode]    EUR
    And Response body parameter should be:   [included][0][attributes][actualValue]    ${gift_card.amount}
    And Response body parameter should be:    [included][0][attributes][isActive]     True
    And Response include should contain certain entity type:    gift-cards
    And Response include element has self link:   gift-cards
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...    AND    Response status code should be:    204
    
Delete_gift_card_from_cart
     [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Create giftcode in Database:    delete_${random}    ${gift_card.amount}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cart_id
    ...  AND    I send a POST request:    /carts/${cart_id}/items    {"data": {"type": "items","attributes": {"sku": "${concrete_available_product.with_label}","quantity": 1}}}
    ...  AND    I send a POST request:    /carts/${cart_id}/cart-codes?include=gift-cards   {"data": {"type": "cart-codes","attributes": {"code": "delete_${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [included][0][id]    cart_code_id
    When I send a DELETE request:    /carts/${cart_id}/cart-codes/${cart_code_id}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    [Teardown]    Run Keywords    I send a DELETE request:    /carts/${cart_id}
    ...   AND    Response status code should be:    204

Add_gift_card_code_to_the_guest_cart
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}   ${concrete_available_product.with_label}    1
    ...    AND    Save value to a variable:    [data][id]    guestcart_id
    ...    AND    Create giftcode in Database:    guest_${random}    ${gift_card.amount}
    When I send a POST request:    /guest-carts/${guestcart_id}/cart-codes?include=gift-cards     {"data": {"type": "cart-codes","attributes": {"code": "guest_${random}"}}}
    Then Response status code should be:    201
    And Response body parameter should be:    [data][type]    guest-carts
    And Response body parameter should not be EMPTY:    [data][id] 
    And Response body parameter should be:    [data][attributes][priceMode]   GROSS_MODE
    And Response body parameter should be:    [data][attributes][currency]     EUR
    And Response body parameter should be:    [data][attributes][store]     DE
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    And Response body parameter should be:    [data][attributes][isDefault]     True
    And Response body parameter should be:    [data][attributes][totals][expenseTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][discountTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][taxTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][subtotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][grandTotal]    0
    And Response body parameter should be greater than:    [data][attributes][totals][priceToPay]    0
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][0][displayName]
    And Response body parameter should not be EMPTY:    [data][attributes][discounts][0][amount]
    And Response body parameter should be:    [data][attributes][discounts][0][code]    None
    And Response body parameter should be:    [data][relationships][gift-cards] [data][0][type]    gift-cards
    And Response body parameter should not be EMPTY:   [data][relationships][gift-cards][data][0][id]
    And Response include should contain certain entity type:    gift-cards
    And Response include element has self link:   gift-cards
    And Response body parameter should not be EMPTY:   [included][0][attributes][code]
    And Response body parameter should not be EMPTY:   [included][0][attributes][name]
    And Response body parameter should be:   [included][0][attributes][value]    ${gift_card.amount}
    And Response body parameter should be:   [included][0][attributes][currencyIsoCode]    EUR
    And Response body parameter should be:   [included][0][attributes][actualValue]    ${gift_card.amount}
    And Response body parameter should be:    [included][0][attributes][isActive]     True
    And Response include should contain certain entity type:    gift-cards
    And Response include element has self link:   gift-cards

Delete_gift_card_code_from_the_guest_cart
    [Setup]    I set Headers:    Content-Type=${default_header_content_type}    X-Anonymous-Customer-Unique-Id=${random}
    Run Keywords    Create a guest cart:    ${random}   ${concrete_available_product.with_label}    1
    ...    AND    Save value to a variable:    [data][id]    guestcart_id
    ...    AND    Create giftcode in Database:    delete_guest_${random}    ${gift_card.amount}
    ...    AND    I send a POST request:    /guest-carts/${guestcart_id}/cart-codes?include=gift-cards    {"data": {"type": "cart-codes","attributes": {"code": "delete_guest_${random}"}}}
    ...    AND    Response status code should be:    201
    ...    AND    Save value to a variable:    [included][0][id]    cart_code_id
    When I send a DELETE request:    /guest-carts/${guestcart_id}/cart-codes/${cart_code_id}
    Then Response status code should be:    204
    And Response reason should be:    No Content

Add_gift_card_code_to_empty_cart
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_second_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    Create giftcode in Database:    empty_${random}    ${gift_card.amount}
    ...  AND    I send a POST request:    /carts    {"data":{"type":"carts","attributes":{"priceMode":"${mode.gross}","currency":"${currency.eur.code}","store":"${store.de}","name": "${test_cart_name}-${random}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    cart_id
    When I send a POST request:    /carts/${cart_id}/cart-codes  {"data": {"type": "cart-codes","attributes": {"code": "empty_${random}"}}}
    And Response status code should be:    201
    And Response body parameter should be:    [data][type]    carts
    And Response body parameter should not be EMPTY:    [data][id]
    And Response body parameter should not be EMPTY:    [data][id] 
    And Response body parameter should be:    [data][attributes][priceMode]   GROSS_MODE
    And Response body parameter should be:    [data][attributes][currency]     EUR
    And Response body parameter should be:    [data][attributes][store]     DE
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    And Response body parameter should be:    [data][attributes][isDefault]     True
    And Response body parameter should not be EMPTY:    [data][attributes][totals][expenseTotal]    
    And Response body parameter should not be EMPTY:    [data][attributes][totals][discountTotal]    
    And Response body parameter should not be EMPTY:    [data][attributes][totals][taxTotal]    
    And Response body parameter should not be EMPTY:    [data][attributes][totals][subtotal]    
    And Response body parameter should not be EMPTY:    [data][attributes][totals][grandTotal]    
    And Response body parameter should not be EMPTY:    [data][attributes][totals][priceToPay]    
    And Response body parameter should not be EMPTY:    [data][links][self]