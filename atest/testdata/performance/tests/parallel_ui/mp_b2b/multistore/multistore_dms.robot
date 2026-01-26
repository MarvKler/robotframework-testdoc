*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_tree
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/zed_store_steps.robot
Resource    ../../../../resources/steps/products_steps.robot
Resource    ../../../../resources/steps/availability_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/zed_cms_page_steps.robot
Resource    ../../../../resources/steps/catalog_steps.robot
Resource    ../../../../resources/steps/zed_cms_block_steps.robot

*** Test Cases ***
Dynamic_multistore
    [Documentation]    This test should exclusively run for dynamic multi-store scenarios. The test verifies that the user can successfully create a new store, assign a product and CMS page, and register a customer within the new store.
    [Tags]    dms-on
    Create dynamic admin user in DB
    Create dynamic customer in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create new Store:
    ...    || name                                    | locale_iso_code | currency_iso_code | currency_code | currency_iso_code2 | currency_code2 | store_delivery_region | store_context_timezone ||
    ...    || ${random_str_store}_${random_str_store} | en_US           | Euro              | EUR           | Swiss Franc        | CHF            | AT                    | Europe/Berlin          ||
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: wait until store switcher contains:     store=${random_str_store}_${random_str_store}
    Yves: go to AT store 'Home' page if other store not specified:     ${random_str_store}_${random_str_store}
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: update abstract product data:
    ...    || store                                    | productAbstract                     ||
    ...    ||  ${random_str_store}_${random_str_store} | ${one_variant_product_abstract_sku} ||
    Zed: update abstract product price on:
    ...    || productAbstract                      | store                                   | mode  | type    | currency | amount | tax set         ||
    ...    || ${one_variant_product_abstract_sku}  | ${random_str_store}_${random_str_store} | gross | default | €        | 160.00 | Standard Taxes  ||   
    Trigger multistore p&s
    Zed: change concrete product data:
    ...    || productAbstract                     | productConcrete                     | active | searchable en | searchable de ||
    ...    || ${one_variant_product_abstract_sku} | ${one_variant_product_concrete_sku} | true   | true          | true          ||
    Zed: change concrete product price on:
    ...    || productAbstract                     | productConcrete                     | store                                   | mode  | type    | currency | amount ||
    ...    || ${one_variant_product_abstract_sku} | ${one_variant_product_concrete_sku} | ${random_str_store}_${random_str_store} | gross | default | €        | 15.00  ||
    Zed: update warehouse:
    ...    || warehouse  | store                                   || 
    ...    || Warehouse1 | ${random_str_store}_${random_str_store} ||
    Zed: change concrete product stock:
    ...    || productAbstract                     | productConcrete                     | warehouse n1 | warehouse n1 qty | warehouse n1 never out of stock ||
    ...    || ${one_variant_product_abstract_sku} | ${one_variant_product_concrete_sku} | Warehouse1   | 100              | true                            ||
    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract                     | name de                        ||
    ...    || ${one_variant_product_abstract_sku} | DEmanageProduct${random} force ||
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to AT store 'Home' page if other store not specified:    ${random_str_store}_${random_str_store}
    Yves: select currency Euro if other currency not specified
    Yves: create new 'Shopping Cart' with name:    storeCart+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_concrete_sku}
    Yves: product price on the PDP should be:    €15.00
    #### create new cms page and check it in new store on YVES
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create a cms page and publish it:    New Page Store${random}    store-page${random}    Page Title    Page text
    Trigger multistore p&s
    Yves: go to newly created page by URL:    en/store-page${random}
    Yves: page contains CMS element:    CMS Page Title    Page Title
    Yves: page contains CMS element:    CMS Page Content    Page text
    Yves: go to AT store 'Home' page if other store not specified:    ${random_str_store}_${random_str_store}
    Yves: go to newly created page by URL:   en/store-page${random}
    Yves: page contains CMS element:    CMS Page Content    Page text
    ## assigned CMS BLocks to new store
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: assigned store to cms block:    ${random_str_store}_${random_str_store}    customer-registration_token--html
    Zed: assigned store to cms block:    ${random_str_store}_${random_str_store}    customer-registration_token--text
    [Teardown]    Run Keywords    Should Test Run
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Content    Pages
    ...    AND    Zed: click Action Button in a table for row that contains:    New Page Store${random}   Deactivate