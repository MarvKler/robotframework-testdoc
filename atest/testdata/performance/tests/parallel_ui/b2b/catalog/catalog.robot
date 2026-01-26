*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_one
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/products_steps.robot
Resource    ../../../../resources/steps/zed_availability_steps.robot
Resource    ../../../../resources/steps/catalog_steps.robot
Resource    ../../../../resources/steps/configurable_product_steps.robot
*** Test Cases ***
Quick_Order
    [Documentation]    Checks Quick Order, checkout and Reorder
    [Setup]    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: create new 'Shopping List' with name:    quickOrderList+${random}
    Yves: go to 'Quick Order' page through the header
    Yves: 'Quick Order' page is displayed
    Yves: add the following articles into the form through quick order text area:    401627,1\n520561,3\n421340,21\n419871,1\n419869,11\n425073,1\n425084,2
    Yves: add products to the shopping cart from quick order page
    Yves: go to shopping cart page
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    401627    520561    421340    419871    419869    425073    425084
    Yves: go to 'Quick Order' page through the header
    Yves: add the following articles into the form through quick order text area:    401627,1\n520561,3\n421340,21\n419871,1\n419869,11\n425073,1\n425084,2
    Yves: add products to the shopping list from quick order page with name:    quickOrderList+${random}
    Yves: 'Shopping List' page is displayed
    Yves: shopping list contains the following products:    401627    520561    421340    419871    419869    425073    425084
    Yves: go to shopping cart page
    ### Order placement ###
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    ### Order History ###
    Yves: go to the 'Home' page
    Yves: go to user menu:    Order History
    Yves: 'Order History' page is displayed
    Yves: get the last placed order ID by current customer
    Yves: 'View Order/Reorder/Return' on the order history page:     View Order    ${lastPlacedOrder}
    Yves: 'Order Details' page is displayed
    ### Reorder ###
    Yves: reorder all items from 'Order Details' page
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    401627    520561    421340    419871    419869    425073    425084

Discontinued_Alternative_Products
    [Documentation]    Checks that product can be discontinued in Zed.
    [Setup]    Create dynamic admin user in DB
    Yves: go to PDP of the product with sku:  M21100
    Yves: PDP contains/doesn't contain:    true    ${alternativeProducts}
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: start new abstract product creation:
    ...    || sku                      | store | name en                      | name de                        | new from   | new to     ||
    ...    || discontinuedSKU${random} | DE    | discontinuedProduct${random} | DEdiscontinuedProduct${random} | 01.01.2020 | 01.01.2030 ||
    Zed: select abstract product variants:
    ...    || attribute 1 | attribute value 1 ||
    ...    || farbe       | grey              ||
    Zed: update abstract product price on:
    ...    || store | mode  | type    | currency | amount | tax set        ||
    ...    || DE    | gross | default | €        | 100.00 | Standard Taxes ||
    Zed: change concrete product data:
    ...    || productAbstract          | productConcrete                     | active | searchable en | searchable de ||
    ...    || discontinuedSKU${random} | discontinuedSKU${random}-farbe-grey | true   | true          | true          ||
    Zed: add following alternative products to the concrete:    M22613
    Zed: concrete product has the following alternative products:    M22613
    Zed: discontinue the following product:    discontinuedSKU${random}    discontinuedSKU${random}-farbe-grey
    Zed: product is successfully discontinued
    [Teardown]    Delete dynamic admin user from DB

Measurement_Units
    [Documentation]    Checks checkout with Measurement Unit product
    [Setup]    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    M23723
    Yves: select the following 'Sales Unit' on PDP:    Meter
    Yves: change quantity using '+' or '-' button № times:    +    1
    Yves: PDP contains/doesn't contain:    true    ${measurementUnitSuggestion}
    Yves: change quantity using '+' or '-' button № times:    -    1
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M1006871
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: 'Shopping Cart' page is displayed
    Yves: shopping cart contains the following products:    425079
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Packaging_Units
    [Documentation]    Checks checkout with Packaging Unit product
    [Setup]    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    M21766
    Yves: change variant of the product on PDP on:    Box
    Yves: change amount on PDP:    51
    Yves: PDP contains/doesn't contain:    true    ${packagingUnitSuggestion}
    Yves: change amount on PDP:    10
    Yves: add product to the shopping cart
    Yves: go to PDP of the product with sku:    M1006871
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: shopping cart contains the following products:    421519_3
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: select the following existing address on the checkout as 'shipping' address and go next:    ${default_address.full_address}
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed

Product_Bundles
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
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
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

Product_Restrictions
    [Documentation]    Checks White and Black lists
    [Setup]    Run keywords    Create dynamic customer in DB
    ...    AND    Create dynamic customer in DB    based_on=${yves_company_user_restriction_customer_email_1}
    ...    AND    Create dynamic customer in DB    based_on=${yves_company_user_restriction_customer_email_2}
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: perform search by:    Soennecken
    Yves: 'Catalog' page should show products:    18
    Yves: go to URL:    en/office-furniture/storage/lockers
    Yves: 'Catalog' page should show products:    34
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${dynamic_second_customer}
    Yves: perform search by:    Soennecken
    Yves: 'Catalog' page should show products:    0
    Yves: logout on Yves as a customer
    Yves: login on Yves with provided credentials:    ${dynamic_third_customer}
    Yves: go to URL:    en/office-furniture/storage/lockers
    Yves: 'Catalog' page should show products:    0
    Yves: go to URL:    en/transport/lift-carts
    Yves: 'Catalog' page should show products:    16
    Yves: go to URL:    en/transport/sack-trucks
    Yves: 'Catalog' page should show products:    10

