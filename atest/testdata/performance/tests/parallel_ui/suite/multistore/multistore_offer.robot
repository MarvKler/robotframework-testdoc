*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_tree    spryker-core-back-office    marketplace-merchantportal-core    spryker-core    product    marketplace-product-offer-prices    marketplace-merchant-portal-product-offer-management    product-offer-shipment    marketplace-merchant-portal-product-management    marketplace-product-offer    marketplace-product
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/common/common_mp.robot
Resource    ../../../../resources/steps/mp_products_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/mp_offers_steps.robot
Resource    ../../../../resources/steps/products_steps.robot

*** Test Cases ***
Multistore_Product_Offer
    [Tags]    smoke
    [Documentation]    check product and offer multistore functionality.
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Zed: create dynamic merchant user:    Spryker
    ...    AND    Zed: create dynamic merchant user:    Video King
    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku            | product name               | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || multistoreSKU${random} | multistoreProduct${random} | color                | white                       | black                        | series                | Ace Plus               ||
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
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     multistoreProduct${random}     Approve
    Zed: save abstract product:    multistoreProduct${random}
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}  
    Yves: go to PDP of the product with sku:     multistoreSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Yves: product price on the PDP should be:    €50.00    wait_for_p&s=true
    MP: login on MP with provided credentials:    ${dynamic_spryker_merchant}
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
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     multistoreSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    Yves: merchant's offer/product price should be:    Spryker    €200.00
    Yves: go to AT store 'Home' page if other store not specified:
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     multistoreSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Video King    true
    Yves: product price on the PDP should be:    €55.00    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    true
    Yves: merchant's offer/product price should be:    Spryker    €10.00
    MP: login on MP with provided credentials:    ${dynamic_spryker_merchant}
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
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     multistoreSKU${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    Spryker    false
    Save current URL
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: update abstract product data:
    ...    || productAbstract        | unselect store ||
    ...    || multistoreSKU${random} | AT             ||
    Repeat Keyword    3    Trigger multistore p&s
    Zed: update abstract product data:
    ...    || productAbstract        | unselect store ||
    ...    || multistoreSKU${random} | AT             ||
    Repeat Keyword    3    Trigger multistore p&s
    Yves: navigate to specified AT store URL if no other store is specified and refresh until 404 occurs:    ${url}
    [Teardown]    Delete dynamic admin user from DB