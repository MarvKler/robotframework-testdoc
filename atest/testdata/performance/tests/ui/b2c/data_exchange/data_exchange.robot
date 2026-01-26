*** Settings ***
Suite Setup       UI_suite_setup
Test Setup        UI_test_setup
Test Teardown     UI_test_teardown
Suite Teardown    UI_suite_teardown
Test Tags    robot:recursive-stop-on-failure    group_two
Resource    ../../../../resources/common/common.robot
Resource    ../../../../resources/steps/header_steps.robot
Resource    ../../../../resources/common/common_yves.robot
Resource    ../../../../resources/common/common_zed.robot
Resource    ../../../../resources/common/common_mp.robot
Resource    ../../../../resources/steps/pdp_steps.robot
Resource    ../../../../resources/steps/shopping_lists_steps.robot
Resource    ../../../../resources/steps/checkout_steps.robot
Resource    ../../../../resources/steps/order_history_steps.robot
Resource    ../../../../resources/steps/product_set_steps.robot
Resource    ../../../../resources/steps/catalog_steps.robot
Resource    ../../../../resources/steps/agent_assist_steps.robot
Resource    ../../../../resources/steps/company_steps.robot
Resource    ../../../../resources/steps/customer_account_steps.robot
Resource    ../../../../resources/steps/zed_users_steps.robot
Resource    ../../../../resources/steps/products_steps.robot
Resource    ../../../../resources/steps/orders_management_steps.robot
Resource    ../../../../resources/steps/zed_customer_steps.robot
Resource    ../../../../resources/steps/zed_discount_steps.robot
Resource    ../../../../resources/steps/zed_availability_steps.robot
Resource    ../../../../resources/steps/zed_cms_page_steps.robot
Resource    ../../../../resources/steps/merchant_profile_steps.robot
Resource    ../../../../resources/steps/zed_marketplace_steps.robot
Resource    ../../../../resources/steps/mp_profile_steps.robot
Resource    ../../../../resources/steps/mp_orders_steps.robot
Resource    ../../../../resources/steps/mp_offers_steps.robot
Resource    ../../../../resources/steps/mp_products_steps.robot
Resource    ../../../../resources/steps/mp_account_steps.robot
Resource    ../../../../resources/steps/mp_dashboard_steps.robot
Resource    ../../../../resources/steps/zed_root_menus_steps.robot
Resource    ../../../../resources/steps/minimum_order_value_steps.robot
Resource    ../../../../resources/steps/availability_steps.robot
Resource    ../../../../resources/steps/glossary_steps.robot
Resource    ../../../../resources/steps/order_comments_steps.robot
Resource    ../../../../resources/steps/configurable_product_steps.robot
Resource    ../../../../resources/steps/dynamic_entity_steps.robot
Resource    ../../../../resources/steps/api_dynamic_entity_steps.robot

*** Test Cases ***
Data_exchange_API_download_specification
    [Documentation]    DMS-ON: https://spryker.atlassian.net/browse/FRW-7396
    [Setup]    Trigger API specification update
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
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
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: edit data exchange api configuration:
    ...    || table_name  | is_enabled ||
    ...    || mime-types  | false      ||
    ...    AND    Zed: save data exchange api configuration
    ...    AND    Trigger API specification update
    ...    AND    Zed: wait until info box is not displayed
    ...    AND    Zed: delete downloaded api specification
    ...    AND    Delete dynamic entity configuration in Database:    mime-types
    ...    AND    Trigger API specification update

Data_exchange_API_Configuration_in_Zed
    [Documentation]    DMS-ON: https://spryker.atlassian.net/browse/FRW-7396
    [Tags]    bapi
    [Setup]    Trigger API specification update
    Zed: login on Zed with provided credentials:    ${zed_admin_email}
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
    I get access token by user credentials:   ${zed_admin_email}
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
    [Teardown]    Run Keywords    Zed: login on Zed with provided credentials:    ${zed_admin_email}
    ...    AND    Zed: edit data exchange api configuration:
    ...    || table_name  | is_enabled ||
    ...    || mime-types  | false      ||
    ...    AND    Zed: save data exchange api configuration
    ...    AND    Trigger API specification update
    ...    AND    Zed: wait until info box is not displayed
    ...    AND    Delete dynamic entity configuration in Database:    mime-types
    ...    AND    Delete mime_type by id_mime_type in Database:    ${id_mime_type}
    ...    AND    Trigger API specification update
