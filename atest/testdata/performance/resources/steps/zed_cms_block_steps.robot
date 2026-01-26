*** Settings ***
Resource    ../pages/zed/zed_cms_page_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Keywords ***

Zed: assigned store to cms block:
    [Arguments]    ${store}    ${block_name}
    Zed: go to URL:    /cms-block-gui/list-block
    Zed: perform search by:    ${block_name}
    Zed: click Action Button in a table for row that contains:     ${block_name}     Edit Block
    Set Browser Timeout    ${browser_timeout}
    Wait Until Element Is Visible    xpath=//div[@id='cms_block_storeRelation']//label[normalize-space(.)='${store}']//input[@type='checkbox']
    Zed: Check checkbox by Label:    ${store} 
    Click    ${zed_cms_block_save_button}
    Zed: message should be shown:    CMS Block was updated successfully.
    Trigger multistore p&s
