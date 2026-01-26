*** Settings ***
Name    Custom Name Suite B
Metadata    author=Marvin Klerx
Metadata    creation_date=January 2026
Metadata    company=imbus AG


*** Test Cases ***
Suite C - TC001
    [Tags]    CompC    robot:exclude
    Log    C-TC001

Suite C - TC002
    [Tags]    CompC    test:retry(1)
    Log    C-TC002


*** Keywords ***
Suite C - User Keyword 1
    Log    Suite C - User Keyword 1
