*** Settings ***
Documentation    Basic Console Logging - Suite Doc
Metadata    Author=Marvin Klerx
Metadata    Creation=March 2025
Test Tags    Global-Tag


*** Test Cases ***
Log Message
    [Documentation]    Basic Console Logging
    [Tags]    RobotTestDoc

    # this is my commentary
    Log    RobotFramework Test Documentation Generator!


*** Keywords ***
MyUserKeword
    [Documentation]    User Keyword

    Log   This is a user keyword

My Second User Keyword
    [Documentation]    User Keyword

    Log   This is a user keyword
