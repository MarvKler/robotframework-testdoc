*** Settings ***
Resource    ../common/common_ui.robot
Resource    ../../resources/pages/yves/yves_product_configurator_page.robot
Resource    ../../resources/pages/yves/yves_product_details_page.robot
Resource    ../../resources/pages/zed/zed_order_details_page.robot

*** Keywords ***
Yves: change the product options in configurator to:
    [Documentation]    fill the fields for product configuration (it is possible to set price OR option name).
    [Arguments]    @{args}
    ${configurationData}=    Set Up Keyword Arguments    @{args}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    Click    ${pdp_configure_button}
    FOR    ${key}    ${value}    IN    &{configurationData}
        ${key}=   Convert To Lower Case   ${key}
        IF    '${env}' in ['ui_suite']
            IF    '${key}'=='option one' and '${value}' != '${EMPTY}'   Click    xpath=//div[contains(@class, 'configurator')]//app-configurator-group/div[@class='group__heading'][h3='Option One']/following-sibling::div[@class='group__section']//label[contains(@class,'tile__inner')]/span[contains(text(), '${value}')]    
            IF    '${key}'=='option two' and '${value}' != '${EMPTY}'   Click    xpath=//div[contains(@class, 'configurator')]//app-configurator-group/div[@class='group__heading'][h3='Option Two']/following-sibling::div[@class='group__section']//label[contains(@class,'tile__inner')]/span[contains(text(), '${value}')]
        ELSE IF    '${env}' in ['ui_b2b','ui_mp_b2b']
            IF    '${key}'=='option one' and '${value}' != '${EMPTY}'   Click    xpath=//div[contains(@class, 'configurator')]//app-configurator-group/div[@class='group__heading'][h3='Adjustable shelves']/following-sibling::div[@class='group__section']//label[contains(@class,'tile__inner')]/span[contains(text(), '${value}')]    
            IF    '${key}'=='option two' and '${value}' != '${EMPTY}'   Click    xpath=//div[contains(@class, 'configurator')]//app-configurator-group/div[@class='group__heading'][h3='Lockers']/following-sibling::div[@class='group__section']//label[contains(@class,'tile__inner')]/span[contains(text(), '${value}')]
        ELSE
            IF    '${key}'=='option one' and '${value}' != '${EMPTY}'   Click    xpath=//div[contains(@class, 'configurator')]//app-configurator-group/div[@class='group__heading'][h3='Barebone']/following-sibling::div[@class='group__section']//label[contains(@class,'tile__inner')]/span[contains(text(), '${value}')]    
            IF    '${key}'=='option two' and '${value}' != '${EMPTY}'   Click    xpath=//div[contains(@class, 'configurator')]//app-configurator-group/div[@class='group__heading'][h3='Processor']/following-sibling::div[@class='group__section']//label[contains(@class,'tile__inner')]/span[contains(text(), '${value}')]
            IF    '${key}'=='option three' and '${value}' != '${EMPTY}'   Click    xpath=//div[contains(@class, 'configurator')]//app-configurator-group/div[@class='group__heading'][h3='GPU']/following-sibling::div[@class='group__section']//label[contains(@class,'tile__inner')]/span[contains(text(), '${value}')]    
            IF    '${key}'=='option four' and '${value}' != '${EMPTY}'   Click    xpath=//div[contains(@class, 'configurator')]//app-configurator-group/div[@class='group__heading'][h3='External Drive']/following-sibling::div[@class='group__section']//label[contains(@class,'tile__inner')]/span[contains(text(), '${value}')]
            IF    '${key}'=='option five' and '${value}' != '${EMPTY}'   Click    xpath=//div[contains(@class, 'configurator')]//app-configurator-group/div[@class='group__heading'][h3='Operating system']/following-sibling::div[@class='group__section']//label[contains(@class,'tile__inner')]/span[contains(text(), '${value}')]    
            IF    '${key}'=='option six' and '${value}' != '${EMPTY}'   Click    xpath=//div[contains(@class, 'configurator')]//app-configurator-group/div[@class='group__heading'][h3='W-LAN']/following-sibling::div[@class='group__section']//label[contains(@class,'tile__inner')]/span[contains(text(), '${value}')]        
            IF    '${key}'=='option seven' and '${value}' != '${EMPTY}'   Click    xpath=//div[contains(@class, 'configurator')]//app-configurator-group/div[@class='group__heading'][h3='Memory']/following-sibling::div[@class='group__section']//label[contains(@class,'tile__inner')]/span[contains(text(), '${value}')]    
            IF    '${key}'=='option eight' and '${value}' != '${EMPTY}'   Click    xpath=//div[contains(@class, 'configurator')]//app-configurator-group/div[@class='group__heading'][h3='SSD']/following-sibling::div[@class='group__section']//label[contains(@class,'tile__inner')]/span[contains(text(), '${value}')]          
            IF    '${key}'=='option nine' and '${value}' != '${EMPTY}'   Click    xpath=//div[contains(@class, 'configurator')]//app-configurator-group/div[@class='group__heading'][h3='Hard disk drive (HDD)']/following-sibling::div[@class='group__section']//label[contains(@class,'tile__inner')]/span[contains(text(), '${value}')]    
            IF    '${key}'=='option ten' and '${value}' != '${EMPTY}'   Click    xpath=//div[contains(@class, 'configurator')]//app-configurator-group/div[@class='group__heading'][h3='Keyboard']/following-sibling::div[@class='group__section']//label[contains(@class,'tile__inner')][contains(text(), '${value}')]              
        END 
   END
    ### sleep 1 seconds to process background event
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    Sleep    1s

