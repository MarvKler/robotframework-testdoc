*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_one    catalog    product    search    spryker-core-back-office    spryker-core    cart    
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
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/steps/zed_root_menus_steps.robot
Resource    ../../../../resources/steps/minimum_order_value_steps.robot
Resource    ../../../../resources/steps/availability_steps.robot
Resource    ../../../../resources/steps/glossary_steps.robot
Resource    ../../../../resources/steps/order_comments_steps.robot
Resource    ../../../../resources/steps/configurable_product_steps.robot
Resource    ../../../../resources/steps/dynamic_entity_steps.robot
Resource    ../../../../resources/steps/merchants_steps.robot
Resource    ../../../../resources/steps/configurable_product_steps.robot
Resource    ../../../../resources/pages/yves/yves_product_configurator_page.robot
Resource    ../../../../resources/pages/yves/yves_product_details_page.robot
Resource    ../../../../resources/pages/zed/zed_order_details_page.robot

*** Test Cases ***
Product_PDP
    [Tags]    smoke    product-options
    [Documentation]    Checks that PDP contains required elements
    Delete All Cookies
    Yves: go to PDP of the product with sku:    135
    Yves: change variant of the product on PDP on:    Flash
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}   ${addToCartButton}    ${pdp_limited_warranty_option}[${env}]    ${pdp_gift_wrapping_option}[${env}]    ${relatedProducts}
    Yves: PDP contains/doesn't contain:    false    ${pdp_add_to_wishlist_button}
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    135
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}   ${pdp_add_to_cart_disabled_button}[${env}]    ${pdp_limited_warranty_option}[${env}]    ${pdp_gift_wrapping_option}[${env}]     ${pdp_add_to_wishlist_button}    ${relatedProducts}
    Yves: change variant of the product on PDP on:    Flash
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}    ${addToCartButton}    ${pdp_limited_warranty_option}[${env}]    ${pdp_gift_wrapping_option}[${env}]     ${pdp_add_to_wishlist_button}    ${relatedProducts}

Catalog
    [Tags]    smoke
    [Documentation]    Checks that catalog options and search work
    Yves: perform search by:    canon
    Yves: 'Catalog' page should show products:    29
    Yves: select filter value:    Color    Blue
    Yves: 'Catalog' page should show products:    2
    Yves: go to first navigation item level:    Cameras
    Yves: 'Catalog' page should show products:    63
    Yves: change sorting order on catalog page:    Sort by price ascending
    Yves: 1st product card in catalog (not)contains:     Price    €25.00
    Yves: change sorting order on catalog page:    Sort by price descending
    Yves: 1st product card in catalog (not)contains:      Price    €3,456.99
    Yves: go to catalog page:    2
    Yves: catalog page contains filter:    Price    Ratings     Label     Brand    Color    Merchant
    Yves: select filter value:    Color    Blue
    Yves: 'Catalog' page should show products:    2
    [Teardown]    Yves: check if cart is not empty and clear it

Catalog_Actions
    [Tags]    product-groups    quick-add-to-cart
    [Documentation]    Checks quick add to cart and product groups
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: change concrete product price on:
    ...    || productAbstract | productConcrete | store | mode  | type   | currency | amount ||
    ...    || 003             | 003_26138343    | DE    | gross | default| €        | 65.00  ||
    Trigger p&s
    Yves: check if cart is not empty and clear it
    Yves: perform search by:     150_29554292
    Yves: 1st product card in catalog (not)contains:      Add to Cart    true
    Yves: quick add to cart for first item in catalog
    Yves: perform search by:    115_26408656
    Yves: 1st product card in catalog (not)contains:     Add to Cart    false
    Yves: perform search by:    002_25904004
    Yves: 1st product card in catalog (not)contains:      Add to Cart    true
    Yves: 1st product card in catalog (not)contains:      Color selector   true
    Yves: mouse over color on product card:    D3D3D3
    Yves: quick add to cart for first item in catalog
    Yves: go to shopping cart page
    Yves: shopping cart contains the following products:    150_29554292    003_26138343
    Yves: shopping cart contains product with unit price:    sku=003    productName=Canon IXUS 160    productPrice=65.00
    [Teardown]    Yves: check if cart is not empty and clear it

