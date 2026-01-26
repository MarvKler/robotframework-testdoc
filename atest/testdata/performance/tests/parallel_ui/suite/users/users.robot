*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_tree     spryker-core-back-office    spryker-core    agent-assist
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/agent_assist_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/zed_users_steps.robot

*** Test Cases ***
Agent_Assist
    [Tags]    smoke
    [Documentation]    Checks customer data and checkout as an agent
    Create dynamic admin user in DB
    Create dynamic customer in DB    based_on=${yves_second_user_email}    first_name=DynamicCustomerForAgent${random}    last_name=DynamicCustomerForAgent${random}
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create new Zed user with the following data:    agent+${random}@spryker.com    ${default_secure_password}    Agent    Assist    Root group    This user is an agent in Storefront    en_US
    Yves: go to the 'Home' page
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    agent+${random}@spryker.com    ${default_secure_password}    agent_assist=${True}
    Yves: header contains/doesn't contain:    true    ${customerSearchWidget}
    Yves: perform search by customer:    DynamicCustomerForAgent${random}
    Yves: agent widget contains:    ${dynamic_customer}
    Yves: as an agent login under the customer:    ${dynamic_customer}
    Yves: go to user menu:    My Profile
    Yves: 'Profile' page is displayed
    Yves: assert customer profile data:
    ...    || salutation | first name                       | last name                        | email               ||
    ...    || Mr.        | DynamicCustomerForAgent${random} | DynamicCustomerForAgent${random} | ${dynamic_customer} ||
    Yves: go to PDP of the product with sku:    ${available_never_out_of_stock_abstract_sku}
    Yves: add product to the shopping cart
    Yves: go to shopping cart page
    Yves: click on the 'Checkout' button in the shopping cart
    Yves: billing address same as shipping address:    true
    Yves: fill in the following new shipping address:
    ...    || salutation | firstName | lastName | street        | houseNumber | postCode | city   | country | company | phone     | additionalAddress ||
    ...    || Mr.        | Guest     | User     | Kirncher Str. | 7           | 10247    | Berlin | Germany | Spryker | 123456789 | Additional street ||
    Yves: submit form on the checkout
    Yves: select the following shipping method on the checkout and go next:    Express
    Yves: select the following payment method on the checkout and go next:    Invoice (Marketplace)
    Yves: accept the terms and conditions:    true
    Yves: 'submit the order' on the summary page
    Yves: 'Thank you' page is displayed
    [Teardown]    Delete dynamic admin user from DB

User_Control
    [Tags]    smoke
    [Documentation]    Create a user with limited access
    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create new role with name:    controlRole${random}
    Zed: apply access permissions for user role:    ${full_access}    ${full_access}    ${full_access}   ${permission_allow}
    Zed: apply access permissions for user role:    ${bundle_access}    ${controller_access}    ${action_access}    ${permission_deny}
    Zed: create new group with role assigned:   controlGroup${random}    controlRole${random}
    Zed: create new Zed user with the following data:    sonia+control${random}@spryker.com   ${default_secure_password}    First Control    Last Control    ControlGroup${random}    This user is an agent in Storefront    en_US    
    Zed: login on Zed with provided credentials:   sonia+control${random}@spryker.com    ${default_secure_password}
    Zed: go to second navigation item level:    Catalog    Attributes
    Zed: click button in Header:    Create Product Attribute
    Zed: validate the message when permission is restricted:    Access denied
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: deactivate the created user:    sonia+control${random}@spryker.com
    Zed: login with deactivated user/invalid data:    sonia+control${random}@spryker.com    ${default_secure_password}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Users    User Roles
    ...    AND    Zed: click Action Button in a table for row that contains:    controlRole${random}    Delete
    ...    AND    Delete dynamic admin user from DB