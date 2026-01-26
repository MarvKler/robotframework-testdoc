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
Resource    ../../../../resources/steps/mp_offers_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/mp_profile_steps.robot
Resource    ../../../../resources/pages/yves/yves_merchant_profile.robot

*** Test Cases ***
Merchant_Profile_Set_to_Offline_from_MP
    [Documentation]    Checks that merchant is able to set store offline and then his profile, products and offers won't be displayed on Yves
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create new Merchant with the following data:
    ...    || merchant name            | merchant reference                 | e-mail                             | store | store 2 | en url                   | de url                   | approved | contact_first_name  | contact_last_name  ||
    ...    || offline_from_MP${random} | offline_from_MP_reference${random} | offline_from_MP+${random}@test.com | DE    | AT      | offline-from-mp${random} | offline-from-mp${random} | true     | FirstOffMP${random} | LastOffMP${random} ||
    Zed: create dynamic merchant user:    offline_from_MP${random}    merchant_user_email=sonia+offline+mp${random}@spryker.com
    Zed: create dynamic merchant user:    Spryker
    MP: login on MP with provided credentials:    ${dynamic_spryker_merchant}
    MP: open navigation menu tab:    Products    
    MP: click on create new entity button:    Create Product
    MP: create multi sku product with following data:
    ...    || product sku        | product name       | first attribute name | first attribute first value | first attribute second value | second attribute name | second attribute value ||
    ...    || offlineMP${random} | offlineMP${random} | color                | white                       | black                        | series                | Ace Plus               ||
    MP: perform search by:    offlineMP${random}
    MP: click on a table row that contains:     offlineMP${random}
    MP: fill abstract product required fields:
    ...    || product name       | store | tax set           ||
    ...    || offlineMP${random} | DE    | Smart Electronics ||
    MP: fill product price values:
    ...    || product type | row number | store | currency | gross default ||
    ...    || abstract     | 1          | DE    | EUR      | 100           ||
    MP: save abstract product 
    Trigger multistore p&s
    MP: click on a table row that contains:    offlineMP${random}
    MP: open concrete drawer by SKU:    offlineMP${random}-2
    MP: fill concrete product fields:
    ...    || is active | stock quantity | use abstract name | searchability ||
    ...    || true      | 100            | true              | en_US         ||
    MP: login on MP with provided credentials:    sonia+offline+mp${random}@spryker.com    ${default_secure_password}
    MP: open navigation menu tab:    Offers
    MP: click on create new entity button:    Add Offer
    MP: perform search by:    offlineMP${random}-2
    MP: click on a table row that contains:    offlineMP${random}-2
    MP: fill offer fields:
    ...    || is active | merchant sku            | store | stock quantity ||
    ...    || true      | offlineMPoffer${random} | DE    | 100            ||
    MP: add offer price:
    ...    || row number | store | currency | gross default ||
    ...    || 1          | DE    | EUR      | 200           ||
    MP: save offer
    Repeat Keyword    3    Trigger multistore p&s
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Catalog    Products 
    Zed: click Action Button in a table for row that contains:     offlineMP${random}     Approve
    Zed: save abstract product:    offlineMP${random}
    Repeat Keyword    3    Trigger multistore p&s
    Yves: go to newly created page by URL:    url=en/merchant/offline-from-mp${random}    delay=5s    iterations=26
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    offlineMP${random}    wait_for_p&s=true
    Yves: merchant is (not) displaying in Sold By section of PDP:    offline_from_MP${random}    true
    MP: login on MP with provided credentials:    sonia+offline+mp${random}@spryker.com    ${default_secure_password}
    MP: open navigation menu tab:    Profile
    MP: open profile tab:    Online Profile
    MP: change store status to:    offline
    Repeat Keyword    3    Trigger multistore p&s
    Yves: go to URL:    en/merchant/offline-from-mp${random}
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: try reloading page if element is/not appear:    ${merchant_profile_main_content_locator}    false
    Yves: go to PDP of the product with sku:    offlineMP${random}
    Yves: merchant is (not) displaying in Sold By section of PDP:    offline_from_MP${random}    false
    [Teardown]    Delete dynamic admin user from DB