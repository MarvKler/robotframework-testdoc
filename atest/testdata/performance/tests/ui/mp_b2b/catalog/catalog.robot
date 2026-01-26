*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_one
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/steps/header_steps.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/common/common_zed.robot
Resource    ../../../../resources/common/common_mp.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/shopping_lists_steps.robot
Resource    ../../../../resources/steps/checkout_steps.robot
Resource    ../../../../resources/steps/order_history_steps.robot
Resource    ../../../../resources/steps/product_set_steps.robot
Resource    ../../../../resources/steps/catalog_steps.robot
Resource    ../../../../resources/steps/agent_assist_steps.robot
Resource    ../../../../resources/steps/company_steps.robot
Resource    ../../../../resources/steps/customer_account_steps.robot
Resource    ../../../../resources/steps/zed_users_steps.robot
Resource    ../../../../resources/steps/products_steps.robot
Resource    ../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../resources/steps/zed_customer_steps.robot
Resource    ../../../../resources/steps/zed_discount_steps.robot
Resource    ../../../../resources/steps/zed_availability_steps.robot
Resource    ../../../../resources/steps/zed_cms_page_steps.robot
Resource    ../../../../resources/steps/merchant_profile_steps.robot
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/steps/mp_profile_steps.robot
Resource    ../../../../resources/steps/mp_orders_steps.robot
Resource    ../../../../resources/steps/mp_offers_steps.robot
Resource    ../../../../resources/steps/mp_products_steps.robot
Resource    ../../../../resources/steps/mp_account_steps.robot
Resource    ../../../../resources/steps/mp_dashboard_steps.robot
Resource    ../../../../resources/steps/zed_root_menus_steps.robot
Resource    ../../../../resources/steps/minimum_order_value_steps.robot
Resource    ../../../../resources/steps/availability_steps.robot
Resource    ../../../../resources/steps/glossary_steps.robot
Resource    ../../../../resources/steps/order_comments_steps.robot
Resource    ../../../../resources/steps/configurable_product_steps.robot
Resource    ../../../../resources/steps/dynamic_entity_steps.robot

*** Test Cases ***
Quick_Order
    [Documentation]    Checks Quick Order, checkout and Reorder
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts
    ...    AND    Yves: create new 'Shopping Cart' with name:    quickOrderCart+${random}
    ...    AND    Yves: create new 'Shopping List' with name:    quickOrderList+${random}
    Yves: go to 'Quick Order' page through the header
    Yves: 'Quick Order' page is displayed
    Yves: add the following articles into the form through quick order text area:     213103,1\n520561,3\n421340,21\n419871,1\n419869,11\n425073,1\n425084,2
    Yves: find and add new item in the quick order form:
    ...    || searchQuery                                  | merchant         ||
    ...    || ${product_with_multiple_offers_concrete_sku} | Computer Experts ||
    Yves: add products to the shopping cart from quick order page
    Yves: go to the shopping cart through the header with name:    quickOrderCart+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:     213103    520561    421340    419871    419869    425073    425084
    Yves: assert merchant of product in cart or list:    213103    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Computer Experts
    Yves: go to 'Quick Order' page through the header
    Yves: add the following articles into the form through quick order text area:     213103,1\n520561,3\n421340,21\n419871,1\n419869,11\n425073,1\n425084,2
    Yves: find and add new item in the quick order form:
    ...    || searchQuery                                  | merchant         ||
    ...    || ${product_with_multiple_offers_concrete_sku} | Computer Experts ||
    Yves: add products to the shopping list from quick order page with name:    quickOrderList+${random}
    Yves: 'Shopping List' page is displayed
    Yves: shopping list contains the following products:     213103    520561    421340    419871    419869    425073    425084
    Yves: assert merchant of product in cart or list:    213103    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Computer Experts
    Yves: go to the shopping cart through the header with name:    quickOrderCart+${random}
    ### Order placement ###
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method for the shipment:    1    DHL    Express
    Yves: select the following shipping method for the shipment:    2    Hermes    Same Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    ### Order History ###
    Yves: go to the 'Home' page
    Yves: go to user menu:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page is displayed
    ### Reorder ###
    Yves: reorder all items from 'Order Details' page
    Yves: go to the shopping cart through the header with name:    Reorder from Order ${lastPlacedOrder}
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:     213103    520561    421340    419871    419869    425073    425084
    Yves: assert merchant of product in cart or list:    213103    Spryker
    Yves: assert merchant of product in cart or list:    ${product_with_multiple_offers_concrete_sku}    Computer Experts
    [Teardown]    Yves: delete 'Shopping List' with name:    quickOrderList+${random}

