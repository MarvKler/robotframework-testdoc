*** Settings ***
Resource    ../common/common_api.robot
Resource    ../common/common_zed.robot
Resource    ../../resources/pages/zed/zed_data_exchange_api_configurator_page.robot


*** Keywords ***
Zed: start creation of new data exchange api configuration for db table:
    [Arguments]    ${table_name}
    Zed: go to URL:    /dynamic-entity-gui/configuration-list
    Zed: perform search by:    ${table_name}
    ${is_table_empty}=    Run Keyword And Ignore Error    Page Should Contain Element    xpath=//table//td[contains(@class,'empty')]    timeout=400ms
    IF    'PASS' in $is_table_empty
        Zed: click button in Header:    Data Exchange API Configuration
        Select From List By Value    ${data_exchange_table_select_locator}    ${table_name}
        Click    ${data_exchange_create_configuration_button}
        Wait Until Page Contains Element    ${data_exchange_resource_name_field}
    ELSE
        Zed: click Action Button in a table for row that contains:    ${table_name}    Edit
        Wait Until Page Contains Element    ${data_exchange_resource_name_field}
    END

Zed: edit data exchange api configuration:
    [Arguments]    @{args}
    ${configurationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{configurationData}
        IF    '${key}'=='table_name' and '${value}' != '${EMPTY}'
            ${currentURL}=    Get Location
            IF    '/configuration-list' not in '${currentURL}'    Zed: go to URL:    /dynamic-entity-gui/configuration-list
            Zed: click Action Button in a table for row that contains:    ${value}    Edit
            Wait Until Page Contains Element    ${data_exchange_resource_name_field}
        END
        IF    '${key}'=='is_enabled' and '${value}' == 'true'   Zed: Check checkbox by Label:    Is enabled
        IF    '${key}'=='is_enabled' and '${value}' == 'false'   Zed: Uncheck Checkbox by Label:    Is enabled
        IF    '${key}'=='is_deletable' and '${value}' == 'true'   Zed: Check checkbox by Label:    Is deletable
        IF    '${key}'=='is_deletable' and '${value}' == 'false'   Zed: Uncheck Checkbox by Label:    Is deletable
        IF    '${key}'=='field_name' and '${value}' != '${EMPTY}'
            ${field_name}=    Set Variable    ${value}
        END
        IF    '${key}'=='enabled' and '${value}' == 'true'   Check Checkbox    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'is_enabled')]
        IF    '${key}'=='enabled' and '${value}' == 'false'   Uncheck Checkbox    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'is_enabled')]
        IF    '${key}'=='visible_name' and '${value}' != '${EMPTY}'   Type Text    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'visible_name')]    ${value}
        IF    '${key}'=='type' and '${value}' != '${EMPTY}'   Select From List By Value    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//select[contains(@name,'type')]    ${value}
        IF    '${key}'=='creatable' and '${value}' == 'true'   Check Checkbox    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'creatable')]
        IF    '${key}'=='creatable' and '${value}' == 'false'   Uncheck Checkbox    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'creatable')]
        IF    '${key}'=='editable' and '${value}' == 'true'   Check Checkbox    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'editable')]
        IF    '${key}'=='editable' and '${value}' == 'false'   Uncheck Checkbox    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'editable')]
        IF    '${key}'=='required' and '${value}' == 'true'   Check Checkbox    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'required')]
        IF    '${key}'=='required' and '${value}' == 'false'   Uncheck Checkbox    xpath=//input[contains(@id,'dynamic-entity_field_definitions')][@value='${field_name}']/ancestor::tr//input[contains(@name,'required')]
    END

Zed: save data exchange api configuration
    Click    ${data_exchange_create_configuration_button}
    TRY
        Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    Page Should Not Contain Element    ${zed_error_message}    1s
    Page Should Not Contain Element    ${zed_error_flash_message}    1s

Zed: download data exchange api specification should be active:
    [Arguments]    ${expected_condition}
    ${currentURL}=    Get Location
    IF    '/configuration-list' not in '${currentURL}'    Zed: go to URL:    /dynamic-entity-gui/configuration-list
    ${expected_condition}=    Convert To Lower Case    ${expected_condition}
    IF    '${expected_condition}' == 'true'
        Wait Until Element Is Enabled    ${data_exchange_download_spec_button}    timeout=3s    message=Data Exchange API spec is NOT downloadable
    ELSE
        ${download_button_state}=    Get Element Attribute  ${data_exchange_download_spec_button}    class
        Should Contain    ${download_button_state}    disabled    message=Data Exchange API spec is downloadable BUT should NOT
    END

Zed: download data exchange api specification
    [Documentation]    Downloads BAPI spec file and returns file location (path) in '${specification_file_path}' variable
    ${dl_promise}    Promise To Wait For Download    saveAs=${OUTPUTDIR}/tmp.file
    Click    ${data_exchange_download_spec_button}
    ${status}    ${file_object}=    Run Keyword And Ignore Error    Wait For  ${dl_promise}
    File Should Exist    ${file_object}[saveAs]
    Move File    ${file_object}[saveAs]    ${OUTPUTDIR}/${file_object.suggestedFilename}
    Should Be Equal    ${file_object.suggestedFilename}    schema.yml
    Set Test Variable    ${specification_file_path}    ${OUTPUTDIR}/${file_object.suggestedFilename}

Zed: check that downloaded api specification contains:
    [Arguments]    ${expected_content}
    ${file_content}=   Get File  ${specification_file_path}
    Should Contain    ${file_content}    ${expected_content}

Zed: check that downloaded api specification does not contain:
    [Arguments]    ${expected_content}
    ${file_content}=   Get File  ${specification_file_path}
    Should Not Contain    ${file_content}    ${expected_content}

Zed: delete downloaded api specification
    Remove File    ${specification_file_path}

Zed: wait until info box is not displayed
    [Arguments]    ${iterations}=20    ${delays}=10
    Try reloading page until element is/not appear:    ${zed_info_flash_message}    false    tries=${iterations}    timeout=${delays}    message='Download API Specification' button is disabled. Check "Trigger API specification update" CLI command results
