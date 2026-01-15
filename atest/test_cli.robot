*** Settings ***
Metadata    Author=Marvin Klerx
Metadata    Creation=March 2025
Test Tags    Global-Tag


*** Test Cases ***
Log Message
    [Documentation]    Basic Console Logging
    ...    Test Doc in second line
    ...
    ...    Test doc in third line
    ...    \nfourth line
    [Tags]    RobotTestDoc

    # this is my commentary
    Log    RobotFramework Test Documentation Generator!

Test without docs
    Log    Test without Doc


*** Keywords ***
MyUserKeword
    [Documentation]    User Keyword

    Log   This is a user keyword

My Second User Keyword
    [Documentation]    User Keyword

    Log   This is a user keyword
