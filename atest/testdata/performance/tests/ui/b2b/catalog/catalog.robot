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
    Yves: add the following articles into the form through quick order text area:    401627,1\n520561,3\n421340,21\n419871,1\n419869,11\n425073,1\n425084,2
    Yves: add products to the shopping cart from quick order page
    Yves: go to the shopping cart through the header with name:    quickOrderCart+${random}
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    401627    520561    421340    419871    419869    425073    425084
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to 'Quick Order' page through the header
    Yves: add the following articles into the form through quick order text area:    401627,1\n520561,3\n421340,21\n419871,1\n419869,11\n425073,1\n425084,2
    Yves: add products to the shopping list from quick order page with name:    quickOrderList+${random}
    Yves: 'Shopping List' page is displayed
    Yves: shopping list contains the following products:    401627    520561    421340    419871    419869    425073    425084
    Yves: go to the shopping cart through the header with name:    quickOrderCart+${random}
    ### Order placement ###
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
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
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    401627    520561    421340    419871    419869    425073    425084
    [Teardown]    Yves: delete 'Shopping List' with name:    quickOrderList+${random}

Volume_Prices
    [Documentation]    Checks that volume prices are applied in cart
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    VolumePriceCart+${random}
    Yves: go to PDP of the product with sku:    M21189
    Yves: change quantity on PDP:    5
    Yves: product price on the PDP should be:    €4.20
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    VolumePriceCart+${random}
    Yves: shopping cart contains product with unit price:    420685    Post-it stick note Super Sticky Meeting Notes 6445-4SS 4 pieces/pack    4.20
    [Teardown]    Yves: delete 'Shopping Cart' with name:    VolumePriceCart+${random}

Discontinued_Alternative_Products
    [Documentation]    Checks that product can be discontinued in Zed.
    Yves: go to PDP of the product with sku:  M21100
    Yves: PDP contains/doesn't contain:    true    ${alternativeProducts}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: start new abstract product creation:
    ...    || sku                      | store | name en                      | name de                        | new from   | new to     ||
    ...    || discontinuedSKU${random} | DE    | discontinuedProduct${random} | DEdiscontinuedProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 ||
    ...    || farbe       | grey              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set        ||
    ...    || DE    | gross | default | €        | 100.00 | Standard Taxes ||
    Zed: change concrete product data:
    ...    || productAbstract          | productConcrete                     | active | searchable en | searchable de ||
    ...    || discontinuedSKU${random} | discontinuedSKU${random}-farbe-grey | true   | true          | true          ||
    Zed: add following alternative products to the concrete:    M22613
    Zed: concrete product has the following alternative products:    M22613
    Zed: discontinue the following product:    discontinuedSKU${random}    discontinuedSKU${random}-farbe-grey
    Zed: product is successfully discontinued

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
    Yves: select the following payment method on the checkout and go next:    Invoice
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
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Product_Bundles
    [Documentation]    Checks checkout with Bundle product
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: change product stock:    ${bundled_product_1_abstract_sku}    ${bundled_product_1_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_2_abstract_sku}    ${bundled_product_2_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_3_abstract_sku}    ${bundled_product_3_concrete_sku}    true    10
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    productBundleCart+${random}
    Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${bundleItemsSmall}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    productBundleCart+${random}
    Yves: shopping cart contains the following products:    ${bundle_product_concrete_sku}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Product_Restrictions
    [Documentation]    Checks White and Black lists
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
    Yves: PDP contains/doesn't contain:    true    ${pdp_warranty_option}    ${pdp_insurance_option}
    Yves: PDP contains/doesn't contain:    false    ${pdpPriceLocator}   ${addToCartButton}
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    ${multi_variant_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}    ${pdp_add_to_cart_disabled_button}[${env}]    ${pdp_warranty_option}    ${pdp_insurance_option}
    Yves: change variant of the product on PDP on:    500 x 930 x 400
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}    ${addToCartButton}    ${pdp_warranty_option}    ${pdp_insurance_option}

Catalog
    [Documentation]    Checks that catalog options and search work
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: perform search by:    claire
    Yves: 'Catalog' page should show products:    15
    Yves: catalog page contains filter:    Product Ratings     Product Labels     Brand    Color
    Yves: select filter value:    Color    blue
    Yves: 'Catalog' page should show products:    1
    Yves: go to first navigation item level:    Stationery
    Yves: 'Catalog' page should show products:    114
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

Catalog_Actions
    [Documentation]    Checks quick add to cart and product groups
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    catalogActions+${random}
    Yves: perform search by:    Verbatim USB stick OTG
    Yves: 1st product card in catalog (not)contains:      Add to Cart    true
    Yves: quick add to cart for first item in catalog
    Yves: perform search by:    New Clairefontaine Collegeblock 8272C DIN A5, 90 sheets
    Yves: 1st product card in catalog (not)contains:     Add to Cart    false
    Yves: perform search by:    ${multi_color_product_abstract_sku}
    Yves: 1st product card in catalog (not)contains:      Add to Cart    true
    Yves: 1st product card in catalog (not)contains:      Color selector   true
    Yves: mouse over color on product card:    Blue
    Yves: quick add to cart for first item in catalog
    Yves: go to the shopping cart through the header with name:    catalogActions+${random}
    Yves: shopping cart contains the following products:    420573    107255
    [Teardown]    Yves: delete 'Shopping Cart' with name:    catalogActions+${random}

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

