*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_one
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/catalog_steps.robot
Resource    ../../../../resources/steps/products_steps.robot

*** Test Cases ***
Volume_Prices
    [Documentation]    Checks that volume prices are applied in cart
    [Setup]    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    M21189
    Yves: change quantity on PDP:    5
    Yves: product price on the PDP should be:    €4.20
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    420685    Post-it stick note Super Sticky Meeting Notes 6445-4SS 4 pieces/pack    4.20

Customer_Specific_Prices
    [Documentation]    Checks that product price can be different for different customers
    [Setup]    Run keywords    Create dynamic customer in DB
    ...    AND    Create dynamic customer in DB    based_on=${yves_company_user_special_prices_customer_email}
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: perform search by:    ${one_variant_product_abstract_name}
    Yves: product with name in the catalog should have price:    ${one_variant_product_abstract_name}    ${one_variant_product_default_price}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: product price on the PDP should be:    ${one_variant_product_default_price}
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${dynamic_second_customer}
    Yves: perform search by:    ${one_variant_product_abstract_name}
    Yves: product with name in the catalog should have price:    ${one_variant_product_abstract_name}    ${one_variant_product_merchant_price}
    Yves: go to PDP of the product with sku:    ${one_variant_product_abstract_sku}
    Yves: product price on the PDP should be:    ${one_variant_product_merchant_price}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    403125    EUROKRAFT hand truck - with open shovel - load capacity 400 kg    188.34

Product_Original_Price
    [Documentation]    checks that Original price is displayed on the PDP and in Catalog
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
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
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
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
    [Teardown]    Delete dynamic admin user from DB