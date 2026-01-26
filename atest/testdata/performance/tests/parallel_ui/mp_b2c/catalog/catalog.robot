*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_one
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/catalog_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/products_steps.robot
Resource    ../../../../resources/steps/zed_availability_steps.robot
Resource    ../../../../resources/steps/configurable_product_steps.robot

*** Test Cases ***
Catalog
    [Documentation]    Checks that catalog options and search work
    Trigger multistore p&s
    Yves: go to the 'Home' page
    Yves: perform search by:    canon
    Yves: 'Catalog' page should show products:    29
    Yves: select filter value:    Color    blue
    Yves: 'Catalog' page should show products:    2
    Yves: go to first navigation item level:    Computers
    Yves: 'Catalog' page should show products:    72
    Yves: page contains CMS element:    Product Slider    Top Sellers
    Yves: page contains CMS element:    Banner    Computers
    Yves: change sorting order on catalog page:    Sort by price ascending
    Yves: 1st product card in catalog (not)contains:     Price    €18.79
    Yves: change sorting order on catalog page:    Sort by price descending
    Yves: 1st product card in catalog (not)contains:      Price    €3,456.99
    Yves: go to catalog page:    2
    Yves: catalog page contains filter:    Price    Ratings     Label     Brand    Color    Merchant
    Yves: select filter value:    Color    blue
    Yves: 'Catalog' page should show products:    2
    [Teardown]    Yves: check if cart is not empty and clear it

# Catalog_Actions
#     ### Quick add to cart from catalog is not supported by Marketplace for now ###
#     [Documentation]    Checks quick add to cart and product groups.
#     Yves: perform search by:    NEX-VG20EH
#     Yves: 1st product card in catalog (not)contains:      Add to Cart    true
#     Yves: quick add to cart for first item in catalog
#     Yves: perform search by:    115
#     Yves: 1st product card in catalog (not)contains:     Add to Cart    false
#     Yves: perform search by:    002
#     Yves: 1st product card in catalog (not)contains:      Add to Cart    true
#     Yves: 1st product card in catalog (not)contains:      Color selector   true
#     Yves: mouse over color on product card:    black
#     Yves: quick add to cart for first item in catalog
#     Yves: go to shopping cart page
#     Yves: shopping cart contains the following products:    NEX-VG20EH    Canon IXUS 160
#     [Teardown]    Yves: check if cart is not empty and clear it

Product_PDP
    [Documentation]    Checks that PDP contains required elements
    Create dynamic customer in DB
    Delete All Cookies
    Yves: go to PDP of the product with sku:    135
    Yves: change variant of the product on PDP on:    Flash
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}   ${addToCartButton}    ${pdp_limited_warranty_option}[${env}]    ${pdp_gift_wrapping_option}[${env}]    ${relatedProducts}
    Yves: PDP contains/doesn't contain:    false    ${pdp_add_to_wishlist_button}
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    135
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}   ${pdp_add_to_cart_disabled_button}[${env}]    ${pdp_limited_warranty_option}[${env}]    ${pdp_gift_wrapping_option}[${env}]     ${pdp_add_to_wishlist_button}    ${relatedProducts}
    Yves: change variant of the product on PDP on:    Flash
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}    ${addToCartButton}    ${pdp_limited_warranty_option}[${env}]    ${pdp_gift_wrapping_option}[${env}]     ${pdp_add_to_wishlist_button}    ${relatedProducts}

Volume_Prices
    [Documentation]    Checks volume prices are applied
    [Setup]    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    193
    Yves: change quantity using '+' or '-' button № times:    +    4
    Yves: product price on the PDP should be:    €165.00
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    193    Sony FDR-AX40    825.00
    Yves: delete from b2c cart products with name:    Sony FDR-AX40

Discontinued_Alternative_Products
    [Documentation]    Checks discontinued and alternative products
    [Setup]    Run keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    Yves: go to PDP of the product with sku:    ${product_with_relations_alternative_products_sku}
    Yves: change variant of the product on PDP on:    2.3 GHz
    Yves: PDP contains/doesn't contain:    true    ${alternativeProducts}
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${discontinued_product_concrete_sku}
    Yves: add product to wishlist:    My wishlist
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: discontinue the following product:    ${discontinued_product_abstract_sku}    ${discontinued_product_concrete_sku}
    Zed: product is successfully discontinued
    Zed: check if at least one price exists for concrete and add if doesn't:    100
    Zed: add following alternative products to the concrete:    012
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to 'Wishlist' page
    Yves: go to wishlist with name:    My wishlist
    Yves: product with sku is marked as discontinued in wishlist:    ${discontinued_product_concrete_sku}
    Yves: product with sku is marked as alternative in wishlist:    012
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: undo discontinue the following product:    ${discontinued_product_abstract_sku}    ${discontinued_product_concrete_sku}
    ...    AND    Trigger p&s
    ...    AND    Delete dynamic admin user from DB

