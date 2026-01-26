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
Resource    ../../../../resources/steps/customer_registration_steps.robot

*** Test Cases ***
Multistore_Product
    [Documentation]    check product multistore functionality
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
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
    Repeat Keyword    3    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: go to URL:    en/search?q=multiSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: 1st product card in catalog (not)contains:     Price    €100.00
    Yves: go to PDP of the product with sku:    multiSKU${random}    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product price on the PDP should be:    €15.00    wait_for_p&s=true
    Yves: go to AT store 'Home' page if other store not specified:
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    Yves: check if cart is not empty and clear it
    Yves: go to AT store URL if other store not specified:    en/search?q=multiSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: 1st product card in catalog (not)contains:     Price    €200.00
    Yves: go to PDP of the product with sku:    multiSKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: product price on the PDP should be:    €25.00    wait_for_p&s=true
    Save current URL
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    multiSKU${random}-color-grey    multiProduct${random}    25.00
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    Zed: update abstract product data:
    ...    || productAbstract   | unselect store ||
    ...    || multiSKU${random} | AT             ||
    Repeat Keyword    3    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract   | unselect store ||
    ...    || multiSKU${random} | AT             ||
    Repeat Keyword    3    Trigger multistore p&s
    Yves: navigate to specified AT store URL if no other store is specified and refresh until 404 occurs:    ${url}
    [Teardown]    Run Keywords    Should Test Run
    ...    AND    Yves: go to AT store 'Home' page if other store not specified:
    ...    AND    Yves: login on Yves with provided credentials:    ${yves_second_user_email}
    ...    AND    Yves: check if cart is not empty and clear it

Multistore_CMS
    [Documentation]    check CMS multistore functionality
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
    Yves: navigate to specified AT store URL if no other store is specified and refresh until 404 occurs:    ${url}
    [Teardown]    Run Keywords    Should Test Run
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
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
    ...    || productAbstract                      | store                                   | mode  | type    | currency | amount | tax set            ||
    ...    || ${one_variant_product_abstract_sku}  | ${random_str_store}_${random_str_store} | gross | default | €        | 160.00 | Smart Electronics  ||
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
    Yves: go to PDP of the product with sku:    ${one_variant_product_concrete_sku}
    Yves: product price on the PDP should be:    €15.00
    ### create new cms page and check it in new store on YVES
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
    ## register new customer in the new store on YVES
    Yves: go to AT store 'Home' page if other store not specified:    ${random_str_store}_${random_str_store}
    Register a new customer with data:
    ...    || salutation | first name | last name | e-mail                         | password                   ||
    ...    || Mr.        | New        | User      | sonia+dms${random}@spryker.com | ${default_secure_password} ||
    Yves: flash message should be shown:    success    Almost there! We send you an email to validate your email address. Please confirm it to be able to log in.
    [Teardown]    Run Keywords    Should Test Run
    ...    AND    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: go to second navigation item level:    Content    Pages
    ...    AND    Zed: click Action Button in a table for row that contains:    New Page Store${random}   Deactivate
    ...    AND    Zed: delete customer:    sonia+ui+dms${random}@spryker.com
    ...    AND    Trigger multistore p&s