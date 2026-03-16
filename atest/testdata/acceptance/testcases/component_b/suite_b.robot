*** Settings ***
Name    Custom Name Suite B
Documentation    Suite B demonstrates special tag usage such as robot:exclude and test:retry.
Test Tags    CompC
Metadata    author=Marvin Klerx
Metadata    creation_date=January 2026
Metadata    company=imbus AG


*** Test Cases ***
Suite B - TC001 - Robot Exclude Tag
    [Documentation]    Verifies the robot:exclude tag which prevents the test from being executed.
    [Tags]    robot:exclude
    Log    C-TC001

Suite B - TC002 - Test Retry Configuration
    [Documentation]    Verifies the test:retry tag configuration for automatic test retries.
    [Tags]    test:retry(1)
    Log    C-TC002


*** Keywords ***
Suite B - User Keyword 1
    [Documentation]    Executes the Suite B user keyword action.
    Log    Suite C - User Keyword 1
