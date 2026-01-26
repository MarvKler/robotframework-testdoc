*** Settings ***
Resource    ../common/common_ui.robot

*** Keywords ***
Yves: set new password on Restore Password page
    wait until element is visible  ${new_password_field}
    Type Text  ${new_password_field}   ${default_password}
    Type Text  ${confirm_new_password_field}   ${default_password}
    Click  ${new_password_submit_button}
    Wait Until Page Does Not Contain Element  ${new_password_submit_button}