Yves: change the product configuration to:
    [Documentation]    fill the fields for product configuration.
    [Arguments]    @{args}
    ${configurationData}=    Set Up Keyword Arguments    @{args}
    Click    ${pdp_configure_button}
    Wait Until Element Is Visible    ${configurator_date_input}
    FOR    ${key}    ${value}    IN    &{configurationData}
        IF    '${key}'=='date' and '${value}' != '${EMPTY}'   Type Text    ${configurator_date_input}    ${value}
            IF    '${key}'=='date' and '${value}' == '${EMPTY}'   Clear Text    ${configurator_date_input}
        IF    '${key}'=='date_time' and '${value}' != '${EMPTY}'   Select From List By Label    ${configurator_day_time_selector}    ${value}
    END
    Click    ${configurator_day_time_selector}
    ### sleep 1 seconds to process background event
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    Sleep    1s
    Click    ${configurator_save_button}
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    Wait Until Element Is Visible    ${pdp_configure_button}


Yves: save product configuration    
    Click    ${configurator_save_button}
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    Wait Until Element Is Visible    ${pdp_configure_button}

Yves: product configuration notification is:
    [Arguments]    ${expected_notification}
    Element Text Should Be    ${configurator_configuration_status}     ${expected_notification}

Yves: back to PDP and not save configuration    
    Click    ${configurator_back_button}
    Click    ${unsaved_product_configurations_leave_button} 

Yves: product configuration price should be:
    [Arguments]    ${expectedProductPrice}
        ${price_displayed}=    Run Keyword And Ignore Error    Page Should Contain Element    ${configurator_price_element_locator}    timeout=400ms
        ${actualProductPrice}=    Get Text    ${configurator_price_element_locator}
        ${result}=    Run Keyword And Ignore Error    Should Be Equal    ${expectedProductPrice}    ${actualProductPrice}

Yves: product configuration status should be equal:
    [Arguments]    ${expected_status}
    Element Text Should Be    ${pdp_configuration_status}    ${expected_status}

