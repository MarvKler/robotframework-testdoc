*** Settings ***
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../../resources/pages/zed/zed_edit_warehouse_page.robot
Resource    products_steps.robot

*** Keywords ***
Zed: update warehouse:
    [Arguments]    @{args}
    ${warehouseData}=    Set Up Keyword Arguments    @{args}
    Zed: go to URL:    /stock-gui/warehouse/list
    Zed: click Action Button in a table for row that contains:    ${warehouse}    Edit
    Wait Until Element Is Visible    ${zed_warehouse_name}
    FOR    ${key}    ${value}    IN    &{warehouseData}
        IF    '${key}'=='name' and '${value}' != '${EMPTY}'    Type Text    ${zed_warehouse_name}    ${value}
        IF    '${key}'=='available' and '${value}' != '${EMPTY}'    Click    xpath=//label[contains(text(),'${value}')]
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'
            Click    xpath=//div[@class='tabs-container']/ul[contains(@class,'nav-tabs')]//li[@data-bs-toggle='tab']//*[text()='Store Relation']
            Zed: Check checkbox by Label:    ${value}
            Click    xpath=//div[@class='tabs-container']/ul[contains(@class,'nav-tabs')]//li[@data-bs-toggle='tab']//*[text()='Configuration']
        END
        IF    '${key}'=='store 2' and '${value}' != '${EMPTY}'
            Click    xpath=//div[@class='tabs-container']/ul[contains(@class,'nav-tabs')]//li[@data-bs-toggle='tab']//*[text()='Store Relation']
            Zed: Check checkbox by Label:    ${value}
            Click    xpath=//div[@class='tabs-container']/ul[contains(@class,'nav-tabs')]//li[@data-bs-toggle='tab']//*[text()='Configuration']
        END
        IF    '${key}'=='unselect store' and '${value}' != '${EMPTY}'
            Click    xpath=//div[@class='tabs-container']/ul[contains(@class,'nav-tabs')]//li[@data-bs-toggle='tab']//*[text()='Store Relation']
            Zed: Uncheck Checkbox by Label:    ${value}
            Click    xpath=//div[@class='tabs-container']/ul[contains(@class,'nav-tabs')]//li[@data-bs-toggle='tab']//*[text()='Configuration']
        END
    END
    Zed: submit the form