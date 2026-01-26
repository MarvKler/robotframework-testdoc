*** Settings ***
Resource        ../../../../../../resources/common/common_api.robot
Suite Setup     API_suite_setup
Test Setup      API_test_setup
Test Tags    glue

*** Test Cases ***
#GET requests

### Precondition: To run commented tests need to enable service endpoints and uncomment tests
### To enable the endpoints, add the following to /config/Shared/config_default.php:
### Spryker\Shared\HealthCheck\HealthCheckConstants;$config[HealthCheckConstants::HEALTH_CHECK_ENABLED] = true;
### Doc: https://docs.spryker.com/docs/scos/dev/technical-enhancement-integration-guides/integrating-health-checks.html#general-information

# Get_health_check_with_disabled_services
#     [Documentation]    Test works only if all services are disabled as default
#     When I send a GET request:    /health-check
#     Then Response status code should be:    403
#     And Response reason should be:    Forbidden
#     And Response body parameter should be:    [data][0][type]    health-check
#     And Response body parameter should be:    [data][0][id]    None
#     And Response body parameter should be:    [data][0][attributes][status]    None
#     And Response body parameter should be:    [data][0][attributes][statusCode]    403
#     And Response body parameter should be:    [data][0][attributes][message]    HealthCheck endpoints are disabled for all applications.
#     And Response should contain the array of a certain size:    [data][0][attributes][healthCheckServiceResponses]    0
#     And Response body has correct self link

# Get_health_check_with_invalid_service_name
#     When I send a GET request:    /health-check?services=sear
#     Then Response status code should be:    400
#     And Response reason should be:    Bad Request
#     And Response body parameter should be:    [data][0][type]    health-check
#     And Response body parameter should be:    [data][0][id]    None
#     And Response body parameter should be:    [data][0][attributes][status]    None
#     And Response body parameter should be:    [data][0][attributes][statusCode]    400
#     And Response body parameter should be:    [data][0][attributes][message]    Requested services not found.
#     And Response should contain the array of a certain size:    [data][0][attributes][healthCheckServiceResponses]    0
#     And Response body has correct self link

# Get_health_check_with_empty_service_name
#     When I send a GET request:    /health-check?services=
#     Then Response status code should be:    400
#     And Response reason should be:    Bad Request
#     And Response body parameter should be:    [data][0][type]    health-check
#     And Response body parameter should be:    [data][0][id]    None
#     And Response body parameter should be:    [data][0][attributes][status]    None
#     And Response body parameter should be:    [data][0][attributes][statusCode]    400
#     And Response body parameter should be:    [data][0][attributes][message]    Requested services not found.
#     And Response should contain the array of a certain size:    [data][0][attributes][healthCheckServiceResponses]    0
#     And Response body has correct self link

# Get_health_check_with_non_existing_id
#     [Tags]    skip-due-to-issue   
#     [Documentation]    The bug https://spryker.atlassian.net/browse/CC-16492 related to the self link and required ID
#     When I send a GET request:    /health-check/1
#     Then Response status code should be:    200
#     And Response reason should be:    OK
#     And Response body parameter should be:    [data][type]    health-check
#     And Response body parameter should be:    [data][id]    None
#     And Response body parameter should be:    [data][attributes][status]    healthy
#     And Response body parameter should be:    [data][attributes][statusCode]    200
#     And Response body parameter should be:    [data][attributes][message]    None
#     And Response body parameter should be:    [data][attributes][healthCheckServiceResponses][0][name]    search
#     And Response body parameter should be:    [data][attributes][healthCheckServiceResponses][1][name]    storage
#     And Response body parameter should be:    [data][attributes][healthCheckServiceResponses][2][name]    zed-request
#     And Each array element of array in response should contain property with value:    [data][attributes][healthCheckServiceResponses]    status    True
#     And Each array element of array in response should contain property with value:    [data][attributes][healthCheckServiceResponses]    message    None
#     And Response body has correct self link internal
