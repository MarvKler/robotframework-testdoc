*** Settings ***
Library    DatabaseLibrary
Library    BuiltIn
Library    ../../resources/libraries/common.py
Resource    ../common/common_api.robot

*** Keywords ***

Create_warehouse_user_assignment:
    [Documentation]    This keyword creates new warehouse user assignment in the DB table `spy_warehouse_user_assignment`.
        ...    *Example:*
        ...
        ...    ``Create_warehouse_user_assignment:   ${warehouse_uuid}    ${user_uuid}    false``
        ...
    [Arguments]    ${warehouse_uuid}    ${fk_warehouse}    ${user_uuid}    ${isActive}
    ${idWarehouseUserAssignment}=    Get next id from table    spy_warehouse_user_assignment    id_warehouse_user_assignment
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    insert ignore into spy_warehouse_user_assignment (uuid, fk_warehouse, user_uuid, is_active) value ('${warehouse_uuid}',${fk_warehouse}, '${user_uuid}', ${isActive});
    ELSE
        Execute Sql String    INSERT INTO spy_warehouse_user_assignment (id_warehouse_user_assignment, uuid, fk_warehouse, user_uuid, is_active) VALUES (${idWarehouseUserAssignment},'${warehouse_uuid}',${fk_warehouse}, '${user_uuid}', ${isActive});
    END
    Disconnect From Database

Get_warehouse_user_assignment_id:
    [Documentation]    This keyword retrieve  warehouse user assignment  ${id_warehouse_user_assignment} in the DB table `spy_warehouse_user_assignment` by uuid and user_uuid.
        ...    *Example:*
        ...
        ...    ``Get_warehouse_user_assignment_id:   ${warehouse_uuid}    ${user_uuid}`
        ...
    [Arguments]    ${warehouse_uuid}    ${user_uuid}
    Connect to Spryker DB
    ${id_warehouse_user_assignment}=   Query    SELECT id_warehouse_user_assignment FROM spy_warehouse_user_assignment WHERE uuid = '${warehouse_uuid}' AND user_uuid='${user_uuid}';
    Disconnect From Database
    Set Test Variable    ${id_warehouse_user_assignment}    ${id_warehouse_user_assignment[0][0]}
    RETURN    ${id_warehouse_user_assignment}

Remove_warehouse_user_assignment:
    [Documentation]    This keyword deletes the entry from the DB table `spy_warehouse_user_assignment`.
        ...    *Example:*
        ...
        ...    ``Remove_warehouse_user_assignment:    ${warehouse_uuid}    ${user_uuid}``
        ...
    [Arguments]    ${warehouse_uuid}    ${user_uuid}
    ${id_warehouse_user_assignment}=    Get_warehouse_user_assignment_id:   ${warehouse_uuid}    ${user_uuid}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_warehouse_user_assignment WHERE id_warehouse_user_assignment = ${id_warehouse_user_assignment};
    Disconnect From Database

Remove all warehouse user assignments by user uuid:
    [Documentation]    This keyword deletes all entries from the DB table `spy_warehouse_user_assignment` matching provided user_uuid.
        ...    *Example:*
        ...
        ...    ``Remove all warehouse user assignments by user uuid:    ${user_uuid}``
        ...
    [Arguments]    ${user_uuid}
    Connect to Spryker DB
    ${assignments}=    Query    SELECT id_warehouse_user_assignment FROM spy_warehouse_user_assignment WHERE user_uuid='${user_uuid}'
    FOR    ${row}    IN    @{assignments}
        ${assignment_id}=    Set Variable    ${row}[0]
        Execute Sql String    DELETE FROM spy_warehouse_user_assignment WHERE id_warehouse_user_assignment = ${assignment_id}
    END

Make user a warehouse user/ not a warehouse user:
    [Documentation]    This keyword update user with warehouse assignment in the DB table `spy_user`.
        ...    *Example:*
        ...
        ...    ``Make user a warehouse user/ not a warehouse user:   ${user_uuid}    0``
        ...
    [Arguments]    ${user_uuid}    ${isActive}
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    UPDATE spy_user SET is_warehouse_user = '${isActive}' WHERE uuid = '${user_uuid}';
    ELSE
        Execute Sql String    UPDATE spy_user SET is_warehouse_user = '${isActive}' WHERE uuid = '${user_uuid}';
    END
    Disconnect From Database