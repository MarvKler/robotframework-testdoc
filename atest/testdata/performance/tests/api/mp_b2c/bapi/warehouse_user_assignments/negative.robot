*** Settings ***
Suite Setup       API_suite_setup
Test Setup    API_test_setup
Resource    ../../../../../resources/common/common_api.robot
Resource    ../../../../../resources/steps/warehouse_user_assignment_steps.robot
Test Tags    bapi

*** Test Cases ***
*** Test Cases ***
Create_warehouse_user_assignment_with_invalid_token
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer invalid
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    1    
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehouse_user[0].admin_user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    401
    [Teardown]    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    0  

Create_warehouse_user_assignment_without_token
    And I set Headers:    Content-Type=${default_header_content_type}   
    Then Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    1   
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehouse_user[0].admin_user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    403
    And Response should return error message:    Unauthorized request.
    [Teardown]    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    0  

Create_warehouse_user_assignment_with_invalid_body
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token} 
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    1    
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "test","warehouse" :{"uuid": "${warehouse_user[0].admin_user_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    404
    And Response should return error code:    5201
    And Response should return error message:    Warehouse user assignment not found.
    [Teardown]    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    0  


Create_warehouse_user_assignment_with_empty_body
    [Documentation]    https://spryker.atlassian.net/browse/FRW-1597
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    1        
    When I send a POST request:    /warehouse-user-assignments    {"data": {}}
    Then Response status code should be:    400
    [Teardown]    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    0  


Create_warehouse_user_assignment_with_incorrect_type
    [Documentation]    https://spryker.atlassian.net/browse/FRW-6312
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    1        
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "invalid", "attributes":{"userUuid": "${warehouse_user[0].admin_user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    400
    [Teardown]    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    0  


Create_warehouse_user_assignment_with_duplicate_assignment
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    1        
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehouse_user[0].admin_user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assignment_id
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehouse_user[0].admin_user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    400
    And Response should return error code:    5206
    And Response should return error message:    Warehouse user assignment already exists.
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assignment_id}
    ...  AND    Response status code should be:    204
    ...  AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    0  
 

Get_warehouse_user_assignments_by_UUID_without_token
    [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
    [Tags]    skip-due-to-issue
    When Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    1    
    And Create_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse[0].fk_warehouse_spryker}    ${warehouse_user[0].admin_user_uuid}    false
    Then Get_warehouse_user_assignment_id:   ${warehouse[0].warehouse_uuid}    ${warehouse_user[0].admin_user_uuid}
    Then I send a GET request:    /warehouse-user-assignments/${id_warehouse_user_assignment}
    Then Response status code should be:    403
    [Teardown]    Run Keywords    Remove_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse_user[0].admin_user_uuid}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    0  


Get_user_assignments_by_UUID_with_invalid_token
    [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
    [Tags]    skip-due-to-issue
    When Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    1    
    And Create_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse[0].fk_warehouse_spryker}    ${warehouse_user[0].admin_user_uuid}    false
    Then Get_warehouse_user_assignment_id:   ${warehouse[0].warehouse_uuid}    ${warehouse_user[0].admin_user_uuid}
    And I get access token by user credentials:    invalid
    Then I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}  
    Then I send a GET request:    /warehouse-user-assignments/${id_warehouse_user_assignment}
    Then Response status code should be:    401
    And Response should return error code:    001
    And Response should return error message:   Invalid access token.
    [Teardown]    Run Keywords    Remove_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse_user[0].admin_user_uuid}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    0  


Get_user_assignments_by_invalid_UUID
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    When Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    1      
    And Create_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse[0].fk_warehouse_spryker}    ${warehouse_user[0].admin_user_uuid}    false
    Then Get_warehouse_user_assignment_id:   ${warehouse[0].warehouse_uuid}    ${warehouse_user[0].admin_user_uuid}
    Then I send a GET request:    /warehouse-user-assignments/invalid
    Then Response status code should be:    404
    And Response should return error code:    5201
    And Response should return error message:    Warehouse user assignment not found.
    [Teardown]    Run Keywords    Remove_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse_user[0].admin_user_uuid}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    0    

Get_user_assignments_list_with_invalid_token
    [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:    invalid
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}  
    When Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    1      
    And Create_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse[0].fk_warehouse_spryker}    ${warehouse_user[0].admin_user_uuid}    false
    Then I send a GET request:    /warehouse-user-assignments/
    Then Response status code should be:    403
    And Response reason should be:    Forbidden
    [Teardown]    Run Keywords    Remove_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse_user[0].admin_user_uuid}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    0   


