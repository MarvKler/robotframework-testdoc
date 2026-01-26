*** Settings ***
Library    DatabaseLibrary
Library    BuiltIn
Library    ../../resources/libraries/common.py
Resource    ../common/common_api.robot

*** Keywords ***
Get id service point by uuid
    [Documentation]    This keyword returns Service Point ID ${servicePointIds[0][0]} by Service Point UUID.
        ...    *Example:*
        ...
        ...    ``Get id service point by uuid    uuid=262feb9d-33a7-5c55-9b04-45b1fd22067e``
        ...
    [Arguments]    ${uuid}
    Connect to Spryker DB
    ${servicePointIds}    Query    SELECT id_service_point FROM spy_service_point WHERE uuid = '${uuid}' ORDER BY id_service_point DESC LIMIT 1;
    Disconnect From Database
    RETURN    ${servicePointIds[0][0]}

Create service point in DB
    [Documentation]    This keyword creates a new entry in the DB table `spy_service_point`. If `storeName` is provided, creates store relation.
        ...    *Example:*
        ...
        ...    ``Create service point in DB    uuid=262feb9d-33a7-5c55-9b04-45b1fd22067e    name=Main Service Point    key=sp1    isActive=true    storeName=DE``
        ...
    [Arguments]    ${uuid}=${None}    ${name}=${None}    ${key}=${None}    ${isActive}=${True}    ${storeName}=DE
    IF    '${uuid}' == '${None}'
        ${uuid}=    Evaluate    uuid.uuid4()
    END
    IF    '${name}' == '${None}'
        ${name}=    Generate Random String    5    [LETTERS]
    END
    IF    '${key}' == '${None}'
        ${key}=    Generate Random String    5    [LETTERS]
    END
    ${idServicePoint}=    Get next id from table    spy_service_point    id_service_point
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    insert ignore into spy_service_point (`key`, name, uuid, is_active) value ('${key}', '${name}', '${uuid}', ${isActive});
    ELSE
        Execute Sql String    INSERT INTO spy_service_point (id_service_point, key, name, uuid, is_active) VALUES (${idServicePoint}, '${key}', '${name}', '${uuid}', ${isActive});
    END
    Disconnect From Database
    IF    '${storeName}' != '${None}'
        Create service point store relation in DB    ${uuid}    ${storeName}
    END

Create service point store relation in DB
    [Documentation]    This keyword creates a new entry in the DB table `spy_service_point_store`.
        ...    *Example:*
        ...
        ...    ``Create service point store relation in DB    servicePointUuid=262feb9d-33a7-5c55-9b04-45b1fd22067e    storeName=DE``
        ...
    [Arguments]    ${servicePointUuid}    ${storeName}
    ${idServicePoint}=    Get id service point by uuid    ${servicePointUuid}
    ${idServicePointStore}=    Get next id from table    spy_service_point_store    id_service_point_store
    Connect to Spryker DB
    ${storeIds}=    Query    SELECT id_store FROM spy_store WHERE name = '${storeName}' ORDER BY id_store DESC LIMIT 1;
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    insert ignore into spy_service_point_store (fk_service_point, fk_store) value (${idServicePoint}, ${storeIds[0][0]});
    ELSE
        Execute Sql String    INSERT INTO spy_service_point_store (id_service_point_store, fk_service_point, fk_store) VALUES (${idServicePointStore}, ${idServicePoint}, ${storeIds[0][0]});
    END
    Disconnect From Database

