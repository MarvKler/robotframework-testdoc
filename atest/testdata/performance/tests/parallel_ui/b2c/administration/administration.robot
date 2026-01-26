*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_one
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/common/common_zed.robot
Resource    ../../../../resources/steps/zed_root_menus_steps.robot
Resource    ../../../../resources/steps/zed_payment_methods_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/glossary_steps.robot

*** Test Cases ***
Zed_navigation_ordering_and_naming
    [Documentation]    Verifies each left navigation node can be opened
    [Setup]    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: verify first navigation root menus
    Zed: verify root menu icons
    Zed: verify second navigation root menus
    [Teardown]    Delete dynamic admin user from DB

Payment_method_update
    [Documentation]    Deactivate payment method, unset payment method for stores in zed and check its impact on yves.
    [Setup]    Run Keywords    Create dynamic customer in DB
    ...    AND    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: activate/deactivate payment method:    Dummy Payment    Credit Card    true
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to PDP of the product with sku:    020
    Yves: add product to the shopping cart
    Yves: go to shopping cart page    
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: fill in the following new shipping address:
    ...    ||      firstName                    |           lastName                  |    street           |    houseNumber     |    city      |    postCode    |    phone        ||
    ...    || ${yves_second_user_first_name}    |     ${yves_second_user_last_name}   |    ${random}        |    ${random}       |    Berlin    |   ${random}    |    ${random}    ||
    Yves: billing address same as shipping address:    true
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:     Standard: €4.90
    Yves: check that the payment method is/not present in the checkout process:    ${checkout_payment_credit_card_locator}    true
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: activate/deactivate payment method:    Dummy Payment    Credit Card    False
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: go to shopping cart page    
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: fill in the following new shipping address:
    ...    ||      firstName                    |           lastName                  |    street           |    houseNumber     |    city     |    postCode    |    phone        ||
    ...    || ${yves_second_user_first_name}    |     ${yves_second_user_last_name}   |    ${random}        |    ${random}       |    Berlin   |   ${random}    |    ${random}    ||
    Yves: billing address same as shipping address:    true
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:     Standard: €4.90
    Yves: check that the payment method is/not present in the checkout process:     ${checkout_payment_credit_card_locator}    false
    [Teardown]    Run keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: activate/deactivate payment method:    Dummy Payment    Credit Card    True
    ...    AND    Delete dynamic admin user from DB

Glossary
    [Documentation]    Create + edit glossary translation in BO
    Create dynamic admin user in DB
    Create dynamic customer in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Administration    Glossary  
    Zed: click button in Header:    Create Translation
    Zed: fill glossary form:
    ...    || Name                     | EN_US                        | DE_DE                             ||
    ...    || cart.price.test${random} | This is a sample translation | Dies ist eine Beispielübersetzung ||
    Zed: submit the form
    Zed: table should contain:    cart.price.test${random}
    Zed: go to second navigation item level:    Administration    Glossary 
    Zed: click Action Button in a table for row that contains:    ${glossary_name}    Edit
    Zed: fill glossary form:
    ...    || DE_DE                    | EN_US                              ||
    ...    || ${original_DE_text}-Test | ${original_EN_text}-Test-${random} ||
    Zed: submit the form
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: validate the page title:    ${original_EN_text}-Test-${random}
    Zed: undo the changes in glossary translation:    ${glossary_name}     ${original_DE_text}    ${original_EN_text}
    Trigger p&s
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: validate the page title:    ${original_EN_text}
    [Teardown]    Run Keywords    Zed: undo the changes in glossary translation:    ${glossary_name}     ${original_DE_text}    ${original_EN_text}
    ...    AND    Trigger p&s
    ...    AND    Delete dynamic admin user from DB