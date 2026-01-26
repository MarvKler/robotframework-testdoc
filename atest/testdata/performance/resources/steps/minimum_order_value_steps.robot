*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_zed.robot
Resource    ../../resources/pages/zed/zed_edit_global_threshold_page.robot
Resource    ../../resources/pages/yves/yves_shopping_cart_page.robot
Resource    ../../resources/pages/yves/yves_checkout_summary_page.robot
Resource    ../common/common_yves.robot
Resource    ../../resources/steps/checkout_steps.robot


*** Keywords ***
Zed: change global threshold settings:
    [Arguments]    @{args}
    ${thresholdData}=    Set Up Keyword Arguments    @{args}
    Zed: go to URL:    /sales-order-threshold-gui/global
    Wait Until Element Is Visible    ${zed_global_threshold_store_currency_span}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT    
        Log    Page is not loaded
    END
    FOR    ${key}    ${value}    IN    &{thresholdData}
        IF    '${key}'=='store & currency' and '${value}' != '${EMPTY}'    
            Select From List By Label    ${zed_global_threshold_store_currency_select}    ${value}
            ${second_local_minimum_hard_section_expanded}=    Run Keyword And Return Status    Page Should Not Contain Element    ${zed_global_threshold_minimum_hard_second_locale_collapce_section}    timeout=500ms
            IF    '${second_local_minimum_hard_section_expanded}'=='False'
                Scroll Element Into View    ${zed_global_threshold_minimum_hard_second_locale_collapce_section}
                Click    ${zed_global_threshold_minimum_hard_second_locale_collapce_section}
            END
            ${second_local_maximum_hard_section_expanded}=    Run Keyword And Return Status    Page Should Not Contain Element    ${zed_global_threshold_maximum_hard_second_locale_collapce_section}    timeout=500ms
            IF    '${second_local_maximum_hard_section_expanded}'=='False'
                Scroll Element Into View    ${zed_global_threshold_maximum_hard_second_locale_collapce_section}
                Click    ${zed_global_threshold_maximum_hard_second_locale_collapce_section}
            END
            ${second_local_soft_section_expanded}=    Run Keyword And Return Status    Page Should Not Contain Element    ${zed_global_threshold_soft_second_locale_collapce_section}    timeout=500ms
            IF    '${second_local_soft_section_expanded}'=='False'
                Scroll Element Into View    ${zed_global_threshold_soft_second_locale_collapce_section}
                Click    ${zed_global_threshold_soft_second_locale_collapce_section}
            END
        END
        IF    '${key}'=='store & currency' and '${value}' == '${EMPTY}'    
            ${second_local_minimum_hard_section_expanded}=    Run Keyword And Return Status    Page Should Not Contain Element    ${zed_global_threshold_minimum_hard_second_locale_collapce_section}    timeout=500ms
            IF    '${second_local_minimum_hard_section_expanded}'=='False'
                Scroll Element Into View    ${zed_global_threshold_minimum_hard_second_locale_collapce_section}
                Click    ${zed_global_threshold_minimum_hard_second_locale_collapce_section}
            END
            ${second_local_maximum_hard_section_expanded}=    Run Keyword And Return Status    Page Should Not Contain Element    ${zed_global_threshold_maximum_hard_second_locale_collapce_section}    timeout=500ms
            IF    '${second_local_maximum_hard_section_expanded}'=='False'
                Scroll Element Into View    ${zed_global_threshold_maximum_hard_second_locale_collapce_section}
                Click    ${zed_global_threshold_maximum_hard_second_locale_collapce_section}
            END
            ${second_local_soft_section_expanded}=    Run Keyword And Return Status    Page Should Not Contain Element    ${zed_global_threshold_soft_second_locale_collapce_section}    timeout=500ms
            IF    '${second_local_soft_section_expanded}'=='False'
                Scroll Element Into View    ${zed_global_threshold_soft_second_locale_collapce_section}
                Click    ${zed_global_threshold_soft_second_locale_collapce_section}
            END
        END
        IF    '${key}'=='minimum hard value' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_minimum_hard_value_input}    ${value}
        IF    '${key}'=='minimum hard en message' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_minimum_hard_en_message_input}    ${value}
        IF    '${key}'=='minimum hard de message' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_minimum_hard_de_message_input}    ${value}
        IF    '${key}'=='maximum hard value' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_maximum_hard_value_input}    ${value}
        IF    '${key}'=='maximum hard en message' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_maximum_hard_en_message_input}    ${value}
        IF    '${key}'=='maximum hard de message' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_maximum_hard_de_message_input}    ${value}
        IF    '${key}'=='soft threshold' and '${value}' != '${EMPTY}'    Click    xpath=//input[contains(@name,'global-threshold[softThreshold][strategy]')]/../../label[contains(.,'${value}')]
        IF    '${key}'=='soft threshold value' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_soft_value_input}    ${value}
        IF    '${key}'=='soft threshold en message' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_soft_en_message_input}    ${value}
        IF    '${key}'=='soft threshold de message' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_soft_de_message_input}    ${value}
        IF    '${key}'=='soft threshold fixed fee' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_soft_fixed_fee_value_input}    ${value}
        IF    '${key}'=='soft threshold flexible fee' and '${value}' != '${EMPTY}'    Type Text    ${zed_global_threshold_soft_flexible_fee_value_input}    ${value}
    END     
    Zed: submit the form
    Zed: flash message should be shown:    success

Yves: soft threshold surcharge is added in the cart:
    [Arguments]    ${expectedSurchargeAmount}
    Wait Until Element Is Visible    ${shopping_cart_surcharge_amount}[${env}]
    Scroll Element Into View    ${shopping_cart_surcharge_amount}[${env}]
    ${actualSurchargeAmount}=    Get Text    ${shopping_cart_surcharge_amount}[${env}]
    Should Be Equal    ${actualSurchargeAmount}    ${expectedSurchargeAmount}  

Yves: soft threshold surcharge is added on summary page:
    [Arguments]    ${expectedSurchargeAmount}
    Wait Until Element Is Visible    ${checkout_summary_surcharge_amount}[${env}]
    Scroll Element Into View    ${checkout_summary_surcharge_amount}[${env}]
    ${actualSurchargeAmount}=    Get Text    ${checkout_summary_surcharge_amount}[${env}]
    Should Be Equal    ${actualSurchargeAmount}    ${expectedSurchargeAmount}  

Yves: hard threshold is applied with the following message:
    [Arguments]    ${expectedMessage}
    TRY
        Element Should Be Visible    ${checkout_summary_alert_message}[${env}]
        Page Should Not Contain Element    ${checkout_summary_submit_order_button}
        ${actualAlertMessage}=    Get Text    ${checkout_summary_alert_message}[${env}]
        Should Contain    ${actualAlertMessage}    ${expectedMessage}
    EXCEPT    
        Yves: accept the terms and conditions:    true
        Click    ${checkout_summary_submit_order_button}
        Yves: flash message should be shown:    error    ${expectedMessage}
    END