Get_user_assignments_list_without_token
    [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
    [Tags]    skip-due-to-issue
    When Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    1
    And Create_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse[0].fk_warehouse_spryker}   ${warehouse_user[0].admin_user_uuid}    false
    Then I send a GET request:    /warehouse-user-assignments/
    Then Response status code should be:    403
    And Response reason should be:    Unauthorized
    And Response should return error message:    Invalid access token.
    [Teardown]    Run Keywords    Remove_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse_user[0].admin_user_uuid}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    0   

Update_warehouse_user_assignment_without_token
    [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
    [Tags]    skip-due-to-issue
    When Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    1    
    And Create_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse[0].fk_warehouse_spryker}    ${warehouse_user[0].admin_user_uuid}    false
    Then Get_warehouse_user_assignment_id:   ${warehouse[0].warehouse_uuid}    ${warehouse_user[0].admin_user_uuid}
    Then I send a PATCH request:    /warehouse-user-assignments/${id_warehouse_user_assignment}    {"data":{"attributes":{"isActive":"true"}}} 
    Then Response status code should be:    401
    [Teardown]    Run Keywords    Remove_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse_user[0].admin_user_uuid}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    0   

Update_warehouse_user_assignment_with_invalid_token
    [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
    [Tags]    skip-due-to-issue
    [Setup]    Run Keywords    I get access token by user credentials:    invalid
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}   
    When Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    1
    And Create_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse[0].fk_warehouse_spryker}    ${warehouse_user[0].admin_user_uuid}    false
    Then Get_warehouse_user_assignment_id:   ${warehouse[0].warehouse_uuid}    ${warehouse_user[0].admin_user_uuid}
    And Create_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse[0].fk_warehouse_spryker}    ${warehouse_user[0].admin_user_uuid}    false 
    Then I send a PATCH request:    /warehouse-user-assignments/${id_warehouse_user_assignment}    {"data":{"attributes":{"isActive":"true"}}} 
    Then Response status code should be:    403
    [Teardown]    Run Keywords    Remove_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse_user[0].admin_user_uuid}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    0   

Update_warehouse_user_assignment_without_uuid
    [Setup]    Run Keywords    I get access token by user credentials:    ${zed_admin.email}
    ...    AND    I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer ${token}
    When Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    1   
    When I send a POST request:    /warehouse-user-assignments    {"data": {"type": "warehouse-user-assignments", "attributes":{"userUuid": "${warehouse_user[0].admin_user_uuid}","warehouse" :{"uuid": "${warehouse[0].warehouse_uuid}"},"isActive":"false"}}}
    Then Response status code should be:    201
    Then Save value to a variable:    [data][id]   warehouse_assignment_id_1
    Then I send a PATCH request:    /warehouse-user-assignments/invalid    {"data":{"attributes":{"isActive":"true"}}}
    Then Response status code should be:    404
    And Response should return error code:    5201
    And Response should return error message:    Warehouse user assignment not found.
    [Teardown]     Run Keywords    I send a DELETE request:    /warehouse-user-assignments/${warehouse_assignment_id_1}
    ...    AND    Response status code should be:    204
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    0  
 

Delete_warehouse_user_assignment_without_token
    [Documentation]    https://spryker.atlassian.net/browse/FRW-5850
    [Tags]    skip-due-to-issue
    When Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    1
    And Create_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse[0].fk_warehouse_spryker}    ${warehouse_user[0].admin_user_uuid}    false
    Then Get_warehouse_user_assignment_id:   ${warehouse[0].warehouse_uuid}    ${warehouse_user[0].admin_user_uuid}
    Then I send a DELETE request:    /warehouse-user-assignments/${id_warehouse_user_assignment}  
    Then Response status code should be:    400
    [Teardown]    Run Keywords    Remove_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse_user[0].admin_user_uuid}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    0       

 Delete_warehouse_user_assignment_with_invalid_token
    And I set Headers:    Content-Type=${default_header_content_type}    Authorization=Bearer invalid
    When Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    1
    And Create_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse[0].fk_warehouse_spryker}    ${warehouse_user[0].admin_user_uuid}    false
    Then Get_warehouse_user_assignment_id:   ${warehouse[0].warehouse_uuid}    ${warehouse_user[0].admin_user_uuid}
    Then I send a DELETE request:    /warehouse-user-assignments/${id_warehouse_user_assignment}
    Then Response status code should be:    401
    [Teardown]    Run Keywords    Remove_warehouse_user_assignment:    ${warehouse[0].warehouse_uuid}    ${warehouse_user[0].admin_user_uuid}
    ...    AND    Make user a warehouse user/ not a warehouse user:   ${warehouse_user[0].admin_user_uuid}    0   
 