*** Variables ***
${bundle_configurator_main_content_locator}    xpath=//*[@data-qa='component configurator-sidebar']
${bundle_configurator_summary_step}    xpath=//form[@name='configurator_state_form']//button[contains(.,'Summary')]
${bundle_configurator_add_to_cart_button}    xpath=//form[@name='configurator_state_form'][contains(@action,'add-to-cart')]/button