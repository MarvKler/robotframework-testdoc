*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/push_notifications_steps.robot
Test Tags    bapi

*** Test Cases ***
Create_push_notification_provider
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider ${random}"}}}
    Then Response status code should be:    201
    And Response body parameter should not be EMPTY:    [data][id]
    And Save value to a variable:    [data][id]    push_notification_provider_id
    And Response body parameter should be:    [data][type]    push-notification-providers
    And Response body parameter should not be EMPTY:    [data][attributes][uuid]
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    And Response body parameter should be:    [data][attributes][name]    My Push Notification Provider ${random}
    And Response body has correct self link for created entity:    ${push_notification_provider_id}
    [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}

Create_push_notification_provider_with_255_characters_in_the_name
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "testProviderNameadkjhsjkdhsjkdsjdsjdjsdfsdbshajdbshdhsdsadbfsadhjfsajdfhbwehfdnmsabdfmsbdafnmbsadfnmasbdfnabfnasbdfnasdbfsndafbsnadfbsnfbsnfbsndfbsnafbsanfbsanfmbasnfabsfnabsfnas fnceaschgewahcaehewdhdbsadbcashdcdsacsedfseffsfdfedrfreferfferferferferfrfer"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    push_notification_provider_id
    And Response body parameter should be:    [data][attributes][name]    testProviderNameadkjhsjkdhsjkdsjdsjdjsdfsdbshajdbshdhsdsadbfsadhjfsajdfhbwehfdnmsabdfmsbdafnmbsadfnmasbdfnabfnasbdfnasdbfsndafbsnadfbsnfbsnfbsndfbsnafbsanfbsanfmbasnfabsfnabsfnas fnceaschgewahcaehewdhdbsadbcashdcdsacsedfseffsfdfedrfreferfferferferferfrfer
    [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}

Update_push_notification_provider
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider ${random}"}}}
    Then Save value to a variable:    [data][id]    push_notification_provider_id
    When I send a PATCH request:    /push-notification-providers/${push_notification_provider_id}    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider Updated ${random}"}}}
    Then Response status code should be:    200
    And Response body parameter should be:    [data][type]    push-notification-providers
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    And Response body parameter should not be EMPTY:    [data][attributes][uuid]
    And Response body parameter should be:    [data][attributes][name]    My Push Notification Provider Updated ${random}
    And Response body has correct self link internal
    [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}

Retrieve_push_notification_providers
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider1 ${random}"}}}
    Then Save value to a variable:    [data][id]    push_notification_provider_id
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider2 ${random}"}}}
    Then Save value to a variable:    [data][id]    push_notification_provider_id_2
    When I send a GET request:    /push-notification-providers
    Then Response status code should be:    200
    And Response should contain the array larger than a certain size:    [data]    1
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body parameter should not be EMPTY:    [data][1][id]
    And Response body parameter should be:    [data][0][type]    push-notification-providers
    And Response body parameter should be:    [data][1][type]    push-notification-providers
    And Each array in response should contain property with NOT EMPTY value:    [data]    [attributes][name]
    And Each array in response should contain property with NOT EMPTY value:    [data]    [attributes][uuid]
    [Teardown]     Run Keywords    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}
    ...    AND    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id_2}
    
Retrieve_push_notification_provider_with_pagination
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    # And I send a DELETE request:    /push-notification-providers/${push_notification_provider_uuid}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My-Push-Notification1${random}"}}}
    Then Save value to a variable:    [data][id]    push_notification_provider_id
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My-Push-Notification2${random}"}}}
    Then Save value to a variable:    [data][id]    push_notification_provider_id_2
    When I send a GET request:    /push-notification-providers?page[offset]=1&page[limit]=1
    Then Response status code should be:    200
    And Response body parameter should not be EMPTY:    [data][0][id]
    And Response body parameter should be:    [data][0][type]    push-notification-providers
    And Response body parameter should not be EMPTY:    [data][0][attributes][uuid]
    And Response body parameter should not be EMPTY:    [data][0][attributes][name]
    And Response body parameter should be:    [data][0][attributes][name]    My-Push-Notification1${random}
    [Teardown]     Run Keywords    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}
    ...    AND    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id_2}

Retrieve_push_notification_provider_with_sorting
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "A-My-Push-Notification"}}}
    Then Save value to a variable:    [data][id]    push_notification_provider_id
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "B-My-Push-Notification"}}}
    Then Save value to a variable:    [data][id]    push_notification_provider_id_2
    When I send a GET request:    /push-notification-providers?sort=-name
    Then Response status code should be:    200
    And Response body parameter should be:    [data][0][attributes][name]    web-push-php
    And Response body parameter should be:    [data][1][attributes][name]    B-My-Push-Notification
    And Response body parameter should be:    [data][2][attributes][name]    A-My-Push-Notification
    [Teardown]     Run Keywords    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}
    ...    AND    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id_2}

Retrieve_push_notification_provider_by_id
    [Setup]    Run Keywords    I get access token by user credentials:   ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=application/vnd.api+json   Authorization=Bearer ${token}
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider ${random}"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    push_notification_provider_id
    When I send a GET request:    /push-notification-providers/${push_notification_provider_id}
    Then Response status code should be:    200
    And Response body parameter should not be EMPTY:    [data][id]
    And Save value to a variable:    [data][id]    push_notification_provider_id
    And Response body parameter should be:    [data][type]    push-notification-providers
    And Response body parameter should not be EMPTY:    [data][attributes][uuid]
    And Response body parameter should not be EMPTY:    [data][attributes][name]
    And Response body parameter should be:    [data][attributes][name]    My Push Notification Provider ${random}
    [Teardown]    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}

Delete_push_notification_provider_while_push_notification_subscribtion_exists
    [Setup]    Run Keywords    Create warehouse in DB:    ${warehouses.name}     ${True}     ${warehouses.uuid}
    ...    AND    Assign user to Warehouse in DB:    admin@spryker.com   ${warehouses.uuid}
    I get access token by user credentials:    admin@spryker.com
    When I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    # create a provider for push notification
    When I send a POST request:    /push-notification-providers    {"data": {"type": "push-notification-providers","attributes": {"name": "My Push Notification Provider ${random}"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    push_notification_provider_id
    And Save value to a variable:    [data][attributes][name]    push_notification_provider_name
    # create a subscription
    And I send a POST request:    /push-notification-subscriptions    {"data":{"type":"push-notification-subscriptions","attributes":{"providerName":"${push_notification_provider_name}","group":{"name":"${push_notification_subscriptions[0].group.name}","identifier":"${warehouses.uuid}"},"payload":{"endpoint":"${push_notification_subscriptions[0].payload.endpoint}","publicKey":"${push_notification_subscriptions[0].payload.publicKey}","authToken":"${push_notification_subscriptions[0].payload.authToken}"},"localeName":"${locale.DE.name}"}}}
    Then Response status code should be:    201
    And Save value to a variable:    [data][id]    push_notification_subscription_uuid
    Then I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}
    Then Response status code should be:    400
    And Response should return error code:    5004
    And Response should return error message:    Unable to delete push notification provider while push notification subscription exists.
    [Teardown]    Run Keywords    De-assign user from Warehouse in DB:    admin@spryker.com    ${warehouses.uuid}
    ...    AND    Delete warehouse in DB:   ${warehouses.uuid}
    ...    AND    Delete push notification subscription in DB:    ${push_notification_subscription_uuid}
    ...    AND    I send a DELETE request:    /push-notification-providers/${push_notification_provider_id}