Manage_Product
    [Documentation]    checks that BO user can manage abstract and concrete products + create new
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: start new abstract product creation:
    ...    || sku                | store | name en                | name de                  | new from   | new to     ||
    ...    || manageSKU${random} | DE    | manageProduct${random} | DEmanageProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 | attribute 2 | attribute value 2 ||
    ...    || farbe       | grey              | farbe       | blue              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set        ||
    ...    || DE    | gross | default | €        | 100.00 | Standard Taxes ||
    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract    | productConcrete               | active | searchable en | searchable de ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-grey | true   | true          | true          ||
    Zed: change concrete product data:
    ...    || productAbstract    | productConcrete               | active | searchable en | searchable de ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-blue | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract    | productConcrete               | store | mode  | type    | currency | amount ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-blue | DE    | gross | default | €        | 15.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract    | productConcrete               | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-grey | Warehouse1   | 100              | true                            ||
    Zed: change concrete product stock:
    ...    || productAbstract    | productConcrete               | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-blue | Warehouse1   | 100              | false                           ||
    Zed: save abstract product:    manageSKU${random}
    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract    | name de                        ||
    ...    || manageSKU${random} | DEmanageProduct${random} force ||
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to PDP of the product with sku:    manageSKU${random}    wait_for_p&s=true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change variant of the product on PDP on:    grey
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: reset selected variant of the product on PDP
    Yves: change variant of the product on PDP on:    blue
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: add new concrete product to abstract:
    ...    || productAbstract    | sku                            | autogenerate sku | attribute 1 | name en                  | name de                  | use prices from abstract ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-black | false            | black       | ENaddedConcrete${random} | DEaddedConcrete${random} | true                     ||
    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract    | productConcrete                | active | searchable en | searchable de ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-black | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract    | productConcrete                | store | mode  | type    | currency | amount ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-black | DE    | gross | default | €        | 25.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract    | productConcrete                | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || manageSKU${random} | manageSKU${random}-farbe-black | Warehouse1   | 5                | false                           ||
    Zed: update abstract product price on:
    ...    || productAbstract    | store | mode  | type    | currency | amount | tax set        ||
    ...    || manageSKU${random} | DE    | gross | default | €        | 150.00 | Standard Taxes ||
    Trigger multistore p&s
    Zed: update abstract product price on:
    ...    || productAbstract    | store | mode  | type    | currency | amount | tax set        ||
    ...    || manageSKU${random} | DE    | gross | default | €        | 150.00 | Standard Taxes ||
    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract    | name en                         | name de                         ||
    ...    || manageSKU${random} | ENUpdatedmanageProduct${random} | DEUpdatedmanageProduct${random} ||
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    manageProductCart+${random}
    Yves: go to PDP of the product with sku:    manageSKU${random}    wait_for_p&s=true
    Yves: product name on PDP should be:    ENUpdatedmanageProduct${random}
    Yves: product price on the PDP should be:    €150.00    wait_for_p&s=true
    Yves: change variant of the product on PDP on:    grey
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: reset selected variant of the product on PDP
    Yves: change variant of the product on PDP on:    blue
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    Yves: reset selected variant of the product on PDP
    Yves: change variant of the product on PDP on:    black
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product name on PDP should be:    ENaddedConcrete${random}
    Yves: product price on the PDP should be:    €25.00    wait_for_p&s=true
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item manageSKU${random}-farbe-black only has availability of 5.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    manageProductCart+${random}
    Yves: shopping cart contains product with unit price:    manageSKU${random}-farbe-black    ENaddedConcrete${random}    25.00
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: click Action Button in a table for row that contains:     manageProduct${random}     View
    Zed: view product page is displayed
    Zed: view abstract product page contains:
    ...    || store | sku                | name                            | variants count ||
    ...    || DE AT | manageSKU${random} | ENUpdatedmanageProduct${random} | 3              ||
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts

Product_Original_Price
    [Documentation]    checks that Original price is displayed on the PDP and in Catalog
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: start new abstract product creation:
    ...    || sku                  | store | name en                  | name de                    | new from   | new to     ||
    ...    || originalSKU${random} | DE    | originalProduct${random} | DEoriginalProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 | attribute 2 | attribute value 2 ||
    ...    || farbe       | grey              | farbe       | blue              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set        ||
    ...    || DE    | gross | default | €        | 100.00 | Standard Taxes ||
    Zed: update abstract product price on:
    ...    || store | mode  | type     | currency | amount | tax set        ||
    ...    || DE    | gross | original | €        | 200.00 | Standard Taxes ||
    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract      | productConcrete                 | active | searchable en | searchable de ||
    ...    || originalSKU${random} | originalSKU${random}-farbe-grey | true   | true          | true          ||
    Zed: change concrete product data:
    ...    || productAbstract      | productConcrete                 | active | searchable en | searchable de ||
    ...    || originalSKU${random} | originalSKU${random}-farbe-blue | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract      | productConcrete                 | store | mode  | type    | currency | amount ||
    ...    || originalSKU${random} | originalSKU${random}-farbe-blue | DE    | gross | default | €        | 15.00  ||
    Zed: change concrete product price on:
    ...    || productAbstract      | productConcrete                 | store | mode  | type     | currency | amount ||
    ...    || originalSKU${random} | originalSKU${random}-farbe-blue | DE    | gross | original | €        | 50.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract      | productConcrete                 | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || originalSKU${random} | originalSKU${random}-farbe-grey | Warehouse1   | 100              | true                            ||
    Zed: change concrete product stock:
    ...    || productAbstract      | productConcrete                 | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || originalSKU${random} | originalSKU${random}-farbe-blue | Warehouse1   | 100              | false                           ||
    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract      | name de                     ||
    ...    || originalSKU${random} | originalSKU${random} forced ||
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to URL:    en/search?q=originalSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    2    5s
    Yves: 1st product card in catalog (not)contains:     Price    €100.00
    Yves: 1st product card in catalog (not)contains:     Original Price    €200.00
    Yves: go to PDP of the product with sku:    originalSKU${random}    wait_for_p&s=true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: product original price on the PDP should be:    €200.00
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change variant of the product on PDP on:    blue
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    Yves: product original price on the PDP should be:    €50.00

Product_Availability_Calculation
    [Documentation]    Check product availability + multistore
    Repeat Keyword    3    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: update warehouse:
    ...    || warehouse  | store ||
    ...    || Warehouse1 | AT    ||
    Repeat Keyword    3    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: start new abstract product creation:
    ...    || sku                      | store | store 2 | name en                      | name de                        | new from   | new to     ||
    ...    || availabilitySKU${random} | DE    | AT      | availabilityProduct${random} | DEavailabilityProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 ||
    ...    || farbe       | grey              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set        ||
    ...    || DE    | gross | default | €        | 100.00 | Standard Taxes ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set        ||
    ...    || AT    | gross | default | €        | 200.00 | Standard Taxes ||
    Repeat Keyword    3    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract          | productConcrete                     | active | searchable en | searchable de ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-farbe-grey | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract          | productConcrete                     | store | mode  | type    | currency | amount ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-farbe-grey | DE    | gross | default | €        | 50.00  ||
    Zed: change concrete product price on:
    ...    || productAbstract          | productConcrete                     | store | mode  | type    | currency | amount ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-farbe-grey | AT    | gross | default | €        | 75.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract          | productConcrete                     | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-farbe-grey | Warehouse1   | 5                | false                            ||
    Zed: update abstract product data:
    ...    || productAbstract          | name de                              ||
    ...    || availabilitySKU${random} | DEavailabilityProduct${random} force ||
    Repeat Keyword    3    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: create new 'Shopping Cart' with name:    availabilityCart+${random}
    Yves: go to PDP of the product with sku:    availabilitySKU${random}    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-farbe-grey only has availability of 5.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    availabilityCart+${random}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Hermes    Next Day
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    skip grace period
    Zed: wait for order item to be in state:    sku=availabilitySKU${random}-farbe-grey    state=payment pending    iterations=7
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to PDP of the product with sku:    availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-farbe-grey only has availability of 2.
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    Cancel
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to PDP of the product with sku:    availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-farbe-grey only has availability of 5.
    Yves: go to AT store 'Home' page if other store not specified:
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to PDP of the product with sku:    availabilitySKU${random}    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: update warehouse:
    ...    || warehouse  | unselect store ||
    ...    || Warehouse1 | AT             ||
    Repeat Keyword    3    Trigger multistore p&s
    Yves: go to AT store 'Home' page if other store not specified:
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to PDP of the product with sku:    availabilitySKU${random}    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
    [Teardown]    Run Keywords    Should Test Run
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: update warehouse:
    ...    || warehouse  | unselect store ||
    ...    || Warehouse1 | AT             ||
    ...    AND    Trigger multistore p&s
    ...    AND    Repeat Keyword    3    Trigger multistore p&s

Configurable_Product_PDP_Shopping_List
    [Documentation]    Configure products from both the PDP and the Shopping List. Verify the availability of five items. Ensure that products that have not been configured cannot be purchased.
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
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €2,352.44
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    skip grace period
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    Pay
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: trigger all matching states inside this order:    Ship
    Zed: trigger all matching states inside this order:    Stock update
    Zed: trigger all matching states inside this order:    Refund
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
