*** Settings ***
Metadata    name=marvin


*** Variables ***
${SUITE_VAR} =    Hello Suite Variable


*** Test Cases ***
Suite A - TC-001
    [Documentation]    Doc for test A
    ...    Next line
    ...
    ...    another line
    [Tags]    CompA    Regression
    Log    A-TC001
    Log    ABC
    Suite A - User Keyword A
    Second User Keyword    Hello!

    GROUP    Print Suite Var
        Log    ${SUITE_VAR}
    END
    

Suite A - TC002
    [Tags]    CompA    Smoke
    Log    A-TC002

    GROUP    Group Syntax
        Log    Log in GROUP
    END
    


*** Keywords ***
Suite A - User Keyword A
    [Documentation]    docs
    Log    A-KW001

Second User Keyword
    [Arguments]    ${arg}

    Log   ${arg}
