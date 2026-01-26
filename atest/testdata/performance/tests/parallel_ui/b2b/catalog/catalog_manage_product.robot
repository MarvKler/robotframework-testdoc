*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_one
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/common/common_zed.robot
Resource    ../../../../resources/steps/products_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot

*** Test Cases ***
Manage_Product
    [Documentation]    checks that BO user can manage abstract and concrete products + create new
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
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
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
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
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
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
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
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
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    manageSKU${random}-farbe-black    ENaddedConcrete${random}    25.00
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products
    Zed: click Action Button in a table for row that contains:     manageProduct${random}     View
    Zed: view product page is displayed
    Zed: view abstract product page contains:
    ...    || store | sku                | name                            | variants count ||
    ...    || DE AT | manageSKU${random} | ENUpdatedmanageProduct${random} | 3              ||
    [Teardown]    Delete dynamic admin user from DB