Volume_Prices
    [Documentation]    Checks that volume prices are applied in cart
    [Setup]    Run keywords    Zed: check and restore product availability in Zed:    ${volume_prices_product_abstract_sku}    Available    ${volume_prices_product_concrete_sku}
    ...    AND    Trigger p&s
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts
    ...    AND    Yves: create new 'Shopping Cart' with name:    VolumePriceCart+${random}
    Yves: go to PDP of the product with sku:    ${volume_prices_product_abstract_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity on PDP:    5
    Yves: product price on the PDP should be:    €4.20
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    VolumePriceCart+${random}
    Yves: shopping cart contains product with unit price:    420685    Post-it stick note Super Sticky Meeting Notes 6445-4SS 4 pieces/pack    4.20
    [Teardown]    Yves: delete 'Shopping Cart' with name:    VolumePriceCart+${random}

Discontinued_Alternative_Products
    [Documentation]    Checks that product can be discontinued in Zed
    Yves: go to PDP of the product with sku:  M21100
    Yves: PDP contains/doesn't contain:    true    ${alternativeProducts}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: discontinue the following product:    ${discontinued_product_abstract_sku}    ${discontinued_product_concrete_sku}
    Zed: product is successfully discontinued
    Zed: add following alternative products to the concrete:    M22613
    Zed: submit the form
    [Teardown]    Zed: undo discontinue the following product:    ${discontinued_product_abstract_sku}    ${discontinued_product_concrete_sku}

Measurement_Units
    [Documentation]    Checks checkout with Measurement Unit product
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    measurementUnitsCart+${random}
    Yves: go to PDP of the product with sku:    M23723
    Yves: select the following 'Sales Unit' on PDP:    Meter
    Yves: change quantity using '+' or '-' button № times:    +    1
    Yves: PDP contains/doesn't contain:    true    ${measurementUnitSuggestion}
    Yves: change quantity using '+' or '-' button № times:    -    1
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M1006871
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:  measurementUnitsCart+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    425079
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_manager_and_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Packaging_Units
    [Documentation]    Checks checkout with Packaging Unit product
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_manager_and_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    packagingUnitsCart+${random}
    Yves: go to PDP of the product with sku:    M21766
    Yves: change variant of the product on PDP on:    Box
    Yves: change amount on PDP:    51
    Yves: PDP contains/doesn't contain:    true    ${packagingUnitSuggestion}
    Yves: change amount on PDP:    10
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M1006871
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    packagingUnitsCart+${random}
    Yves: shopping cart contains the following products:    421519_3
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_manager_and_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Product_Restrictions
    [Documentation]    Checks White and Aluminium lists
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: perform search by:    Soennecken
    Yves: 'Catalog' page should show products:    18
    Yves: go to URL:    en/office-furniture/storage/lockers
    Yves: 'Catalog' page should show products:    34
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_restriction_customer_email_1}
    Yves: perform search by:    Soennecken
    Yves: 'Catalog' page should show products:    0
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_restriction_customer_email_2}
    Yves: go to URL:    en/office-furniture/storage/lockers
    Yves: 'Catalog' page should show products:    0
    Yves: go to URL:    en/transport/lift-carts
    Yves: 'Catalog' page should show products:    16
    Yves: go to URL:    en/transport/sack-trucks
    Yves: 'Catalog' page should show products:    10

