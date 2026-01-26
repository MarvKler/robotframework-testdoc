*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_two
Resource    ../../../../resources/common/common_ui.robot
Resource    ../../../../resources/common/common_zed.robot
Resource    ../../../../resources/steps/company_steps.robot
Resource    ../../../../resources/steps/agent_assist_steps.robot

*** Test Cases ***
Create_new_company_with_linked_entities_and_customer_in_backoffice
    [Documentation]    Create a new company with linked entities and new customer in backoffice
    [Setup]    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create new Company with provided name:    RobotCompany
    Zed: click Action Button in a table for row that contains:    ${created_company}    Activate
    Zed: click Action Button in a table for row that contains:    ${created_company}    Approve
    Zed: create new Company Business Unit for the following company:    company_name=${created_company}    company_id=${created_company_id}    business_unit_name=Robot_Business_Unit
    Zed: create new Company Role with provided permissions:    ${created_company}    ${created_company_id}    RobotRole    true    View company users    See Company Menu
    Zed: Create new Company User with provided details:
    ...    || email                                     | salutation | first_name | last_name | gender | company           | business_unit            | role      ||
    ...    || sonia+created+cuser+${random}@spryker.com | Ms         | Robot      | User      | Female | ${created_company}| ${created_business_unit} | RobotRole ||
    Yves: go to the 'Home' page
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    ${dynamic_admin_user}    agent_assist=${True}
    Yves: as an agent login under the customer:    sonia+created+cuser+${random}@spryker.com
    Yves: go to URL:    /company/user    
    ${location}=    Get Location
    Should Contain    ${location}    /company/user    msg=Failed to navigate to the 'Company User' page
    Yves: go to URL:    /company/company-role
    ${location}=    Get Location
    Should Contain    ${location}    /403    msg=Navigated to the 'Company Role' page despite the lack of permissions
    [Teardown]    Delete dynamic admin user from DB
    
Create_new_company_user_with_linked_entities_in_storefront
    [Documentation]    Create a new company user on Storefront
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Create dynamic customer in DB    based_on=${yves_spryker_admin_company_user_email}
    Yves: login on Yves with provided credentials:    ${dynamic_customer}
    Yves: create new company role:    RobotYvesRole+${random}
    Yves: assign the following permissions to the company role:    RobotYvesRole+${random}    View company users    See Company Menu
    Yves: create new company business unit:    business_unit_name=RobotYvesBusinessUnit+${random}    business_unit_email=robot+business+unit+${random}@spryker.com
    Yves: create new company user:    business_unit=RobotYvesBusinessUnit+${random}    email=sonia+sf+new+cuser+${random}@spryker.com    role=RobotYvesRole+${random}    first_name=Sonia    last_name=NewUser    
    Yves: logout on Yves as a customer
    Yves: go to URL:    agent/login
    Yves: login on Yves with provided credentials:    ${dynamic_admin_user}    agent_assist=${True}
    Yves: as an agent login under the customer:    sonia+sf+new+cuser+${random}@spryker.com
    Yves: go to URL:    /company/user    
    ${location}=    Get Location
    Should Contain    ${location}    /company/user    msg=Failed to navigate to the 'Company User' page
    Yves: go to URL:    /company/company-role
    ${location}=    Get Location
    Should Contain    ${location}    /403    msg=Navigated to the 'Company Role' page despite the lack of permissions
    [Teardown]    Delete dynamic admin user from DB