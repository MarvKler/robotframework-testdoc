*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Test Tags    glue    product    marketplace-product-offer    product-offer-shipment    marketplace-product-offer-prices    prices    marketplace-product    merchant    marketplace-merchant

*** Test Cases ***
Get_concrete_product_without_offers
    When I send a GET request:    /concrete-products/${bundle_product.concrete.sku}/product-offers
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    0

Get_all_concrete_product_offer_info_with_product_offer_prices_and_product_offer_availabilities_and_merchants_included
    When I send a GET request:    /concrete-products/${abstract_product.product_with_volume_prices.concrete_sku}/product-offers?include=product-offer-prices,product-offer-availabilities,merchants
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][0][id]    ${second_offer_with_volume_price}
    And Response body parameter should be:    [data][0][type]    product-offers
    And Response body parameter should be in:    [data][0][attributes][isDefault]    True    False
    And Response body parameter should be:    [data][0][attributes][merchantReference]    ${merchants.merchant_office_king_id}
    And Response body parameter should not be EMPTY:    [data][0][links][self]
    And Response body parameter should contain:    [data][0][attributes]    merchantSku
    And Response should contain the array of a certain size:    [included]    6
    And Response should contain the array of a certain size:    [data][0][relationships]    3
    And Response include should contain certain entity type:    product-offer-prices
    And Response include should contain certain entity type:    product-offer-availabilities
    And Response include should contain certain entity type:    merchants
    And Response include element has self link:    product-offer-prices
    And Response include element has self link:    product-offer-availabilities
    And Response include element has self link:    merchants
    And Response body has correct self link

Get_all_product_offer_info_with_product_offer_prices_and_product_offer_availabilities_and_merchants_included
    When I send a GET request:    /product-offers/${active_offer_with_merchant_sku}?include=product-offer-prices,product-offer-availabilities,merchants
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${active_offer_with_merchant_sku}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response body parameter should be:    [data][attributes][merchantReference]    ${merchants.merchant_office_king_id}
    And Response body parameter should not be EMPTY:    [data][links][self]
    And Response body parameter should not be EMPTY:    [data][attributes][merchantSku]
    And Response should contain the array of a certain size:    [included]    3
    And Response should contain the array of a certain size:    [data][relationships]    3
    And Response include should contain certain entity type:    product-offer-prices
    And Response include should contain certain entity type:    product-offer-availabilities
    And Response include should contain certain entity type:    merchants
    And Response include element has self link:    product-offer-prices
    And Response include element has self link:    product-offer-availabilities
    And Response include element has self link:    merchants

Get_product_offer_without_volume_prices
    When I send a GET request:    /product-offers/${offer_without_volume_price}?include=product-offer-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_without_volume_price}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    product-offer-prices
    And Response include element has self link:    product-offer-prices
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][volumePrices]    0

Get_product_offer_with_gross_eur_volume_prices
    When I send a GET request:    /product-offers/${offer_with_volume_price}?include=product-offer-prices
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_with_volume_price}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    product-offer-prices
    And Response include element has self link:    product-offer-prices
    And Response body parameter should be:    [included][0][attributes][prices][0][netAmount]    None
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][grossAmount]    0
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][volumePrices]    3
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][grossAmount]    int
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][netAmount]    int
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][quantity]    int
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][currency]    3
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    ${currency.eur.code}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    ${currency.eur.name}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    ${currency.eur.symbol}

Get_product_offer_with_net_eur_volume_prices
    When I send a GET request:    /product-offers/${offer_with_volume_price}?include=product-offer-prices&priceMode=${mode.net}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_with_volume_price}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    product-offer-prices
    And Response include element has self link:    product-offer-prices
    And Response body parameter should be:    [included][0][attributes][prices][0][grossAmount]    None
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][netAmount]    1
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][volumePrices]    3
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][grossAmount]    int
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][netAmount]    int
    And Each array element of array in response should contain nested property with datatype:    [included]    [attributes][prices][0][volumePrices][0][quantity]    int
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][currency]    3
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    ${currency.eur.code}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    ${currency.eur.name}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    ${currency.eur.symbol}

Get_product_offer_with_gross_chf_volume_prices
    When I send a GET request:    /product-offers/${offer_with_volume_price}?include=product-offer-prices&currency=${currency.chf.code}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_with_volume_price}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    product-offer-prices
    And Response include element has self link:    product-offer-prices
    And Response body parameter should be:    [included][0][attributes][prices][0][netAmount]    None
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][grossAmount]    1
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][currency]    3
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    ${currency.chf.code}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    ${currency.chf.name}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    ${currency.chf.symbol}

Get_product_offer_with_net_chf_volume_prices
    When I send a GET request:    /product-offers/${offer_with_volume_price}?include=product-offer-prices&priceMode=${mode.net}&currency=${currency.chf.code}
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    And Response body parameter should be:    [data][id]    ${offer_with_volume_price}
    And Response body parameter should be:    [data][type]    product-offers
    And Response body parameter should be in:    [data][attributes][isDefault]    True    False
    And Response should contain the array of a certain size:    [included]    1
    And Response should contain the array of a certain size:    [data][relationships]    1
    And Response include should contain certain entity type:    product-offer-prices
    And Response include element has self link:    product-offer-prices
    And Response body parameter should be:    [included][0][attributes][prices][0][grossAmount]    None
    And Response body parameter should be greater than:    [included][0][attributes][prices][0][netAmount]    1
    And Response should contain the array of a certain size:    [included][0][attributes][prices][0][currency]    3
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][code]    ${currency.chf.code}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][name]    ${currency.chf.name}
    And Response body parameter should be:    [included][0][attributes][prices][0][currency][symbol]    ${currency.chf.symbol}