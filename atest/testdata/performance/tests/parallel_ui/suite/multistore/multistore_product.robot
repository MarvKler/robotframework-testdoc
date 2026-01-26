*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_tree    spryker-core-back-office    marketplace-merchantportal-core    spryker-core    product    marketplace-merchant-portal-product-management    marketplace-product    cart
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/products_steps.robot
Resource    ../../../../resources/steps/catalog_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot

*** Test Cases ***
Multistore_Product
    [Documentation]    check product multistore functionality
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: start new abstract product creation:
    ...    || sku               | store | store 2 | name en               | name de                 | new from   | new to     ||
    ...    || multiSKU${random} | DE    | AT      | multiProduct${random} | DEmultiProduct${random} | 01.01.2020 | 01.01.2030 ||
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
    ...    || productAbstract   | productConcrete              | active | searchable en | searchable de ||
    ...    || multiSKU${random} | multiSKU${random}-color-grey | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract   | productConcrete              | store | mode  | type    | currency | amount ||
    ...    || multiSKU${random} | multiSKU${random}-color-grey | DE    | gross | default | €        | 15.00  ||
    Zed: change concrete product price on:
    ...    || productAbstract   | productConcrete              | store | mode  | type    | currency | amount ||
    ...    || multiSKU${random} | multiSKU${random}-color-grey | AT    | gross | default | €        | 25.00  ||
    Zed: change concrete product stock:
    ...    || productAbstract   | productConcrete              | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || multiSKU${random} | multiSKU${random}-color-grey | Warehouse2   | 100              | true                            ||
    Zed: update abstract product data:
    ...    || productAbstract   | name de                        ||
    ...    || multiSKU${random} | DEmultiProduct${random} forced ||
    Trigger multistore p&s
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     multiSKU${random}     Approve
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to URL:    en/search?q=multiSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: 1st product card in catalog (not)contains:     Price    €100.00
    Yves: go to PDP of the product with sku:    multiSKU${random}    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    Yves: go to AT store 'Home' page if other store not specified:
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to AT store URL if other store not specified:    en/search?q=multiSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: 1st product card in catalog (not)contains:     Price    €200.00
    Yves: go to PDP of the product with sku:    multiSKU${random}    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product price on the PDP should be:    €25.00    wait_for_p&s=true
    Save current URL
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    multiSKU${random}-color-grey    multiProduct${random}    25.00
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: update abstract product data:
    ...    || productAbstract   | unselect store ||
    ...    || multiSKU${random} | AT             ||
    Repeat Keyword    3    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract   | unselect store ||
    ...    || multiSKU${random} | AT             ||
    Repeat Keyword    3    Trigger multistore p&s
    Yves: navigate to specified AT store URL if no other store is specified and refresh until 404 occurs:    ${url}
    [Teardown]    Delete dynamic admin user from DB