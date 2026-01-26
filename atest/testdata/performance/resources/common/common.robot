*** Settings ***
Library    String
# Library    Dialogs
Library    OperatingSystem
Library    Process
Library    Collections
Library    BuiltIn
Library    DateTime
Library    RequestsLibrary
Library    DatabaseLibrary
Library    ../../resources/libraries/common.py
# Library    Telnet

*** Variables ***
# *** DB VARIABLES ***
${db_engine}
${db_port}
${default_db_host}    127.0.0.1
${default_db_name}    eu-docker
${default_db_password}    secret
${default_db_port}    3306
${default_db_port_postgres}    5432
${default_db_user}    spryker
${default_db_engine}    pymysql
# ${default_db_engine}       psycopg2

# *** DOCKER VARIABLES ***
${docker}
${default_docker}     ${False}
${docker_db_host}     database
${docker_cli_url}     http://cli:9000
${cli_path}    ..

# *** CLI VARIABLES ***
${project_location}
${ignore_console}
${default_ignore_console}    ${True}

# *** COMMON VARIABLES ***
${verify_ssl}          false

# *** DMS VARIABLES ***
${dms}
${default_dms}    ${False}

# *** SSP VARIABLES ***
${is_ssp}
${default_is_ssp}    ${False}

*** Keywords ***
Common_suite_setup
    [Documentation]  Basic steps before each suite
    [Arguments]    ${skip_if_already_executed}=False
    Remove Files    ${OUTPUTDIR}/selenium-screenshot-*.png
    Remove Files    ${OUTPUTDIR}/*.png
    Remove Files    ${OUTPUTDIR}/*.yml

    Generate global random variable
    ${random_id}=    Generate Random String    5    [NUMBERS]
    ${random_str}=    Generate Random String    5    [LETTERS]
    ${random_str_store}=    Generate Random String    2    [UPPER]
    ${random_str_password}=    Generate Random String    5    [LETTERS]
    ${random_id_password}=    Generate Random String    5    [NUMBERS]

    Set Global Variable    ${random_id}
    Set Global Variable    ${random_str}
    Set Global Variable    ${random_str_store}
    Set Global Variable    ${random_id_password}
    Set Global Variable    ${random_str_password}

    ${today}=    Get Current Date    result_format=%Y-%m-%d
    Set Global Variable    ${today}

    ${already_executed}=    Run Keyword And Return Status    Variable Should Exist    ${setup_done}
    IF    ${already_executed} and ${skip_if_already_executed}
        # Setup is already done, skip
        RETURN
    END
    Load Variables    ${env}
    Overwrite env variables
    IF    ${docker}
        Set Global Variable    ${db_host}    ${docker_db_host}
    END
    VAR    ${setup_done}    ${True}    scope=GLOBAL

Generate global random variable
    ${excluded_ranges}=    Evaluate    [str(i).zfill(3) for i in list(range(1, 220)) + [666]]
    ${random}=    Evaluate    random.randint(300, 99999)
    WHILE    any(ex in str(${random}) for ex in ${excluded_ranges})
        ${random}=    Evaluate    random.randint(300, 99999)
    END
    ${random}=    Convert To String    ${random}
    Set Global Variable    ${random}

Should Test Run
    Log Many    @{Test Tags}
    ${dms_state}=    Convert To String    ${dms}
    IF   '${dms_state}' != 'True'
        IF   'dms-on' in @{Test Tags}
            Skip
        END
    ELSE
        IF   'dms-off' in @{Test Tags}
            Skip
        END
    END

Load Variables
    [Documentation]    Keyword is used to load variable values from the environment file passed during execution. This Keyword is used during suite setup.
    ...    It accepts the name of the environment as specified at the beginning of an environment file e.g. ``"environment": "api_suite"``.
    ...
    ...    These variables are loaded and usable throughout all tests of the test suite, if this keyword is called during suite setup.
    ...
    ...    *Example:*
    ...
    ...    ``Load Variables    ${env}``
    ...
    ...    ``Load Variables    api_suite``
    [Arguments]    ${env}
    ${variables_already_loaded}=    Run Keyword And Return Status    Variable Should Exist    ${env_variables_loaded}
    IF    not ${variables_already_loaded}
        &{vars}=   Define Environment Variables From Json File    ${env}
        FOR    ${key}    ${value}    IN    &{vars}
            ${var_value}=   Get Variable Value  ${${key}}   ${value}
            Set Global Variable    ${${key}}    ${var_value}
        END
        VAR    ${env_variables_loaded}    ${True}    scope=GLOBAL
    ELSE
        Log    Environment variables are already loaded
    END

Overwrite env variables
    IF    '${project_location}' == '${EMPTY}'
            Set Global Variable    ${cli_path}    ${cli_path}
    ELSE
            Set Global Variable    ${cli_path}    ${project_location}
    END
    IF    '${ignore_console}' == '${EMPTY}'
            Set Global Variable    ${ignore_console}    ${default_ignore_console}
    ELSE
            Set Global Variable    ${ignore_console}    ${ignore_console}
    END
    IF    '${docker}' == '${EMPTY}'
            Set Global Variable    ${docker}    ${default_docker}
    ELSE
            Set Global Variable    ${docker}    ${docker}
    END
    IF    '${dms}' == '${EMPTY}'
            Set Global Variable    ${dms}    ${default_dms}
    ELSE
        Set Global Variable    ${dms}    ${dms}
    END
    IF    '${is_ssp}' == '${EMPTY}'
            Set Global Variable    ${is_ssp}    ${default_is_ssp}
    ELSE
        ${is_ssp}=    Convert To String    ${is_ssp}
        ${is_ssp}=    Convert To Lower Case    ${is_ssp}
        IF    '${is_ssp}' == 'yes'    Set Global Variable    ${is_ssp}    true
        Set Global Variable    ${is_ssp}    ${is_ssp}
    END
    ${dms}=    Convert To String    ${dms}
    ${dms}=    Convert To Lower Case    ${dms}
    IF    '${dms}' == 'true'    Set Global Variable    ${dms}    ${True}
    IF    '${dms}' == 'false'    Set Global Variable    ${dms}    ${False}
    IF    '${dms}' == 'on'    Set Global Variable    ${dms}    ${True}
    IF    '${dms}' == 'off'    Set Global Variable    ${dms}    ${False}
    IF    '${ignore_console}' == 'true'    Set Global Variable    ${ignore_console}    ${True}
    IF    '${ignore_console}' == 'false'    Set Global Variable    ${ignore_console}    ${False}
    IF    '${docker}' == 'true'    Set Global Variable    ${docker}    ${True}
    IF    '${docker}' == 'false'    Set Global Variable    ${docker}    ${False}
    ${verify_ssl}=    Convert To String    ${verify_ssl}
    ${verify_ssl}=    Convert To Lower Case    ${verify_ssl}
    IF    '${verify_ssl}' == 'true'
        Set Global Variable    ${verify_ssl}    ${True}
    ELSE
        Set Global Variable    ${verify_ssl}    ${False}
    END

Set Up Keyword Arguments
    [Arguments]    @{args}
    &{arguments}=    Fill Variables From Text String    @{args}
    FOR    ${key}    ${value}    IN    &{arguments}
        ${var_value}=   Set Variable    ${value}
        Set Test Variable    ${${key}}    ${var_value}
    END
    RETURN    &{arguments}

Variable datatype should be:
    [Arguments]    ${variable}    ${expected_data_type}
    ${actual_data_type}=    Evaluate datatype of a variable:    ${variable}
    Should Be Equal    ${actual_data_type}    ${expected_data_type}

Evaluate datatype of a variable:
    [Arguments]    ${variable}
    ${data_type}=    Evaluate     type($variable).__name__
    RETURN    ${data_type}
    #Example of assertions:
    # ${is int}=      Evaluate     isinstance($variable, int)    # will be True
    # ${is string}=   Evaluate     isinstance($variable, str)    # will be False

Convert string to List by separator:
    [Arguments]    ${string}    ${separator}=,
    ${convertedList}=    Split String    ${string}    ${separator}
    ${convertedList}=    Set Test Variable    ${convertedList}
    RETURN    ${convertedList}

Remove leading and trailing whitespace from a string:
    [Arguments]    ${string}
    ${string}=    Replace String Using Regexp    ${string}    (^[ ]+|[ ]+$)    ${EMPTY}
    Set Global Variable    ${string}
    RETURN    ${string}

Connect to Spryker DB
    [Documentation]    This keyword allows to connect to Spryker DB.
    ...        Supports both MariaDB and PostgeSQL.
    ...
    ...        To specify the expected DB engine, use ``db_engine`` variable. Default one -> *MariaDB*
    ...
    ...    *Example:*
    ...    ``robot -v env:api_suite -v db_engine:psycopg2``
    ...
    ...    with the example above you'll use PostgreSQL DB engine
    Set Log Level    NONE
    ${db_name}=    Set Variable If    '${db_name}' == '${EMPTY}'    ${default_db_name}    ${db_name}
    ${db_user}=    Set Variable If    '${db_user}' == '${EMPTY}'    ${default_db_user}    ${db_user}
    ${db_password}=    Set Variable If    '${db_password}' == '${EMPTY}'    ${default_db_password}    ${db_password}
    ${db_host}=    Set Variable If    '${db_host}' == '${EMPTY}'    ${default_db_host}    ${db_host}
    ${db_engine}=    Set Variable If    '${db_engine}' == '${EMPTY}'    ${default_db_engine}    ${db_engine}
    ${db_engine}=    Convert To Lower Case    ${db_engine}
    IF    '${db_engine}' == 'mysql'
        ${db_engine}=    Set Variable    pymysql
    ELSE IF    '${db_engine}' == 'mariadb'
        ${db_engine}=    Set Variable    pymysql
    ELSE IF    '${db_engine}' == 'maria'
        ${db_engine}=    Set Variable    pymysql
    ELSE IF    '${db_engine}' == 'postgresql'
        ${db_engine}=    Set Variable    psycopg2
    ELSE IF    '${db_engine}' == 'postgres'
        ${db_engine}=    Set Variable    psycopg2
    END
    IF    '${db_engine}' == 'psycopg2'
        ${db_port}=    Set Variable If    '${db_port}' == '${EMPTY}'    ${db_port_postgres_env}    ${db_port}
        IF    '${db_port_postgres_env}' == '${EMPTY}'
        ${db_port}=    Set Variable If    '${db_port_postgres_env}' == '${EMPTY}'    ${default_db_port_postgres}    ${db_port_postgres_env}
        END
    ELSE
    ${db_port}=    Set Variable If    '${db_port}' == '${EMPTY}'    ${db_port_env}    ${db_port}
        IF    '${db_port_env}' == '${EMPTY}'
        ${db_port}=    Set Variable If    '${db_port_env}' == '${EMPTY}'    ${default_db_port}    ${db_port_env}
        END
    END
    Set Test Variable    ${db_engine}
    Disconnect From Database
    Connect To Database    ${db_engine}    ${db_name}    ${db_user}    ${db_password}    ${db_host}    ${db_port}
    Reset Log Level

Save the result of a SELECT DB query to a variable:
    [Documentation]    This keyword saves any value which you receive from DB using SQL query ``{sql_query}`` to a test variable called ``{variable_name}``.
    ...
    ...    It can be used to save a value returned by any query into a custom test variable.
    ...    This variable, once created, can be used during the specific test where this keyword is used and can be re-used by the keywords that follow this keyword in the test.
    ...    It will not be visible to other tests.
    ...    NOTE: Make sure that you expect only 1 value from DB, you can also check your query via external SQL tool.
    ...
    ...    *Examples:*
    ...
    ...    ``Save the result of a SELECT DB query to a variable:    select registration_key from spy_customer where customer_reference = '${user_reference_id}'    confirmation_key``
    [Arguments]    ${sql_query}    ${variable_name}
    Connect to Spryker DB
    ${var_value} =    Query    ${sql_query}
    Disconnect From Database
    ${var_value}=    Convert To String    ${var_value}
    ${var_value}=    Replace String    ${var_value}    '   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    ,   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    (   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    )   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    [   ${EMPTY}
    ${var_value}=    Replace String    ${var_value}    ]   ${EMPTY}
    Set Test Variable    ${${variable_name}}    ${var_value}
    RETURN    ${variable_name}

Send GET request and return status code:
    [Arguments]    ${url}    ${timeout}=5
    ${response}=    GET    ${url}    timeout=${timeout}    allow_redirects=true    expected_status=ANY
    Set Test Variable    ${response.status_code}    ${response.status_code}
    RETURN    ${response.status_code}

Run console command
    [Documentation]    This keyword executes console command using provided command and parameters. If docker is enabled, it will execute the command using docker.
        ...    *Example:*
        ...
        ...    ``Run console command    command=publish:trigger-events parameters=-r service_point    storeName=DE``
        ...
    [Arguments]    ${command}    ${storeName}=DE
    IF    ${dms}
        IF    '${storeName}' == 'DE'
            ${storeName}=    Set Variable    EU
        END
        IF    '${storeName}' == 'AT'
            ${storeName}=    Set Variable    EU
        END
        IF    '${storeName}' == 'US'
            ${storeName}=    Set Variable    US
        END
        ${consoleCommand}=    Set Variable    cd ${cli_path} && SPRYKER_CURRENT_REGION=${storeName} docker/sdk ${command}
        IF    ${docker}
            ${consoleCommand}=    Set Variable    curl --request POST -LsS --data "SPRYKER_CURRENT_REGION='${storeName}' COMMAND='${command}' cli.sh" --max-time 1000 --url "${docker_cli_url}/console"
            TRY
                ${rc}    ${output}=    Run And Return RC And Output    ${consoleCommand}
                Log   ${output}
                Should Be Equal As Integers    ${rc}    0    message=CLI output:"${output}". CLI command can't be executed. Check '{docker}', '{ignore_console}' variables value and cli execution path: '{cli_path}'.
            EXCEPT
                Sleep    1s
                ${rc}    ${output}=    Run And Return RC And Output    ${consoleCommand}
                Log   ${output}
                Should Be Equal As Integers    ${rc}    0    message=CLI output:"${output}". CLI command can't be executed. Check '{docker}', '{ignore_console}' variables value and cli execution path: '{cli_path}'.
            END
        END
        Log    ${ignore_console}
        IF    ${ignore_console} != True and not ${docker}
            TRY
                ${rc}    ${output}=    Run And Return RC And Output    ${consoleCommand}
                Log   ${output}
                Should Be Equal As Integers    ${rc}    0    message=CLI output:"${output}". CLI command can't be executed. Check '{docker}', '{ignore_console}' variables value and cli execution path: '{cli_path}'
            EXCEPT
                Sleep    1s
                ${rc}    ${output}=    Run And Return RC And Output    ${consoleCommand}
                Log   ${output}
                Should Be Equal As Integers    ${rc}    0    message=CLI output:"${output}". CLI command can't be executed. Check '{docker}', '{ignore_console}' variables value and cli execution path: '{cli_path}'
            END
        END
    ELSE
        ${consoleCommand}=    Set Variable    cd ${cli_path} && APPLICATION_STORE=${storeName} docker/sdk ${command}
        IF    ${docker}
            ${consoleCommand}=    Set Variable    curl --request POST -LsS --data "APPLICATION_STORE='${storeName}' COMMAND='${command}' cli.sh" --max-time 1000 --url "${docker_cli_url}/console"
            TRY
                ${rc}    ${output}=    Run And Return RC And Output    ${consoleCommand}
                Log   ${output}
                Should Be Equal As Integers    ${rc}    0    message=CLI output:"${output}". CLI command can't be executed. Check '{docker}', '{ignore_console}' variables value and cli execution path: '{cli_path}'.
            EXCEPT
                Sleep    1s
                ${rc}    ${output}=    Run And Return RC And Output    ${consoleCommand}
                Log   ${output}
                Should Be Equal As Integers    ${rc}    0    message=CLI output:"${output}". CLI command can't be executed. Check '{docker}', '{ignore_console}' variables value and cli execution path: '{cli_path}'.
            END
        END
        IF    ${ignore_console} != True and not ${docker}
            TRY
                ${rc}    ${output}=    Run And Return RC And Output    ${consoleCommand}
                Log   ${output}
                Should Be Equal As Integers    ${rc}    0    message=CLI output:"${output}". CLI command can't be executed. Check '{docker}', '{ignore_console}' variables value and cli execution path: '{cli_path}'
            EXCEPT
                Sleep    200ms
                ${rc}    ${output}=    Run And Return RC And Output    ${consoleCommand}
                Log   ${output}
                Should Be Equal As Integers    ${rc}    0    message=CLI output:"${output}". CLI command can't be executed. Check '{docker}', '{ignore_console}' variables value and cli execution path: '{cli_path}'
            END
        END
    END

Trigger p&s
    [Arguments]    ${timeout}=0ms    ${storeName}=DE
    Run console command    console queue:worker:start --stop-when-empty    ${storeName}
    IF    ${docker} or ${ignore_console} != True    Sleep    ${timeout}

Trigger API specification update
    [Arguments]    ${timeout}=200ms    ${storeName}=DE
    IF    ${docker}
        Run console command    glue api:generate:documentation --invalidated-after-interval 90sec    ${storeName}
    ELSE
        Run console command    cli glue api:generate:documentation --invalidated-after-interval 90sec    ${storeName}
    END
    IF    ${docker} or ${ignore_console} != True    Sleep    ${timeout}

Trigger multistore p&s
    [Arguments]    ${timeout}=0ms
    IF    ${dms}
        Trigger p&s    ${timeout}    DE
    ELSE
        Trigger p&s    ${timeout}    DE
        Trigger p&s    ${timeout}    AT
    END

Trigger oms
    [Arguments]    ${timeout}=10ms
    IF    ${dms}
        Run console command    console oms:check-timeout    DE
        Run console command    console oms:check-condition    DE
    ELSE
        Run console command    console oms:check-timeout    DE
        Run console command    console oms:check-timeout    AT
        Run console command    console oms:check-condition    DE
        Run console command    console oms:check-condition    AT
    END
    IF    ${docker} or ${ignore_console} != True    Sleep    ${timeout}

Trigger publish trigger-events
    [Documentation]    This keyword triggers publish:trigger-events console command using provided resource, path and store.
        ...    *Example:*
        ...
        ...    ``Trigger publish trigger-events    resource=service_point    storeName=DE    timeout=5s``
        ...
    [Arguments]    ${resource}    ${storeName}=DE    ${timeout}=0ms
    Run console command    console publish:trigger-events -r ${resource}    ${storeName}
    Trigger p&s    ${timeout}    ${storeName}

Get next id from table
    [Documentation]    This keyword returns next ID from the given table.
        ...    *Example:*
        ...
        ...    ``Get next id from table    tableName=product    idColumnName=id_product``
        ...
    [Arguments]    ${tableName}    ${idColumnName}
    Connect to Spryker DB
    ${lastId}=    Query    SELECT ${idColumnName} FROM ${tableName} ORDER BY ${idColumnName} DESC LIMIT 1;
    ${newId}=    Set Variable    ${EMPTY}
    ${lastIdLength}=    Get Length    ${lastId}
    IF    ${lastIdLength} > 0
        ${newId}=    Evaluate    ${lastId[0][0]} + 1
    ELSE
        ${newId}=    Evaluate    1
    END
    Disconnect From Database
    RETURN    ${newId}

Get concrete product sku by id from DB:
    [Documentation]    This keyword returns product concrete sku from DB found by id_product. Returns '${concrete_sku}' variable
    ...    *Example:*
    ...
    ...    ``Get concrete product sku by id from DB:    ${id_product}``
    ...
    [Arguments]    ${id_product}
    Connect to Spryker DB
    ${concrete_sku}=    Query    select sku from spy_product WHERE id_product='${id_product}';
    ${concrete_sku}=    Get From List    ${concrete_sku}    0
    ${concrete_sku}=    Convert To String    ${concrete_sku[0]}
    Set Test Variable    ${concrete_sku}    ${concrete_sku}
    Disconnect From Database

Create giftcode in Database:
    [Documentation]    This keyword creates a new entry in the DB table spy_gift_card with the name, value and gift-card code.
        ...    *Example:*
        ...
        ...    ``Create giftcode in Database:    checkout_${random}    ${gift_card.amount}``
        ...
    [Arguments]    ${spy_gift_card_code}    ${spy_gift_card_value}
    ${amount}=   Evaluate    ${spy_gift_card_value} / 100
    ${amount}=    Evaluate    "%.f" % ${amount}
    ${new_id}=    Get next id from table    spy_gift_card    id_gift_card
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    insert ignore into spy_gift_card (code,name,currency_iso_code,value) value ('${spy_gift_card_code}','Gift_card_${amount}','EUR','${spy_gift_card_value}')
    ELSE
        Execute Sql String    INSERT INTO spy_gift_card (id_gift_card, code, name, currency_iso_code, value) VALUES (${new_id}, '${spy_gift_card_code}', 'Gift_card_${amount}', 'EUR', '${spy_gift_card_value}');
    END
    Disconnect From Database

Update order status in Database:
    [Documentation]    This keyword updates order status in database to any required status. This allows to skip going through the order workflow manually
    ...    but just switch to the status you need to create a test.
    ...    There is no separate endpoint to update order status and this keyword allows to do this via database value update.
    ...    *Example:*
    ...
    ...    ``Update order status in Database:    7    shipped``
    [Arguments]    ${order_item_status_name}    ${uuid_to_use}
    Connect to Spryker DB
    ${new_id}=    Set Variable    ${EMPTY}
    ${state_id}=    Set Variable    ${EMPTY}
    ${last_id}=    Query    SELECT id_oms_order_item_state FROM spy_oms_order_item_state ORDER BY id_oms_order_item_state DESC LIMIT 1;
    ${expected_state_id}=    Query    SELECT id_oms_order_item_state FROM spy_oms_order_item_state WHERE name='${order_item_status_name}';
    ${last_id_length}=    Get Length    ${last_id}
    ${expected_state_id_length}=    Get Length    ${expected_state_id}
    IF    ${expected_state_id_length} > 0
        ${state_id}=    Set Variable    ${expected_state_id[0][0]}
    ELSE
        IF    ${last_id_length} > 0
            ${new_id}=    Evaluate    ${last_id[0][0]} + 1
        ELSE
            ${new_id}=    Evaluate    1
        END
        Execute Sql String    INSERT INTO spy_oms_order_item_state (id_oms_order_item_state, name) VALUES (${new_id}, '${order_item_status_name}');
        ${state_id}=    Set Variable    ${new_id}
    END
    Execute Sql String    update spy_sales_order_item set fk_oms_order_item_state = '${state_id}' where uuid= '${uuid_to_use}'
    Disconnect From Database

Create merchant order for the item in DB and change status:
    [Documentation]    This keyword creates new merchant order in the DB and sets the desired status . This allows to skip going through the order workflow manually
    ...    but just switch to the status you need to create a test.
    ...    There is no separate endpoint to update order status and this keyword allows to do this via database value update.
    ...    *Example:*
    ...
    ...    ``Create merchant order for the item in DB and change status:    shipped    ${uuid}    ${merchants.sony_experts.merchant_reference}``
    [Arguments]    ${order_item_status_name}    ${uuid_to_use}    ${merchant_reference}
    Connect to Spryker DB
    ${new_id}=    Set Variable    ${EMPTY}
    ${state_id}=    Set Variable    ${EMPTY}
    ${last_id}=    Query    SELECT id_state_machine_item_state FROM spy_state_machine_item_state ORDER BY id_state_machine_item_state DESC LIMIT 1;
    ${expected_state_id}=    Query    SELECT id_state_machine_item_state FROM spy_state_machine_item_state WHERE name='${order_item_status_name}';
    ${last_id_length}=    Get Length    ${last_id}
    IF    ${last_id_length} == 0
        ${state_id}=    Set Variable    1
        ${state_id}=    Convert To String    ${state_id}
    END
    ${expected_state_id_length}=    Get Length    ${expected_state_id}
    IF    ${expected_state_id_length} > 0
        ${state_id}=    Set Variable    ${expected_state_id[0][0]}
    ELSE
        IF    ${last_id_length} > 0
            ${state_id}=    Evaluate    ${last_id[0][0]} + 1
        ELSE
            ${state_id}=    Evaluate    1
        END
        Execute Sql String    INSERT INTO spy_state_machine_item_state (id_state_machine_item_state, fk_state_machine_process, name) VALUES (${state_id}, 2, '${order_item_status_name}');
    END
    ${last_order_item_id}=    Query    SELECT id_merchant_sales_order_item from spy_merchant_sales_order_item order by id_merchant_sales_order_item desc limit 1;
    ${last_order_item_id_length}=    Get Length    ${last_order_item_id}
    IF    ${last_order_item_id_length} == 0
        ${new_order_item_id}=    Set variable    1
        ${new_order_item_id}=    Convert To String    ${new_order_item_id}
    END
    IF    ${last_order_item_id_length} > 0
        ${new_order_item_id}=    Evaluate    ${last_order_item_id[0][0]} +1
    ELSE
        ${new_order_item_id}=    Set Variable    ${new_order_item_id}
    END
    ${last_merchant_order_id}=    Query    SELECT id_merchant_sales_order from spy_merchant_sales_order order by id_merchant_sales_order desc limit 1;
    ${last_merchant_order_id_length}=    Get Length    ${last_merchant_order_id}
    IF    ${last_merchant_order_id_length} == 0
        ${new_merchant_order_id}=    Set Variable    1
        ${new_merchant_order_id}=    Convert To String    ${new_merchant_order_id}
    END
    IF    ${last_merchant_order_id_length} > 0
        ${new_merchant_order_id}=    Evaluate    ${last_merchant_order_id[0][0]} +1
    ELSE
        ${new_merchant_order_id}=    Set Variable    ${new_merchant_order_id}
    END
    ${sales_order_id}=    Query    SELECT fk_sales_order from spy_sales_order_item where uuid='${uuid_to_use}';
    ${sales_order_id}=    Set Variable    ${sales_order_id[0][0]}
    Execute Sql String    INSERT INTO spy_merchant_sales_order (id_merchant_sales_order, fk_sales_order, merchant_reference, merchant_sales_order_reference) VALUES (${new_merchant_order_id}, ${sales_order_id}, '${merchant_reference}', 'DE--${sales_order_id}--${merchant_reference}');
    ${last_merchant_order_item_id}=    Query    SELECT id_merchant_sales_order from spy_merchant_sales_order order by id_merchant_sales_order desc limit 1;
    ${last_merchant_order_item_id_length}=    Get Length    ${last_merchant_order_item_id}
    IF    ${last_merchant_order_item_id_length} > 0
        ${new_merchant_order_item_id}=    Evaluate    ${last_merchant_order_item_id[0][0]} +1
    END
    ${sales_order_item_id}=    Query    SELECT id_sales_order_item from spy_sales_order_item where uuid='${uuid_to_use}';
    ${sales_order_item_id}=    Set Variable    ${sales_order_item_id[0][0]}
    ${random_merchant_order_item_reference}=    Generate Random String    10    [NUMBERS]
    Execute Sql String    INSERT INTO spy_merchant_sales_order_item (id_merchant_sales_order_item, fk_merchant_sales_order, fk_sales_order_item, fk_state_machine_item_state, merchant_order_item_reference) VALUES (${new_merchant_order_item_id}, ${new_merchant_order_id}, ${sales_order_item_id}, ${state_id}, '${random_merchant_order_item_reference}');
    Disconnect From Database

Delete country by iso2_code in Database:
    [Documentation]    This keyword deletes a country by iso2_code in the DB table spy_country.
        ...    *Example:*
        ...
        ...    ``Delete country by iso2_code in Database:    DE``
        ...
    [Arguments]    ${iso2_code}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_country WHERE iso2_code = '${iso2_code}';
    Disconnect From Database

Delete url by url name in Database:
    [Documentation]    This keyword deletes a url by url name in the DB table spy_url.
        ...    *Example:*
        ...
        ...    ``Delete url by url name in Database:    test``
        ...
    [Arguments]    ${url}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_url WHERE url = '${url}';
    Disconnect From Database

Verify that url is present in the Database:
    [Documentation]    This keyword verifies that url is present in the DB table spy_url.
        ...    *Example:*
        ...
        ...    ``Verify that url is present in the Database:    test``
        ...
    [Arguments]    ${url}
    Connect to Spryker DB
    ${db_url}=    Query    SELECT url FROM spy_url WHERE url = '${url}' LIMIT 1;
    ${db_url}=    Set Variable    ${db_url[0][0]}
    Disconnect From Database
    Should Be Equal    ${url}    ${db_url}

Update dynamic entity configuration in Database:
     [Documentation]    This keyword update dynamic entity configuration in the DB table spy_dynamic_entity_configuration if configuration exists.
        ...    *Example:*
        ...
        ...    ``Update dynamic entity configuration in Database:    country    spy_country     1   {"identifier":"id_country","fields":[...]}``
        ...
    [Arguments]    ${table_alias}   ${table_name}    ${is_active}    ${definition}
    Connect to Spryker DB
    Execute Sql String  update spy_dynamic_entity_configuration set table_alias = '${table_alias}', table_name = '${table_name}', is_active = '${is_active}', definition = '${definition}' where table_alias = '${table_alias}';
    Disconnect From Database

I add 'admin' role to company user and get company_user_uuid:
    [Documentation]    This is a helper keyword which sets the 'Admin' role to the company user if it is not already set and returns the uuid of this company user. Requires: company user email, company key and business unit key
    ...    *Example:*
    ...
    ...    ``Add 'admin' role to company user and return company_user_uuid:    anne.boleyn@spryker.com    BoB-Hotel-Jim    business-unit-jim-1``
    [Arguments]    ${email}    ${company_key}    ${business_unit_key}
    Connect to Spryker DB
    Set Log Level    NONE
    ${id_customer}=    Query    select id_customer from spy_customer WHERE email='${email}'
    ${id_customer}=    Evaluate    ${id_customer[0][0]}+0
    IF    '${db_engine}' == 'pymysql'
        ${id_business_unit}=    Query    select id_company_business_unit from spy_company_business_unit where `key`='${business_unit_key}'
    ELSE
        ${id_business_unit}=    Query    select id_company_business_unit from spy_company_business_unit where "key"='${business_unit_key}'
    END
    ${id_business_unit}=    Evaluate    ${id_business_unit[0][0]}+0
    IF    '${db_engine}' == 'pymysql'
        ${id_company}=    Query    select id_company from spy_company WHERE `key`='${company_key}'
    ELSE
        ${id_company}=    Query    select id_company from spy_company WHERE "key"='${company_key}'
    END
    ${id_company}=    Evaluate    ${id_company[0][0]}+0
    ${id_company_user}=    Query    select id_company_user from spy_company_user WHERE fk_customer=${id_customer} and fk_company_business_unit=${id_business_unit} and fk_company=${id_company}
    ${id_company_user}=    Evaluate    ${id_company_user[0][0]}+0
    ${id_company_role_admin}=    Query    select id_company_role from spy_company_role WHERE name='Admin' and fk_company='${id_company}'
    ${id_company_role_admin}=    Evaluate    ${id_company_role_admin[0][0]}+0
    ${is_role_set}=    Query    SELECT id_company_role_to_company_user FROM spy_company_role_to_company_user WHERE fk_company_role = ${id_company_role_admin} and fk_company_user = ${id_company_user}
    ${is_role_set_length}=    Get Length    ${is_role_set}
    IF    ${is_role_set_length} == 0
        ${last_id}=    Query    SELECT id_company_role_to_company_user FROM spy_company_role_to_company_user ORDER BY id_company_role_to_company_user DESC LIMIT 1;
        ${new_id}=    Evaluate    ${last_id[0][0]}+1
        Execute Sql String    INSERT INTO spy_company_role_to_company_user (id_company_role_to_company_user, fk_company_role, fk_company_user) VALUES (${new_id}, ${id_company_role_admin}, ${id_company_user});
    END
    ${company_user_uuid}=    Query    select uuid from spy_company_user where id_company_user=${id_company_user}
    ${company_user_uuid}=    Convert To String    ${company_user_uuid}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    '   ${EMPTY}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    ,   ${EMPTY}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    (   ${EMPTY}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    )   ${EMPTY}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    [   ${EMPTY}
    ${company_user_uuid}=    Replace String    ${company_user_uuid}    ]   ${EMPTY}
    Set Test Variable    ${company_user_uuid}    ${company_user_uuid}
    Reset Log Level
    RETURN    ${company_user_uuid}

Get voucher code by discountId from Database:
    [Documentation]    This keyword allows to get voucher code according to the discount ID. Discount_id can be found in Backoffice > Merchandising > Discount page
    ...        and set this id as an argument of a keyword.
    ...
    ...    *Example:*
    ...    ``Get voucher code by discountId from Database:    3``
    [Arguments]    ${discount_id}
    Save the result of a SELECT DB query to a variable:    select fk_discount_voucher_pool from spy_discount where id_discount = ${discount_id}    discount_voucher_pool_id
    IF    '${db_engine}' == 'pymysql'
        Save the result of a SELECT DB query to a variable:    select code from spy_discount_voucher where fk_discount_voucher_pool = ${discount_voucher_pool_id} and is_active = 1 limit 1    discount_voucher_code
    ELSE
        Save the result of a SELECT DB query to a variable:    select code from spy_discount_voucher where fk_discount_voucher_pool = ${discount_voucher_pool_id} and is_active = true limit 1    discount_voucher_code
    END

Update dynamic entity configuration relation in Database:
    [Documentation]    This keyword update dynamic entity configuration in the DB tables spy_dynamic_entity_configuration_relation and spy_dynamic_entity_configuration_relation_field_mapping.
    ...    *Example:*
    ...
    ...    ``Update dynamic entity configuration relation in Database:    product-abstracts    products    productAbstractProducts    fk_product_abstract    id_product_abstract``
    ...
    [Arguments]    ${parent_dynamic_entity_configuration_alias}   ${child_dynamic_entity_configuration_alias}    ${name}    ${child_field_name}   ${parent_field_name}
    Connect to Spryker DB

    ${parent_dynamic_entity_configuration_alias_id}=    Query    SELECT id_dynamic_entity_configuration from spy_dynamic_entity_configuration where table_alias='${parent_dynamic_entity_configuration_alias}';
    ${parent_dynamic_entity_configuration_alias_id}=    Set Variable    ${parent_dynamic_entity_configuration_alias_id[0][0]}
    Log  ${parent_dynamic_entity_configuration_alias_id}
    ${child_dynamic_entity_configuration_alias_id}=    Query    SELECT id_dynamic_entity_configuration from spy_dynamic_entity_configuration where table_alias='${child_dynamic_entity_configuration_alias}';
    ${child_dynamic_entity_configuration_alias_id}=    Set Variable    ${child_dynamic_entity_configuration_alias_id[0][0]}
    Log  ${child_dynamic_entity_configuration_alias_id}
    Execute Sql String  update spy_dynamic_entity_configuration_relation set fk_parent_dynamic_entity_configuration = '${parent_dynamic_entity_configuration_alias_id}', fk_child_dynamic_entity_configuration = '${child_dynamic_entity_configuration_alias_id}', name = '${name}', is_editable = true where name='${name}';

    ${dynamic_entity_configuration_relation_id}=    Query    SELECT id_dynamic_entity_configuration_relation from spy_dynamic_entity_configuration_relation where name='${name}';
    ${dynamic_entity_configuration_relation_id}=    Set Variable    ${dynamic_entity_configuration_relation_id[0][0]}

    Execute Sql String  update spy_dynamic_entity_configuration_relation_field_mapping set parent_field_name = '${parent_field_name}', child_field_name = '${child_field_name}' where fk_dynamic_entity_configuration_relation='${dynamic_entity_configuration_relation_id}';
    Disconnect From Database

Create dynamic entity configuration in Database:
    [Documentation]    This keyword create dynamic entity configuration in the DB table spy_dynamic_entity_configuration.
    ...    *Example:*
    ...
    ...    ``Create dynamic entity configuration in Database:    country    spy_country     1   {"identifier":"id_country","fields":[...]}``
    ...
    [Arguments]    ${table_alias}   ${table_name}    ${is_active}    ${definition}
    ${new_id}=    Get next id from table    spy_dynamic_entity_configuration    id_dynamic_entity_configuration
    Connect to Spryker DB
    IF    '${db_engine}' == 'pymysql'
        Execute Sql String  insert ignore into spy_dynamic_entity_configuration (table_alias, table_name, is_active, definition) value ('${table_alias}', '${table_name}', '${is_active}', '${definition}');
    ELSE
        Execute Sql String  insert into spy_dynamic_entity_configuration (id_dynamic_entity_configuration, table_alias, table_name, is_active, definition) values (${new_id}, '${table_alias}', '${table_name}', '${is_active}', '${definition}')
    END
    Disconnect From Database

Delete dynamic entity configuration in Database:
    [Documentation]    This keyword delete dynamic entity configuration in the DB table spy_dynamic_entity_configuration.
    ...    *Example:*
    ...
    ...    ``Delete dynamic entity configuration in Database:    country```
    ...
    [Arguments]    ${table_alias}
    Connect to Spryker DB
    Execute Sql String  DELETE FROM spy_dynamic_entity_configuration WHERE table_alias = '${table_alias}';
    Disconnect From Database

Create dynamic entity configuration relation in Database:
    [Documentation]    This keyword create dynamic entity configuration in the DB tables spy_dynamic_entity_configuration_relation and spy_dynamic_entity_configuration_relation_field_mapping.
    ...    *Example:*
    ...
    ...    ``Create dynamic entity configuration relation in Database:    country    spy_country     1   {"identifier":"id_country","fields":[...]}``
    ...
    [Arguments]    ${parent_dynamic_entity_configuration_alias}   ${child_dynamic_entity_configuration_alias}    ${name}    ${child_field_name}   ${parent_field_name}
    Connect to Spryker DB

    ${parent_dynamic_entity_configuration_alias_id}=    Query    SELECT id_dynamic_entity_configuration from spy_dynamic_entity_configuration where table_alias='${parent_dynamic_entity_configuration_alias}';
    ${parent_dynamic_entity_configuration_alias_id}=    Set Variable    ${parent_dynamic_entity_configuration_alias_id[0][0]}
    Log  ${parent_dynamic_entity_configuration_alias_id}
    ${child_dynamic_entity_configuration_alias_id}=    Query    SELECT id_dynamic_entity_configuration from spy_dynamic_entity_configuration where table_alias='${child_dynamic_entity_configuration_alias}';
    ${child_dynamic_entity_configuration_alias_id}=    Set Variable    ${child_dynamic_entity_configuration_alias_id[0][0]}
    Log  ${child_dynamic_entity_configuration_alias_id}

    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    INSERT INTO spy_dynamic_entity_configuration_relation (fk_parent_dynamic_entity_configuration,fk_child_dynamic_entity_configuration,name,is_editable) VALUES (${parent_dynamic_entity_configuration_alias_id},${child_dynamic_entity_configuration_alias_id},'${name}',true);
    ELSE
        Disconnect From Database
        ${new_relation_id}=    Get next id from table    spy_dynamic_entity_configuration_relation    id_dynamic_entity_configuration_relation
        Log  ${new_relation_id}
        Connect to Spryker DB
        Execute Sql String    INSERT INTO spy_dynamic_entity_configuration_relation (id_dynamic_entity_configuration_relation, fk_parent_dynamic_entity_configuration, fk_child_dynamic_entity_configuration,name,is_editable) values (${new_relation_id}, ${parent_dynamic_entity_configuration_alias_id},${child_dynamic_entity_configuration_alias_id},'${name}',true);
    END

    ${dynamic_entity_configuration_relation_id}=    Query    SELECT id_dynamic_entity_configuration_relation from spy_dynamic_entity_configuration_relation where name='${name}';
    ${dynamic_entity_configuration_relation_id}=    Set Variable    ${dynamic_entity_configuration_relation_id[0][0]}

    IF    '${db_engine}' == 'pymysql'
        Execute Sql String    insert ignore into spy_dynamic_entity_configuration_relation_field_mapping (fk_dynamic_entity_configuration_relation, parent_field_name, child_field_name) value (${dynamic_entity_configuration_relation_id}, '${parent_field_name}', '${child_field_name}');
    ELSE
        Disconnect From Database
        ${new_mapping_id}=    Get next id from table    spy_dynamic_entity_configuration_relation_field_mapping    id_dynamic_entity_configuration_relation_field_mapping
        Connect to Spryker DB
        Execute Sql String  insert into spy_dynamic_entity_configuration_relation_field_mapping (id_dynamic_entity_configuration_relation_field_mapping, fk_dynamic_entity_configuration_relation, parent_field_name, child_field_name) values (${new_mapping_id},'${dynamic_entity_configuration_relation_id}','${parent_field_name}','${child_field_name}');
    END
    Disconnect From Database

Delete dynamic entity configuration relation in Database:
    [Documentation]    This keyword delete dynamic entity configuration in the DB table spy_dynamic_entity_configuration_relation.
    ...    *Example:*
    ...
    ...    ``Delete dynamic entity configuration relation in Database:    name```
    ...
    [Arguments]    ${relation_name}
    Connect to Spryker DB
    ${dynamic_entity_configuration_relation_id}=    Query    SELECT id_dynamic_entity_configuration_relation from spy_dynamic_entity_configuration_relation where name='${relation_name}';
    ${dynamic_entity_configuration_relation_id_length}=    Get Length    ${dynamic_entity_configuration_relation_id}
    ${dynamic_entity_configuration_relation_id_length}=    Set Variable    ${dynamic_entity_configuration_relation_id_length}
    IF   ${dynamic_entity_configuration_relation_id_length} > 0
        ${dynamic_entity_configuration_relation_id}=    Set Variable    ${dynamic_entity_configuration_relation_id[0][0]}
        Log   ${dynamic_entity_configuration_relation_id}

        Execute Sql String  DELETE FROM spy_dynamic_entity_configuration_relation_field_mapping WHERE fk_dynamic_entity_configuration_relation = ${dynamic_entity_configuration_relation_id};
        Execute Sql String  DELETE FROM spy_dynamic_entity_configuration_relation WHERE id_dynamic_entity_configuration_relation = ${dynamic_entity_configuration_relation_id};
    END

    Disconnect From Database

Delete product by id_product in Database:
    [Documentation]    This keyword deletes a product by id_product in the DB table spy_product.
        ...    *Example:*
        ...
        ...    ``Delete product by id_product in Database:    100``
        ...
    [Arguments]    ${id_product}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_product WHERE id_product = ${id_product};
    Disconnect From Database

Delete product_abstract by id_product_abstract in Database:
    [Documentation]    This keyword deletes a product abstract by id_product_abstract from spy_product_abstract.
        ...    *Example:*
        ...
        ...    ``Delete product_abstract by id_product_abstract in Database:    200``
        ...
    [Arguments]    ${id_product_abstract}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_product_abstract WHERE id_product_abstract = ${id_product_abstract};
    Disconnect From Database

Delete complex product by id_product_abstract in Database:
    [Documentation]    This keyword deletes a product abstract by id_product_abstract from spy_product_abstract.
        ...    *Example:*
        ...
        ...    ``Delete complex product by id_product_abstract in Database:    200``
        ...
    [Arguments]    ${id_product_abstract}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_product_image_set WHERE fk_product_abstract = ${id_product_abstract};
    Execute Sql String    DELETE FROM spy_product_label_product_abstract WHERE fk_product_abstract = ${id_product_abstract};
    Execute Sql String    DELETE FROM spy_product_abstract_localized_attributes WHERE fk_product_abstract = ${id_product_abstract};
    Execute Sql String    DELETE FROM spy_url WHERE fk_resource_product_abstract = ${id_product_abstract};
    Execute Sql String    DELETE FROM spy_product_category WHERE fk_product_abstract = ${id_product_abstract};
    Execute Sql String    DELETE FROM spy_product_abstract_page_search WHERE fk_product_abstract = ${id_product_abstract};

    ${id_price_product}=    Query    SELECT id_price_product from spy_price_product WHERE fk_product_abstract = ${id_product_abstract};
    ${id_price_product_length}=    Get Length    ${id_price_product}
    IF    ${id_price_product_length} > 0
        ${id_price_product}=    Set Variable    ${id_price_product[0][0]}
        Execute Sql String    DELETE FROM spy_price_product_store WHERE fk_price_product = ${id_price_product};
        Execute Sql String    DELETE FROM spy_price_product WHERE fk_product_abstract = ${id_product_abstract};
    END

    ${id_product_relation}=    Query    SELECT id_product_relation from spy_product_relation WHERE fk_product_abstract = ${id_product_abstract};
    ${id_product_relation_length}=    Get Length    ${id_product_relation}
    IF    ${id_product_relation_length} > 0
        ${id_product_relation}=    Set Variable    ${id_product_relation[0][0]}
        Execute Sql String    DELETE FROM spy_product_relation_store WHERE fk_product_relation = ${id_product_relation};
        Execute Sql String    DELETE FROM spy_product_relation WHERE fk_product_abstract = ${id_product_abstract};
    END

    ${id_product}=    Query    SELECT id_product from spy_product WHERE fk_product_abstract='${id_product_abstract}';
    ${id_product_length}=    Get Length    ${id_product}
    IF    ${id_product_length} > 0
        ${id_product}=    Set Variable    ${id_product[0][0]}
        Execute Sql String    DELETE FROM spy_product_search WHERE fk_product = ${id_product};
        Execute Sql String    DELETE FROM spy_stock_product WHERE fk_product = ${id_product};
        Execute Sql String    DELETE FROM spy_product_concrete_page_search WHERE fk_product = ${id_product};
        Execute Sql String    DELETE FROM spy_product_search WHERE fk_product = ${id_product};
        Execute Sql String    DELETE FROM spy_product_localized_attributes WHERE fk_product = ${id_product};
        Execute Sql String    DELETE FROM spy_product WHERE fk_product_abstract = ${id_product_abstract};
    END

    Execute Sql String    DELETE FROM spy_product_abstract_store WHERE fk_product_abstract = ${id_product_abstract};
    Execute Sql String    DELETE FROM spy_product_abstract_category_storage WHERE fk_product_abstract = ${id_product_abstract};
    Execute Sql String    DELETE FROM spy_product_abstract_label_storage WHERE fk_product_abstract = ${id_product_abstract};
    Execute Sql String    DELETE FROM spy_product_abstract_product_list_storage WHERE fk_product_abstract = ${id_product_abstract};
    Execute Sql String    DELETE FROM spy_product_abstract_page_search WHERE fk_product_abstract = ${id_product_abstract};
    Execute Sql String    DELETE FROM spy_product_abstract_relation_storage WHERE fk_product_abstract = ${id_product_abstract};
    Execute Sql String    DELETE FROM spy_product_abstract_storage WHERE fk_product_abstract = ${id_product_abstract};
    Execute Sql String    DELETE FROM spy_product_label_product_abstract WHERE fk_product_abstract = ${id_product_abstract};
    Execute Sql String    DELETE FROM spy_product_abstract WHERE id_product_abstract = ${id_product_abstract};

    Disconnect From Database

Delete product_price by id_price_product in Database:
    [Documentation]    This keyword deletes a product price by id_price_product from spy_price_product.
        ...    *Example:*
        ...
        ...    ``Delete product_price by id_price_product in Database:    200``
        ...
    [Arguments]    ${id_price_product}
    Connect to Spryker DB
    Execute Sql String    DELETE FROM spy_price_product WHERE id_price_product = ${id_price_product};
    Disconnect From Database

Trigger product labels update
    [Arguments]    ${timeout}=0.5s
    Run console command    console product-label:relations:update -vvv --no-touch    DE
    Run console command    console product-label:validity    DE
    Run console command    console product-label:relations:update -vvv --no-touch    AT
    Run console command    console product-label:validity    AT
    Repeat Keyword    2    Trigger multistore p&s
    IF    ${docker} or ${ignore_console} != True    Sleep    ${timeout}

Create dynamic admin user in DB
    [Documentation]    This keyword creates a new admin user in the DB using data from an existing admin.
        ...    It works for both MariaDB and PostgreSQL.
    [Arguments]    ${user_name}=${EMPTY}    ${first_name}=Dynamic    ${last_name}=Admin    ${based_on}=${zed_admin_email}

    IF    '${user_name}' == '${EMPTY}'
        ${unique}=    Generate Random String    5    [NUMBERS]
        VAR    ${user_name}    admin+robot${unique}@spryker.com
        VAR    ${dynamic_admin_user}    ${user_name}    scope=TEST
    ELSE
        VAR    ${dynamic_admin_user}    ${user_name}    scope=TEST
    END

    # Step 1: Fetch the existing user data (admin@spryker.com)
    Connect to Spryker DB
    ${existing_user_data_id}=    Query    SELECT spy_user.id_user FROM spy_user WHERE username = '${based_on}'
    ${existing_user_data_locale}=    Query    SELECT spy_user.fk_locale FROM spy_user WHERE username = '${based_on}'
    ${existing_user_data_password}=    Query    SELECT spy_user.password FROM spy_user WHERE username = '${based_on}'
    ${existing_user_data_created_at}=    Query    SELECT spy_user.created_at FROM spy_user WHERE username = '${based_on}'
    ${existing_user_data_updated_at}=    Query    SELECT spy_user.updated_at FROM spy_user WHERE username = '${based_on}'

    # Step 1: Extract fields from the existing user
    ${existing_id_user}=    Set Variable    ${existing_user_data_id[0][0]}
    ${existing_fk_locale}=    Set Variable    ${existing_user_data_locale[0][0]}
    ${existing_password}=    Set Variable    ${existing_user_data_password[0][0]}
    ${existing_created_at}=    Set Variable    ${existing_user_data_created_at[0][0]}
    ${existing_updated_at}=    Set Variable    ${existing_user_data_updated_at[0][0]}

    # Step 2: Get the maximum id_user and increment it
    ${max_id_user}=    Query    SELECT MAX(id_user) FROM spy_user
    IF    '${None}' in '${max_id_user}'    VAR    ${max_id_user}    0

    IF    ${max_id_user[0][0]} > 5000
        # new ID will be max +1 not to intersect with real IDs
        ${new_id_user}=    Evaluate    ${max_id_user[0][0]} + 1
    ELSE
        # new ID will be max + 5001 not to intersect with real IDs
        ${new_id_user}=    Evaluate    ${max_id_user[0][0]} + 5001
    END
    # Step 3: Generate new UUID
    ${new_uuid}=   Generate Random String	4	[UPPER]
    VAR    ${new_uuid}    ${new_uuid}-${random}-${random_str}-${random_id}

    # Step 4: Check table structure before the insert

    IF    '${db_engine}' == 'pymysql'
        ${spy_user_column_names}=    Query    SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'spy_user' AND TABLE_SCHEMA = DATABASE()
        ${spy_user_column_names}=    Convert To String    ${spy_user_column_names}
        ${is_uuid_present}=    Run Keyword And Return Status    Should Contain    ${spy_user_column_names}    uuid
        VAR    ${is_uuid_present}    ${is_uuid_present}
    ELSE
        ${spy_user_column_names}=    Query    SELECT column_name FROM information_schema.columns WHERE table_name = 'spy_user' AND table_schema = current_schema
        ${spy_user_column_names}=    Convert To String    ${spy_user_column_names}
        ${is_uuid_present}=    Run Keyword And Return Status    Should Contain    ${spy_user_column_names}    uuid
        VAR    ${is_uuid_present}    ${is_uuid_present}
    END

    # Step 5: Insert the new user into the spy_user table using correct variables
    ${attempt}=    Set Variable    1
    WHILE    ${attempt} <= 3
        TRY
            IF    ${is_uuid_present}
                Execute Sql String    INSERT INTO spy_user (id_user, fk_locale, is_agent, first_name, last_name, password, status, username, uuid, created_at, updated_at) VALUES (${new_id_user}, ${existing_fk_locale}, True, '${first_name}', '${last_name}', '${existing_password}', 0, '${user_name}', '${new_uuid}', '${existing_created_at}', '${existing_updated_at}')
            ELSE
                Execute Sql String    INSERT INTO spy_user (id_user, fk_locale, is_agent, first_name, last_name, password, status, username, created_at, updated_at) VALUES (${new_id_user}, ${existing_fk_locale}, True, '${first_name}', '${last_name}', '${existing_password}', 0, '${user_name}', '${existing_created_at}', '${existing_updated_at}')
            END
            Exit For Loop
        EXCEPT
            Log    Attempt ${attempt} failed due to duplicate entry in spy_user. Retrying...
            ${unique_id}=    Generate Random String    3    [NUMBERS]
            ${unique_id}=    Replace String    ${unique_id}    0    9
            ${unique_id}=    Convert To Integer    ${unique_id}
            ${new_id_user}=    Evaluate    ${new_id_user} + ${unique_id}
            ${unique}=    Generate Random String    5    [NUMBERS]
            VAR    ${new_uuid}    ${unique}-${random}-${random_str}-${random_id}
            IF    '${user_name}' == '${EMPTY}'
                VAR    ${user_name}    admin+robot${unique}@spryker.com
                VAR    ${dynamic_admin_user}    ${user_name}    scope=TEST
            END
            ${attempt}=    Evaluate    ${attempt} + 1
        END
    END
    IF    ${attempt} > 3    Fail    Unable to insert user into spy_users after 3 attempts.

    # Step 6: Get the ACL group of the existing user from spy_acl_user_has_group
    ${existing_acl_group}=    Query    SELECT fk_acl_group FROM spy_acl_user_has_group WHERE fk_user = ${existing_id_user}

    # Step 7: Insert the new user’s ID and the same ACL group into spy_acl_user_has_group
    Execute Sql String    INSERT INTO spy_acl_user_has_group (fk_user, fk_acl_group) VALUES (${new_id_user}, ${existing_acl_group[0][0]})

    Disconnect From Database

Delete dynamic admin user from DB
    [Documentation]    This keyword deletes a dynamic admin user from the DB based on the provided username.
        ...           It works for both MariaDB and PostgreSQL.
    [Arguments]    ${user_name}=${EMPTY}

    ${dynamic_admin_exists}=    Run Keyword And Return Status    Variable Should Exist    ${dynamic_admin_user}

    # Step 2: Decide action based on existence of discount states and the argument

    IF    '${user_name}' == '${EMPTY}'
        IF    ${dynamic_admin_exists}
            VAR    ${user_name}    ${dynamic_admin_user}
        ELSE
            Log    message=No dynamic (doesn't exist) or static user was provided for deletion    level=INFO
            RETURN
        END
    END

    # Step 1: Fetch the ID of the user to be deleted
    Connect to Spryker DB
    ${user_data}=    Query    SELECT id_user FROM spy_user WHERE username = '${user_name}'
    ${user_exists}=    Evaluate    len(${user_data}) > 0

    IF    ${user_exists}
        ${user_id}=    Set Variable    ${user_data[0][0]}

        # Step 2: Delete entries in related tables
        IF    '${db_engine}' == 'pymysql'
            Execute Sql String    DELETE FROM spy_acl_user_has_group WHERE fk_user = ${user_id}
        ELSE
            Execute Sql String    DELETE FROM spy_acl_user_has_group WHERE fk_user = ${user_id}
        END

        # Step 3: Delete the user from spy_user table
        IF    '${db_engine}' == 'pymysql'
            Execute Sql String    DELETE FROM spy_user WHERE id_user = ${user_id}
        ELSE
            Execute Sql String    DELETE FROM spy_user WHERE id_user = ${user_id}
        END
    END

    Disconnect From Database

Create dynamic customer in DB
    [Documentation]    This keyword creates a new approved dynamic customer in the DB based on an existing customer (sonia@spryker.com) and assigns the customer to a company.
    ...               It works for both MariaDB and PostgreSQL.
    [Arguments]    ${first_name}=Dynamic    ${last_name}=Customer    ${email}=${EMPTY}    ${based_on}=${EMPTY}    ${create_default_address}=True
    ${dynamic_customer_exists}=    Run Keyword And Return Status    Variable Should Exist    ${dynamic_customer}
    ${dynamic_second_customer_exists}=    Run Keyword And Return Status    Variable Should Exist    ${dynamic_second_customer}

    IF    '${email}' == '${EMPTY}'
        ${unique}=    Generate Random String    5    [NUMBERS]
        IF    ${dynamic_second_customer_exists}
            VAR    ${email}    sonia+robot${unique}@spryker.com
            VAR    ${dynamic_third_customer}    ${email}    scope=TEST
        ELSE IF    ${dynamic_customer_exists}
            VAR    ${email}    sonia+robot${unique}@spryker.com
            VAR    ${dynamic_second_customer}    ${email}    scope=TEST
        ELSE
            VAR    ${email}    sonia+robot${unique}@spryker.com
            VAR    ${dynamic_customer}    ${email}    scope=TEST
        END
    END

    IF    '${based_on}' == '${EMPTY}'
        VAR    ${based_on}    sonia@spryker.com
    END

    # Step 1: Fetch the existing customer data (${based_on})
    Connect to Spryker DB
    ${existing_customer_data}=    Query    SELECT * FROM spy_customer WHERE email = '${based_on}'

    # Extract all columns from the existing customer with Set Variable If for conditional handling of None values
    VAR    ${existing_customer_id}    ${existing_customer_data[0][0]}
    ${existing_fk_locale}=                 Set Variable If    ${existing_customer_data[0][1]}    ${existing_customer_data[0][1]}    NULL
    ${existing_fk_user}=                   Set Variable If    ${existing_customer_data[0][2]}    ${existing_customer_data[0][2]}    NULL
    ${existing_anonymized_at}=             Set Variable If    ${existing_customer_data[0][3]}    ${existing_customer_data[0][3]}    NULL
    ${existing_company}=                   Set Variable If    '${existing_customer_data[0][4]}' != '${EMPTY}'    ${existing_customer_data[0][4]}    ${EMPTY}
    ${existing_date_of_birth}=             Set Variable If    ${existing_customer_data[0][6]}    ${existing_customer_data[0][6]}    NULL
    VAR    ${existing_default_billing_address}    NULL
    VAR    ${existing_default_shipping_address}    NULL
    ${existing_gender}=                    Set Variable If    ${existing_customer_data[0][11]}   ${existing_customer_data[0][11]}   NULL
    ${existing_password}=                  Set Variable    ${existing_customer_data[0][13]}
    ${existing_phone}=                     Set Variable If    '${existing_customer_data[0][14]}' != '${EMPTY}'   ${existing_customer_data[0][14]}   ${EMPTY}
    ${existing_registered}=                Set Variable If    ${existing_customer_data[0][15]}   ${existing_customer_data[0][15]}   '2020-06-24'
    ${existing_registration_key}=          Set Variable If    ${existing_customer_data[0][16]}   ${existing_customer_data[0][16]}   NULL
    VAR    ${existing_restore_password_date}    NULL
    VAR    ${existing_restore_password_key}    NULL
    ${existing_salutation}=                Set Variable    ${existing_customer_data[0][19]}
    ${existing_created_at}=                Set Variable    ${existing_customer_data[0][20]}
    ${existing_updated_at}=                Set Variable    ${existing_customer_data[0][21]}

    # Step 2: Get the maximum id_customer and increment it
    ${max_id_customer}=    Query    SELECT MAX(id_customer) FROM spy_customer
    IF    '${None}' in '${max_id_customer}'    VAR    ${max_id_customer}    0

    IF    ${max_id_customer[0][0]} > 5000
        # new ID will be max +1 not to intersect with real IDs
        ${new_id_customer}=    Evaluate    ${max_id_customer[0][0]} + 1
    ELSE
        # new ID will be max + 5001 not to intersect with real IDs
        ${new_id_customer}=    Evaluate    ${max_id_customer[0][0]} + 5001
    END

    # Step 3: Generate new values for customer_reference
    ${new_customer_reference}=    Set Variable    dynamic--${new_id_customer}

    # Step 4: Insert the new customer into the spy_customer table using all columns
    ${attempt}=    Set Variable    1
    WHILE    ${attempt} <= 3
        TRY
            Execute Sql String    INSERT INTO spy_customer (id_customer, fk_locale, fk_user, anonymized_at, company, customer_reference, date_of_birth, default_billing_address, default_shipping_address, email, first_name, gender, last_name, password, phone, registered, registration_key, restore_password_date, restore_password_key, salutation, created_at, updated_at) VALUES (${new_id_customer}, ${existing_fk_locale}, ${existing_fk_user}, ${existing_anonymized_at}, '${existing_company}', '${new_customer_reference}', ${existing_date_of_birth}, ${existing_default_billing_address}, ${existing_default_shipping_address}, '${email}', '${first_name}', ${existing_gender}, '${last_name}', '${existing_password}', '${existing_phone}', '${existing_registered}', ${existing_registration_key}, ${existing_restore_password_date}, ${existing_restore_password_key}, ${existing_salutation}, '${existing_created_at}', '${existing_updated_at}')
            Exit For Loop
        EXCEPT
            Log    Attempt ${attempt} failed due to duplicate entry in spy_customer. Retrying...
            ${unique_id}=    Generate Random String    3    [NUMBERS]
            ${unique_id}=    Replace String    ${unique_id}    0    9
            ${unique_id}=    Convert To Integer    ${unique_id}
            ${new_id_customer}=    Evaluate    ${new_id_customer} + ${unique_id}
            ${new_customer_reference}=    Set Variable    dynamic--${new_id_customer}
            IF    '${email}' == '${EMPTY}' or 'sonia+robot' in '${email}'
                ${unique}=    Generate Random String    5    [NUMBERS]
                IF    ${dynamic_second_customer_exists}
                    VAR    ${email}    sonia+robot${unique}@spryker.com
                    VAR    ${dynamic_third_customer}    ${email}    scope=TEST
                ELSE IF    ${dynamic_customer_exists}
                    VAR    ${email}    sonia+robot${unique}@spryker.com
                    VAR    ${dynamic_second_customer}    ${email}    scope=TEST
                ELSE
                    VAR    ${email}    sonia+robot${unique}@spryker.com
                    VAR    ${dynamic_customer}    ${email}    scope=TEST
                END
            END
            ${attempt}=    Evaluate    ${attempt} + 1
        END
    END
    IF    ${attempt} > 3    Fail    Unable to insert customer into spy_customer after 3 attempts.

    IF    '${env}' in ['ui_b2b','ui_mp_b2b','ui_suite']
        # Step 5: Fetch the existing company user data associated with the existing customer
        ${existing_company_user_data}=    Query    SELECT * FROM spy_company_user WHERE fk_customer = ${existing_customer_id}
        ${existing_company_user_data_length}=    Get Length    ${existing_company_user_data}
        IF    ${existing_company_user_data_length} > 0
            # Extract the relevant fields for inserting a new company user
            VAR    ${existing_id_company_user}    ${existing_company_user_data[0][0]}
            VAR    ${existing_fk_company}    ${existing_company_user_data[0][1]}
            VAR    ${existing_fk_company_business_unit}    ${existing_company_user_data[0][2]}
            VAR    ${existing_key}    ${existing_company_user_data[0][6]}

            # Step 6: Get the maximum id_company_user and increment it
            ${max_id_company_user}=    Query    SELECT MAX(id_company_user) FROM spy_company_user
            IF    '${None}' in '${max_id_company_user}'    VAR    ${max_id_company_user}    0

            IF    ${max_id_company_user[0][0]} > 5000
                # new ID will be max +1 not to intersect with real IDs
                ${new_id_company_user}=    Evaluate    ${max_id_company_user[0][0]} + 1
            ELSE
                # new ID will be max + 5001 not to intersect with real IDs
                ${new_id_company_user}=    Evaluate    ${max_id_company_user[0][0]} + 5001
            END

            # Step 7: Generate unique values for `key` and `uuid`
            VAR    ${new_key}    ${existing_key}--${new_id_company_user}
            ${new_uuid}=   Generate Random String	4	[UPPER]
            VAR    ${new_uuid}    ${new_uuid}-${random}-${random_str}-${random_id}

            # Step 8: Insert the new company user entry in the spy_company_user table
            ${attempt}=    Set Variable    1
            WHILE    ${attempt} <= 3
                TRY
                    IF    '${db_engine}' == 'pymysql'
                        Execute Sql String    INSERT INTO spy_company_user (id_company_user, fk_company, fk_company_business_unit, fk_customer, is_active, is_default, \`key\`, uuid) VALUES (${new_id_company_user}, ${existing_fk_company}, ${existing_fk_company_business_unit}, ${new_id_customer}, True, False, '${new_key}', '${new_uuid}')
                    ELSE
                        Execute Sql String    INSERT INTO spy_company_user (id_company_user, fk_company, fk_company_business_unit, fk_customer, is_active, is_default, key, uuid) VALUES (${new_id_company_user}, ${existing_fk_company}, ${existing_fk_company_business_unit}, ${new_id_customer}, True, False, '${new_key}', '${new_uuid}')
                    END
                    Exit For Loop
                EXCEPT
                    Log    Attempt ${attempt} failed due to duplicate entry in spy_company_user. Retrying...
                    ${unique_id}=    Generate Random String    3    [NUMBERS]
                    ${unique_id}=    Replace String    ${unique_id}    0    9
                    ${unique_id}=    Convert To Integer    ${unique_id}
                    ${new_id_company_user}=    Evaluate    ${new_id_company_user} + ${unique_id}
                    ${new_key}=    Set Variable    ${existing_key}--${new_id_company_user}
                    ${unique}=    Generate Random String    5    [NUMBERS]
                    VAR    ${new_uuid}    ${unique}-${random}-${random_str}-${random_id}
                    ${attempt}=    Evaluate    ${attempt} + 1
                END
            END
            IF    ${attempt} > 3    Fail    Unable to insert company user into spy_company_user after 3 attempts.

            # Insert the new company role to company user entry in the spy_company_role_to_company_user table
            ${existing_company_role_to_user_data}=    Query    SELECT * FROM spy_company_role_to_company_user WHERE fk_company_user = ${existing_id_company_user}
            FOR    ${roles}    IN    @{existing_company_role_to_user_data}

                VAR    ${existing_fk_company_role}    ${roles[1]}
                VAR    ${existing_created_at}    ${roles[3]}
                VAR    ${existing_updated_at}    ${roles[4]}

                # Get the maximum id_company_role_to_company_user and increment it
                ${max_id_company_role_to_company_user}=    Query    SELECT MAX(id_company_role_to_company_user) FROM spy_company_role_to_company_user
                IF    '${None}' in '${max_id_company_role_to_company_user}'    VAR    ${max_id_company_role_to_company_user}    0

                IF    ${max_id_company_role_to_company_user[0][0]} > 5000
                    # new ID will be max +1 not to intersect with real IDs
                    ${new_id_company_role_to_company_user}=    Evaluate    ${max_id_company_role_to_company_user[0][0]} + 1
                ELSE
                    # new ID will be max + 5001 not to intersect with real IDs
                    ${new_id_company_role_to_company_user}=    Evaluate    ${max_id_company_role_to_company_user[0][0]} + 5001
                END

                # Insert the new company role to company user entry in the spy_company_role_to_company_user table
                ${attempt}=    Set Variable    1
                WHILE    ${attempt} <= 3
                    TRY
                        Execute Sql String    INSERT INTO spy_company_role_to_company_user (id_company_role_to_company_user, fk_company_role, fk_company_user, created_at, updated_at) VALUES (${new_id_company_role_to_company_user}, ${existing_fk_company_role}, ${new_id_company_user}, '${existing_created_at}', '${existing_updated_at}')
                        Exit For Loop
                    EXCEPT
                        Log    Attempt ${attempt} failed due to duplicate entry in spy_company_role_to_company_user. Retrying...
                        ${unique_id}=    Generate Random String    3    [NUMBERS]
                        ${unique_id}=    Replace String    ${unique_id}    0    9
                        ${unique_id}=    Convert To Integer    ${unique_id}
                        ${new_id_company_role_to_company_user}=    Evaluate    ${new_id_company_role_to_company_user} + ${unique_id}
                        ${attempt}=    Evaluate    ${attempt} + 1
                    END
                END
                IF    ${attempt} > 3    Fail    Unable to insert company role to company user into spy_company_role_to_company_user after 3 attempts.
            END
        ELSE
            Log    message=Selected customer is not a company user. Skipping company user creation.    level=INFO
        END
    END

    IF    ${create_default_address}
        # Step 9: Check if an address exists for the new customer
        ${address_exists}=    Query    SELECT COUNT(*) FROM spy_customer_address WHERE fk_customer = ${new_id_customer}

        # Step 10: Handle address creation or update
        IF    ${address_exists[0][0]} == 0
            # No address exists, so create a new address
            ${max_id_customer_address}=    Query    SELECT MAX(id_customer_address) FROM spy_customer_address
            IF    '${None}' in '${max_id_customer_address}'    VAR    ${max_id_customer_address}    0
            IF    ${max_id_customer_address[0][0]} > 5000
                # new ID will be max +1 not to intersect with real IDs
                ${new_id_customer_address}=    Evaluate    ${max_id_customer_address[0][0]} + 1
            ELSE
                # new ID will be max + 5001 not to intersect with real IDs
                ${new_id_customer_address}=    Evaluate    ${max_id_customer_address[0][0]} + 5001
            END
            ${address_uuid}=   Generate Random String	4	[UPPER]
            VAR    ${address_uuid}    ${address_uuid}-${random}-${random_str}-${random_id}
            ${attempt}=    Set Variable    1
            WHILE    ${attempt} <= 3
                TRY
                    Execute Sql String    INSERT INTO spy_customer_address (id_customer_address, fk_country, fk_customer, fk_region, address1, address2, address3, anonymized_at, city, comment, company, deleted_at, first_name, last_name, phone, salutation, uuid, zip_code, created_at, updated_at) VALUES (${new_id_customer_address}, 60, ${new_id_customer}, NULL, '${default_address.street}', '${default_address.house_number}', NULL, NULL, '${default_address.city}', NULL, NULL, NULL, '${default_address.first_name}', '${default_address.last_name}', NULL, 0, '${address_uuid}', '${default_address.post_code}', NOW(), NOW())
                    Exit For Loop
                EXCEPT
                    Log    Attempt ${attempt} failed due to duplicate entry in spy_customer_address. Retrying...
                    ${unique_id}=    Generate Random String    3    [NUMBERS]
                    ${unique_id}=    Replace String    ${unique_id}    0    9
                    ${unique_id}=    Convert To Integer    ${unique_id}
                    ${new_id_customer_address}=    Evaluate    ${new_id_customer_address} + ${unique_id}
                    ${unique}=    Generate Random String    5    [NUMBERS]
                    VAR    ${address_uuid}    ${unique}-${random}-${random_str}-${random_id}
                    ${attempt}=    Evaluate    ${attempt} + 1
                END
            END
            IF    ${attempt} > 3    Fail    Unable to insert customer address into spy_customer_address after 3 attempts.
        ELSE
            # Address exists, so update it
            ${existing_address_id}=    Query    SELECT id_customer_address FROM spy_customer_address WHERE fk_customer = ${new_id_customer}
            Execute Sql String    UPDATE spy_customer_address SET fk_country = 60, fk_region = NULL, address1 = '${default_address.street}', address2 = '${default_address.house_number}', address3 = NULL, anonymized_at = NULL, city = '${default_address.city}', first_name = '${default_address.first_name}', last_name = '${default_address.last_name}', phone = NULL, salutation = 0, zip_code = '${default_address.post_code}', updated_at = NOW() WHERE id_customer_address = ${existing_address_id[0][0]}
        END
    END
    Disconnect From Database

Deactivate all discounts in the database
    [Documentation]    This keyword retrieves all existing discounts in the database, saves their keys and activation status,
    ...               and then sets each discount's `is_active` status to `False`.

    # Step 1: Fetch all existing discounts
    Connect to Spryker DB
    ${existing_discounts}=    Query    SELECT discount_key, is_active FROM spy_discount

    # Step 2: Store the current discount states with scope TEST
    VAR    ${discount_states}    ${existing_discounts}    scope=TEST

    # Step 3: Deactivate all discounts
    Execute Sql String    UPDATE spy_discount SET is_active = False

    Disconnect From Database

Restore all discounts in the database
    [Documentation]    This keyword restores the activation status of all discounts based on the previously saved data.
    ...               It must be called after `Deactivate all discounts in the database` to ensure data is available for restoration.
    [Arguments]    ${enable_all_if_no_previous_state}=True

    # Step 1: Check if discount states were saved
    ${state_exists}=    Run Keyword And Return Status    Variable Should Exist    ${discount_states}

    # Step 2: Decide action based on existence of discount states and the argument
    IF    ${state_exists}
        Log    Restoring each discount's original state based on saved data.
        Connect to Spryker DB
        FOR    ${discount_data}    IN    @{discount_states}
            ${discount_key}=    Set Variable    ${discount_data[0]}
            ${status}=    Set Variable    ${discount_data[1]}
            Execute Sql String    UPDATE spy_discount SET is_active = ${status} WHERE discount_key = '${discount_key}'
        END
        Disconnect From Database
    ELSE
        Log    No saved discount state data available.
        IF    ${enable_all_if_no_previous_state}
            Log    Enabling all discounts as per the argument.
            Connect to Spryker DB
            Execute Sql String    UPDATE spy_discount SET is_active = True
            Disconnect From Database
        ELSE
            Fail    No saved discount state data available and 'enable_all_if_no_previous_state' is set to False. Cannot proceed.
        END
    END
