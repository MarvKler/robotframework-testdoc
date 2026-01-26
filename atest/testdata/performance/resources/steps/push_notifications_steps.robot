*** Settings ***
Library    DatabaseLibrary
Library    BuiltIn
Library    ../../resources/libraries/common.py
Resource    ../common/common_api.robot

*** Keywords ***
Create warehouse in DB:
    [Documentation]    This keyword creates a new entry in the DB table `spy_stock`.
        ...    *Example:*
        ...
        ...    ``Create warehouse in DB    name=Test    isActive=true   warehouseUuid=262feb9d-33a7-5c55-9b04-45b1fd22067e``
        ...
    [Arguments]    ${name}=${None}    ${isActive}=${True}    ${warehouseUuid}=${None}
    IF    '${name}' == '${None}'
        ${name}=    Generate Random String    5    [LETTERS]
    END
    IF    '${warehouseUuid}' == '${None}'
        ${uuid}=    Evaluate    uuid.uuid4()
    END
    ${idStock}=    Get next id from table    spy_stock    id_stock
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    INSERT IGNORE INTO spy_stock(name, uuid, is_active) VALUES ('${name}', '${warehouseUuid}', ${isActive});
    ELSE
        Execute Sql String    INSERT INTO spy_stock(id_stock, name, uuid, is_active) VALUES (${idStock}, '${name}', '${warehouseUuid}', ${isActive});
    END
    Disconnect From Database

Assign user to Warehouse in DB:
    [Documentation]    This keyword assigns provided user to a warehouse and makes user a warehouse-user.
    ...
    ...    It gets the UUID for the specified user ``${email}`` and ``${warehouseUuid}`` and saves it into spy_warehouse_user_assignment.
    ...    Also it updates `spy_user.is_warehouse_user` to true for specified user.
    ...
    ...    *Example:*
    ...
    ...    ``Assign user to Warehouse in DB:    richard@spryker.com   834b3731-02d4-5d6f-9a61-d63ae5e70517``
    [Arguments]    ${email}     ${warehouse_uuid}
    Connect to Spryker DB
    ${user_uuid}=    Query    SELECT uuid FROM spy_user WHERE username = '${email}' LIMIT 1
    ${fk_warehouse}=    Query    SELECT id_stock FROM spy_stock WHERE uuid = '${warehouse_uuid}' LIMIT 1
    Disconnect From Database
    ${idWarehouseUserAssignment}=    Get next id from table    spy_warehouse_user_assignment    id_warehouse_user_assignment
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    INSERT IGNORE INTO spy_warehouse_user_assignment (`uuid`, fk_warehouse, user_uuid, is_active) VALUE ('random_uuid', ${fk_warehouse[0][0]}, '${user_uuid[0][0]}', 1);
        Execute Sql String    UPDATE spy_user SET is_warehouse_user = 1 WHERE username = '${email}';
    ELSE
        Execute Sql String    INSERT INTO spy_warehouse_user_assignment (id_warehouse_user_assignment, uuid, fk_warehouse, user_uuid, is_active) VALUES (${idWarehouseUserAssignment}, 'random_uuid', ${fk_warehouse[0][0]}, '${user_uuid[0][0]}', true);
        Execute Sql String    UPDATE spy_user SET is_warehouse_user = true WHERE username = '${email}';
    END
    Disconnect From Database

De-assign user from Warehouse in DB:
    [Documentation]    This keyword de-assigns provided user from a warehouse and unmakes user a warehouse-user.
    ...
    ...    It gets the UUID for the specified user ``${email}`` and ``${warehouseUuid}`` and removes it from spy_warehouse_user_assignment.
    ...    Also it updates `spy_user.is_warehouse_user` to false for specified user.
    ...
    ...    *Example:*
    ...
    ...    ``De-assign user from Warehouse in DB:    richard@spryker.com   834b3731-02d4-5d6f-9a61-d63ae5e70517``
    [Arguments]    ${email}     ${warehouse_uuid}
    Connect to Spryker DB
    ${user_uuid}    Query    SELECT uuid FROM spy_user WHERE username = '${email}' LIMIT 1;
    ${fk_warehouse}    Query    SELECT id_stock FROM spy_stock WHERE uuid = '${warehouse_uuid}' LIMIT 1;
    Execute Sql String    DELETE FROM spy_warehouse_user_assignment WHERE user_uuid = '${user_uuid[0][0]}' AND fk_warehouse = ${fk_warehouse[0][0]};
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    UPDATE spy_user SET is_warehouse_user = 0 WHERE username = '${email}';
    ELSE
        Execute Sql String    UPDATE spy_user SET is_warehouse_user = false WHERE username = '${email}';
    END
    Disconnect From Database

Delete warehouse in DB:
    [Documentation]    This keyword deletes the entry from the DB table `spy_stock`.
        ...    *Example:*
        ...
        ...    ``Delete warehouse in DB    834b3731-02d4-5d6f-9a61-d63ae5e70517``
        ...
    [Arguments]    ${uuid}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_stock WHERE uuid = '${uuid}';
    Disconnect From Database

Delete push notification subscription in DB:
    [Documentation]    This keyword deletes the entry from the DB table `spy_push_notification_subscription`.
        ...    *Example:*
        ...
        ...    ``Delete push notification subscription in DB    834b3731-02d4-5d6f-9a61-d63ae5e70517``
        ...
    [Arguments]    ${uuid}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_push_notification_subscription WHERE uuid = '${uuid}';
    Disconnect From Database