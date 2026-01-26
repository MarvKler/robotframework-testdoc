*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_tree
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
Resource    ../../../../resources/steps/zed_store_steps.robot
Resource    ../../../../resources/steps/zed_cms_block_steps.robot

*** Test Cases ***
Multistore_Product_Offer
    [Documentation]    check product and offer multistore functionality
    Repeat Keyword    3    Trigger multistore p&s
    MP: login on MP with provided credentials:    ${merchant_office_king_email}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku            | product name               | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || multistoreSKU${random} | multistoreProduct${random} | packaging_unit       | Item                        | Box                          | material              | Aluminium              ||
    MP: perform search by:    multistoreProduct${random}
    MP: click on a table row that contains:     multistoreProduct${random}
    MP: fill abstract product required fields:
    ...    || product name               | store | store 2 |  tax set       ||
    ...    || multistoreProduct${random} | DE    | AT      | Standard Taxes ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 1           | DE    | EUR      | 100           | 90             ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 2           | AT    | EUR      | 300           | 90             ||
    MP: save abstract product 
    Trigger multistore p&s
    MP: click on a table row that contains:    multistoreProduct${random}
    MP: open concrete drawer by SKU:    multistoreSKU${random}-1
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    MP: open concrete drawer by SKU:    multistoreSKU${random}-1
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 50            ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 2          | AT    | EUR      | 55            ||
    MP: save concrete product
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     multistoreSKU${random}     Approve
    Zed: save abstract product:    multistoreSKU${random}
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}  
    Yves: check if cart is not empty and clear it
    Yves: go to PDP of the product with sku:     multistoreSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    true
    Yves: product price on the PDP should be:    €50.00    wait_for_p&s=true
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    multistoreSKU${random}-1
    MP: click on a table row that contains:    multistoreSKU${random}-1
    MP: fill offer fields:
    ...    || is active | merchant sku                   | store | store 2 | stock quantity ||
    ...    || true      | multistoreMerchantSKU${random} | DE    | AT      | 100            ||
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
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:     multistoreSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    Yves: merchant's offer/product price should be:    Spryker    €200.00
    Yves: go to AT store 'Home' page if other store not specified:
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:     multistoreSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Office King    true
    Yves: product price on the PDP should be:    €55.00    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    Yves: merchant's offer/product price should be:    Spryker    €10.00
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Offers
    MP: perform search by:    multistoreSKU${random}-1
    MP: click on a table row that contains:    multistoreSKU${random}-1
    MP: fill offer fields:
    ...    || is active | unselect store ||
    ...    || true      | AT             ||         
    MP: save offer
    Repeat Keyword    3    Trigger multistore p&s
    Yves: go to AT store 'Home' page if other store not specified:
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to PDP of the product with sku:     multistoreSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    false
    Save current URL
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: update abstract product data:
    ...    || productAbstract        | unselect store ||
    ...    || multistoreSKU${random} | AT             ||
    Repeat Keyword    3    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract        | unselect store ||
    ...    || multistoreSKU${random} | AT             ||
    Repeat Keyword    3    Trigger multistore p&s
    Yves: navigate to specified AT store URL if no other store is specified and refresh until 404 occurs:    ${url}
    [Teardown]    Run Keywords    Should Test Run
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     multistoreSKU${random}     Deny
    ...    AND    Trigger multistore p&s

Multistore_CMS
    [Documentation]    Check CMS multistore functionality
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create a cms page and publish it:    Multistore Page${random}    multistore-page${random}    Multistore Page    Page text
    Trigger multistore p&s
    Yves: go to newly created page by URL on AT store if other store not specified:    en/multistore-page${random}
    Save current URL
    Yves: page contains CMS element:    CMS Page Title    Multistore Page
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: update cms page and publish it:
    ...    || cmsPage                  | unselect store ||
    ...    || Multistore Page${random} | AT             ||
    Trigger multistore p&s
    Yves: navigate to specified AT store URL if no other store is specified and refresh until 404 occurs:    ${url}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Content    Pages
    ...    AND    Zed: click Action Button in a table for row that contains:    Multistore Page${random}    Deactivate
    ...    AND    Trigger multistore p&s

Dynamic_multistore
    [Documentation]    This test should exclusively run for dynamic multi-store scenarios. The test verifies that the user can successfully create a new store, assign a product and CMS page, and register a customer within the new store.
    [Tags]    dms-on
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create new Store:
    ...    || name                                    | locale_iso_code | currency_iso_code | currency_code | currency_iso_code2 | currency_code2 | store_delivery_region | store_context_timezone ||
    ...    || ${random_str_store}_${random_str_store} | en_US           | Euro              | EUR           | Swiss Franc        | CHF            | AT                    | Europe/Berlin          ||
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: wait until store switcher contains:     store=${random_str_store}_${random_str_store}
    Yves: go to AT store 'Home' page if other store not specified:     ${random_str_store}_${random_str_store}
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
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
    Yves: login on Yves with provided credentials:    ${yves_user_email}
    Yves: go to AT store 'Home' page if other store not specified:    ${random_str_store}_${random_str_store}
    Yves: select currency Euro if other currency not specified
    Yves: create new 'Shopping Cart' with name:    storeCart+${random}
    Yves: go to PDP of the product with sku:    ${one_variant_product_concrete_sku}
    Yves: product price on the PDP should be:    €15.00
    #### create new cms page and check it in new store on YVES
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: create a cms page and publish it:    New Page Store${random}    store-page${random}    Page Title    Page text
    Trigger multistore p&s
    Yves: go to newly created page by URL:    en/store-page${random}
    Yves: page contains CMS element:    CMS Page Title    Page Title
    Yves: page contains CMS element:    CMS Page Content    Page text
    Yves: go to AT store 'Home' page if other store not specified:    ${random_str_store}_${random_str_store}
    Yves: go to newly created page by URL:   en/store-page${random}
    Yves: page contains CMS element:    CMS Page Content    Page text
    ## assigned CMS BLocks to new store
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: assigned store to cms block:    ${random_str_store}_${random_str_store}    customer-registration_token--html
    Zed: assigned store to cms block:    ${random_str_store}_${random_str_store}    customer-registration_token--text
    [Teardown]    Run Keywords    Should Test Run
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Content    Pages
    ...    AND    Zed: click Action Button in a table for row that contains:    New Page Store${random}   Deactivate
    ...    AND    Trigger multistore p&s
