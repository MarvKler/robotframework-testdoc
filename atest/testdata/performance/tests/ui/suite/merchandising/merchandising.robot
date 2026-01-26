*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_tree    spryker-core-back-office   spryker-core    inventory-management
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
Resource    ../../../../resources/steps/configurable_bundle_steps.robot

*** Test Cases ***
Product_labels
    [Tags]    smoke    product-labels    search    catalog
    [Documentation]    Checks that products have labels on PLP and PDP
    Trigger product labels update
    Yves: go to first navigation item level:    Sale
    Yves: 1st product card in catalog (not)contains:     Sale label    true
    Yves: go to the PDP of the first product on open catalog page
    Yves: PDP contains/doesn't contain:    true    ${pdp_sales_label}[${env}]
    Yves: go to first navigation item level:    New
    Yves: 1st product card in catalog (not)contains:     New label    true
    Yves: go to the PDP of the first product on open catalog page
    Yves: PDP contains/doesn't contain:    true    ${pdp_new_label}[${env}]
    [Teardown]    Yves: check if cart is not empty and clear it

Product_Sets
    [Tags]    product-sets    cart
    [Documentation]    Check the usage of product sets
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to URL:    en/product-sets
    Yves: 'Product Sets' page contains the following sets:    HP Product Set    Sony Product Set    TomTom Runner Product Set
    Yves: view the following Product Set:    TomTom Runner Product Set
    Yves: 'Product Set' page contains the following products:    TomTom Golf    Samsung Galaxy S6 edge
    Yves: change variant of the product on CMS page on:    Samsung Galaxy S6 edge    128 GB
    Yves: add all products to the shopping cart from Product Set
    Yves: go to shopping cart page
    Yves: shopping cart contains the following products:     052_30614390    096_30856274
    Yves: delete product from the shopping cart with sku:    052_30614390
    Yves: delete product from the shopping cart with sku:    096_30856274
    [Teardown]    Yves: check if cart is not empty and clear it

CRUD_Product_Set
    [Tags]    smoke    product    product-sets    cart
    [Documentation]    CRUD operations for product sets. DMS-ON: https://spryker.atlassian.net/browse/FRW-7393 
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create new product set:
    ...    || name en            | name de            | url en             | url de             | set key       | active | product | product 2 | product 3 ||
    ...    || test set ${random} | test set ${random} | test-set-${random} | test-set-${random} | test${random} | true   | 005     | 007       | 010       ||
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: check if cart is not empty and clear it
    Yves: go to newly created page by URL:    en/test-set-${random}
    Yves: 'Product Set' page contains the following products:    Canon IXUS 175
    Yves: 'Product Set' page contains the following products:    Canon IXUS 285
    Yves: 'Product Set' page contains the following products:    Canon IXUS 180
    Yves: add all products to the shopping cart from Product Set
    Yves: shopping cart contains the following products:    005_30663301
    Yves: shopping cart contains the following products:    007_30691822
    Yves: shopping cart contains the following products:    010_30692994
    Yves: check if cart is not empty and clear it
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: delete product set:    test set ${random}
    Trigger multistore p&s
    Yves: go to URL and refresh until 404 occurs:    ${yves_url}en/test-set-${random}

