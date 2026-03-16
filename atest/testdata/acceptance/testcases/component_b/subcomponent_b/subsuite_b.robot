*** Settings ***
Documentation    Subsuite B covers regression and smoke test scenarios for Component B.
Test Tags    CompB


*** Test Cases ***
Subsuite B - TC-001 - Regression Test
    [Documentation]    Regression test verifying core Subsuite B functionality.
    [Tags]    Regression
    Log    SB-TC001

Subsuite B - TC-002 - Smoke Test
    [Documentation]    Smoke test verifying basic Subsuite B functionality with Feature-XYZ tag.
    [Tags]    Smoke    Feature-XYZ
    Log    SB-TC002


*** Keywords ***
Subsuite B - User Keyword B
    [Documentation]    docs
    Log    SB-KW001
