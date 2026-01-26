*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_one    search    catalog    spryker-core    product
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/catalog_steps.robot
Resource    ../../../../resources/steps/products_steps.robot
Resource    ../../../../resources/steps/zed_availability_steps.robot
Resource    ../../../../resources/steps/configurable_product_steps.robot
Resource    ../../../../resources/steps/merchants_steps.robot

*** Test Cases ***
Product_PDP
    [Tags]    smoke
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

Catalog
    [Tags]    smoke
    [Documentation]    Checks that catalog options and search work
    Yves: perform search by:    canon
    Yves: 'Catalog' page should show products:    29
    Yves: select filter value:    Color    Blue
    Yves: 'Catalog' page should show products:    2
    Yves: go to first navigation item level:    Cameras
    Yves: 'Catalog' page should show products:    63
    Yves: change sorting order on catalog page:    Sort by price ascending
    Yves: 1st product card in catalog (not)contains:     Price    €25.00
    Yves: change sorting order on catalog page:    Sort by price descending
    Yves: 1st product card in catalog (not)contains:      Price    €3,456.99
    Yves: go to catalog page:    2
    Yves: catalog page contains filter:    Price    Ratings     Label     Brand    Color    Merchant
    Yves: select filter value:    Color    Blue
    Yves: 'Catalog' page should show products:    2
    [Teardown]    Yves: check if cart is not empty and clear it

Catalog_Actions
    [Tags]    smoke    quick-add-to-cart     cart
    [Documentation]    Checks quick add to cart and product groups
    [Setup]    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: change concrete product price on:
    ...    || productAbstract | productConcrete | store | mode  | type   | currency | amount ||
    ...    || 003             | 003_26138343    | DE    | gross | default| €        | 65.00  ||
    Trigger p&s
    Yves: check if cart is not empty and clear it
    Yves: perform search by:     150_29554292
    Yves: 1st product card in catalog (not)contains:      Add to Cart    true
    Yves: quick add to cart for first item in catalog
    Yves: perform search by:    115_26408656
    Yves: 1st product card in catalog (not)contains:     Add to Cart    false
    Yves: perform search by:    002_25904004
    Yves: 1st product card in catalog (not)contains:      Add to Cart    true
    Yves: 1st product card in catalog (not)contains:      Color selector   true
    Yves: mouse over color on product card:    D3D3D3
    Yves: quick add to cart for first item in catalog
    Yves: go to shopping cart page
    Yves: shopping cart contains the following products:    150_29554292    003_26138343
    Yves: shopping cart contains product with unit price:    sku=003    productName=Canon IXUS 160    productPrice=65.00
    [Teardown]    Run Keywords    Yves: check if cart is not empty and clear it
    ...    AND    Delete dynamic admin user from DB

Discontinued_Alternative_Products
    [Tags]    wishlist    discontinued-products    alternative-products
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

