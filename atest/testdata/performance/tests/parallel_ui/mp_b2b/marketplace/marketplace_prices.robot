*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_two
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/common/common_mp.robot
Resource    ../../../../resources/steps/mp_products_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/catalog_steps.robot

*** Test Cases ***
Merchant_Portal_Customer_Specific_Prices
    [Documentation]    Checks that customer will see product/offer prices specified by merchant for his business unit
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB    based_on=${yves_company_user_custom_merchant_prices_email}
    ...    AND    Zed: create dynamic merchant user:    Spryker
    MP: login on MP with provided credentials:    ${dynamic_spryker_merchant}
    MP: open navigation menu tab:    Products
    MP: perform search by:    ${one_variant_product_of_main_merchant_abstract_sku}
    MP: click on a table row that contains:    ${one_variant_product_of_main_merchant_abstract_sku}
    MP: open concrete drawer by SKU:    ${one_variant_product_of_main_merchant_concrete_sku}
    MP: fill product price values:
    ...    || product type | row number | customer                  | store | currency | gross default ||
    ...    || concrete     | 1          | 5 - Spryker Systems GmbH  | DE    | EUR      | 100           ||
    MP: save concrete product
    Trigger p&s
    Yves: login on Yves with provided credentials:     ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${one_variant_product_of_main_merchant_abstract_sku}
    Yves: merchant's offer/product price should be:    Spryker     €100.00
    MP: login on MP with provided credentials:    ${merchant_spryker_email}
    MP: open navigation menu tab:    Products
    MP: perform search by:    ${one_variant_product_of_main_merchant_abstract_sku}
    MP: click on a table row that contains:    ${one_variant_product_of_main_merchant_abstract_sku}
    MP: open concrete drawer by SKU:    ${one_variant_product_of_main_merchant_concrete_sku}
    MP: delete product price row that contains text:    5 - Spryker Systems GmbH
    MP: save concrete product
    Trigger p&s
    Yves: login on Yves with provided credentials:     ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${one_variant_product_of_main_merchant_abstract_sku}
    Yves: merchant's offer/product price should be:    Spryker     €632.12
    [Teardown]    Delete dynamic admin user from DB

Merchant_Product_Original_Price
    [Documentation]    checks that Original price is displayed on the PDP and in Catalog
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Zed: create dynamic merchant user:    Office King
    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku          | product name             | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || originalSKU${random} | originalProduct${random} | packaging_unit       | Item                        | Box                          | material              | Aluminium              ||
    MP: perform search by:    originalProduct${random}
    MP: click on a table row that contains:     originalProduct${random}
    MP: fill abstract product required fields:
    ...    || product name             | store | tax set        ||
    ...    || originalProduct${random} | DE    | Standard Taxes ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original  ||
    ...    || abstract     | 1           | DE    | EUR      | 100           | 150             ||
    MP: save abstract product 
    MP: click on a table row that contains:    originalProduct${random}
    MP: open concrete drawer by SKU:    originalSKU${random}-1
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    MP: open concrete drawer by SKU:    originalSKU${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 3              | true              | en_US         ||
    MP: open concrete drawer by SKU:    originalSKU${random}-1
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 50            ||
    MP: save concrete product
    MP: open concrete drawer by SKU:    originalSKU${random}-2
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 20            ||
    MP: save concrete product
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     originalProduct${random}     Approve
    Zed: save abstract product:    originalProduct${random}
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}   
    Yves: go to URL:    en/search?q=originalSKU${random}
    Try reloading page until element is/not appear:    ${catalog_product_card_locator}    true    21    5s
    Yves: 1st product card in catalog (not)contains:     Price    €100.00
    Yves: 1st product card in catalog (not)contains:     Original Price    €150.00
    Yves: go to PDP of the product with sku:     originalSKU${random}    wait_for_p&s=true
    Yves: product price on the PDP should be:    €100.00    wait_for_p&s=true
    Yves: product original price on the PDP should be:    €150.00
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     originalSKU${random}     Deny
    ...    AND    Delete dynamic admin user from DB