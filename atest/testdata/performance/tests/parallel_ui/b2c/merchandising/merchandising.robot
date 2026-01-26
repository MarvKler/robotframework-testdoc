*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_tree
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/catalog_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/product_set_steps.robot
Resource    ../../../../resources/steps/configurable_bundle_steps.robot
Resource    ../../../../resources/steps/orders_management_steps.robot

*** Test Cases ***
Product_labels
    [Documentation]    Checks that products have labels on PLP and PDP
    Trigger product labels update
    Yves: go to first navigation item level:    Sale
    Yves: 1st product card in catalog (not)contains:     Sale label    true
    Yves: go to the PDP of the first product on open catalog page
    Yves: PDP contains/doesn't contain:    true    ${pdp_sales_label}[${env}]
    Yves: go to first navigation item level:    New
    Yves: 1st product card in catalog (not)contains:     New label    true
    Yves: go to PDP of the product with sku:    666
    Yves: PDP contains/doesn't contain:    true    ${pdp_new_label}[${env}]
    [Teardown]    Yves: check if cart is not empty and clear it

Product_Sets
    [Documentation]    Check the usage of product sets.
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to URL:    en/product-sets
    Yves: 'Product Sets' page contains the following sets:    HP Product Set    Sony Product Set    Upgrade your running game
    Yves: view the following Product Set:    Upgrade your running game
    Yves: 'Product Set' page contains the following products:    TomTom Golf    Samsung Galaxy S6 edge
    Yves: change variant of the product on CMS page on:    Samsung Galaxy S6 edge    128 GB
    Yves: add all products to the shopping cart from Product Set
    Yves: go to shopping cart page
    Yves: shopping cart contains the following products:    TomTom Golf    Samsung Galaxy S6 edge
    Yves: delete from b2c cart products with name:    TomTom Golf    Samsung Galaxy S6 edge

Configurable_Bundle
    [Documentation]    Check the usage of configurable bundles (includes authorized checkout). DMS-ON: https://spryker.atlassian.net/browse/FRW-7463
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to URL:    en/configurable-bundle/configurator/template-selection
    Yves: 'Choose Bundle to configure' page is displayed
    Yves: choose bundle template to configure:    Smartstation Kit
    Yves: select product in the bundle slot:    Slot 5    Sony Cyber-shot DSC-W830
    Yves: select product in the bundle slot:    Slot 6    Sony NEX-VG30E
    Yves: go to 'Summary' step in the bundle configurator
    Yves: add products to the shopping cart in the bundle configurator
    Yves: go to URL:    en/configurable-bundle/configurator/template-selection
    Yves: 'Choose Bundle to configure' page is displayed
    Yves: choose bundle template to configure:    Smartstation Kit
    Yves: select product in the bundle slot:    Slot 5    Canon IXUS 165
    Yves: select product in the bundle slot:    Slot 6    Sony HDR-MV1
    Yves: go to 'Summary' step in the bundle configurator
    Yves: add products to the shopping cart in the bundle configurator
    Yves: go to shopping cart page
    Yves: change quantity of the configurable bundle in the shopping cart on:    Smartstation Kit    2
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
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
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: trigger all matching states inside xxx order:    ${lastPlacedOrder}    skip grace period
    Zed: trigger all matching states inside this order:    Pay
    Zed: trigger all matching states inside this order:    Skip timeout
    Zed: trigger all matching states inside this order:    skip picking
    Zed: trigger all matching states inside this order:    Ship
    Zed: trigger all matching states inside this order:    Stock update
    Zed: trigger all matching states inside this order:    Close

Product_Relations
    [Documentation]    Checks related product on PDP and upsell products in cart
    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${product_with_relations_related_products_sku}
    Yves: PDP contains/doesn't contain:    true    ${relatedProducts}
    Yves: go to PDP of the product with sku:    ${product_with_relations_upselling_sku}
    Yves: PDP contains/doesn't contain:    false    ${relatedProducts}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains/doesn't contain the following elements:    true    ${upSellProducts}

CRUD_Product_Set
    [Documentation]    CRUD operations for product sets.
    Create dynamic admin user in DB
    Create dynamic customer in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create new product set:
    ...    || name en            | name de            | url en             | url de             | set key       | active | product | product 2 | product 3 ||
    ...    || test set ${random} | test set ${random} | test-set-${random} | test-set-${random} | test${random} | true   | 005     | 007       | 010       ||
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to newly created page by URL:    en/test-set-${random}
    Yves: 'Product Set' page contains the following products:    Canon IXUS 175
    Yves: 'Product Set' page contains the following products:    Canon IXUS 285
    Yves: 'Product Set' page contains the following products:    Canon IXUS 180
    Yves: add all products to the shopping cart from Product Set
    Yves: shopping cart contains the following products:    Canon IXUS 175
    Yves: shopping cart contains the following products:    Canon IXUS 285
    Yves: shopping cart contains the following products:    Canon IXUS 180
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: delete product set:    test set ${random}
    Trigger multistore p&s
    Yves: go to URL and refresh until 404 occurs:    ${yves_url}en/test-set-${random}
    [Teardown]    Delete dynamic admin user from DB