Yves: configuration should be equal:
    [Arguments]    @{args}
    ${configurationData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${pdp_configure_button}
    FOR    ${key}    ${value}    IN    &{configurationData}
        IF    '${env}' in ['ui_suite']
            IF    '${key}'=='option one' and '${value}' != '${EMPTY}'   Element Should Contain    ${pdp_configuration_option_one}[${env}]    ${value}
            IF    '${key}'=='option two' and '${value}' != '${EMPTY}'   Element Should Contain    ${pdp_configuration_option_two}[${env}]    ${value}
        ELSE
            IF    '${key}'=='option one' and '${value}' != '${EMPTY}'   Element Text Should Be    ${pdp_configuration_option_one}[${env}]    ${value}
            IF    '${key}'=='option two' and '${value}' != '${EMPTY}'   Element Text Should Be    ${pdp_configuration_option_two}[${env}]    ${value}
        END
    END

Yves: configuration for concrete product should be equal:
    [Arguments]    @{args}    ${concrete_sku}
    ${configurationData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${pdp_configure_button}
    FOR    ${key}    ${value}    IN    &{configurationData}
        IF    '${env}' in ['ui_suite']
            IF    '${key}'=='option one' and '${value}' != '${EMPTY}'   Element Should Contain    ${pdp_configuration_option_one}[${env}]    ${value}
            IF    '${key}'=='option two' and '${value}' != '${EMPTY}'   Element Should Contain    ${pdp_configuration_option_two}[${env}]    ${value}
        ELSE
            IF    '${key}'=='option one' and '${value}' != '${EMPTY}'   Element Text Should Be    ${pdp_configuration_option_one}[${env}]    ${value}
            IF    '${key}'=='option two' and '${value}' != '${EMPTY}'   Element Text Should Be    ${pdp_configuration_option_two} [${env}]    ${value}
        END
    END

Yves: check and go back that configuration page contains:
    [Arguments]    @{args}
    ${configuratorData}=    Set Up Keyword Arguments    @{args}
    Wait Until Element Is Visible    ${pdp_configure_button}
    Click    ${pdp_configure_button}
    FOR    ${key}    ${value}    IN    &{configuratorData}
        IF    '${key}'=='store' and '${value}' != '${EMPTY}'   Element Should Contain    ${configurator_store}    ${value}
        IF    '${key}'=='locale' and '${value}' != '${EMPTY}'   Element Should Contain    ${configurator_locale}    ${value}
        IF    '${key}'=='price_mode' and '${value}' != '${EMPTY}'   Element Should Contain    ${configurator_price_mode}    ${value}
        IF    '${key}'=='currency' and '${value}' != '${EMPTY}'   Element Should Contain    ${configurator_currency}    ${value}
        IF    '${key}'=='sku' and '${value}' != '${EMPTY}'   Element Should Contain    ${configurator_sku}    ${value}
    END
    Click    ${configurator_back_button}
    Wait Until Element Is Visible    ${pdp_configure_button}


Zed: product configuration should be equal:
    [Arguments]    @{args}
    ${configurationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{configurationData}
        IF    '${key}'=='shipment' and '${value}' != '${EMPTY}'   
            ${shipment}=    Set Variable    ${shipment}
        ELSE IF    '${key}'=='shipment' and '${value}' == '${EMPTY}'
            ${shipment}=    Set Variable    1
        END
        IF    '${key}'=='sku' and '${value}' != '${EMPTY}'   
            ${sku}=    Set Variable    ${value}
        END
        IF    '${key}'=='position' and '${value}' != '${EMPTY}'
            ${position}=    Set Variable    ${value}
        ELSE IF    '${key}'=='position' and '${value}' == '${EMPTY}'
            ${position}=    Set Variable    1
        END
        IF    '${key}'=='date' and '${value}' != '${EMPTY}'    Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//tr[${position}]/td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr//td//*[contains(@class,'sku')]/../div[last()]    ${value}
        IF    '${key}'=='date_time' and '${value}' != '${EMPTY}'    
            IF    '${env}' in ['ui_b2b','ui_mp_b2b']
                Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//tr[${position}]/td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr//td//*[contains(@class,'sku')]/../div[3]    ${value}
            ELSE
                Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//tr[${position}]/td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr//td//*[contains(@class,'sku')]/../div[4]    ${value}
            END
        END
    END

Zed: new product configuration should be equal:
    [Arguments]    @{args}
    ${configurationData}=    Set Up Keyword Arguments    @{args}
    FOR    ${key}    ${value}    IN    &{configurationData}
        IF    '${key}'=='shipment' and '${value}' != '${EMPTY}'   
            ${shipment}=    Set Variable    ${shipment}
        ELSE IF    '${key}'=='shipment' and '${value}' == '${EMPTY}'
            ${shipment}=    Set Variable    1
        END
        IF    '${key}'=='sku' and '${value}' != '${EMPTY}'   
            ${sku}=    Set Variable    ${value}
        END
        IF    '${key}'=='position' and '${value}' != '${EMPTY}'
            ${position}=    Set Variable    ${value}
        ELSE IF    '${key}'=='position' and '${value}' == '${EMPTY}'
            ${position}=    Set Variable    1
        END
        IF    '${key}'=='Option One:' and '${value}' != '${EMPTY}'    Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//tr[${position}]/td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr//td//*[contains(@class,'sku')]/../div[last()]    ${value}
        IF    '${key}'=='Option Two:' and '${value}' != '${EMPTY}'    
            IF    '${env}' in ['ui_b2b','ui_mp_b2b']
                Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//tr[${position}]/td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr//td//*[contains(@class,'sku')]/../div[3]    ${value}
            ELSE
                Element Should Contain    xpath=//table[@data-qa='order-item-list'][${shipment}]/tbody//tr[${position}]/td//div[@class='sku'][contains(text(),'${sku}')]/ancestor::tr//td//*[contains(@class,'sku')]/../div[4]    ${value}
            END
        END
    END    