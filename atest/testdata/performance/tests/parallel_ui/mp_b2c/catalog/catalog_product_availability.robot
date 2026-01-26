*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_one
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/common/common_mp.robot
Resource    ../../../../resources/steps/mp_products_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../resources/steps/availability_steps.robot

*** Test Cases ***
Product_Availability_Calculation
    [Documentation]    Check product availability + multistore. DMS-ON: https://spryker.atlassian.net/browse/FRW-7477
    [Setup]    Run Keywords    Repeat Keyword    3    Trigger multistore p&s
    ...    AND    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Zed: create dynamic merchant user:    Spryker
    ...    AND    Zed: create dynamic merchant user:    merchant=Spryker    merchant_user_group=Root group
    MP: login on MP with provided credentials:    ${dynamic_spryker_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku              | product name                 | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || availabilitySKU${random} | availabilityProduct${random} | packaging_unit       | Item                        | Box                          | series                | Ace Plus               ||
    MP: perform search by:    availabilityProduct${random}
    MP: click on a table row that contains:     availabilityProduct${random}
    MP: fill abstract product required fields:
    ...    || product name                 | store | store 2 | tax set           ||
    ...    || availabilityProduct${random} | DE    | AT      | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 1           | DE    | EUR      | 100           | 90             ||
    MP: fill product price values:
    ...    || product type | row number  | store | currency | gross default | gross original ||
    ...    || abstract     | 2           | AT    | EUR      | 200           | 90             ||
    MP: save abstract product 
    Trigger multistore p&s
    MP: click on a table row that contains:    availabilityProduct${random}
    MP: open concrete drawer by SKU:    availabilitySKU${random}-1
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 5              | true              | en_US         ||
    MP: open concrete drawer by SKU:    availabilitySKU${random}-1
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 1          | DE    | EUR      | 50            ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || concrete     | 2          | AT    | EUR      | 50            || 
    MP: save concrete product
    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     availabilityProduct${random}     Approve
    Zed: save abstract product:    availabilityProduct${random}
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}   
    Yves: go to PDP of the product with sku:     availabilitySKU${random}    wait_for_p&s=true
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-1 only has availability of 5.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: assert merchant of product in b2c cart:    availabilityProduct${random}    Spryker
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method for the shipment:    1    DHL    Express
    Yves: submit form on the checkout
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    Trigger oms
    Yves: get the last placed order ID by current customer
    Yves: go to PDP of the product with sku:     availabilitySKU${random}
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-1 only has availability of 2.
    Zed: login on Zed with provided credentials:    ${dynamic_spryker_second_merchant}
    Zed: go to order page:    ${lastPlacedOrder}
    Zed: trigger all matching states inside this order:    skip grace period
    Zed: trigger all matching states inside this order:    Pay
    Zed: go to my order page:    ${lastPlacedOrder}
    Zed: trigger matching state of xxx merchant's shipment:    1    Cancel
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:     availabilitySKU${random}
    Yves: change quantity using '+' or '-' button № times:    +    5
    Yves: try add product to the cart from PDP and expect error:    Item availabilitySKU${random}-1 only has availability of 5.
    Yves: change quantity using '+' or '-' button № times:    +    2
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: assert merchant of product in b2c cart:    availabilityProduct${random}    Spryker
    Yves: go to AT store 'Home' page if other store not specified:
    Trigger multistore p&s
    Yves: go to PDP of the product with sku:     availabilitySKU${random}    wait_for_p&s=true
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Zed: login on Zed with provided credentials:    ${dynamic_spryker_second_merchant}
    Zed: update warehouse:    
    ...    || warehouse                                         | unselect store || 
    ...    || Spryker ${merchant_spryker_reference} Warehouse 1 | AT             ||
    Trigger multistore p&s
    Yves: go to AT store 'Home' page if other store not specified:
    Yves: go to PDP of the product with sku:     availabilitySKU${random}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
    [Teardown]    Run Keywords    Should Test Run
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Catalog    Products 
    ...    AND    Zed: click Action Button in a table for row that contains:      availabilitySKU${random}     Deny
    ...    AND    Zed: update warehouse:    
    ...    || warehouse                                         | store || 
    ...    || Spryker ${merchant_spryker_reference} Warehouse 1 | AT    ||
    ...    AND    Delete dynamic admin user from DB