*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/push_notifications_steps.robot
Test Tags    bapi

*** Test Cases ***
Creates_push_notification_subscription_with_incorrect_locale
    [Setup]    Run Keywords    Create warehouse in DB:    ${warehouses[0].name}     ${True}     ${warehouses[0].uuid}
    ...    AND    Assign user to Warehouse in DB:    ${zed_admin.email}    ${warehouses[0].uuid}
    I get access token by user credentials:    ${zed_admin.email}
    When I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    And I send a POST request:    /push-notification-subscriptions    {"data":{"type":"push-notification-subscriptions","attributes":{"providerName":"${push_notification_subscriptions[0].providerName}","group":{"name":"${push_notification_subscriptions[0].group.name}","identifier":"${warehouses[0].uuid}"},"payload":{"endpoint":"${push_notification_subscriptions[0].payload.endpoint}","publicKey":"${push_notification_subscriptions[0].payload.publicKey}","authToken":"${push_notification_subscriptions[0].payload.authToken}"},"localeName":"DU_AE"}}}
    Then Response status code should be:    400
    And Response reason should be:    Bad Request
    And Response should return error message:    Provided locale not found.
    And Response header parameter should be:    Content-Type    ${default_header_content_type}
    [Teardown]    Run Keywords    De-assign user from Warehouse in DB:    ${zed_admin.email}    ${warehouses[0].uuid}
    ...    AND    Delete warehouse in DB:   ${warehouses[0].uuid}
