*** Settings ***
Name    Suite 2
Documentation    Basic Console Logging - Suite Doc
Metadata    Author=Marvin Klerx
Metadata    Creation=January 2026
Test Tags    Global-Tag


*** Test Cases ***
Suite 2 - TC-001
    [Documentation]    Basic Console Logging
    [Tags]    RobotTestDoc

    Log    Log message in suite 2 - TC-001
