*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_two
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/steps/merchant_profile_steps.robot
Resource    ../../../../resources/common/common_mp.robot
Resource    ../../../../resources/steps/mp_profile_steps.robot

*** Test Cases ***
Merchant_Profile_Update
    [Setup]    Run Keywords    Create dynamic admin user in DB
    ...    AND    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: create dynamic merchant user:    Office King
    [Documentation]    Checks that merchant profile could be updated from merchant portal and that changes will be displayed on Yves
    Yves: go to URL:    en/merchant/office-king
    Yves: assert merchant profile fields:
    ...    || name | email             | phone           | delivery time | data privacy                                          ||
    ...    ||      | hi@office-king.nl | +31 123 345 777 | 2-4 days      | Office King values the privacy of your personal data. ||
    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    MP: open navigation menu tab:    Profile  
    MP: open profile tab:    Online Profile
    MP: update profile fields with following data:
    ...    || email                  | phone           | delivery time | data privacy              ||
    ...    || updated@office-king.nl | +11 222 333 444 | 2-4 weeks     | Data privacy updated text ||
    MP: click submit button
    Trigger p&s
    Yves: go to URL:    en/merchant/office-king
    Yves: assert merchant profile fields:
    ...    || name | email                  | phone           | delivery time | data privacy              ||
    ...    ||      | updated@office-king.nl | +11 222 333 444 | 2-4 weeks     | Data privacy updated text ||
    [Teardown]    Run Keywords    MP: login on MP with provided credentials:    ${dynamic_king_merchant}
    ...    AND    MP: open navigation menu tab:    Profile
    ...    AND    MP: open profile tab:    Online Profile  
    ...    AND    MP: update profile fields with following data:
    ...    || email             | phone           | delivery time | data privacy                                          ||
    ...    || hi@office-king.nl | +31 123 345 777 | 2-4 days      | Office King values the privacy of your personal data. ||
    ...    AND    MP: click submit button
    ...    AND    Trigger p&s
    ...    AND    Delete dynamic admin user from DB

Manage_Merchants_from_Backoffice
    [Documentation]    Checks that backoffice admin is able to create, approve, edit merchants
    [Setup]    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: create new Merchant with the following data:
    ...    || merchant name          | merchant reference              | e-mail                           | store | store 2 | en url                    | de url                    ||
    ...    || RobotMerchant${random} | RobotMerchantReference${random} | robotMerchant+${random}@test.com | DE    | AT      | RobotMerchantURL${random} | RobotMerchantURL${random} ||
    Zed: perform search by:    RobotMerchant${random}
    Zed: table should contain non-searchable value:    Inactive
    Zed: table should contain non-searchable value:    Waiting for Approval
    Zed: table should contain non-searchable value:    DE
    Zed: click Action Button in a table for row that contains:    RobotMerchant${random}    Activate
    Zed: click Action Button in a table for row that contains:    RobotMerchant${random}    Approve Access
    Zed: perform search by:    RobotMerchant${random}
    Zed: table should contain non-searchable value:    Active
    Zed: table should contain non-searchable value:    Approved
    Zed: click Action Button in a table for row that contains:    RobotMerchant${random}    Edit
    Zed: update Merchant on edit page with the following data:
    ...    || merchant name                 | merchant reference | e-mail  | store | en url | de url ||
    ...    || RobotMerchantUpdated${random} |                    |         |       |        |        ||
    Trigger multistore p&s
    Yves: go to newly created page by URL:    en/merchant/RobotMerchantURL${random}
    Yves: assert merchant profile fields:
    ...    || name                          | email | phone | delivery time | data privacy ||
    ...    || RobotMerchantUpdated${random} |       |       |               |              ||
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:    RobotMerchantUpdated${random}    Edit
    Zed: update Merchant on edit page with the following data:
    ...    || merchant name        | merchant reference | e-mail  | uncheck store | uncheck store 2 | en url | de url ||
    ...    || Deactivated${random} |                    |         | DE            | AT              |        |        ||
    Trigger multistore p&s
    Yves: go to URL and refresh until 404 occurs:    ${yves_url}en/merchant/RobotMerchantURL${random}
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Marketplace    Merchants  
    ...    AND    Zed: click Action Button in a table for row that contains:     Deactivated${random}     Deactivate
    ...    AND    Trigger multistore p&s
    ...    AND    Delete dynamic admin user from DB

Manage_Merchant_Users
    [Documentation]    Checks that backoffice admin is able to create, activate, edit and delete merchant users
    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:     Office King     Edit
    Zed: create new Merchant User with the following data:
    ...    || e-mail                         | first name     | last name      ||
    ...    || sonia+mu+${random}@spryker.com | FName${random} | LName${random} ||
    Zed: perform merchant user search by:     sonia+mu+${random}@spryker.com
    Zed: table should contain non-searchable value:    Deactivated
    Zed: click Action Button in Merchant Users table for row that contains:    sonia+mu+${random}@spryker.com    Activate
    Zed: table should contain non-searchable value:    Active
    Zed: click Action Button in Merchant Users table for row that contains:    sonia+mu+${random}@spryker.com    Edit
    Zed: update Merchant User on edit page with the following data:
    ...    || e-mail | first name           | last name ||
    ...    ||        | UpdatedName${random} |           ||
    Zed: perform merchant user search by:    sonia+mu+${random}@spryker.com
    Zed: table should contain non-searchable value:    UpdatedName${random}
    Zed: update Zed user:
    ...    || oldEmail                       | newEmail | password                   | firstName | lastName ||
    ...    || sonia+mu+${random}@spryker.com |          | ${default_secure_password} |           |          ||
    MP: login on MP with provided credentials:    sonia+mu+${random}@spryker.com    ${default_secure_password}
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: go to second navigation item level:    Marketplace    Merchants
    Zed: click Action Button in a table for row that contains:     Office King     Edit
    Zed: go to tab by link href that contains:    merchant-user
    Zed: click Action Button in Merchant Users table for row that contains:    sonia+mu+${random}@spryker.com    Deactivate
    Zed: table should contain non-searchable value:    Deactivated
    MP: login on MP with provided credentials and expect error:    sonia+mu+${random}@spryker.com    ${default_secure_password}
    [Teardown]    Run Keywords     Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: go to second navigation item level:    Marketplace    Merchants
    ...    AND    Zed: click Action Button in a table for row that contains:     Office King     Edit
    ...    AND    Zed: go to tab by link href that contains:    merchant-user
    ...    AND    Zed: click Action Button in Merchant Users table for row that contains:    sonia+mu+${random}@spryker.com    Delete
    ...    AND    Zed: submit the form
    ...    AND    Delete dynamic admin user from DB