Product_PDP
    [Documentation]    Checks that PDP contains required elements
    [Setup]    Create dynamic customer in DB
    Delete All Cookies
    Yves: go to PDP of the product with sku:    ${multi_variant_product_abstract_sku}
    Yves: change variant of the product on PDP on:    500 x 930 x 400
    Yves: PDP contains/doesn't contain:    true    ${pdp_warranty_option}    ${pdp_insurance_option}
    Yves: PDP contains/doesn't contain:    false    ${pdpPriceLocator}   ${addToCartButton}
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    ${multi_variant_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}    ${pdp_add_to_cart_disabled_button}[${env}]    ${pdp_warranty_option}    ${pdp_insurance_option}
    Yves: change variant of the product on PDP on:    500 x 930 x 400
    Yves: PDP contains/doesn't contain:    true    ${pdpPriceLocator}    ${addToCartButton}    ${pdp_warranty_option}    ${pdp_insurance_option}

Catalog
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Trigger product labels update
    [Documentation]    Checks that catalog options and search work
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: perform search by:    claire
    Yves: 'Catalog' page should show products:    15
    Yves: catalog page contains filter:    Product Ratings     Product Labels     Brand    Color
    Yves: select filter value:    Color    blue
    Yves: 'Catalog' page should show products:    1
    Yves: go to first navigation item level:    Stationery
    Yves: 'Catalog' page should show products:    114
    Yves: page contains CMS element:    CMS Block    Build a Space That Spurs Creativity
    Yves: page contains CMS element:    CMS Block    Tackle Your To-Do's
    Yves: change sorting order on catalog page:    Sort by price ascending
    Yves: 1st product card in catalog (not)contains:     Price    0.48
    Yves: change sorting order on catalog page:    Sort by price descending
    Yves: 1st product card in catalog (not)contains:      Price    €41.68
    Yves: go to catalog page:    2
    Yves: catalog page contains filter:    Product Ratings     Product Labels     Brand    Color
    Yves: select filter value:    Color    blue
    Yves: 'Catalog' page should show products:    3

Catalog_Actions
    [Documentation]    Checks quick add to cart and product groups
    [Setup]    Create dynamic customer in DB
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: perform search by:    Verbatim USB stick OTG
    Yves: 1st product card in catalog (not)contains:      Add to Cart    true
    Yves: quick add to cart for first item in catalog
    Yves: perform search by:    New Clairefontaine Collegeblock 8272C DIN A5, 90 sheets
    Yves: 1st product card in catalog (not)contains:     Add to Cart    false
    Yves: perform search by:    ${multi_color_product_abstract_sku}
    Yves: 1st product card in catalog (not)contains:      Add to Cart    true
    Yves: 1st product card in catalog (not)contains:      Color selector   true
    Yves: mouse over color on product card:    Blue
    Yves: quick add to cart for first item in catalog
    Yves: go to shopping cart page
    Yves: shopping cart contains the following products:    420573    107255

Back_in_Stock_Notification
    [Documentation]    Back in stock notification is sent and availability check
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB
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

Configurable_Product_PDP_Shopping_List
    [Documentation]    Configure products from both the PDP and the Shopping List. Verify the availability of five items. Ensure that products that have not been configured cannot be purchased.
    [Setup]    Run keywords    Create dynamic customer in DB
    ...    AND    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    ...    AND    Yves: create new 'Shopping List' with name:    configProduct+${random}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: PDP contains/doesn't contain:    true    ${configureButton}
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: product configuration status should be equal:       Configuration is not complete.
    Yves: checkout is blocked with the following message:    This cart can't be processed. Please configure items inside the cart.
    Yves: delete product from the shopping cart with sku:    ${configurable_product_concrete_sku}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: check and go back that configuration page contains:
    ...    || store | locale | price_mode | currency | customer_id                          | sku                                  ||
    ...    || DE    | en_US  | GROSS_MODE | EUR      | ${yves_company_user_buyer_reference} | ${configurable_product_concrete_sku} ||
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 420        | 240        ||
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 280        | 480        ||
    Yves: product configuration notification is:     Only 7 items available
    Yves: save product configuration
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: configuration should be equal:
    ...    || option one | option two ||
    ...    || 5 shelves  | 3 lockers  ||
    Yves: product configuration status should be equal:      Configuration complete!
    Yves: change quantity on PDP:    8
    Yves: try add product to the cart from PDP and expect error:    Item ${configurable_product_concrete_sku} only has availability of 7.
    Yves: go to PDP of the product with sku:   ${configurable_product_abstract_sku}
    Yves: change quantity on PDP:    7
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 140        | 240        ||
    Yves: save product configuration
    Yves: shopping cart contains product with unit price:    ${configurable_product_concrete_sku}    ${configurable_product_name}    €2,206.54
    Yves: delete all shopping carts
    Yves: create new 'Shopping Cart' with name:    configProduct+${random}
    Yves: go to PDP of the product with sku:    ${configurable_product_abstract_sku}
    Yves: add product to the shopping list:    configProduct+${random}
    Yves: go to 'Shopping Lists' page
    Yves: view shopping list with name:    configProduct+${random}
    Yves: change the product options in configurator to:
    ...    || option one | option two ||
    ...    || 420        | 240        ||
    Yves: save product configuration
    Yves: configuration should be equal:
    ...    || option one | option two ||
    ...    || 6 shelves  | 2 lockers  ||
    Yves: add all available products from list to cart
    Yves: configuration should be equal:
    ...    || option one | option two ||
    ...    || 6 shelves  | 2 lockers  ||
    Yves: shopping cart contains product with unit price:    ${configurable_product_concrete_sku}    ${configurable_product_name}    €2,486.54