Create service point address in DB
    [Documentation]    This keyword creates a new entry in the DB table `spy_service_point_address`.
        ...    *Example:*
        ...
        ...    ``Create service point address in DB    servicePointUuid=262feb9d-33a7-5c55-9b04-45b1fd22067e    uuid=262feb9d-33a7-5c55    address1=Main    address2=8    city=Berlin    zipCode=10115    countryIso2Code=DE``
        ...
    [Arguments]    ${servicePointUuid}    ${uuid}=${None}    ${address1}=${None}    ${address2}=${None}    ${address3}=${None}    ${city}=${None}    ${zipCode}=${None}     ${countryIso2Code}=DE
    ${idServicePoint}=    Get id service point by uuid    ${servicePointUuid}
    IF    '${uuid}' == '${None}'
        ${uuid}=    Evaluate    uuid.uuid4()
    END
    IF    '${address1}' == '${None}'
        ${address1}=    Generate Random String    5    [LETTERS]
    END
    IF    '${address2}' == '${None}'
        ${address2}=    Generate Random String    5    [LETTERS]
    END
    IF    '${address3}' == '${None}'
        ${address3}=    Generate Random String    5    [LETTERS]
    END
    IF    '${city}' == '${None}'
        ${city}=    Generate Random String    5    [LETTERS]
    END
    IF    '${zipCode}' == '${None}'
        ${zipCode}=    Generate Random String    5    [NUMBERS]
    END
    ${idServicePointAddress}=    Get next id from table    spy_service_point_address    id_service_point_address
    Connect to Spryker DB
    ${countryIds}=    Query    SELECT id_country FROM spy_country WHERE iso2_code = '${countryIso2Code}' ORDER BY id_country DESC LIMIT 1;
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    insert ignore into spy_service_point_address (fk_service_point, fk_country, uuid, address1, address2, address3, city, zip_code) value (${idServicePoint}, ${countryIds[0][0]}, '${uuid}', '${address1}', '${address2}', '${address3}', '${city}', '${zipCode}');
    ELSE
        Execute Sql String    INSERT INTO spy_service_point_address (id_service_point_address, fk_service_point, fk_country, uuid, address1, address2, address3, city, zip_code) VALUES (${idServicePointAddress}, ${idServicePoint}, ${countryIds[0][0]}, '${uuid}', '${address1}', '${address2}', '${address3}', '${city}', '${zipCode}');
    END
    Disconnect From Database

Create service point with address and store relations in DB
    [Documentation]    This keyword creates a new entry in the DB table `spy_service_point` with address and store relations.
        ...    *Example:*
        ...
        ...    ``Create service point with address and store relations in DB    servicePointUuid=262feb9d-33a7-5c55-9b04-45b1fd22067e    servicePointAddressUuid=262feb9d-33a7-5c55    storeName=DE``
        ...
    [Arguments]    ${servicePointUuid}    ${servicePointAddressUuid}=${None}    ${storeName}=DE
    Create service point in DB    uuid=${servicePointUuid}    storeName=${storeName}
    Create service point address in DB    servicePointUuid=${servicePointUuid}    uuid=${servicePointAddressUuid}

Create service in DB
    [Documentation]    This keyword creates a new entry in the DB table `spy_service`.
        ...    *Example:*
        ...
        ...    ``Create service in DB    servicePointUuid=262feb9d-33a7-5c55-9b04-45b1fd22067e    serviceTypeUuid=33a7-5c55-9b04    uuid=262feb1fd22067e    key=s1    isActive=true``
        ...
    [Arguments]    ${servicePointUuid}    ${serviceTypeUuid}    ${uuid}=${None}    ${key}=${None}    ${isActive}=${True}
    IF    '${uuid}' == '${None}'
        ${uuid}=    Evaluate    uuid.uuid4()
    END
    IF    '${key}' == '${None}'
        ${key}=    Generate Random String    5    [LETTERS]
    END
    ${idServicePoint}=    Get id service point by uuid    ${servicePointUuid}
    ${idService}=    Get next id from table    spy_service    id_service
    Connect to Spryker DB
    ${serviceTypeIds}=    Query    SELECT id_service_type FROM spy_service_type WHERE uuid = '${serviceTypeUuid}' ORDER BY id_service_type DESC LIMIT 1;
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    insert ignore into spy_service (fk_service_point, fk_service_type, `key`, uuid, is_active) value (${idServicePoint}, ${serviceTypeIds[0][0]}, '${key}', '${uuid}', ${isActive});
    ELSE
        Execute Sql String    INSERT INTO spy_service (id_service, fk_service_point, fk_service_type, key, uuid, is_active) VALUES (${idService}, ${idServicePoint}, ${serviceTypeIds[0][0]}, '${key}', '${uuid}', ${isActive});
    END
    Disconnect From Database

Create service type in DB
    [Documentation]    This keyword creates a new entry in the DB table `spy_service_type`.
        ...    *Example:*
        ...
        ...    ``Create service type in DB    uuid=33a7-5c55-9b04    name=Main Service Point    key=sp1``
        ...
    [Arguments]    ${uuid}=${None}    ${name}=${None}    ${key}=${None}
    IF    '${uuid}' == '${None}'
        ${uuid}=    Evaluate    uuid.uuid4()
    END
    IF    '${name}' == '${None}'
        ${name}=    Generate Random String    5    [LETTERS]
    END
    IF    '${key}' == '${None}'
        ${key}=    Generate Random String    5    [LETTERS]
    END
    ${idServiceType}=    Get next id from table    spy_service_type    id_service_type
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    insert ignore into spy_service_type (`key`, name, uuid) value ('${key}', '${name}', '${uuid}');
    ELSE
        Execute Sql String    INSERT INTO spy_service_type (id_service_type, key, name, uuid) VALUES (${idServiceType}, '${key}', '${name}', '${uuid}');
    END
    Disconnect From Database

