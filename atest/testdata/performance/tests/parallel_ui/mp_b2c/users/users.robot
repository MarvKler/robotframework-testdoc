*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_tree
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/agent_assist_steps.robot
Resource    ../../../../resources/steps/catalog_steps.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/zed_users_steps.robot

*** Test Cases ***
Agent_Assist
    [Documentation]    Checks that agent can be used.
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
    Yves: perform search by:    031
    Yves: product with name in the catalog should have price:    Canon PowerShot G9 X    €400.24
    Yves: go to PDP of the product with sku:    031
    Yves: product price on the PDP should be:    €400.24
    [Teardown]    Delete dynamic admin user from DB

User_Control
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
