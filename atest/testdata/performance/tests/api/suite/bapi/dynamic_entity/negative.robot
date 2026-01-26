*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../resources/common/common_api.robot
Test Tags    bapi    spryker-core    spryker-core-back-office

*** Test Cases ***
Get_list_of_country_with_invalid_token
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### GET WITH INVALID TOKEN ###
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=${token}
    And I send a GET request:    /dynamic-entity/robot-test-countries
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    And Response should return error code:    002
    And Response should return error message:    Missing access token.
    [Teardown]    Run Keyword    Delete dynamic entity configuration in Database:    robot-test-countries

Get_list_of_country_with_invalid_resource_prefix
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### GET WITH INVALID RESOURCE PREFIX ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity-invalid/robot-test-countries
    Then Response status code should be:    404
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][message]    Not found
    And Response body parameter should be:    [0][status]    404
    And Response body parameter should be:    [0][code]    007
    [Teardown]    Run Keyword    Delete dynamic entity configuration in Database:    robot-test-countries

Get_list_of_country_with_invalid_resource_name
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### GET WITH INVALID RESOURCE NAME ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/invalid-resource
    Then Response status code should be:    404
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][message]    Not found
    And Response body parameter should be:    [0][status]    404
    And Response body parameter should be:    [0][code]    007
    [Teardown]    Run Keyword    Delete dynamic entity configuration in Database:    robot-test-countries

Get_list_of_country_with_invalid_id
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### GET COUNTRY WITH INVALID ID ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/countries/9999999
    Then Response status code should be:    404
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][message]    The entity `countries` could not be found in the database.
    And Response body parameter should be:    [0][status]    404
    And Response body parameter should be:    [0][code]    1303
    [Teardown]    Run Keyword    Delete dynamic entity configuration in Database:    robot-test-countries

Create_country_with_empty_body
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### POST WITH EMPTY BODY ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/countries   {}
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    Invalid or missing data format. Please ensure that the data is provided in the correct format
    And Response body parameter should be:    [0][code]    1301
    [Teardown]    Run Keyword    Delete dynamic entity configuration in Database:    robot-test-countries

Create_country_with_empty_json
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### POST WITH EMPTY JSON ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/countries   {}
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    Invalid or missing data format. Please ensure that the data is provided in the correct format
    And Response body parameter should be:    [0][code]    1301
    [Teardown]    Run Keyword    Delete dynamic entity configuration in Database:    robot-test-countries

Create_country_with_empty_data
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### POST WITH EMPTY DATA ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/countries   {"data": []}
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    Invalid or missing data format. Please ensure that the data is provided in the correct format
    And Response body parameter should be:    [0][code]    1301
    [Teardown]    Run Keyword    Delete dynamic entity configuration in Database:    robot-test-countries

Create_country_with_invalid_data
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### POST WITH INVALID DATA ###
    Delete country by iso2_code in Database:   XX
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-test-countries   {"data":[{"iso2_code":"XX","name":"XXX"}]}
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    The required field must not be empty. Field: `robot-test-countries0.iso3_code`
    And Response body parameter should be:    [0][code]    1307
    And Response body parameter should contain:    [0][status]   400
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-test-countries
    ...   AND    Delete country by iso2_code in Database:   XX

Create_country_with_invalid_data_non_transactional
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### POST WITH INVALID DATA ###
    Delete country by iso2_code in Database:   XX
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}    X-Is-Transactional=false
    And I send a POST request:    /dynamic-entity/robot-test-countries   {"data":[{"iso2_code":"XX","name":"XXX"}]}
    Then Response status code should be:    400
    And Response body parameter should contain:    [errors][0][message]    The required field must not be empty. Field: `robot-test-countries0.iso3_code`
    And Response body parameter should be:    [errors][0][code]    1307
    And Response body parameter should contain:    [errors][0][status]   400
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-test-countries
    ...   AND    Delete country by iso2_code in Database:   XX