Measurement_Units
    [Tags]    smoke    measurement-units    cart    checkout
    [Documentation]    Checks checkout with Measurement Unit product
    [Setup]    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    215
    Yves: change variant of the product on PDP on:    Ring (500m)
    Yves: select the following 'Sales Unit' on PDP:    Meter
    Yves: set quantity on PDP:    3
    Yves: PDP contains/doesn't contain:    true    ${measurementUnitSuggestion}
    Yves: set quantity on PDP:    10
    Yves: add product to the shopping cart
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    215_124
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Packaging_Units
    [Tags]    smoke    packaging-units    marketplace-packaging-units    cart    checkout
    [Documentation]    Checks checkout with Packaging Unit product
    [Setup]    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    218
    Yves: change variant of the product on PDP on:    Giftbox
    Yves: change amount on PDP:    51
    Yves: PDP contains/doesn't contain:    true    ${packagingUnitSuggestion}
    Yves: change amount on PDP:    1000
    Yves: add product to the shopping cart
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    218_1234
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Product_Bundles
    [Tags]    smoke
    [Documentation]    Checks checkout with Bundle product
    [Setup]    Run keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: change product stock:    ${bundled_product_1_abstract_sku}    ${bundled_product_1_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_2_abstract_sku}    ${bundled_product_2_concrete_sku}    true    10
    ...    AND    Zed: change product stock:    ${bundled_product_3_abstract_sku}    ${bundled_product_3_concrete_sku}    true    10
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${bundle_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${bundleItemsSmall}
    Yves: add product to the shopping cart    wait_for_p&s=true
    Yves: shopping cart contains the following products:    ${bundle_product_concrete_sku}
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Delete dynamic admin user from DB

Back_in_Stock_Notification
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
    [Documentation]    Back in stock notification is sent and availability check
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
    [Teardown]    Run Keywords    Zed: check and restore product availability in Zed:    ${stock_product_abstract_sku}    Available    ${stock_product_concrete_sku}    ${dynamic_admin_user}
    ...    AND    Delete dynamic admin user from DB

Configurable_Product_PDP_Wishlist_Availability
    [Documentation]    Configure product from PDP and Wishlist + availability case.
    [Setup]    Run keywords   Create dynamic customer in DB
    ...    AND    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    ...    AND    Yves: create new 'Wishlist' with name:    configProduct${random}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${configureButton}
    Yves: product price on the PDP should be:    ${configurable_product_price_without_configurations}
    Yves: product configuration status should be equal:      Configuration is not complete.
    Yves: check and go back that configuration page contains:
    ...    || store | locale | price_mode | currency | sku                                  ||
    ...    || DE    | en_US  | GROSS_MODE | EUR      | ${configurable_product_concrete_sku} ||
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 517        | 275        ||
    Yves: product configuration price should be:    ${configurable_product_price_without_configurations}
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: configuration should be equal:
    ...    || option one                 | option two                     ||
    ...    || Option One: Option title 2 | Option Two: Option Two title 4 ||
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 389.50     | 210        ||
    Yves: product configuration price should be:    932.99
    Yves: product configuration notification is:    No item available for your configuration
    Yves: back to PDP and not save configuration
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 607        | 249        ||
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: product price on the PDP should be:    ${configurable_product_price_without_configurations}
    Yves: add product to wishlist:    configProduct${random}    select
    Yves: go to wishlist with name:    configProduct${random}
    Yves: wishlist contains product with sku:    ${configurable_product_concrete_sku}
    Yves: configuration should be equal:
    ...    || option one                 | option two                     ||
    ...    || Option One: Option title 3 | Option Two: Option Two title 3 ||
    Yves: change the product options in configurator to:
    ...    || option one    | option two ||
    ...    || 389.50        | 275        ||
    Yves: product configuration price should be:    ${configurable_product_price_with_options} 
    Yves: save product configuration
    Yves: add all available products from wishlist to cart
    Yves: go to shopping cart page
    Yves: shopping cart contains product with unit price:    sku=${configurable_product_concrete_sku}    productName=${configurable_product_name}    productPrice=${configurable_product_price_with_options}

Configurable_Product_PDP_Shopping_List
    [Tags]    smoke
    [Documentation]    Configure products from both the PDP and the Shopping List. Verify the availability of five items. Ensure that products that have not been configured cannot be purchased.
    [Setup]    Run keywords    Create dynamic customer in DB
    ...    AND    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    ...    AND    Yves: create new 'Shopping List' with name:    configProduct+${random}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${configureButton}
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: add product to the shopping cart
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: checkout is blocked with the following message:    This cart can't be processed. Please configure items inside the cart.
    Yves: delete product from the shopping cart with sku:    ${configurable_product_concrete_sku}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: check and go back that configuration page contains:
    ...    || store | locale | price_mode | currency | customer_id                          | sku                                  ||
    ...    || DE    | en_US  | GROSS_MODE | EUR      | ${yves_company_user_buyer_reference} | ${configurable_product_concrete_sku} ||
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 607        | 275        ||
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 517        | 167        ||
    Yves: product configuration notification is:     Only 5 items available 
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: configuration should be equal:
    ...    || option one                 | option two                     ||
    ...    || Option One: Option title 2 | Option Two: Option Two title 1 ||
    Yves: product configuration status should be equal:      Configuration complete! 
    Yves: change quantity on PDP:    6
    Yves: try add product to the cart from PDP and expect error:    Item ${configurable_product_concrete_sku} only has availability of 5.
    Yves: go to PDP of the product with sku:   ${configurable_product_abstract_sku}
    Yves: change quantity on PDP:    5
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 517        | 249        ||
    Yves: save product configuration
    ### bug: https://spryker.atlassian.net/browse/CC-33647
    Yves: shopping cart contains product with unit price:    ${configurable_product_concrete_sku}    ${configurable_product_name}    €249.00
    Yves: delete product from the shopping cart with name:    ${configurable_product_name}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: add product to the shopping list:    configProduct+${random}
    Yves: go to 'Shopping Lists' page
    Yves: view shopping list with name:    configProduct+${random}
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 607        | 275        ||
    Yves: save product configuration
    Yves: configuration should be equal:
    ...    || option one                 | option two                     ||
    ...    || Option One: Option title 3 | Option Two: Option Two title 4 ||
    Yves: add all available products from list to cart
    Yves: configuration should be equal:
    ...    || option one                 | option two                     ||
    ...    || Option One: Option title 3 | Option Two: Option Two title 4 ||
    Yves: shopping cart contains product with unit price:    ${configurable_product_concrete_sku}    ${configurable_product_name}    €882.00

Product_Restrictions
    [Documentation]    Checks White and Black lists
    [Setup]    Run keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB    based_on=${yves_test_company_user_email}
    ...    AND    Create dynamic customer in DB    based_on=${yves_user_email}
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create product list with the following assigned category:    list_name=White${random}    list_type=white    category=Smartwatches
    Zed: create product list with the following assigned category:    list_name=Black${random}    list_type=black    category=Smartphones
    Zed: unassign all product lists from merchant relation:    business_unit_owner=Hotel Tommy Berlin    merchant_relation=Hotel Tommy Berlin,Hotel Tommy London
    Zed: assign product list to merchant relation:    business_unit_owner=Hotel Tommy Berlin    merchant_relation=Hotel Tommy Berlin,Hotel Tommy London    product_list=White${random}
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: at least one product is/not displayed on the search results page:    search_query=TomTom    expected_visibility=true    wait_for_p&s=true
    Yves: at least one product is/not displayed on the search results page:    search_query=Canon    expected_visibility=false
    Yves: at least one product is/not displayed on the search results page:    search_query=Lenovo    expected_visibility=false
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: unassign all product lists from merchant relation:    business_unit_owner=Hotel Tommy Berlin    merchant_relation=Hotel Tommy Berlin,Hotel Tommy London
    Zed: assign product list to merchant relation:    business_unit_owner=Hotel Tommy Berlin    merchant_relation=Hotel Tommy Berlin,Hotel Tommy London    product_list=Black${random}
    Trigger multistore p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: at least one product is/not displayed on the search results page:    search_query=060    expected_visibility=false    wait_for_p&s=true
    Yves: at least one product is/not displayed on the search results page:    search_query=052    expected_visibility=false
    Yves: at least one product is/not displayed on the search results page:    search_query=Canon    expected_visibility=true
    Yves: at least one product is/not displayed on the search results page:    search_query=Lenovo    expected_visibility=true
    Yves: login on Yves with provided credentials:    ${dynamic_second_customer}
    Yves: at least one product is/not displayed on the search results page:    search_query=060    expected_visibility=true
    Yves: at least one product is/not displayed on the search results page:    search_query=052    expected_visibility=true
    Yves: at least one product is/not displayed on the search results page:    search_query=Canon    expected_visibility=true
    Yves: at least one product is/not displayed on the search results page:    search_query=Lenovo    expected_visibility=true
    Yves: at least one product is/not displayed on the search results page:    search_query=TomTom    expected_visibility=true
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: unassign all product lists from merchant relation:    business_unit_owner=Hotel Tommy Berlin    merchant_relation=Hotel Tommy Berlin,Hotel Tommy London
    ...    AND    Zed: remove product list with title:    White${random}
    ...    AND    Zed: remove product list with title:    Black${random}
    ...    AND    Trigger multistore p&s
    ...    AND    Delete dynamic admin user from DB