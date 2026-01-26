*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_tree
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/steps/dynamic_entity_steps.robot
Resource    ../../../../resources/steps/api_dynamic_entity_steps.robot

*** Test Cases ***
Data_exchange_API_download_specification
    [Setup]    Run Keywords    Trigger API specification update
    ...    AND    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: download data exchange api specification should be active:    true
    Zed: download data exchange api specification
    Zed: check that downloaded api specification contains:    /dynamic-entity/product-abstracts
    Zed: check that downloaded api specification does not contain:    /dynamic-entity/mime-types
    Zed: delete downloaded api specification
    Zed: start creation of new data exchange api configuration for db table:    spy_mime_type
    Zed: edit data exchange api configuration:
    ...    || table_name  | is_enabled ||
    ...    || mime-types  | true       ||
    Zed: edit data exchange api configuration:
    ...    || field_name   | enabled | visible_name | type    | creatable | editable | required ||
    ...    || id_mime_type | true    | id_mime_type | integer | true      | false    | false    ||
    Zed: edit data exchange api configuration:
    ...    || field_name  | enabled | visible_name | type    | creatable | editable | required ||
    ...    || comment     | true    | comment      | string  | true      | true     | false    ||
    Zed: edit data exchange api configuration:
    ...    || field_name  | enabled | visible_name | type    | creatable | editable | required ||
    ...    || extensions  | true    | extensions   | string  | true      | true     | false    ||
    Zed: edit data exchange api configuration:
    ...    || field_name  | enabled | visible_name | type    | creatable | editable | required ||
    ...    || is_allowed  | true    | is_allowed   | boolean | true      | true     | true     ||
    Zed: edit data exchange api configuration:
    ...    || field_name | enabled | visible_name | type   | creatable | editable | required ||
    ...    || name       | true    | name         | string | true      | true     | true     ||
    Zed: save data exchange api configuration
    Zed: download data exchange api specification should be active:    false
    Trigger API specification update
    Zed: wait until info box is not displayed
    Zed: download data exchange api specification
    Zed: check that downloaded api specification contains:    /mime-types
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: edit data exchange api configuration:
    ...    || table_name  | is_enabled ||
    ...    || mime-types  | false      ||
    ...    AND    Zed: save data exchange api configuration
    ...    AND    Trigger API specification update
    ...    AND    Zed: wait until info box is not displayed
    ...    AND    Zed: delete downloaded api specification
    ...    AND    Delete dynamic entity configuration in Database:    mime-types
    ...    AND    Trigger API specification update
    ...    AND    Delete dynamic admin user from DB

Data_exchange_API_Configuration_in_Zed
    [Tags]    bapi
    [Setup]    Run Keywords    Trigger API specification update
    ...    AND    Create dynamic admin user in DB
    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    Zed: start creation of new data exchange api configuration for db table:    spy_mime_type
    Zed: edit data exchange api configuration:
    ...    || table_name  | is_enabled ||
    ...    || mime-types  | true       ||
    Zed: edit data exchange api configuration:
    ...    || field_name   | enabled | visible_name | type    | creatable | editable | required ||
    ...    || id_mime_type | true    | id_mime_type | integer | true      | false    | false    ||
    Zed: edit data exchange api configuration:
    ...    || field_name  | enabled | visible_name | type    | creatable | editable | required ||
    ...    || comment     | true    | comment      | string  | true      | true     | false    ||
    Zed: edit data exchange api configuration:
    ...    || field_name  | enabled | visible_name | type    | creatable | editable | required ||
    ...    || extensions  | true    | extensions   | string  | true      | true     | false    ||
    Zed: edit data exchange api configuration:
    ...    || field_name  | enabled | visible_name | type    | creatable | editable | required ||
    ...    || is_allowed  | true    | is_allowed   | boolean | true      | true     | true     ||
    Zed: edit data exchange api configuration:
    ...    || field_name | enabled | visible_name | type   | creatable | editable | required ||
    ...    || name       | true    | name         | string | true      | true     | true     ||
    Zed: save data exchange api configuration
    Trigger API specification update
    Trigger multistore p&s
    Zed: wait until info box is not displayed
    API_test_setup
    I get access token by user credentials:   ${dynamic_admin_user}
    ### CREATE TEST MIME TYPE USING DATA EXCHANGE API ###
    I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    I send a POST request:    /dynamic-entity/mime-types    {"data":[{"name":"POST ${random}","is_allowed":false,"extensions":"fake"}]}
    Response status code should be:    201
    Response header parameter should be:    Content-Type    application/json
    Response body parameter should be:    [data][0][name]    POST ${random}
    Response body parameter should be:    [data][0][is_allowed]    False
    Response body parameter should be:    [data][0][extensions]    fake
    Response body parameter should be:    [data][0][comment]    None
    Save value to a variable:    [data][0][id_mime_type]    id_mime_type
    ### UPDATE TEST MIME TYPE USING DATA EXCHANGE API ###
    I send a PATCH request:    /dynamic-entity/mime-types/${id_mime_type}    {"data":{"comment":null,"extensions":"dummy","is_allowed":true,"name":"PATCH ${random}"}}
    Response status code should be:    200
    ### GET UPDATE TEST MIME TYPE BY ID ###
    I send a GET request:    /dynamic-entity/mime-types/${id_mime_type}
    Response status code should be:    200
    Response header parameter should be:    Content-Type    application/json
    Response body parameter should be:    [data][name]    PATCH ${random}
    Response body parameter should be:    [data][is_allowed]    True
    Response body parameter should be:    [data][extensions]    dummy
    Response body parameter should be:    [data][comment]    None
    ### DELETE TEST CONFIGURATION AND TEST MIME TYPE FROM DB ###
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${dynamic_admin_user}
    ...    AND    Zed: edit data exchange api configuration:
    ...    || table_name  | is_enabled ||
    ...    || mime-types  | false      ||
    ...    AND    Zed: save data exchange api configuration
    ...    AND    Trigger API specification update
    ...    AND    Zed: wait until info box is not displayed
    ...    AND    Delete dynamic entity configuration in Database:    mime-types
    ...    AND    Delete mime_type by id_mime_type in Database:    ${id_mime_type}
    ...    AND    Trigger API specification update
    ...    AND    Delete dynamic admin user from DB
