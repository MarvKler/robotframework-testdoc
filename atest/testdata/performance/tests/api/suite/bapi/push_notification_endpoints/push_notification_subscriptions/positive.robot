*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/push_notifications_steps.robot
Test Tags    bapi    push-notification    spryker-core    spryker-core-back-office

*** Test Cases ***
Creates_push_notification_subscription_with_correct_locale
    [Setup]    Run Keywords    Create warehouse in DB:    ${warehouses[0].name}     ${True}     ${warehouses[0].uuid}
    ...    AND    Assign user to Warehouse in DB:    ${zed_admin.email}    ${warehouses[0].uuid}
    I get access token by user credentials:    ${zed_admin.email}
    When I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    And I send a POST request:    /push-notification-subscriptions    {"data":{"type":"push-notification-subscriptions","attributes":{"providerName":"${push_notification_subscriptions[0].providerName}","group":{"name":"${push_notification_subscriptions[0].group.name}","identifier":"${warehouses[0].uuid}"},"payload":{"endpoint":"${push_notification_subscriptions[0].payload.endpoint}","publicKey":"${push_notification_subscriptions[0].payload.publicKey}","authToken":"${push_notification_subscriptions[0].payload.authToken}"},"localeName":"${locale.DE.name}"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    push_notification_subscription_uuid
    And Response body parameter should be:    [data][type]    push-notification-subscriptions
    And Response body parameter should be:    [data][attributes][providerName]    ${push_notification_subscriptions[0].providerName}
    And Response body parameter should be:    [data][attributes][payload][endpoint]    ${push_notification_subscriptions[0].payload.endpoint}
    And Response body parameter should be:    [data][attributes][payload][publicKey]    ${push_notification_subscriptions[0].payload.publicKey}
    And Response body parameter should be:    [data][attributes][payload][authToken]    ${push_notification_subscriptions[0].payload.authToken}
    And Response body parameter should be:    [data][attributes][localeName]    ${locale.DE.name}
    And Response body parameter should be:    [data][attributes][group][name]    ${push_notification_subscriptions[0].group.name}
    And Response body parameter should be:    [data][attributes][group][identifier]    ${warehouses[0].uuid}
    [Teardown]    Run Keywords    De-assign user from Warehouse in DB:    ${zed_admin.email}    ${warehouses[0].uuid}
    ...    AND    Delete warehouse in DB:   ${warehouses[0].uuid}
    ...    AND    Delete push notification subscription in DB:    ${push_notification_subscription_uuid}

Creates_push_notification_subscription_without_locale
    [Setup]    Run Keywords    Create warehouse in DB:    ${warehouses[0].name}     ${True}     ${warehouses[0].uuid}
    ...    AND    Assign user to Warehouse in DB:    ${zed_admin.email}    ${warehouses[0].uuid}
    I get access token by user credentials:    ${zed_admin.email}
    When I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    And I send a POST request:    /push-notification-subscriptions    {"data":{"type":"push-notification-subscriptions","attributes":{"providerName":"${push_notification_subscriptions[0].providerName}","group":{"name":"${push_notification_subscriptions[0].group.name}","identifier":"${warehouses[0].uuid}"},"payload":{"endpoint":"${push_notification_subscriptions[0].payload.endpoint}","publicKey":"${push_notification_subscriptions[0].payload.publicKey}","authToken":"${push_notification_subscriptions[0].payload.authToken}"}}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    push_notification_subscription_uuid
    And Response body parameter should be:    [data][type]    push-notification-subscriptions
    And Response body parameter should be:    [data][attributes][providerName]    ${push_notification_subscriptions[0].providerName}
    And Response body parameter should be:    [data][attributes][payload][endpoint]    ${push_notification_subscriptions[0].payload.endpoint}
    And Response body parameter should be:    [data][attributes][payload][publicKey]    ${push_notification_subscriptions[0].payload.publicKey}
    And Response body parameter should be:    [data][attributes][payload][authToken]    ${push_notification_subscriptions[0].payload.authToken}
    And Response body parameter should be:    [data][attributes][localeName]    None
    And Response body parameter should be:    [data][attributes][group][name]    ${push_notification_subscriptions[0].group.name}
    And Response body parameter should be:    [data][attributes][group][identifier]    ${warehouses[0].uuid}
    [Teardown]    Run Keywords    De-assign user from Warehouse in DB:    ${zed_admin.email}    ${warehouses[0].uuid}
    ...    AND    Delete warehouse in DB:   ${warehouses[0].uuid}
    ...    AND    Delete push notification subscription in DB:    ${push_notification_subscription_uuid}