Create_country_with_valid_and_invalid_data_non_transactional
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### POST WITH INVALID DATA ###
    Delete country by iso2_code in Database:   XX
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}    X-Is-Transactional=false
    And I send a POST request:    /dynamic-entity/robot-test-countries   {"data":[{"iso2_code":"XX","name":"XXX"}, {"iso2_code":"XX", "iso3_code":"XXX", "name":"Country XXX"}]}
    Then Response status code should be:    201
    And Response body parameter should contain:    [errors][0][message]    The required field must not be empty. Field: `robot-test-countries0.iso3_code`
    And Response body parameter should be:    [errors][0][code]    1307
    And Response body parameter should contain:    [errors][0][status]   400
    And Response body parameter should contain:    [data][0][iso2_code]    XX
    And Response body parameter should contain:    [data][0][iso3_code]    XXX
    When Save value to a variable:    [data][0][id_country]    country_id
    ### GET COUNTRY AND VALIDATE DATA ###
    And I set Headers:    Content-Type==application/json    Authorization=Bearer ${token}
    And I send a GET request:    /dynamic-entity/robot-test-countries/${country_id}
    Then Response status code should be:    200
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][iso2_code]    XX
    And Response body parameter should be:    [data][iso3_code]    XXX
    And Response body parameter should be:    [data][name]    Country XXX
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-test-countries
    ...   AND    Delete country by iso2_code in Database:   XX

Create_country_with_invalid_resource_name
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### POST WITH INVALID RESOURCE NAME ###
    Delete country by iso2_code in Database:   XX
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/cnt   {"data":[{"iso2_code":"XX","name":"XXX"}]}
    Then Response status code should be:    404
    And Response body parameter should contain:    [0][message]    Not found
    And Response body parameter should be:    [0][code]    007
    And Response body parameter should contain:    [0][status]   404
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-test-countries
    ...   AND    Delete country by iso2_code in Database:   XX

Create_country_with_invalid_field_value
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### POST WITH INVALID FIELD VALUE ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-test-countries   {"data":[{"iso2_code":"X","iso3_code":"XXXX","name":""}]}
    Then Response status code should be:    400
    And Response should contain the array of a certain size:   $    3
    And Response body parameter should contain:    [0][message]    Invalid data value `robot-test-countries0` for field: `iso2_code`.
    And Response body parameter should be:    [0][code]    1306
    And Response body parameter should contain:    [0][status]   400
    And Response body parameter should contain:    [1][message]    Invalid data value `robot-test-countries0` for field: `iso3_code`.
    And Response body parameter should be:    [1][code]    1306
    And Response body parameter should contain:    [1][status]   400
    And Response body parameter should contain:    [2][message]    Invalid data value `robot-test-countries0` for field: `name`.
    And Response body parameter should be:    [2][code]    1306
    And Response body parameter should contain:    [2][status]   400
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-test-countries
    ...   AND    Delete country by iso2_code in Database:   X

Create_country_with_invalid_field
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### POST WITH INVALID DATA ###
    Delete country by iso2_code in Database:   XX
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-test-countries   {"data":[{"iso2_code":"XX","iso3_code":"XXX","name":"XXX"}]}
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    The provided `robot-test-countries0.iso3_code` is incorrect or invalid.
    And Response body parameter should be:    [0][code]    1311
    And Response body parameter should contain:    [0][status]   400
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-test-countries
    ...   AND    Delete country by iso2_code in Database:   XX