Create region in DB:
    [Documentation]    This keyword creates a new entry in the DB table `spy_region`.
        ...    *Example:*
        ...
        ...    ``Create region in DB:    country=60  iso2_code=DE    name=Germany``
        ...
    [Arguments]    ${country}    ${iso2_code}   ${name}=${None}    ${uuid}=${None}
    IF    '${name}' == '${None}'
        ${name}=    Generate Random String    5    [LETTERS]
    END
    IF    '${uuid}' == '${None}'
        ${uuid}=    Generate Random String    5    [LETTERS]
    END
    ${new_id}=    Get next id from table    spy_region    id_region
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    insert ignore into spy_region (fk_country, iso2_code, name, uuid) value ('${country}', '${iso2_code}', '${name}','${uuid}');
    ELSE
        Execute Sql String    INSERT INTO spy_region (id_region, fk_country, iso2_code, name, uuid) VALUES (${new_id}, '${country}', '${iso2_code}', '${name}','${uuid}');
    END
    Disconnect From Database

Get service point uuid by key:
    [Documentation]    This keyword returns Service Point UUID ${servicePointUuid} by Service Point KEY.
        ...    *Example:*
        ...
        ...    ``Get service point uuid by key:    some-service-point-34395``
        ...
    [Arguments]    ${key}
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql' 
    ${servicePointUuid}    Query    SELECT uuid FROM spy_service_point WHERE `key` = '${key}' ORDER BY uuid DESC LIMIT 1;
    ELSE
    ${servicePointUuid}    Query    SELECT uuid FROM spy_service_point WHERE "key" = '${key}' ORDER BY uuid DESC LIMIT 1;
    END
    Disconnect From Database
    Set Test Variable    ${servicePointUuid}     ${servicePointUuid[0][0]}
    RETURN    ${servicePointUuid}

Delete service point in DB
    [Documentation]    This keyword deletes the entry from the DB table `spy_service_point`. If `withRelations=true`, deletes with relations.
        ...    *Example:*
        ...
        ...    ``Get service point uuid by key:    ${service_point_key}``
        ...    `` Delete service point in DB    ${servicePointUuid}``
        ...     OR
        ...    ``Delete service point in DB    uuid=262feb9d-33a7-5c55-9b04-45b1fd22067e    withRelations=true``
        ...
    [Arguments]    ${uuid}    ${withRelations}=${True}
    Deactivate service points in DB    ${uuid}
    IF    ${withRelations}
        ${idServicePoint}=    Get id service point by uuid    ${uuid}
        Connect to Spryker DB
        Execute Sql String    DELETE FROM spy_service_point_store WHERE fk_service_point = ${idServicePoint};
        Execute Sql String    DELETE FROM spy_service_point_address WHERE fk_service_point = ${idServicePoint};
        Execute Sql String    DELETE FROM spy_service WHERE fk_service_point = ${idServicePoint};
        Disconnect From Database
    END
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_service_point WHERE uuid = '${uuid}';
    Disconnect From Database

Delete service point address in DB
    [Documentation]    This keyword deletes the entry from the DB table `spy_service_point_address`. 
        ...    *Example:*
        ...
        ...    ``Delete service point address in DB    uuid=262feb9d-33a7-5c55-9b04-45b1fd22067e``
        ...
    [Arguments]    ${uuid}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_service_point_address WHERE uuid = '${uuid}';
    Disconnect From Database

Delete service type in DB
    [Documentation]    This keyword deletes the entry from the DB table `spy_service_type`.
        ...    *Example:*
        ...
        ...    ``Delete service type in DB    uuid=33a7-5c55-9b04``
        ...
    [Arguments]    ${uuid}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_service_type WHERE uuid = '${uuid}';
    Disconnect From Database

