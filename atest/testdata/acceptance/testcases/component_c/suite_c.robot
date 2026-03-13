*** Settings ***
Documentation    Suite C demonstrates test-level setup and teardown usage.
...              Contains tests with various fixture configurations.
Metadata         component=C
Metadata         owner=testdoc-team
Suite Setup      Suite C - Initialize Environment
Suite Teardown   Suite C - Cleanup Environment


*** Variables ***
${BASE_URL} =       https://example.com
${TIMEOUT} =        30s
${DB_CONNECTION} =  None


*** Test Cases ***
Suite C - TC001 - Login With Valid Credentials
    [Documentation]    Verifies that a user can log in with valid credentials.
    ...                Expects a successful session after authentication.
    [Tags]    CompC    Smoke    Authentication
    [Setup]    Suite C - Open Browser Session    ${BASE_URL}
    Log    Navigating to login page
    Log    Entering credentials
    Log    Verifying successful login
    [Teardown]    Suite C - Close Browser Session

Suite C - TC002 - Login With Invalid Credentials
    [Documentation]    Verifies that an error is shown for invalid credentials.
    [Tags]    CompC    Regression    Authentication
    [Setup]    Suite C - Open Browser Session    ${BASE_URL}
    Log    Entering invalid credentials
    Log    Verifying error message is displayed
    [Teardown]    Suite C - Close Browser Session

Suite C - TC003 - Fetch User Data From API
    [Documentation]    Verifies that user data can be fetched via the REST API.
    [Tags]    CompC    Regression    API
    [Setup]    Suite C - Prepare API Headers    Authorization=Bearer token123
    Log    Sending GET /api/users/1
    Log    Verifying response status is 200
    Log    Verifying response body contains expected fields

Suite C - TC004 - Create New User Via API
    [Documentation]    Verifies that a new user can be created via POST endpoint.
    [Tags]    CompC    Smoke    API
    [Setup]    Suite C - Prepare API Headers    Authorization=Bearer token123
    Log    Sending POST /api/users with user payload
    Log    Verifying response status is 201
    Log    Verifying Location header is present
    [Teardown]    Suite C - Delete Test User    test-user-created-in-tc004

Suite C - TC005 - Database Record Integrity Check
    [Documentation]    Verifies that records written to the DB are consistent.
    [Tags]    CompC    Regression    Database
    [Setup]    Suite C - Connect To Database    host=localhost    port=5432
    Log    Inserting test record
    Log    Querying record back
    Log    Verifying field values match inserted data
    [Teardown]    Suite C - Disconnect From Database

Suite C - TC006 - No Fixtures Test
    [Documentation]    Basic smoke test without any setup or teardown.
    ...                Verifies a standalone utility function.
    [Tags]    CompC    Smoke
    Log    Running standalone utility check
    Log    Utility returned expected result


*** Keywords ***
Suite C - Initialize Environment
    [Documentation]    Suite-level setup: initialise shared test resources.
    Log    Initialising environment for Suite C
    Log    Loading configuration from ${BASE_URL}

Suite C - Cleanup Environment
    [Documentation]    Suite-level teardown: release all shared resources.
    Log    Tearing down environment after Suite C

Suite C - Open Browser Session
    [Documentation]    Opens a browser and navigates to the given URL.
    [Arguments]    ${url}
    Log    Opening browser session for ${url}

Suite C - Close Browser Session
    [Documentation]    Closes the active browser session.
    Log    Closing browser session

Suite C - Prepare API Headers
    [Documentation]    Sets up HTTP headers for API calls.
    [Arguments]    ${Authorization}
    Log    Setting Authorization header: ${Authorization}

Suite C - Delete Test User
    [Documentation]    Removes a test user created during a test.
    [Arguments]    ${user_id}
    Log    Deleting test user: ${user_id}

Suite C - Connect To Database
    [Documentation]    Opens a database connection.
    [Arguments]    ${host}    ${port}
    Log    Connecting to database at ${host}:${port}

Suite C - Disconnect From Database
    [Documentation]    Closes the active database connection.
    Log    Disconnecting from database
