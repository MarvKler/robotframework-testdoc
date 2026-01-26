*** Settings ***
Resource    ../common/common.robot
Resource    ../common/common_yves.robot
Resource    ../pages/yves/yves_bundle_configurator_page.robot

*** Keywords ***
Yves: choose bundle template to configure:
    [Arguments]    ${bundleTemplate}
    Click    xpath=//div[@data-qa='component template-list']//*[@class='template-list__item-name'][text()='${bundleTemplate}']/ancestor::a
    Wait Until Element Is Visible    ${bundle_configurator_main_content_locator}

Yves: select product in the bundle slot:
    [Arguments]    ${slot}    ${sku}
    Click    xpath=//form[@name='configurator_state_form']//button[contains(.,'${slot}')]
    IF    '${env}' in ['ui_b2b','ui_mp_b2b']
        Click    xpath=//product-item-list[@data-qa='component configurator-product']//span[@class='configurator-product__sku'][text()='Sku: ${sku}']/ancestor::product-item-list//button
    ELSE IF    '${env}' in ['ui_b2c','ui_mp_b2c']    
        Click    xpath=(//product-item-list[@data-qa='component configurator-product']//span[contains(text(),'${sku}')]/ancestor::product-item-list//button)[1]
    ELSE
        Click    xpath=//product-item//*[@itemprop='sku'][contains(text(),'${sku}')]/ancestor::product-item//button
    END

Yves: go to 'Summary' step in the bundle configurator
    Click    ${bundle_configurator_summary_step}

Yves: add products to the shopping cart in the bundle configurator
    Wait Until Element Is Visible    ${bundle_configurator_add_to_cart_button}
    Click    ${bundle_configurator_add_to_cart_button}
    Yves: remove flash messages