Deactivate service points in DB
    [Documentation]    This keyword deactivates service points. If `uuid` is provided, deactivates service point by uuid.
        ...    *Example:*
        ...
        ...    ``Deactivate service point in DB    uuid=262feb9d-33a7-5c55-9b04-45b1fd22067e``
        ...
    [Arguments]    ${uuid}=${None}
    ${query}    Set Variable    UPDATE spy_service_point SET is_active = false
    IF    '${uuid}' != '${None}'
         ${query}    Set Variable    ${query} WHERE uuid = '${uuid}'
    END
    Log   ${query}
    Connect to Spryker DB
    Execute Sql String    ${query};
    Disconnect From Database

Deactivate service point via BAPI
    [Arguments]    ${service_point_uuid}
    ${have_access_token}    Run Keyword and return status     Should Contain    ${headers}    Authorization
    IF    not ${have_access_token}
        I get access token by user credentials:   ${zed_admin.email}
        I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    END
    I send a PATCH request:    /service-points/${service_point_uuid}    {"data": {"type": "service-points","attributes": {"isActive": "false"}}}
    Response status code should be:    200

Deactivate service via BAPI
    [Arguments]    ${service_uuid}
    ${have_access_token}    Run Keyword and return status     Should Contain    ${headers}    Authorization
    IF    not ${have_access_token}
        I get access token by user credentials:   ${zed_admin.email}
        I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
    END
    I send a PATCH request:    When I send a PATCH request:    /services/${service_uuid}    {"data": {"type": "services", "attributes": {"isActive": "false"}}}
    Response status code should be:    200

Create dynamic service with all data via BAPI if doesn't exist
    Connect to Spryker DB
    # Check if 'robot' dynamic service point already exists
    IF    '${db_engine}' == 'pymysql'
        ${dynamic_service_point_uuid}=    Query    SELECT uuid FROM spy_service_point WHERE `key` LIKE '%${dynamic_service.service_point_key}%' ORDER BY id_service_point DESC LIMIT 1;
    ELSE
        ${dynamic_service_point_uuid}=    Query    SELECT uuid FROM spy_service_point WHERE "key" ILIKE '%${dynamic_service.service_point_key}%' ORDER BY id_service_point DESC LIMIT 1;
    END
    ${dynamic_service_point_exists}=    Evaluate    len(${dynamic_service_point_uuid}) > 0
    VAR    ${dynamic_service_point_exists}    ${dynamic_service_point_exists}    scope=SUITE
    
    IF    ${dynamic_service_point_exists}
        VAR    ${dynamic_service_point_uuid}    ${dynamic_service_point_uuid}[0][0]   scope=SUITE
        IF    '${db_engine}' == 'pymysql'
            ${dynamic_service_point_address_uuid}=    Query    SELECT uuid FROM spy_service_point_address WHERE city LIKE '%${dynamic_service.service_point_address_city}%' ORDER BY id_service_point_address DESC LIMIT 1;
            VAR    ${dynamic_service_point_address_uuid}    ${dynamic_service_point_address_uuid}[0][0]   scope=SUITE
            
            ${dynamic_service_type_uuid}=    Query    SELECT uuid FROM spy_service_type WHERE `key` LIKE '%${dynamic_service.service_type_key}%' ORDER BY id_service_type DESC LIMIT 1;
            VAR    ${dynamic_service_type_uuid}    ${dynamic_service_type_uuid}[0][0]   scope=SUITE

            ${dynamic_service_uuid}=    Query    SELECT uuid FROM spy_service WHERE `key` LIKE '%${dynamic_service.service_key}%' ORDER BY id_service DESC LIMIT 1;
            VAR    ${dynamic_service_uuid}    ${dynamic_service_uuid}[0][0]   scope=SUITE
        ELSE
            ${dynamic_service_point_address_uuid}=    Query    SELECT uuid FROM spy_service_point_address WHERE city ILIKE '%${dynamic_service.service_point_address_city}%' ORDER BY id_service_point_address DESC LIMIT 1;
            VAR    ${dynamic_service_point_address_uuid}    ${dynamic_service_point_address_uuid}[0][0]   scope=SUITE
            
            ${dynamic_service_type_uuid}=    Query    SELECT uuid FROM spy_service_type WHERE "key" ILIKE '%${dynamic_service.service_type_key}%' ORDER BY id_service_type DESC LIMIT 1;
            VAR    ${dynamic_service_type_uuid}    ${dynamic_service_type_uuid}[0][0]   scope=SUITE

            ${dynamic_service_uuid}=    Query    SELECT uuid FROM spy_service WHERE "key" ILIKE '%${dynamic_service.service_key}%' ORDER BY id_service DESC LIMIT 1;
            VAR    ${dynamic_service_uuid}    ${dynamic_service_uuid}[0][0]   scope=SUITE
        END
    END
    
    Disconnect From Database

    IF    not ${dynamic_service_point_exists}
        # Create Service Point
        Switch to BAPI
        I get access token by user credentials:   ${zed_admin.email}
        I set Headers:    Content-Type=${default_header_content_type}   Authorization=Bearer ${token}
        I send a POST request:    /service-points    {"data": {"type": "service-points","attributes": {"name": "${dynamic_service.service_point_name}","key": "${dynamic_service.service_point_key}","isActive": "true","stores": ["DE"]}}}
        Response status code should be:    201
        Save value to a variable:    [data][id]    service_point_id
        
        VAR    ${dynamic_service_point_uuid}    ${service_point_id}    scope=SUITE
        
        # Create Service Point Address
        I send a POST request:    /service-points/${service_point_id}/service-point-addresses    {"data":{"type":"service-point-addresses","attributes":{"address1":"${dynamic_service.service_point_address_line_1}","address2":"${dynamic_service.service_point_address_line_2}","city":"${dynamic_service.service_point_address_city}","zipCode":"${dynamic_service.service_point_address_zip_code}","countryIso2Code":"${dynamic_service.service_point_address_country}"}}}
        Response status code should be:    201
        Save value to a variable:    [data][id]    service_point_address_id

        VAR    ${dynamic_service_point_address_uuid}    ${service_point_address_id}    scope=SUITE

        # Create Service Type
        I send a POST request:    /service-types    {"data": {"type": "service-types", "attributes": {"name": "${dynamic_service.service_type_name}", "key": "${dynamic_service.service_type_key}"}}}
        Response status code should be:    201
        Save value to a variable:    [data][id]    service_type_id

        VAR    ${dynamic_service_type_uuid}    ${service_type_id}    scope=SUITE

        # Create Service
        I send a POST request:    /services    {"data": {"type": "services", "attributes": {"serviceTypeUuid": "${service_type_id}", "servicePointUuid": "${service_point_id}", "isActive":"true", "key": "${dynamic_service.service_key}"}}}
        Response status code should be:    201
        Save value to a variable:    [data][id]    service_id

        VAR    ${dynamic_service_uuid}    ${service_id}    scope=SUITE

        # Publish to Redis and ES
        Repeat Keyword    3    Trigger p&s
    END