Configurable_Bundle
    [Tags]    smoke    product    configurable-bundle    cart    checkout    shipment    order-management
    [Documentation]    Check the usage of configurable bundles (includes authorized checkout)
    Yves: login on Yves with provided credentials:    ${yves_default_user_email}
    Yves: check if cart is not empty and clear it
    Yves: go to URL:    en/configurable-bundle/configurator/template-selection
    Yves: 'Choose Bundle to configure' page is displayed
    Yves: choose bundle template to configure:    Smartstation Kit
    Yves: select product in the bundle slot:    Slot 5    130_24725761
    Yves: select product in the bundle slot:    Slot 6    042_31040075
    Yves: go to 'Summary' step in the bundle configurator
    Yves: add products to the shopping cart in the bundle configurator
    Yves: go to URL:    en/configurable-bundle/configurator/template-selection
    Yves: 'Choose Bundle to configure' page is displayed
    Yves: choose bundle template to configure:    Smartstation Kit
    Yves: select product in the bundle slot:    Slot 5    121_29406823
    Yves: select product in the bundle slot:    Slot 6    043_31040074
    Yves: go to 'Summary' step in the bundle configurator
    Yves: add products to the shopping cart in the bundle configurator
    Yves: go to shopping cart page
    Yves: change quantity of the configurable bundle in the shopping cart on:    Smartstation Kit    2
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${yves_default_user_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: go to user menu:    Orders History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page is displayed
    Yves: 'Order Details' page contains the following product title N times:    Smartstation Kit    3
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    skip grace period
    Zed: trigger all matching states inside this order:    Pay
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: trigger all matching states inside this order:    skip picking
    Zed: trigger all matching states inside this order:    Ship
    Zed: trigger all matching states inside this order:    Stock update
    Zed: trigger all matching states inside this order:    Close
    [Teardown]    Run Keywords    Yves: login on Yves with provided credentials:    ${yves_default_user_email}
    ...    AND    Yves: check if cart is not empty and clear it

Product_Relations
    [Tags]    product-relations    product    cart
    [Documentation]    Checks related product on PDP and upsell products in cart
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:    ${product_with_relations_related_products_sku}
    Yves: PDP contains/doesn't contain:    true    ${relatedProducts}
    Yves: go to PDP of the product with sku:    ${product_with_relations_upselling_sku}
    Yves: PDP contains/doesn't contain:    false    ${relatedProducts}
    Yves: add product to the shopping cart
    Yves: shopping cart contains/doesn't contain the following elements:    true    ${upSellProducts}
    [Teardown]    Yves: check if cart is not empty and clear it

Discounts
    [Tags]    smoke    promotions-discounts    marketplace-promotions-discounts    cart    checkout    order-management    prices
    [Documentation]    Discounts, Promo Products, and Coupon Codes (includes guest checkout)
    [Setup]    Run keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate all discounts from Overview page
    ...    AND    Zed: change product stock:    190    190_25111746    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_1_abstract_sku}    ${bundled_product_1_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_2_abstract_sku}    ${bundled_product_2_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_3_abstract_sku}    ${bundled_product_3_concrete_sku}    true    10
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create a discount and activate it:    voucher    Percentage    5    sku = '*'    test${random}    discountName=Voucher Code 5% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    10    sku = '*'    discountName=Cart Rule 10% ${random}
    Zed: create a discount and activate it:    cart rule    Percentage    100    discountName=Promotional Product 100% ${random}    promotionalProductDiscount=True    promotionalProductAbstractSku=002    promotionalProductQuantity=2
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: delete all user addresses
    Yves: create a new customer address in profile:     Mr    ${yves_user_first_name}    ${yves_user_last_name}    Kirncher Str.    7    10247    Berlin    Germany
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:    190
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to shopping cart page
    Yves: apply discount voucher to cart:    test${random}
    Yves: discount is applied:    voucher    Voucher Code 5% ${random}    - €8.73
    Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €17.46
    Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: discount is applied:    cart rule    Cart Rule 10% ${random}    - €87.96
    Yves: promotional product offer is/not shown in cart:    true
    Yves: add promotional product to the cart
    Yves: shopping cart contains the following products:    190_25111746    002_25904004
    Yves: discount is applied:    cart rule    Promotional Product 100% ${random}    - €75.00
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: select xxx shipment type on checkout:    Delivery
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping':    ${yves_user_address}
    Yves: select xxx shipment type on checkout:    Delivery
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Spryker Dummy Shipment    Standard
    Yves: select the following shipping method for the shipment:    2    Spryker Dummy Shipment    Express
    Yves: select the following shipping method for the shipment:    3    Spryker Drone Shipment    Air Light
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €773.45
    [Teardown]    Run keywords    Yves: login on Yves with provided credentials:    ${yves_user_email}
    ...    AND    Yves: check if cart is not empty and clear it
    ...    AND    Yves: delete all user addresses
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: deactivate following discounts from Overview page:    Voucher Code 5% ${random}    Cart Rule 10% ${random}    Promotional Product 100% ${random}
    ...    AND    Zed: activate following discounts from Overview page:    	Free mobile phone    20% off cameras products    Free Acer M2610 product    Free delivery    10% off Intel products    5% off white products    Tuesday & Wednesday $5 off 5 or more    10% off $100+    Free smartphone    20% off cameras    Free Acer M2610    Free standard delivery    10% off Intel Core    5% off white    Tu & Wed €5 off 5 or more    10% off minimum order
    ...    AND    Trigger p&s