Customer_Specific_Prices
    [Documentation]    Checks that product price can be different for different customers
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: perform search by:    ${one_variant_product_abstract_name}
    Yves: product with name in the catalog should have price:    ${one_variant_product_abstract_name}    ${one_variant_product_default_price}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: product price on the PDP should be:    ${one_variant_product_default_price}
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_company_user_special_prices_customer_email}
    Yves: create new 'Shopping Cart' with name:    customerPrices+${random}
    Yves: perform search by:    ${one_variant_product_abstract_name}
    Yves: product with name in the catalog should have price:    ${one_variant_product_abstract_name}    ${one_variant_product_merchant_price}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: product price on the PDP should be:    ${one_variant_product_merchant_price}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    customerPrices+${random}
    Yves: shopping cart contains product with unit price:    403125    EUROKRAFT hand truck - with open shovel - load capacity 400 kg    188.34
    [Teardown]    Yves: delete 'Shopping Cart' with name:    customerPrices+${random}

Product_PDP
    [Documentation]    Checks that PDP contains required elements
    Delete All Cookies
    Yves: go to PDP of the product with sku:    ${multi_variant_product_abstract_sku}
    Yves: change variant of the product on PDP on:    500 x 930 x 400
    Yves: PDP contains/doesn't contain:    true    ${pdp_limited_warranty_option}[${env}]     ${pdp_insurance_coverage_option}
    Yves: PDP contains/doesn't contain:    false    ${pdpPriceLocator}   ${addToCartButton}
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    ${multi_variant_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}    ${pdp_add_to_cart_disabled_button}[${env}]    ${pdp_limited_warranty_option}[${env}]    ${pdp_insurance_coverage_option}
    Yves: change variant of the product on PDP on:    500 x 930 x 400
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}    ${addToCartButton}    ${pdp_limited_warranty_option}[${env}]     ${pdp_insurance_coverage_option}

Catalog
    [Documentation]    Checks that catalog options and search work
    Trigger product labels update
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: perform search by:    claire
    Yves: 'Catalog' page should show products:    15
    Yves: catalog page contains filter:    Product Ratings     Product Labels     Brand    Color    Merchant
    Yves: select filter value:    Color    blue
    Yves: 'Catalog' page should show products:    1
    Yves: go to first navigation item level:    Stationery
    Yves: 'Catalog' page should show products:    114
    Yves: select filter value:    Merchant    Spryker
    Yves: page contains CMS element:    CMS Block    Build a Space That Spurs Creativity
    Yves: page contains CMS element:    CMS Block    Tackle Your To-Do's
    Yves: change sorting order on catalog page:    Sort by price ascending
    Yves: 1st product card in catalog (not)contains:     Price    0.48
    Yves: change sorting order on catalog page:    Sort by price descending
    Yves: 1st product card in catalog (not)contains:      Price    €41.68
    Yves: go to catalog page:    2
    Yves: catalog page contains filter:    Product Ratings     Product Labels     Brand    Color
    Yves: select filter value:    Color    blue
    Yves: 'Catalog' page should show products:    3