Delete all non-default service points from DB with p&s
    [Documentation]    This keyword deletes all non-default service points from the `spy_service_point` table.
    ...    It also deletes related entries from `spy_service_point_store`, `spy_service_point_address`, and `spy_service`.
    ...    It processes all service points where `id_service_point > 3`.
    ...
    [Tags]    Database    Cleanup

    Connect to Spryker DB
    ${service_point_uuids}=    Query    SELECT uuid FROM spy_service_point WHERE id_service_point > 2;

    FOR    ${row}    IN    @{service_point_uuids}
        ${uuid}=    Set Variable    ${row}[0]
        ${idServicePoint}=    Get id service point by uuid    ${uuid}
        Connect to Spryker DB
        Execute Sql String    DELETE FROM spy_service_point_store WHERE fk_service_point = ${idServicePoint};
        Execute Sql String    DELETE FROM spy_service_point_address WHERE fk_service_point = ${idServicePoint};
        Execute Sql String    DELETE FROM spy_product_offer_service WHERE fk_service IN (SELECT id_service FROM spy_service WHERE fk_service_point = ${idServicePoint});
        Execute Sql String    DELETE FROM spy_service WHERE fk_service_point = ${idServicePoint};
        Execute Sql String    DELETE FROM spy_service_point WHERE uuid = '${uuid}';
    END
    
    ${service_types_uuids}=    Query    SELECT uuid FROM spy_service_type WHERE id_service_type > 2;
    FOR    ${row}    IN    @{service_types_uuids}
        ${uuid}=    Set Variable    ${row}[0]
        Execute Sql String    DELETE FROM spy_shipment_type_service_type WHERE fk_service_type > 2;
        Execute Sql String    DELETE FROM spy_service_type WHERE uuid = '${uuid}';
    END

    Disconnect From Database
    Trigger publish trigger-events    service_point    timeout=1s