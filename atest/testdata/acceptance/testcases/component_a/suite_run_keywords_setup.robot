*** Settings ***
Documentation    Suite with a test that uses Run Keywords in its test-level setup.


*** Test Cases ***
Test With Run Keywords Setup
    [Documentation]    Test whose setup calls Run Keywords with two Log calls.
    [Setup]    Run Keywords
    ...    Log    Setup Step One
    ...    AND
    ...    Log    Setup Step Two
    Log    Running
