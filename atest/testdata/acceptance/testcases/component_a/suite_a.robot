*** Settings ***
Library    Collections
Library    Tables
Library    ../../resources/keyword_library.py    AS    MyLib
Documentation    This is a suite documentation
Metadata    name=marvin


*** Variables ***
${SUITE_VAR} =    Hello Suite Variable


*** Test Cases ***
Suite A - TC-001 - ${SUITE_VAR}
    [Documentation]    Doc for test A
    ...    Next line
    ...
    ...    another line
    [Tags]    CompA    Regression
    [Setup]    Log   Setup
    Log    A-TC001
    Log    ABC
    Suite A - User Keyword A
    Second User Keyword    Hello!

    GROUP    Print Suite Var
        Log    ${SUITE_VAR}
    END

Suite A - Library Keyword Docs
    [Documentation]    Using keywords from ``Collections``.
    VAR    @{list} =    0    1    2
    Collections.Append To List    ${list}    1
    Collections.Get From List    ${list}    0

Suite A - Custom Python Library
    [Documentation]    Verifies that custom Python library keywords can be resolved and documented.
    MyLib.My Keyword    test log output

Suite A - Installed Library Keyword
    [Documentation]    Verifies that installed library (Tables) keywords can be resolved and documented.
    Tables.Create Table     ${{["A", "B"]}}
    Tables.Get Table

Suite A - AND Statement
    [Documentation]    This test case demonstrates the use of AND statement in Robot Framework.
    Run Keywords
    ...    Log    First
    ...    AND
    ...    Log    Second

Suite A - TC002 - Group Syntax Demo
    [Documentation]    Demonstrates GROUP block syntax for structuring test steps visually.
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
    [Documentation]    Logs the given argument.
    [Arguments]    ${arg}

    Log   ${arg}
