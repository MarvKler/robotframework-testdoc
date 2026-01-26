*** Settings ***
Suite Setup    API_suite_setup
Test Setup     API_test_setup
Resource       ../../../../../../resources/common/common_api.robot
Test Tags    glue    availability-notification    spryker-core    mailing-notifications    customer-access    acl    inventory-management    marketplace-inventory-management 

*** Test Cases ***
#GET requests
Get_availability_notifications_for_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /availability-notifications    {"data": {"type": "availability-notifications","attributes": {"sku": "${product_with_alternative.concrete_sku}","email": "${yves_user.email}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    availability_notification_id
    When I send a GET request:    /customers/${yves_user.reference}/availability-notifications
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response body parameter should be:    [data][0][type]    availability-notifications
    And Response body parameter should be:    [data][0][id]    ${availability_notification_id}
    And Response body parameter should be:    [data][0][attributes][email]    ${yves_user.email}
    And Response body parameter should be:    [data][0][attributes][sku]    ${product_with_alternative.concrete_sku}
    And Response body has correct self link
    [Teardown]    Run Keywords    I send a DELETE request:    /availability-notifications/${availability_notification_id}
    ...  AND    Response status code should be:    204

Get_empty_list_of_availability_notifications_for_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    When I send a GET request:    /customers/${yves_user.reference}/availability-notifications
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    0
    And Response body has correct self link

#POST requests
Subscribe_to_availability_notifications_for_customer
    When I send a POST request:    /availability-notifications    {"data": {"type": "availability-notifications","attributes": {"sku": "${product_with_alternative.concrete_sku}","email": "${yves_user.email}"}}}
    And Save value to a variable:    [data][id]    availability_notification_id
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    availability-notifications
    And Response body parameter should be:    [data][id]    ${availability_notification_id}
    And Response body parameter should not be EMPTY:    [data][attributes][localeName]
    And Response body parameter should be:    [data][attributes][email]    ${yves_user.email}
    And Response body parameter should be:    [data][attributes][sku]    ${product_with_alternative.concrete_sku}
    And Response body has correct self link for created entity:    ${availability_notification_id}
    [Teardown]    Run Keywords    I send a DELETE request:    /availability-notifications/${availability_notification_id}
    ...  AND    Response status code should be:    204

Subscribe_to_availability_notifications_with_non_existing_email
    When I send a POST request:    /availability-notifications    {"data": {"type": "availability-notifications","attributes": {"sku": "${product_with_alternative.concrete_sku}","email": "sonia+${random}@spryker.com"}}}
    And Save value to a variable:    [data][id]    availability_notification_id
    Then Response status code should be:    201
    And Response reason should be:    Created
    And Response body parameter should be:    [data][type]    availability-notifications
    And Response body parameter should be:    [data][id]    ${availability_notification_id}
    And Response body parameter should not be EMPTY:    [data][attributes][localeName]
    And Response body parameter should be:    [data][attributes][email]    sonia+${random}@spryker.com
    And Response body parameter should be:    [data][attributes][sku]    ${product_with_alternative.concrete_sku}
    And Response body has correct self link for created entity:    ${availability_notification_id}
    [Teardown]    Run Keywords    I send a DELETE request:    /availability-notifications/${availability_notification_id}
    ...  AND    Response status code should be:    204

#DELETE requests
Delete_availability_notifications_for_customer
    [Setup]    Run Keywords    I get access token for the customer:    ${yves_user.email}
    ...  AND    I set Headers:    Authorization=${token}
    ...  AND    I send a POST request:    /availability-notifications    {"data": {"type": "availability-notifications","attributes": {"sku": "${product_with_alternative.concrete_sku}","email": "${yves_user.email}"}}}
    ...  AND    Response status code should be:    201
    ...  AND    Save value to a variable:    [data][id]    availability_notification_id
    When I send a DELETE request:    /availability-notifications/${availability_notification_id}
    Then Response status code should be:    204
    And Response reason should be:    No Content
    When I send a GET request:    /customers/${yves_user.reference}/availability-notifications
    Then Response status code should be:    200
    And Response reason should be:    OK
    And Response should contain the array of a certain size:    [data]    0
    And Response body has correct self link