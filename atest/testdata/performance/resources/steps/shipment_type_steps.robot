*** Settings ***
Library    DatabaseLibrary
Library    BuiltIn
Library    ../../resources/libraries/common.py
Resource    ../common/common_api.robot

*** Keywords ***
Get shipment type id from DB by key:
    [Documentation]    This keyword gets the entry ${id_shipment_type_store[0][0]} from the DB table `spy_shipment_type`. 
        ...    *Example:*
        ...
        ...    ``Get shipment type id from DB by key:   some-shipment-type-61152``
        ...
    [Arguments]    ${key}
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql' 
    ${id_shipment_type_store}    Query    SELECT id_shipment_type FROM spy_shipment_type WHERE `key` = '${key}' ORDER BY id_shipment_type DESC LIMIT 1;
    Disconnect From Database
    ELSE
    ${id_shipment_type_store}    Query    SELECT id_shipment_type FROM spy_shipment_type WHERE "key" = '${key}' ORDER BY id_shipment_type DESC LIMIT 1;
    END
    Disconnect From Database
    RETURN    ${id_shipment_type_store[0][0]}

Delete shipment type in DB:
    [Documentation]    This keyword deletes the entry from the DB table `spy_shipment_type`. If `withRelations=true`, deletes with relations.
        ...    *Example:*
        ...
        ...    ``Delete shipment type in DB:    some-shipment-type-61152    withRelations=true``
        ...
    [Arguments]    ${key}    ${withRelations}=${True}
    IF    ${withRelations}
        ${id_shipment_type_store}=    Get shipment type id from DB by key:    ${key} 
        Connect to Spryker DB
        IF    '${db_engine}' == 'pymysql' 
        Execute Sql String    DELETE FROM spy_shipment_type_store WHERE fk_shipment_type = ${id_shipment_type_store};
        Execute Sql String    DELETE FROM spy_shipment_type WHERE `key` = '${key}';
        ELSE
        Execute Sql String    DELETE FROM spy_shipment_type_store WHERE fk_shipment_type = ${id_shipment_type_store};
        Execute Sql String    DELETE FROM spy_shipment_type WHERE "key" = '${key}';
        END
        Disconnect From Database
    END
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql' 
        Execute Sql String    DELETE FROM spy_shipment_type WHERE `key` = '${key}';
    ELSE
        Execute Sql String    DELETE FROM spy_shipment_type WHERE "key" = '${key}';
    END
    Disconnect From Database