Volume_Prices
    [Tags]    prices   
    [Documentation]    Checks that volume prices are applied in cart
    [Setup]    Run keywords    Zed: check and restore product availability in Zed:    ${volume_prices_product_abstract_sku}    Available    ${volume_prices_product_concrete_sku}
    ...    AND    Trigger p&s
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: delete all shopping carts
    ...    AND    Yves: create new 'Shopping Cart' with name:    VolumePriceCart+${random}
    Yves: go to PDP of the product with sku:    ${volume_prices_product_abstract_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity on PDP:    5
    Yves: product price on the PDP should be:    €16.50
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    VolumePriceCart+${random}
    Yves: shopping cart contains product with unit price:    sku=${volume_prices_product_concrete_sku}    productName=${volume_prices_product_name}    productPrice=16.50
    [Teardown]    Yves: delete 'Shopping Cart' with name:    VolumePriceCart+${random}

Discontinued_Alternative_Products
    [Tags]    discontinued-products    alternative-products    wishlist
    [Documentation]    Checks discontinued and alternative products
    Yves: go to PDP of the product with sku:    ${product_with_relations_alternative_products_sku}
    Yves: change variant of the product on PDP on:    2.3 GHz
    Yves: PDP contains/doesn't contain:    true    ${alternativeProducts}
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: delete all wishlists
    Yves: go to PDP of the product with sku:    ${discontinued_product_concrete_sku}
    Yves: add product to wishlist:    My wishlist
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: discontinue the following product:    ${discontinued_product_abstract_sku}    ${discontinued_product_concrete_sku}
    Zed: product is successfully discontinued
    Zed: check if at least one price exists for concrete and add if doesn't:    100
    Zed: add following alternative products to the concrete:    012
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to 'Wishlist' page
    Yves: go to wishlist with name:    My wishlist
    Yves: product with sku is marked as discontinued in wishlist:    ${discontinued_product_concrete_sku}
    Yves: product with sku is marked as alternative in wishlist:    012
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: undo discontinue the following product:    ${discontinued_product_abstract_sku}    ${discontinued_product_concrete_sku}
    ...    AND    Trigger p&s

Measurement_Units
    [Tags]    smoke    marketplace-packaging-units    measurement-units    packaging-units    checkout
    [Documentation]    Checks checkout with Measurement Unit product
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    measurementUnitsCart+${random}
    Yves: go to PDP of the product with sku:    215
    Yves: change variant of the product on PDP on:    Ring (500m)
    Yves: select the following 'Sales Unit' on PDP:    Meter
    Yves: set quantity on PDP:    3
    Yves: PDP contains/doesn't contain:    true    ${measurementUnitSuggestion}
    Yves: set quantity on PDP:    10
    Yves: add product to the shopping cart
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    215_124
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Packaging_Units
    [Tags]    smoke     marketplace-packaging-units    measurement-units    packaging-units    checkout
    [Documentation]    Checks checkout with Packaging Unit product
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    packagingUnitsCart+${random}
    Yves: go to PDP of the product with sku:    218
    Yves: change variant of the product on PDP on:    Giftbox
    Yves: change amount on PDP:    51
    Yves: PDP contains/doesn't contain:    true    ${packagingUnitSuggestion}
    Yves: change amount on PDP:    1000
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    packagingUnitsCart+${random}
    Yves: shopping cart contains the following products:    218_1234
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Product_Bundles
    [Tags]    smoke    checkout    product-bundles
    [Documentation]    Checks checkout with Bundle product
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: change product stock:    ${bundled_product_1_abstract_sku}    ${bundled_product_1_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_2_abstract_sku}    ${bundled_product_2_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_3_abstract_sku}    ${bundled_product_3_concrete_sku}    true    10
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${bundleItemsSmall}
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: shopping cart contains the following products:    ${bundle_product_concrete_sku}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Yves: check if cart is not empty and clear it

Back_in_Stock_Notification
    [Tags]    availability-notification    mailing-notifications    
    [Documentation]    Back in stock notification is sent and availability check
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: check if product is/not in stock:    ${stock_product_abstract_sku}    true
    Zed: change product stock:    ${stock_product_abstract_sku}    ${stock_product_concrete_sku}    false    0
    Zed: check if product is/not in stock:    ${stock_product_abstract_sku}    false
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:  ${stock_product_abstract_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
    Yves: check if product is available on PDP:    ${stock_product_abstract_sku}    false
    Yves: submit back in stock notification request for email:    ${yves_second_user_email}
    Yves: unsubscribe from availability notifications
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: change product stock:    ${stock_product_abstract_sku}    ${stock_product_concrete_sku}    true    0
    Zed: check if product is/not in stock:    ${stock_product_abstract_sku}    true
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:  ${stock_product_abstract_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: check if product is available on PDP:    ${stock_product_abstract_sku}    true
    [Teardown]    Zed: check and restore product availability in Zed:    ${stock_product_abstract_sku}    Available    ${stock_product_concrete_sku}

Manage_Product
    [Tags]    smoke    prices    marketplace-product    product-approval-process    marketplace-product-approval-process
    [Documentation]    checks that BO user can manage abstract and concrete products + create new
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: start new abstract product creation:
    ...    || sku                   | store | name en                | name de                  | new from   | new to     ||
    ...    || zedManageSKU${random} | DE    | manageProduct${random} | DEmanageProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 | attribute 2 | attribute value 2 ||
    ...    || color       | grey              | color       | blue              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set           ||
    ...    || DE    | gross | default | €        | 100.00 | Smart Electronics ||
    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract       | productConcrete                  | active | searchable en | searchable de ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-grey | true   | true          | true          ||
    Zed: change concrete product data:
    ...    || productAbstract       | productConcrete                  | active | searchable en | searchable de ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-blue | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract       | productConcrete                  | store | mode  | type    | currency | amount ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-blue | DE    | gross | default | €        | 15.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract       | productConcrete                  | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-grey | Warehouse1   | 100              | true                            ||
    Zed: change concrete product stock:
    ...    || productAbstract       | productConcrete                  | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-blue | Warehouse1   | 100              | false                           ||
    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract       | name de                        ||
    ...    || zedManageSKU${random} | DEmanageProduct${random} force ||
    Trigger multistore p&s
    Zed: go to second navigation item level:    Catalog    Products
    Zed: click Action Button in a table for row that contains:     zedManageSKU${random}     Approve
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    zedManageSKU${random}    wait_for_p&s=true
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
    ...    || productAbstract       | sku                               | autogenerate sku | attribute 1 | name en                  | name de                  | use prices from abstract ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-black | false            | black       | ENaddedConcrete${random} | DEaddedConcrete${random} | true                     ||
    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract       | productConcrete                   | active | searchable en | searchable de ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-black | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract       | productConcrete                   | store | mode  | type    | currency | amount ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-black | DE    | gross | default | €        | 25.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract       | productConcrete                   | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || zedManageSKU${random} | zedManageSKU${random}-color-black | Warehouse1   | 5                | false                           ||
    Zed: update abstract product price on:
    ...    || productAbstract       | store | mode  | type    | currency | amount | tax set           ||
    ...    || zedManageSKU${random} | DE    | gross | default | €        | 150.00 | Smart Electronics ||
    Zed: save abstract product:    zedManageSKU${random}
    Trigger multistore p&s
    Zed: update abstract product price on:
    ...    || productAbstract       | store | mode  | type    | currency | amount | tax set           ||
    ...    || zedManageSKU${random} | DE    | gross | default | €        | 150.00 | Smart Electronics ||
    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract       | name en                         | name de                         ||
    ...    || zedManageSKU${random} | ENUpdatedmanageProduct${random} | DEUpdatedmanageProduct${random} ||
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:    zedManageSKU${random}    wait_for_p&s=true
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
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item zedManageSKU${random}-color-black only has availability of 5.
    Yves: go to PDP of the product with sku:    zedManageSKU${random}
    Yves: change variant of the product on PDP on:    black
    Yves: change quantity on PDP:    3
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    zedManageSKU${random}-color-black    ENaddedConcrete${random}    25.00
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: click Action Button in a table for row that contains:     manageProduct${random}     View
    Zed: view product page is displayed
    Zed: view abstract product page contains:
    ...    || store | sku                   | name                          | variants count ||
    ...    || DE AT | zedManageSKU${random} | UpdatedmanageProduct${random} | 3              ||
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: check if cart is not empty and clear it

Product_Original_Price
    [Tags]    prices    
    [Documentation]    checks that Original price is displayed on the PDP and in Catalog
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: start new abstract product creation:
    ...    || sku                     | store | name en                  | name de                    | new from   | new to     ||
    ...    || zedOriginalSKU${random} | DE    | originalProduct${random} | DEoriginalProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 | attribute 2 | attribute value 2 ||
    ...    || color       | grey              | color       | blue              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set           ||
    ...    || DE    | gross | default | €        | 100.00 | Smart Electronics ||
    Zed: update abstract product price on:
    ...    || store | mode  | type     | currency | amount | tax set           ||
    ...    || DE    | gross | original | €        | 200.00 | Smart Electronics ||
    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract         | productConcrete                    | active | searchable en | searchable de ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-grey | true   | true          | true          ||
    Zed: change concrete product data:
    ...    || productAbstract         | productConcrete                    | active | searchable en | searchable de ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-blue | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract         | productConcrete                    | store | mode  | type    | currency | amount ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-blue | DE    | gross | default | €        | 15.00  ||
    Zed: change concrete product price on:
    ...    || productAbstract         | productConcrete                    | store | mode  | type     | currency | amount ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-blue | DE    | gross | original | €        | 50.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract         | productConcrete                    | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-grey | Warehouse1   | 100              | true                            ||
    Zed: change concrete product stock:
    ...    || productAbstract         | productConcrete                    | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random}-color-blue | Warehouse1   | 100              | false                           ||
    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract         | name de                        ||
    ...    || zedOriginalSKU${random} | zedOriginalSKU${random} forced ||
    Trigger multistore p&s
    Zed: go to second navigation item level:    Catalog    Products
    Zed: click Action Button in a table for row that contains:     zedOriginalSKU${random}     Approve
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to URL:    en/search?q=zedOriginalSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: 1st product card in catalog (not)contains:     Price    €100.00
    Yves: 1st product card in catalog (not)contains:     Original Price    €200.00
    Yves: go to PDP of the product with sku:    zedOriginalSKU${random}    wait_for_p&s=true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: product original price on the PDP should be:    €200.00
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change variant of the product on PDP on:    blue
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    Yves: product original price on the PDP should be:    €50.00

Product_Availability_Calculation
    [Tags]    product-approval-process
    [Documentation]    Check product availability + multistore
    [Setup]    Repeat Keyword    3    Trigger multistore p&s
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
    ...    || color       | grey              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set           ||
    ...    || DE    | gross | default | €        | 100.00 | Smart Electronics ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set           ||
    ...    || AT    | gross | default | €        | 200.00 | Smart Electronics ||
    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract          | productConcrete                     | active | searchable en | searchable de ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-color-grey | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract          | productConcrete                     | store | mode  | type    | currency | amount ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-color-grey | DE    | gross | default | €        | 50.00  ||
    Zed: change concrete product price on:
    ...    || productAbstract          | productConcrete                     | store | mode  | type    | currency | amount ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-color-grey | AT    | gross | default | €        | 75.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract          | productConcrete                     | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || availabilitySKU${random} | availabilitySKU${random}-color-grey | Warehouse1   | 5                | false                           ||
    Zed: update abstract product data:
    ...    || productAbstract          | name de                              ||
    ...    || availabilitySKU${random} | DEavailabilityProduct${random} force ||
    Trigger multistore p&s
    Zed: go to second navigation item level:    Catalog    Products
    Zed: click Action Button in a table for row that contains:     availabilitySKU${random}     Approve
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: check if cart is not empty and clear it
    Yves: delete all user addresses
    Yves: go to PDP of the product with sku:    availabilitySKU${random}    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-color-grey only has availability of 5.
    Yves: go to PDP of the product with sku:    availabilitySKU${random}
    Yves: change quantity on PDP:    3
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_company_user_buyer_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Yves: go to PDP of the product with sku:    availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-color-grey only has availability of 2.
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    skip grace period
    Zed: trigger all matching states inside this order:    Cancel
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:    availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-color-grey only has availability of 5.
    Yves: go to AT store 'Home' page if other store not specified:
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:    availabilitySKU${random}    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: update warehouse:
    ...    || warehouse  | unselect store ||
    ...    || Warehouse1 | AT             ||
    Repeat Keyword    3    Trigger multistore p&s
    Yves: go to AT store 'Home' page if other store not specified:
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to PDP of the product with sku:    availabilitySKU${random}    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: update warehouse:
    ...    || warehouse  | unselect store ||
    ...    || Warehouse1 | AT             ||
    ...    AND    Repeat Keyword    3    Trigger multistore p&s

Configurable_Product_PDP_Wishlist_Availability
    [Tags]    wishlist    configurable-product    configurable-product-wishlist
    [Documentation]    Configure product from PDP and Wishlist + availability case.
    [Setup]    Run keywords   Delete All Cookies
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: create new 'Wishlist' with name:    configProduct${random}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses
    ...    AND    Yves: create a new customer address in profile:     Mr    ${yves_user_first_name}    ${yves_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${configureButton}
    Yves: product price on the PDP should be:    ${configurable_product_price_without_configurations}
    Yves: product configuration status should be equal:      Configuration is not complete.
    Yves: check and go back that configuration page contains:
    ...    || store | locale | price_mode | currency | sku                                  ||
    ...    || DE    | en_US  | GROSS_MODE | EUR      | ${configurable_product_concrete_sku} ||
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 517        | 275        ||
    Yves: product configuration price should be:    ${configurable_product_price_without_configurations}
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: configuration should be equal:
    ...    || option one                 | option two                     ||
    ...    || Option One: Option title 2 | Option Two: Option Two title 4 ||
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 389.50     | 210        ||
    Yves: product configuration price should be:    932.99
    Yves: product configuration notification is:    No item available for your configuration
    Yves: back to PDP and not save configuration
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 607        | 249        ||
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: product price on the PDP should be:    ${configurable_product_price_without_configurations}
    Yves: add product to wishlist:    configProduct${random}    select
    Yves: go to wishlist with name:    configProduct${random}
    Yves: wishlist contains product with sku:    ${configurable_product_concrete_sku}
    Yves: configuration should be equal:
    ...    || option one                 | option two                     ||
    ...    || Option One: Option title 3 | Option Two: Option Two title 3 ||
    Yves: change the product options in configurator to:
    ...    || option one    | option two ||
    ...    || 389.50        | 275        ||
    Yves: product configuration price should be:    ${configurable_product_price_with_options}
    Yves: save product configuration
    Yves: add all available products from wishlist to cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    sku=${configurable_product_concrete_sku}    productName=${configurable_product_name}    productPrice=${configurable_product_price_with_options}
    [Teardown]    Run Keywords    Yves: delete all wishlists
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses
    ...    AND    Delete All Cookies

Configurable_Product_PDP_Shopping_List
    [Tags]    smoke    configurable-product    shopping-lists    configurable-product-shopping-lists
    [Documentation]    Configure products from both the PDP and the Shopping List. Verify the availability of five items. Ensure that products that have not been configured cannot be purchased.
    [Setup]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    ...    AND    Yves: create new 'Shopping Cart' with name:    configProduct+${random}
    ...    AND    Yves: create new 'Shopping List' with name:    configProduct+${random}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${configureButton}
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: add product to the shopping cart
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: checkout is blocked with the following message:    This cart can't be processed. Please configure items inside the cart.
    Yves: delete product from the shopping cart with sku:    ${configurable_product_concrete_sku}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: check and go back that configuration page contains:
    ...    || store | locale | price_mode | currency | customer_id                          | sku                                  ||
    ...    || DE    | en_US  | GROSS_MODE | EUR      | ${yves_company_user_buyer_reference} | ${configurable_product_concrete_sku} ||
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 607        | 275        ||
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 517        | 167        ||
    Yves: product configuration notification is:     Only 5 items available
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: configuration should be equal:
    ...    || option one                 | option two                     ||
    ...    || Option One: Option title 2 | Option Two: Option Two title 1 ||
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item ${configurable_product_concrete_sku} only has availability of 5.
    Yves: go to PDP of the product with sku:   ${configurable_product_abstract_sku}
    Yves: change quantity on PDP:    5
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    configProduct+${random}
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 517        | 249        ||
    Yves: save product configuration
    ### bug: https://spryker.atlassian.net/browse/CC-33647
    Yves: shopping cart contains product with unit price:    ${configurable_product_concrete_sku}    ${configurable_product_name}    €249.00
    Yves: delete product from the shopping cart with name:    ${configurable_product_name}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: add product to the shopping list:    configProduct+${random}
    Yves: go to 'Shopping Lists' page
    Yves: view shopping list with name:    configProduct+${random}
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 607        | 275        ||
    Yves: save product configuration
    Yves: configuration should be equal:
    ...    || option one                 | option two                     ||
    ...    || Option One: Option title 3 | Option Two: Option Two title 4 ||
    Yves: add all available products from list to cart
    Yves: configuration should be equal:
    ...    || option one                 | option two                     ||
    ...    || Option One: Option title 3 | Option Two: Option Two title 4 ||
    Yves: shopping cart contains product with unit price:    ${configurable_product_concrete_sku}    ${configurable_product_name}    €882.00
    [Teardown]    Run Keywords    Yves: delete 'Shopping List' with name:    configProduct+${random}
    ...    AND    Yves: delete 'Shopping Cart' with name:    configProduct+${random}

Configurable_Product_RfQ_OMS
    [Tags]    order-management    marketplace-order-management    configurable-product    reorder    quotation-process    checkout
    [Documentation]    Conf Product in RfQ, OMS, Merchant OMS and reorder.
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: create new Zed user with the following data:    agent_config+${random}@spryker.com   ${default_secure_password}   Config    Product    Root group    This user is an agent in Storefront    en_US
    ...    AND    Zed: deactivate all discounts from Overview page
    Yves: login on Yves with provided credentials:    ${yves_company_user_buyer_email}
    Yves: delete all shopping carts
    Yves: delete all user addresses
    Yves: create new 'Shopping Cart' with name:    confProductCart+${random}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 607        | 275        ||
    Yves: save product configuration
    Yves: add product to the shopping cart
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
    ...    || 517        | 249        ||
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
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €771.90
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: login on Zed with provided credentials:    ${zed_main_merchant_email}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    skip grace period
    Zed: trigger all matching states inside this order:    Pay
    Zed: trigger all matching states inside this order:    skip picking
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
    Yves: go to the shopping cart through the header with name:    ${lastPlacedOrder}
    Yves: 'Shopping Cart' page is displayed
    Yves: product configuration status should be equal:       Configuration is not complete.
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: activate following discounts from Overview page:    	Free mobile phone    20% off cameras products    Free Acer M2610 product    Free delivery    10% off Intel products    5% off white products    Tuesday & Wednesday $5 off 5 or more    10% off $100+    Free smartphone    20% off cameras    Free Acer M2610    Free standard delivery    10% off Intel Core    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order
    ...    AND    Zed: delete Zed user with the following email:    agent_config+${random}@spryker.com

Product_Restrictions
    [Tags]    product-customer-restrictions    product-lists
    [Documentation]    Checks White and Black lists
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create product list with the following assigned category:    list_name=White${random}    list_type=white    category=Smartwatches
    Zed: create product list with the following assigned category:    list_name=Black${random}    list_type=black    category=Smartphones
    Zed: unassign all product lists from merchant relation:    business_unit_owner=Hotel Tommy Berlin    merchant_relation=Hotel Tommy Berlin,Hotel Tommy London
    Zed: assign product list to merchant relation:    business_unit_owner=Hotel Tommy Berlin    merchant_relation=Hotel Tommy Berlin,Hotel Tommy London    product_list=White${random}
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_test_company_user_email}
    Yves: at least one product is/not displayed on the search results page:    search_query=TomTom    expected_visibility=true    wait_for_p&s=true
    Yves: at least one product is/not displayed on the search results page:    search_query=Canon    expected_visibility=false
    Yves: at least one product is/not displayed on the search results page:    search_query=Lenovo    expected_visibility=false
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: unassign all product lists from merchant relation:    business_unit_owner=Hotel Tommy Berlin    merchant_relation=Hotel Tommy Berlin,Hotel Tommy London
    Zed: assign product list to merchant relation:    business_unit_owner=Hotel Tommy Berlin    merchant_relation=Hotel Tommy Berlin,Hotel Tommy London    product_list=Black${random}
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_test_company_user_email}
    Yves: at least one product is/not displayed on the search results page:    search_query=060    expected_visibility=false    wait_for_p&s=true
    Yves: at least one product is/not displayed on the search results page:    search_query=052    expected_visibility=false
    Yves: at least one product is/not displayed on the search results page:    search_query=Canon    expected_visibility=true
    Yves: at least one product is/not displayed on the search results page:    search_query=Lenovo    expected_visibility=true
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: at least one product is/not displayed on the search results page:    search_query=060    expected_visibility=true
    Yves: at least one product is/not displayed on the search results page:    search_query=052    expected_visibility=true
    Yves: at least one product is/not displayed on the search results page:    search_query=Canon    expected_visibility=true
    Yves: at least one product is/not displayed on the search results page:    search_query=Lenovo    expected_visibility=true
    Yves: at least one product is/not displayed on the search results page:    search_query=TomTom    expected_visibility=true
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: unassign all product lists from merchant relation:    business_unit_owner=Hotel Tommy Berlin    merchant_relation=Hotel Tommy Berlin,Hotel Tommy London
    ...    AND    Zed: remove product list with title:    White${random}
    ...    AND    Zed: remove product list with title:    Black${random}
    ...    AND    Trigger multistore p&s

Customer_Specific_Prices
    [Tags]    prices    merchant-custom-prices
    [Documentation]    Checks that product price can be different for different customers
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: perform search by:    ${product_with_merchant_price_abstract_sku}
    Yves: product with name in the catalog should have price:    ${product_with_merchant_price_product_name}    ${product_with_merchant_price_default_price}
    Yves: go to PDP of the product with sku:    ${product_with_merchant_price_abstract_sku}
    Yves: product price on the PDP should be:    ${product_with_merchant_price_default_price}
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${yves_test_company_user_email}
    Yves: create new 'Shopping Cart' with name:    customerPrices+${random}
    Yves: perform search by:    ${product_with_merchant_price_abstract_sku}
    Yves: product with name in the catalog should have price:    ${product_with_merchant_price_product_name}    ${product_with_merchant_price_merchant_price}
    Yves: go to PDP of the product with sku:    ${product_with_merchant_price_abstract_sku}
    Yves: product price on the PDP should be:    ${product_with_merchant_price_merchant_price}
    Yves: add product to the shopping cart
    Yves: go to the shopping cart through the header with name:    customerPrices+${random}
    Yves: shopping cart contains product with unit price:    sku=${product_with_merchant_price_concrete_sku}    productName=${product_with_merchant_price_product_name}    productPrice=${product_with_merchant_price_merchant_price}
    [Teardown]    Yves: delete 'Shopping Cart' with name:    customerPrices+${random}
