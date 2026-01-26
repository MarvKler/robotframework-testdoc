*** Settings ***
Resource    ../common/common_api.robot

*** Keywords ***
Create api key in db
    [Documentation]    This keyword creates api key hash for data exchange api in the DB table spy_api_key. Key hash is static and matches env variable `dummy_api_key`.
    ...
    ...    Each combination of `dummy_api_key` and `dummy_key_hash` is unique
    ...
    ### works for MariaDB and PostgreSQL ###
    [Arguments]    ${key_hash}=${dummy_key_hash}    ${created_by}=1
    Connect to Spryker DB
    ${hash_id}=    Query    select id_api_key from spy_api_key WHERE key_hash='${key_hash}';
    ${hash_id_length}=    Get Length    ${hash_id}
    IF    ${hash_id_length} > 0
        Execute Sql String    DELETE FROM spy_api_key WHERE key_hash='${key_hash}';
    END
    ${new_id}=    Get next id from table    spy_api_key    id_api_key
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String  insert into spy_api_key (id_api_key, name, key_hash, created_by) value ('${new_id}', 'autotest${random}', '${key_hash}', '${created_by}');
    ELSE
        Execute Sql String  insert into spy_api_key (id_api_key, name, key_hash, created_by) values ('${new_id}', 'autotest${random}', '${key_hash}', '${created_by}');
    END
    Disconnect From Database

Delete api key from db
    [Documentation]    This keyword deletes api key hash for data exchange api in the DB table spy_api_key.
    ...
    ### works for MariaDB and PostgreSQL ###
    [Arguments]    ${key_hash}=${dummy_key_hash}
    Connect to Spryker DB
    ${hash_id}=    Query    select id_api_key from spy_api_key WHERE key_hash='${key_hash}';
    ${hash_id_length}=    Get Length    ${hash_id}
    IF    ${hash_id_length} > 0
        Execute Sql String    DELETE FROM spy_api_key WHERE key_hash='${key_hash}';
    END
    Disconnect From Database

Delete mime_type by id_mime_type in Database:
    [Documentation]    This keyword deletes a mime type by id_mime_type in the DB table spy_mime_type.
        ...    *Example:*
        ...
        ...    ``Delete mime_type by id_mime_type in Database:    21``
        ...
    [Arguments]    ${id_mime_type}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_mime_type WHERE id_mime_type = '${id_mime_type}';
    Disconnect From Database

Find first available product via data exchange api
    [Arguments]    ${start_from_index}=0    ${end_index}=100
    Remove Tags    *
    Set Tags    bapi
    API_test_setup
    I get access token by user credentials:   ${zed_admin.email}
    I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    FOR    ${index}    IN RANGE    ${start_from_index}    ${end_index}
        I send a GET request:    /dynamic-entity/stock-products/${index}
        ${is_200}=    Run Keyword And Ignore Error    Response status code should be:    200
        IF    'FAIL' in $is_200    Continue For Loop
        Save value to a variable:    [data][is_never_out_of_stock]    initial_is_never_out_of_stock
        Save value to a variable:    [data][quantity]    initial_quantity
        IF    '${initial_is_never_out_of_stock}' == 'False'
                IF    ${initial_quantity} > 0
                    Save value to a variable:    [data][fk_product]    fk_product
                    Set Test Variable    ${index}    ${index}
                    Exit For Loop
                ELSE
                    Continue For Loop
                END
        ELSE
            Save value to a variable:    [data][fk_product]    fk_product
            Set Test Variable    ${index}    ${index}
            Exit For Loop
        END
    END
    Get concrete product sku by id from DB:    ${fk_product}
    Make sure that concrete product is available:    ${concrete_sku}
    RETURN    ${concrete_sku}

Make sure that concrete product is available:
    [Arguments]    ${sku}=${concrete_sku}
    Remove Tags    *
    Set Tags    glue
    API_test_setup
    I set Headers:    Content-Type==application/json
    I send a GET request:    /concrete-products/${concrete_sku}/concrete-product-availabilities
    ${is_available}=    Run Keyword And Ignore Error    Response body parameter should be:    [data][0][attributes][availability]   True
    IF    'FAIL' in $is_available
        ${index}=    Evaluate    ${index}+1
        Find first available product via data exchange api    ${index}
    END

Product availability status should be changed on:
    [Arguments]    ${is_available}    ${sku}=${concrete_sku}    ${sleep_time}=5s    ${iterations}=26
    ${is_available}=    Convert To Title Case    ${is_available}
    Remove Tags    *
    Set Tags    glue
    API_test_setup
    I set Headers:    Content-Type==application/json
    FOR    ${index}    IN RANGE    1    ${iterations}
        I send a GET request:    /concrete-products/${concrete_sku}/concrete-product-availabilities
        Response status code should be:    200
        ${actual_availability}=    Run Keyword And Ignore Error    Response body parameter should be:    [data][0][attributes][availability]   ${is_available}
        IF    ${index} == ${iterations}-1
            Fail    Expected product availability is not reached. Check P&S
        END
        IF    'PASS' in $actual_availability
            Exit For Loop
        END
        IF    'FAIL' in $actual_availability
            Sleep    ${sleep_time}
            Continue For Loop
        END

    END

Restore product initial stock via data exchange api:
    [Arguments]    ${id_stock_product}=${index}
    Remove Tags    *
    Set Tags    bapi
    API_test_setup
    I get access token by user credentials:   ${zed_admin.email}
    I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    Log    ${initial_is_never_out_of_stock}
    ${initial_is_never_out_of_stock}=    To JSON Boolean    ${initial_is_never_out_of_stock}
    I send a PATCH request:    /dynamic-entity/stock-products/${id_stock_product}    {"data":{"is_never_out_of_stock":${initial_is_never_out_of_stock},"quantity":${initial_quantity}}}