Back_in_Stock_Notification
    [Documentation]    Back in stock notification is sent and availability check
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Yves: go to the 'Home' page
    ...    AND    Yves: go to the PDP of the first available product
    ...    AND    Yves: get sku of the concrete product on PDP
    ...    AND    Yves: get sku of the abstract product on PDP
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: change product stock:    ${stock_product_abstract_sku}    ${stock_product_concrete_sku}    false    0
    Zed: check if product is/not in stock:    ${stock_product_abstract_sku}    false
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:  ${stock_product_abstract_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    True
    Yves: check if product is available on PDP:    ${stock_product_abstract_sku}    false
    Yves: submit back in stock notification request for email:    ${dynamic_customer}
    Yves: unsubscribe from availability notifications
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: change product stock:    ${stock_product_abstract_sku}    ${stock_product_concrete_sku}    true    0
    Zed: check if product is/not in stock:    ${stock_product_abstract_sku}    true
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:  ${stock_product_abstract_sku}
    Yves: try reloading page if element is/not appear:    ${pdp_product_not_available_text}    False
    Yves: check if product is available on PDP:    ${stock_product_abstract_sku}    true
    [Teardown]    Run Keywords    Zed: check and restore product availability in Zed:    ${stock_product_abstract_sku}    Available    ${stock_product_concrete_sku}        ${dynamic_admin_user}
    ...    AND    Delete dynamic admin user from DB

Product_Bundles
    [Documentation]    Checks checkout with Bundle product. 
    [Setup]    Run keywords    Repeat Keyword    3    Trigger multistore p&s
    ...    AND    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: change product stock:    ${bundled_product_1_abstract_sku}    ${bundled_product_1_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_2_abstract_sku}    ${bundled_product_2_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_3_abstract_sku}    ${bundled_product_3_concrete_sku}    true    10
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${bundleItemsSmall}
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: go to shopping cart page
    Yves: shopping cart contains the following products:    ${bundle_product_product_name}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName                      | lastName                      | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | ${yves_second_user_first_name} | ${yves_second_user_last_name} | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Credit Card
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Delete dynamic admin user from DB

 Configurable_Product_PDP_Wishlist_Availability
    [Documentation]    Configure product from PDP and Wishlist + availability case.
    [Setup]    Run keywords   Create dynamic customer in DB
    ...    AND    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    ...    AND    Yves: create new 'Wishlist' with name:    configProduct${random}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: change variant of the product on PDP on:    ${configurable_product_concrete_one_attribute}
    Yves: PDP contains/doesn't contain:    true    ${configureButton}
    Yves: product price on the PDP should be:    €25.00
    Yves: product configuration status should be equal:      Configuration is not complete. 
    Yves: check and go back that configuration page contains:
    ...    || store | locale | price_mode | currency | sku                                      ||
    ...    || DE    | en_US  | GROSS_MODE | EUR      | ${configurable_product_concrete_one_sku} ||
    Yves: change the product options in configurator to:
    ...    || option one | option two | option three |option four | option five | option six | option seven | option eight | option nine | option ten       ||
    ...    || 517        | 473        | 100          | 0.00       |  51         | 19         | 367          | 46           | 72          | English Keyboard ||
    Yves: product configuration price should be:    €1599.00
    Yves: save product configuration
    Yves: product price on the PDP should be:    €25.00
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: change the product options in configurator to:
    ...    || option one    | option two | option four | option five | option six | option seven | option eight | option nine | option ten       ||
    ...    || 389.50        | 210        | 36          |  15         | 19         | 48           | 46           | 33          | English Keyboard ||
    Yves: product configuration price should be:    €731.50
    Yves: product configuration notification is:     Only 7 items available
    Yves: save product configuration
    Yves: change quantity using '+' or '-' button № times:    +    8
    Yves: try add product to the cart from PDP and expect error:    Item ${configurable_product_concrete_one_sku} only has availability of 7.
    Yves: go to PDP of the product with sku:   ${configurable_product_abstract_sku}
    Yves: change variant of the product on PDP on:    ${configurable_product_concrete_one_attribute}
    Yves: change quantity using '+' or '-' button № times:    +    7
    Yves: add product to wishlist:    configProduct${random}    select
    Yves: go to wishlist with name:    configProduct${random}
    Yves: wishlist contains product with sku:    ${configurable_product_concrete_one_sku}
    Yves: change the product options in configurator to:
    ...    || option one | option two | option three |option four | option five | option six | option seven | option eight | option nine | option ten      ||
    ...    || 905        | 249        | 100          | 36         |  15         | 0.00       | 48           | 57           | 36          | German Keyboard ||
    Yves: product configuration price should be:    €1,247.00 
    Yves: save product configuration
    Yves: add all available products from wishlist to cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    sku=${configurable_product_concrete_one_sku}    productName=${configurable_product_name}    productPrice=€1,347.00