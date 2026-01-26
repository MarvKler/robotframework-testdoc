*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_one    marketplace-merchantportal-core    spryker-core-back-office    spryker-core    cart    marketplace-product-offer-prices    marketplace-product-offer    marketplace-merchant    marketplace-product    checkout    
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/mp_offers_steps.robot
Resource    ../../../../resources/steps/mp_products_steps.robot
Resource    ../../../../resources/steps/zed_marketplace_steps.robot

*** Test Cases ***
Click_and_collect
    [Tags]    smoke    group_one
    [Documentation]    checks that product offer is successfully replaced with a target product offer
    [Setup]    Run keywords    Deactivate all discounts in the database
    ...    AND    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: create dynamic merchant user:    Spryker
    ...    AND    Zed: create dynamic merchant user:    Budget Cameras
    MP: login on MP with provided credentials:    ${dynamic_spryker_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku              | product name                 | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || clickCollectSku${random} | clickCollectProduct${random} | color                | white                       | black                        | series                | Ace Plus               ||
    MP: perform search by:    clickCollectProduct${random} 
    MP: click on a table row that contains:     clickCollectSku${random}
    MP: fill abstract product required fields:
    ...    || product name                 | store | tax set           ||
    ...    || clickCollectProduct${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || abstract     | 1          | DE    | EUR      | 50            ||
    MP: save abstract product
    MP: click on a table row that contains:    clickCollectSku${random}
    MP: open concrete drawer by SKU:    clickCollectSku${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     clickCollectSku${random}     Approve
    Zed: save abstract product:    clickCollectSku${random}
    Trigger p&s 
    MP: login on MP with provided credentials:    ${dynamic_budget_merchant}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    clickCollectSku${random}-2
    MP: click on a table row that contains:    clickCollectSku${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku                           | store | stock quantity | service point      | services | shipment types  ||
    ...    || true      | clickCollectFirstSku${random}${random} | DE    | 100            | Spryker Main Store | Pickup   | pickup - Pickup ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | EUR      | 100           ||
    MP: save offer
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    clickCollectSku${random}-2
    MP: click on a table row that contains:    clickCollectSku${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku                            | store | stock quantity | shipment types      ||
    ...    || true      | clickCollectSecondSku${random}${random} | DE    | 100            | delivery - Delivery ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | EUR      | 150           ||
    MP: save offer
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    clickCollectSku${random}-2
    MP: click on a table row that contains:    clickCollectSku${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku                  | store | stock quantity | service point        | services | shipment types  ||
    ...    || true      | clickCollectThirdSku${random} | DE    | 100            | Spryker Berlin Store | Pickup   | pickup - Pickup ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | EUR      | 200           ||
    MP: save offer
    Trigger p&s
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Marketplace    Offers
    Zed: filter by merchant:    Budget Cameras
    Zed: table should contain:    clickCollectSku${random}-2
    Zed: click Action Button in a table for row that contains:     clickCollectSku${random}-2     View
    Zed: view offer page is displayed
    Zed: view offer product page contains:
    ...    || approval status | status | store | sku                        | merchant       | merchant sku                  | services                      | shipment types  ||
    ...    || Approved        | Active | DE    | clickCollectSku${random}-2 | Budget Cameras | clickCollectThirdSku${random} | Spryker Berlin Store - Pickup | pickup - Pickup ||
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     clickCollectSku${random}    wait_for_p&s=true
    Yves: select xxx merchant's offer with price:    Budget Cameras    €100.00    wait_for_p&s=true
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to PDP of the product with sku:     clickCollectSku${random}
    Yves: select xxx merchant's offer with price:    Budget Cameras    €150.00
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: select multiple addresses from toggler
    Yves: select xxx shipment type for item number xxx:    shipment_type=Pickup    item_number=1
    Yves: select xxx shipment type for item number xxx:    shipment_type=Pickup    item_number=2
    Yves: check store availability for item number xxx:
    ...    || item_number | store              | availability ||
    ...    || 1           | Spryker Main Store | green        ||
    Yves: check store availability for item number xxx:
    ...    || item_number | store                | availability ||
    ...    || 1           | Spryker Berlin Store | green        ||
    Yves: check store availability for item number xxx:
    ...    || item_number | store              | availability ||
    ...    || 2           | Spryker Main Store | green        ||
    Yves: check store availability for item number xxx:
    ...    || item_number | store                | availability ||
    ...    || 2           | Spryker Berlin Store | green        ||
    Yves: select pickup service point store for item number xxx:
    ...    || item_number | store                ||
    ...    || 1           | Spryker Berlin Store ||
    Yves: select pickup service point store for item number xxx:
    ...    || item_number | store                ||
    ...    || 2           | Spryker Berlin Store ||
    Yves: 'billing same as shipping' checkbox should be displayed:    false
    Yves: fill in the following new billing address:
    ...    || salutation | firstName | lastName | street         | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | First     | Last     | Billing Street | 123         | 10247    | Berlin | Germany | Spryker | 987654321 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    Pickup    Free Pickup
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: checkout summary step contains product with unit price:    productName=clickCollectProduct${random}    productPrice=200.00
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Yves: get the last placed order ID by current customer
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: grand total for the order equals:    ${lastPlacedOrder}    €400.00
    Zed: order has the following number of shipments:    ${lastPlacedOrder}    1    15s
    Zed: billing address for the order should be:    First Last, Billing Street 123, 10247 Berlin, Germany
    Zed: shipping address inside xxx shipment should be:    1    Spryker Berlin Store, Ms Dynamic, Customer, Julie-Wolfthorn-Straße, 1, 10115, Berlin, Germany
    Zed: shipment data inside xxx shipment should be:
    ...    || shipment n | delivery method | shipping method | shipping costs | requested delivery date ||
    ...    || 1          | Pickup          | Free Pickup     | €0.00          | ASAP                    ||
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:     clickCollectSku${random}     Deny