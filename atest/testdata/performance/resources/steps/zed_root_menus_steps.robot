*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_root_menus_page.robot

*** Keywords ***
Zed: verify first navigation root menus
    ${counter}=    Set Variable    1
    ${first_navigation_count}=    Get Element Count    ${zed_first_navigation_menus_locator}
    WHILE  ${counter} <= ${first_navigation_count}
        Log    ${counter}
        Click    xpath=(//ul[@id='side-menu']/li/a/span[@class='nav-label']/../../a[contains(@href,'/') and not (contains(@href,'javascript'))])[${counter}]
        TRY
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
        TRY
            ${app_terms_overlay_state}=    Page Should Contain Element    xpath=//app-terms-and-conditions-dialog/ancestor::div[contains(@class,'overlay-container')]    message=Overlay is not displayed    timeout=1s
            Remove element from HTML with JavaScript    //app-terms-and-conditions-dialog/ancestor::div[contains(@class,'overlay-container')]
        EXCEPT
            Log    Overlay is not displayed
        END
        Wait Until Element Is Visible    locator=${zed_log_out_button}    timeout=${browser_timeout}    message=Some left navigation menu item throws an error.
        ${counter}=    Evaluate    ${counter} + 1   
    END

Zed: verify root menu icons
    ${counter}=    Set Variable    1
    ${first_navigation_icon_count}=    Get Element Count    ${zed_root_menu_icons_locator}
    WHILE  ${counter} <= ${first_navigation_icon_count}
        Log    ${counter}
        Page should contain element    xpath=(//ul[@id='side-menu']/li/a/span[@class='nav-label']/../../a/i)[${counter}]
        ${counter}=    Evaluate    ${counter} + 1
    END

Zed: verify second navigation root menus
    ${counter}=    Set Variable    1
    ${first_navigation_count}=    Get Element Count    ${zed_second_navigation_menus_locator}
    WHILE  ${counter} <= ${first_navigation_count}
        ${counter_1}=    Set Variable    1
        Log    ${counter}
        Click Element by xpath with JavaScript    (//ul[@id='side-menu']/li/a/span[@class='nav-label']/../../a[contains(@href,'javascript')])[${counter}]
        Wait Until Element Is Visible    xpath=(//ul[@id='side-menu']/li/a/span[@class='nav-label']/../../a[contains(@href,'javascript')]/parent::li)[${counter}]    timeout=10s
        ${second_navigation_count}=    Get Element Count    xpath=((//ul[@id='side-menu']/li/a/span[@class='nav-label']/../../a[contains(@href,'javascript')])[${counter}]/ancestor::li//ul[contains(@class,'nav-second-level')]//a)
            WHILE  ${counter_1} <= ${second_navigation_count}
                ${node_state}=    Get Element Attribute    xpath=(//ul[@id='side-menu']/li/a/span[@class='nav-label']/../../a[contains(@href,'javascript')]/parent::li)[${counter}]    class
                log    ${node_state}
                IF    'active' not in '${node_state}'     
                    Click Element by xpath with JavaScript    (//ul[@id='side-menu']/li/a/span[@class='nav-label']/../../a[contains(@href,'javascript')])[${counter}]
                    TRY
                        Repeat Keyword    3    Wait For Load State
                    EXCEPT
                        Log    Page is not loaded
                    END
                END
                Click Element by xpath with JavaScript    ((//ul[@id='side-menu']/li/a/span[@class='nav-label']/../../a[contains(@href,'javascript')])[${counter}]/ancestor::li//ul[contains(@class,'nav-second-level')]//a)[${counter_1}]
                TRY
                    Repeat Keyword    3    Wait For Load State
                EXCEPT
                    Log    Page is not loaded
                END
                Wait Until Element Is Visible    ${zed_log_out_button}    timeout=${browser_timeout}
                Log    ${counter_1}
                ${counter_1}=    Evaluate    ${counter_1} + 1   
            END        
        Wait Until Element Is Visible    ${zed_log_out_button}    timeout=${browser_timeout}
        ${counter}=    Evaluate    ${counter} + 1  
    END