Back_in_Stock_Notification
    [Documentation]    Back in stock notification is sent and availability check
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: check if product is/not in stock:    ${stock_product_abstract_sku}    true
    Zed: change product stock:    ${stock_product_abstract_sku}    ${stock_product_concrete_sku}    false    0
    Zed: check if product is/not in stock:    ${stock_product_abstract_sku}    false
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:  ${stock_product_abstract_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
    Yves: check if product is available on PDP:    ${stock_product_abstract_sku}    false
    Yves: submit back in stock notification request for email:    ${yves_user_email}
    Yves: unsubscribe from availability notifications
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: change product stock:    ${stock_product_abstract_sku}    ${stock_product_concrete_sku}    true    0
    Zed: check if product is/not in stock:    ${stock_product_abstract_sku}    true
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:  ${stock_product_abstract_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: check if product is available on PDP:    ${stock_product_abstract_sku}    true
    [Teardown]    Zed: check and restore product availability in Zed:    ${stock_product_abstract_sku}    Available    ${stock_product_concrete_sku}

Offer_Availability_Calculation
    [Documentation]    check offer availability
    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    MP: open navigation menu tab:    Products
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku      | product name          | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || offAvKU${random} | offAvProduct${random} | packaging_unit       | Item                        | Box                          | material              | Aluminium              ||
    MP: perform search by:    offAvProduct${random}
    MP: click on a table row that contains:     offAvProduct${random}
    MP: fill abstract product required fields:
    ...    || product name          | store | store 2 | tax set        ||
    ...    || offAvProduct${random} | DE    | AT      | Standard Taxes ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 1           | DE    | EUR      | 100           | 90             ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 2           | AT    | EUR      | 200           | 90             ||
    MP: save abstract product
    MP: click on a table row that contains:    offAvProduct${random}
    MP: open concrete drawer by SKU:    offAvKU${random}-1
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 5              | true              | en_US         ||
    MP: open concrete drawer by SKU:    offAvKU${random}-1
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 50            ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 2          | AT    | EUR      | 50            ||
    MP: save concrete product
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: click Action Button in a table for row that contains:     offAvProduct${random}     Approve
    Trigger multistore p&s
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    offAvKU${random}-1
    MP: click on a table row that contains:    offAvKU${random}-1
    MP: fill offer fields:
    ...    || is active | merchant sku      | store | stock quantity ||
    ...    || true      | offAvMKU${random} | DE    | 5              ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | CHF      | 100           ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 2          | DE    | EUR      | 200           | 1        ||
    MP: add offer price:
    ...    || row number | store | currency | gross default | quantity ||
    ...    || 3          | AT    | EUR      | 10            | 1        ||
    MP: save offer
    Repeat Keyword    2    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: delete all shopping carts
    Yves: delete all user addresses
    Yves: create new 'Shopping Cart' with name:    offAvailability${random}
    Yves: go to PDP of the product with sku:     offAvKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    Yves: merchant's offer/product price should be:    Spryker    €200.00
    Yves: select xxx merchant's offer:    Spryker
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item offAvKU${random}-1 only has availability of 5.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    offAvailability${random}
    Yves: assert merchant of product in cart or list:    offAvKU${random}-1    Spryker
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method for the shipment:    1    DHL    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Yves: go to PDP of the product with sku:     offAvKU${random}
    Yves: select xxx merchant's offer:    Spryker
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item offAvKU${random}-1 only has availability of 2.
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    skip grace period
    Zed: trigger all matching states inside this order:    Pay
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    Cancel
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: delete all shopping carts
    Yves: create new 'Shopping Cart' with name:    offUpdatedAvailability${random}
    Yves: go to PDP of the product with sku:     offAvKU${random}
    Yves: select xxx merchant's offer:    Spryker
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item offAvKU${random}-1 only has availability of 5.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    offUpdatedAvailability${random}
    Yves: assert merchant of product in cart or list:    offAvKU${random}-1    Spryker
    [Teardown]    Run Keywords    Should Test Run
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts
    ...    AND    Yves: delete all user addresses
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products
    ...    AND    Zed: click Action Button in a table for row that contains:      offAvProduct${random}     Deny
    ...    AND    Trigger multistore p&s

Product_Availability_Calculation
    [Documentation]    Check product availability + multistore
    Repeat Keyword    3    Trigger multistore p&s
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Products
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku              | product name                 | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || availabilitySKU${random} | availabilityProduct${random} | packaging_unit       | Item                        | Box                          | material              | Aluminium              ||
    MP: perform search by:    availabilityProduct${random}
    MP: click on a table row that contains:     availabilityProduct${random}
    MP: fill abstract product required fields:
    ...    || product name                 | store | store 2 | tax set        ||
    ...    || availabilityProduct${random} | DE    | AT      | Standard Taxes ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 1           | DE    | EUR      | 100           | 90             ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 2           | AT    | EUR      | 200           | 90             ||
    MP: save abstract product
    MP: click on a table row that contains:    availabilityProduct${random}
    MP: open concrete drawer by SKU:    availabilitySKU${random}-1
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 5              | true              | en_US         ||
    MP: open concrete drawer by SKU:    availabilitySKU${random}-1
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 50            ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 2          | AT    | EUR      | 50            ||
    MP: save concrete product
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: click Action Button in a table for row that contains:     availabilityProduct${random}     Approve
    Zed: save abstract product:    availabilityProduct${random}
    Repeat Keyword    3    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: delete all shopping carts
    Yves: delete all user addresses
    Yves: create new 'Shopping Cart' with name:    prodAvailCalculation+${random}
    Yves: go to PDP of the product with sku:     availabilitySKU${random}    wait_for_p&s=true
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-1 only has availability of 5.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    prodAvailCalculation+${random}
    Yves: assert merchant of product in cart or list:    availabilitySKU${random}-1    Spryker
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method for the shipment:    1    DHL    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Yves: go to PDP of the product with sku:     availabilitySKU${random}
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-1 only has availability of 2.
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    skip grace period
    Zed: trigger all matching states inside this order:    Pay
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    Cancel
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    newProdAvlCalculation+${random}
    Yves: go to PDP of the product with sku:     availabilitySKU${random}
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-1 only has availability of 5.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    newProdAvlCalculation+${random}
    Yves: assert merchant of product in cart or list:    availabilitySKU${random}-1    Spryker
    Yves: go to AT store 'Home' page if other store not specified:
    Trigger multistore p&s
    Yves: go to PDP of the product with sku:     availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: update warehouse:
    ...    || warehouse                                         | unselect store ||
    ...    || Spryker ${merchant_spryker_reference} Warehouse 1 | AT             ||
    Trigger multistore p&s
    Yves: go to AT store 'Home' page if other store not specified:
    Yves: go to PDP of the product with sku:     availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
    [Teardown]    Run Keywords    Should Test Run
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products
    ...    AND    Zed: click Action Button in a table for row that contains:      availabilitySKU${random}     Deny
    ...    AND    Zed: update warehouse:
    ...    || warehouse                                         | store ||
    ...    || Spryker ${merchant_spryker_reference} Warehouse 1 | AT    ||
    ...    AND    Repeat Keyword    3    Trigger multistore p&s

Configurable_Product_PDP_Shopping_List
    [Documentation]    Configure products from both the PDP and the Shopping List. Verify the availability of 7 items. Ensure that products that have not been configured cannot be purchased.
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    configProduct+${random}
    ...    AND    Yves: create new 'Shopping List' with name:    configProduct+${random}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${configureButton}
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    configProduct+${random}
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: checkout is blocked with the following message:    This cart can't be processed. Please configure items inside the cart.
    Yves: delete product from the shopping cart with sku:    ${configurable_product_concrete_sku}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: check and go back that configuration page contains:
    ...    || store | locale | price_mode | currency | customer_id                          | sku                                  ||
    ...    || DE    | en_US  | GROSS_MODE | EUR      | ${yves_company_user_buyer_reference} | ${configurable_product_concrete_sku} ||
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 420        | 240        ||
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 280        | 480        ||
    Yves: product configuration notification is:     Only 7 items available
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: configuration should be equal:
    ...    || option one | option two ||
    ...    || 5 shelves  | 3 lockers  ||
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: change quantity on PDP:    8
    Yves: try add product to the cart from PDP and expect error:    Item ${configurable_product_concrete_sku} only has availability of 7.
    Yves: go to PDP of the product with sku:   ${configurable_product_abstract_sku}
    Yves: change quantity on PDP:    7
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    configProduct+${random}
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 140        | 240        ||
    Yves: save product configuration
    Yves: shopping cart contains product with unit price:    ${configurable_product_concrete_sku}    ${configurable_product_name}    €2,206.54
    Yves: delete all shopping carts
    Yves: create new 'Shopping Cart' with name:    configProduct+${random}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: add product to the shopping list:    configProduct+${random}
    Yves: go to 'Shopping Lists' page
    Yves: view shopping list with name:    configProduct+${random}
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 420        | 240        ||
    Yves: save product configuration
    Yves: configuration should be equal:
    ...    || option one | option two ||
    ...    || 6 shelves  | 2 lockers  ||
    Yves: add all available products from list to cart
    Yves: configuration should be equal:
    ...    || option one | option two ||
    ...    || 6 shelves  | 2 lockers  ||
    Yves: shopping cart contains product with unit price:    ${configurable_product_concrete_sku}    ${configurable_product_name}    €2,486.54
    [Teardown]    Run Keywords    Yves: delete 'Shopping List' with name:    configProduct+${random}
    ...    AND    Yves: delete 'Shopping Cart' with name:    configProduct+${random}

Configurable_Product_RfQ_OMS
    [Documentation]    Conf Product in RfQ, OMS, Merchant OMS and reorder.
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: create new Zed user with the following data:    agent_config+${random}@spryker.com    ${default_secure_password}    Config    Product    Root group    This user is an agent in Storefront    en_US
    ...    AND    Zed: deactivate all discounts from Overview page
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: delete all shopping carts
    Yves: delete all user addresses
    Yves: create new 'Shopping Cart' with name:    confProductCart+${random}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 420        | 480        ||
    Yves: save product configuration
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    confProductCart+${random}
    Yves: submit new request for quote
    Yves: click 'Send to Agent' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent_config+${random}@spryker.com    ${default_secure_password}    agent_assist=${True}
    Yves: go to 'Agent Quote Requests' page through the header
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Waiting
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: 'Quote Request Details' page is displayed
    Yves: click 'Revise' button on the 'Quote Request Details' page
    Yves: click 'Edit Items' button on the 'Quote Request Details' page
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 280        | 240        ||
    Yves: save product configuration
    Yves: click 'Save and Back to Edit' button on the 'Quote Request Details' page
    Yves: click 'Send to Customer' button on the 'Quote Request Details' page
    Yves: logout on Yves as a customer
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu:    Quote Requests
    Yves: quote request with reference xxx should have status:    ${lastCreatedRfQ}    Ready
    Yves: view quote request with reference:    ${lastCreatedRfQ}
    Yves: click 'Convert to Cart' button on the 'Quote Request Details' page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    skip grace period
    Zed: trigger all matching states inside this order:    Pay
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    send to distribution
    Zed: trigger matching state of xxx merchant's shipment:    1    confirm at center
    Zed: trigger matching state of xxx order item inside xxx shipment:    Ship    1
    Zed: trigger matching state of xxx order item inside xxx shipment:    Deliver    1
    Zed: trigger matching state of xxx order item inside xxx shipment:    Refund    1
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €0.00
    Repeat Keyword    3    Trigger multistore p&s
    Yves: go to the 'Home' page
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to user menu:    Order History
    Yves: 'View Order/Reorder/Return' on the order history page:     View Order
    Yves: 'Order Details' page is displayed
    ### Reorder ###
    Yves: reorder all items from 'Order Details' page
    Yves: go to the shopping cart through the header with name:    Reorder from Order ${lastPlacedOrder}
    Yves: 'Shopping Cart' page is displayed
    Yves: product configuration status should be equal:       Configuration is not complete.
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: activate following discounts from Overview page:    	Free mobile phone    20% off cameras products    Free Acer M2610 product    Free delivery    10% off Intel products    5% off white products    Tuesday & Wednesday $5 off 5 or more    10% off $100+    Free smartphone    20% off cameras    Free Acer M2610    Free standard delivery    10% off Intel Core    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order
    ...    AND    Zed: delete Zed user with the following email:    agent_config+${random}@spryker.com

#### Product Bundles feature is not present in marketplace for now ####
# Product_Bundles
#     [Tags]    skip-due-to-refactoring
#     [Documentation]    Checks checkout with Bundle product
#     [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
#     ...    AND    Zed: change product stock:    ${bundled_product_1_abstract_sku}    ${bundled_product_1_concrete_sku}    true    10
#     ...    AND    Zed: change product stock:    ${bundled_product_2_abstract_sku}    ${bundled_product_2_concrete_sku}    true    10
#     ...    AND    Zed: change product stock:    ${bundled_product_3_abstract_sku}    ${bundled_product_3_concrete_sku}    true    10
#     Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
#     Yves: create new 'Shopping Cart' with name:    productBundleCart+${random}
#     Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
#     Yves: PDP contains/doesn't contain:    true    ${bundleItemsSmall}
#     Yves: add product to the shopping cart
#     Yves: go to the shopping cart through the header with name:    productBundleCart+${random}
#     Yves: shopping cart contains the following products:    ${bundle_product_concrete_sku}
#     Yves: click on the 'Checkout' button in the shopping cart
#     Yves: billing address same as shipping address:    true
#     Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
#     Yves: select the following shipping method on the checkout and go next:    Express
#     Yves: select the following payment method on the checkout and go next:    Marketplace Invoice
#     Yves: accept the terms and conditions:    true
#     Yves: 'submit the order' on the summary page
#     Yves: 'Thank you' page is displayed
