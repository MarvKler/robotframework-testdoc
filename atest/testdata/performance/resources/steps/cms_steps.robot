*** Settings ***
Library    DatabaseLibrary
Library    BuiltIn
Library    JSONLibrary
Library    ../../resources/libraries/common.py
Resource    ../common/common_api.robot

*** Keywords ***
Get latest cms page version data by uuid
    [Documentation]    This keyword gets the latest cms page version data by uuid from the DB table `spy_cms_version`.
        ...    *Example:*
        ...
        ...    ``Get latest cms page version data by uuid    uuid=10014bd9-4bba-5a54-b84f-31b4b7efd064``
        ...
    [Arguments]    ${uuid}
    Connect to Spryker DB
    ${data}    Query    SELECT fk_cms_page, version, data from spy_cms_version JOIN spy_cms_page ON spy_cms_version.fk_cms_page = spy_cms_page.id_cms_page WHERE spy_cms_page.uuid = '${uuid}' ORDER BY version DESC LIMIT 1;
    Disconnect From Database
    RETURN    ${data[0]}

Add content product abstract list to cms page in DB
    [Documentation]    This keyword adds conctent product abstarct list to a given CMS page in the DB table `spy_cms_version`.
        ...    *Example:*
        ...
        ...    ``Add content product abstract list to cms page in DB    uuid=10014bd9-4bba-5a54-b84f-31b4b7efd064    content_product_abstract_list_key=apl-1``
        ...
    [Arguments]    ${uuid}    ${content_product_abstract_list_key}=apl-1
    ${data}    Get latest cms page version data by uuid    ${uuid}
    ${cms_page_data_json}=    Convert String to JSON    ${data[2]}
    FOR    ${glossary_attributes}    IN    @{cms_page_data_json['cms_glossary']['glossary_attributes']}
        FOR    ${translation}    IN    @{glossary_attributes['translations']}
            IF    '${glossary_attributes['placeholder']}' == 'content'
                Set To Dictionary    ${translation}    translation={{ content_product_abstract_list("${content_product_abstract_list_key}", "bottom-title") }}
            END
            ${new_translation}=    Replace special chars    ${translation['translation']}
            Set To Dictionary    ${translation}    translation=${new_translation}
        END
    END
    ${cms_page_data}=    Evaluate    json.dumps(${cms_page_data_json})    json
    ${new_id}=    Get next id from table    spy_cms_version    id_cms_version
    ${new_version}=    Evaluate    ${data[1]} + 1
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    insert ignore into spy_cms_version (fk_cms_page, data, version, version_name) value (${data[0]}, '${cms_page_data}', ${new_version}, 'v. ${new_version}');
    ELSE
        Execute Sql String    INSERT INTO spy_cms_version (id_cms_version, fk_cms_page, data, version, version_name) VALUES (${new_id}, ${data[0]}, '${cms_page_data}', ${new_version}, 'v. ${new_version}');
    END
    Disconnect From Database
    Trigger publish trigger-events    cms_page

Delete latest cms page version by uuid from DB
    [Documentation]    This keyword deletes the latest cms page version data by uuid from in the DB table `spy_cms_version`.
        ...    *Example:*
        ...
        ...    ``Delete latest cms page version by uuid from DB    uuid=10014bd9-4bba-5a54-b84f-31b4b7efd064``
        ...
    [Arguments]    ${uuid}
    ${data}    Get latest cms page version data by uuid    ${uuid}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_cms_version WHERE fk_cms_page = ${data[0]} AND version = ${data[1]};
    Disconnect From Database
    Trigger publish trigger-events    cms_page

Replace special chars
    [Documentation]    This keyword replaces special chars in the given string.
        ...    *Example:*
        ...
        ...    ``Replace special chars    input_string=Input string with special chars: & < > ' "``
        ...
    [Arguments]    ${input_string}
    ${converted_string}=    Replace String    ${input_string}    &    \\u0026
    ${converted_string}=    Replace String    ${converted_string}    <    \\u003C
    ${converted_string}=    Replace String    ${converted_string}    >    \\u003E
    ${converted_string}=    Replace String    ${converted_string}    '    \\u0027
    IF    '${db_engine}' == 'pymysql'
        ${converted_string}=    Replace String    ${converted_string}    "    \\u0022
    END
    RETURN  ${converted_string}
