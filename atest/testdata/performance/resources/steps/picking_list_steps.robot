*** Settings ***
Library    DatabaseLibrary
Library    BuiltIn
Library    ../../resources/libraries/common.py
Resource   ../common/common_api.robot

*** Keywords ***
Remove picking list by uuid in DB:
    [Documentation]    This keyword deletes the entry from the DB table `spy_picking_list`.
        ...    *Example:*
        ...
        ...    ``Remove picking list by uuid in DB:    ${pick_list_uuid}``
        ...
    [Arguments]    ${pick_list_uuid}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_picking_list WHERE uuid = '${pick_list_uuid}';
    Disconnect From Database

Remove picking list item by uuid in DB:
    [Documentation]    This keyword deletes the entry from the DB table `spy_warehouse_user_assignment`.
        ...    *Example:*
        ...
        ...    ``Remove picking list item by uuid in DB:    ${pick_list_item_uuid}``
        ...
    [Arguments]    ${pick_list_item_uuid}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_picking_list_item WHERE uuid = '${pick_list_item_uuid}';
    Disconnect From Database    