Create_url_with_invalid_url_name
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-urls
    Create dynamic entity configuration in Database:   robot-test-urls    spy_url     1    {"identifier":"id_url","fields":[{"fieldName":"id_url","fieldVisibleName":"id_url","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_locale","fieldVisibleName":"fk_locale","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"url","fieldVisibleName":"url","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true,"constraints":[{"name":"url"}]}},{"fieldName":"fk_resource_product_set","fieldVisibleName":"fk_resource_product_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### POST WITH INVALID DATA ###
    Delete url by url name in Database:   test-url
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-test-urls   {"data":[{"url":"test-url", "fk_locale": 46}]}
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    The URL is invalid. `robot-test-urls0` field `url` must have a URL data format.
    And Response body parameter should be:    [0][code]    1316
    And Response body parameter should contain:    [0][status]   400
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-test-urls
    ...   AND    Delete url by url name in Database:   test-url

Update_url_with_invalid_url_name
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-urls
    Create dynamic entity configuration in Database:   robot-test-urls    spy_url     1    {"identifier":"id_url","fields":[{"fieldName":"id_url","fieldVisibleName":"id_url","isCreatable":false,"isEditable":false,"validation":{"isRequired":false},"type":"integer"},{"fieldName":"fk_locale","fieldVisibleName":"fk_locale","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":true}},{"fieldName":"url","fieldVisibleName":"url","isCreatable":true,"isEditable":true,"type":"string","validation":{"isRequired":true,"constraints":[{"name":"url"}]}},{"fieldName":"fk_resource_product_set","fieldVisibleName":"fk_resource_product_set","isCreatable":true,"isEditable":true,"type":"integer","validation":{"isRequired":false}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### POST WITH INVALID DATA ###
    Delete url by url name in Database:   test-url
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a PATCH request:    /dynamic-entity/robot-test-urls   {"data":[{"url":"test-url"}]}
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    The URL is invalid. `robot-test-urls0` field `url` must have a URL data format.
    And Response body parameter should be:    [0][code]    1316
    And Response body parameter should contain:    [0][status]   400
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-test-urls
    ...   AND    Delete url by url name in Database:   test-url

Update_country_with_invalid_data
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE TEST COUNTRIES ###
    Delete country by iso2_code in Database:   XA
    Delete country by iso2_code in Database:   XB
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-test-countries   {"data":[{"iso2_code":"XA","iso3_code":"XXA","name":"XXA"},{"iso2_code":"XB","iso3_code":"XXB","name":"XXB"}]}
    Then Response status code should be:    201
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [data][0][iso2_code]    XA
    And Response body parameter should be:    [data][0][iso3_code]    XXA
    And Response body parameter should be:    [data][0][name]   XXA
    And Response body parameter should be:    [data][1][iso2_code]    XB
    And Response body parameter should be:    [data][1][iso3_code]    XXB
    And Response body parameter should be:    [data][1][name]   XXB
    Response body parameter should be greater than :    [data][0][id_country]    200
    When Save value to a variable:    [data][0][id_country]    xxa_country_id
    When Save value to a variable:    [data][1][id_country]    xxb_country_id
    ### UPDATE COUNTRY WITH INVALID DATA ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a PATCH request:    /dynamic-entity/robot-test-countries/${xxa_country_id}    {"data":{"iso2_code":"XXXX"}}
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    Invalid data value `robot-test-countries0` for field: `iso2_code`.
    And Response body parameter should be:    [0][code]    1306
    And Response body parameter should be:    [0][status]    400
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-test-countries
    ...   AND    Delete country by iso2_code in Database:   XA
    ...   AND    Delete country by iso2_code in Database:   XB

Update_country_collection_with_invalid_data
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE TEST COUNTRIES ###
    Delete country by iso2_code in Database:   XA
    Delete country by iso2_code in Database:   XB
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-test-countries   {"data":[{"iso2_code":"XA","iso3_code":"XXA","name":"XXA"},{"iso2_code":"XB","iso3_code":"XXB","name":"XXB"}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_country]    xxa_country_id
    When Save value to a variable:    [data][1][id_country]    xxb_country_id
    ### UPDATE COUNTRY COLLECTION WITH INVALID DATA ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a PATCH request:    /dynamic-entity/robot-test-countries    {"data":[{"id_country":${xxa_country_id},"iso2_code":"XXXX"},{"id_country":${xxb_country_id},"iso3_code":"XXXXX"}]}
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    Invalid data value `robot-test-countries0` for field: `iso2_code`.
    And Response body parameter should be:    [0][code]    1306
    And Response body parameter should be:    [0][status]    400
    And Response body parameter should contain:    [1][message]    Invalid data value `robot-test-countries1` for field: `iso3_code`.
    And Response body parameter should be:    [1][code]    1306
    And Response body parameter should be:    [1][status]    400
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-test-countries
    ...   AND    Delete country by iso2_code in Database:   XA
    ...   AND    Delete country by iso2_code in Database:   XB

Update_country_with_invalid_field_type
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE TEST COUNTRIES ###
    Delete country by iso2_code in Database:   XA
    Delete country by iso2_code in Database:   XB
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-test-countries   {"data":[{"iso2_code":"XA","iso3_code":"XXA","name":"XXA"},{"iso2_code":"XB","iso3_code":"XXB","name":"XXB"}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_country]    xxa_country_id
    When Save value to a variable:    [data][1][id_country]    xxb_country_id
    ### UPDATE COUNTRY WITH INVALID FILELD TYPE ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a PATCH request:    /dynamic-entity/robot-test-countries/${xxa_country_id}    {"data":{"name": "FOO", "iso2_code":1234, "iso3_code": 1234}}
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    Invalid data type `robot-test-countries0` for field `iso2_code`
    And Response body parameter should be:    [0][code]    1305
    And Response body parameter should be:    [0][status]    400
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-test-countries
    ...   AND    Delete country by iso2_code in Database:   XA
    ...   AND    Delete country by iso2_code in Database:   XB

Update_country_with_invalid_field
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### POST WITH INVALID DATA ###
    Delete country by iso2_code in Database:   XX
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a PATCH request:    /dynamic-entity/robot-test-countries   {"data":[{"iso2_code":"XX","iso3_code":"XXX","name":"XXX"}]}
    Then Response status code should be:    400
    And Response body parameter should contain:    [0][message]    The provided `robot-test-countries0.iso3_code` is incorrect or invalid.
    And Response body parameter should be:    [0][code]    1311
    And Response body parameter should contain:    [0][status]   400
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-test-countries
    ...   AND    Delete country by iso2_code in Database:   XX

Upsert_with_invalid_id
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:   robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### POST GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}

    ### UDATE WITH INVALID ID ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a PUT request:    /dynamic-entity/robot-test-countries/1000    {"data":{"iso2_code":"XX","iso3_code":"XXX","name":"Country XXX"}}
    Then Response status code should be:    400
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][message]    Entity `robot-test-countries0.id_country: 1000` not found by identifier, and new identifier can not be persisted. Please update the request.
    And Response body parameter should be:    [0][code]    1308
    And Response body parameter should be:    [0][status]    400
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-test-countries
    ...   AND    Delete country by iso2_code in Database:   XX

Delete_country_by_id_is_deletable_false:
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:    robot-test-countries    spy_country     1    {"identifier":"id_country","isDeletable": false,"fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE TEST COUNTRY ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-test-countries   {"data":[{"iso2_code":"XA","iso3_code":"XXA","name":"Country XA"}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_country]    xxa_id
    #### DELETE COUNTRY ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a DELETE request:    /dynamic-entity/robot-test-countries/${xxa_id}
    Then Response status code should be:    405
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][message]    Method not allowed for the entity `robot-test-countries`.
    And Response body parameter should be:    [0][status]    405
    And Response body parameter should be:    [0][code]    1318
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-test-countries
    ...   AND    Delete country by iso2_code in Database:   XA

Delete_country_by_id_is_deletable_null:
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:    robot-test-countries    spy_country     1    {"identifier":"id_country","isDeletable": null,"fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE TEST COUNTRY ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-test-countries   {"data":[{"iso2_code":"XA","iso3_code":"XXA","name":"Country XA"}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_country]    xxa_id
    #### DELETE COUNTRY ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a DELETE request:    /dynamic-entity/robot-test-countries/${xxa_id}
    Then Response status code should be:    405
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][message]    Method not allowed for the entity `robot-test-countries`.
    And Response body parameter should be:    [0][status]    405
    And Response body parameter should be:    [0][code]    1318
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-test-countries
    ...   AND    Delete country by iso2_code in Database:   XA

Delete_country_by_id_without_is_deletable:
    ### SETUP DYNAMIC ENTITY CONFIGURATION ###
    Delete dynamic entity configuration in Database:    robot-test-countries
    Create dynamic entity configuration in Database:    robot-test-countries    spy_country     1    {"identifier":"id_country","fields":[{"fieldName":"id_country","fieldVisibleName":"id_country","isEditable":false,"isCreatable":false,"type":"integer","validation":{"isRequired":false}},{"fieldName":"iso2_code","fieldVisibleName":"iso2_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":2,"minLength":2}},{"fieldName":"iso3_code","fieldVisibleName":"iso3_code","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":3,"minLength":3}},{"fieldName":"name","fieldVisibleName":"name","type":"string","isEditable":true,"isCreatable":true,"validation":{"isRequired":true,"maxLength":255,"minLength":1}},{"fieldName":"postal_code_mandatory","fieldVisibleName":"postal_code_mandatory","type":"boolean","isEditable":true,"isCreatable":true,"validation":{"isRequired":false}},{"fieldName":"postal_code_regex","isEditable":"false","isCreatable":"false","fieldVisibleName":"postal_code_regex","type":"string","validation":{"isRequired":false,"maxLength":500,"minLength":1}}]}
    ### GET TOKEN ###
    I get access token by user credentials:   ${zed_admin.email}
    ### CREATE TEST COUNTRY ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a POST request:    /dynamic-entity/robot-test-countries   {"data":[{"iso2_code":"XA","iso3_code":"XXA","name":"Country XA"}]}
    Then Response status code should be:    201
    When Save value to a variable:    [data][0][id_country]    xxa_id
    #### DELETE COUNTRY ###
    And I set Headers:    Content-Type=application/json    Authorization=Bearer ${token}
    And I send a DELETE request:    /dynamic-entity/robot-test-countries/${xxa_id}
    Then Response status code should be:    405
    And Response header parameter should be:    Content-Type    application/json
    And Response body parameter should be:    [0][message]    Method not allowed for the entity `robot-test-countries`.
    And Response body parameter should be:    [0][status]    405
    And Response body parameter should be:    [0][code]    1318
    [Teardown]    Run Keywords    Delete dynamic entity configuration in Database:    robot-test-countries
    ...   AND    Delete country by iso2_code in Database:   XA
