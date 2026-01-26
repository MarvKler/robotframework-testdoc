*** Variables ***
${agent_assist_overview_link}    xpath=//div[@data-qa='component agent-control-item']//a[contains(@href,'agent/overview')]
${agent_assist_menu_overview}    xpath=//*[contains(@data-qa,'agent-navigation')]//*[contains(text(),'Overview')]
${agent_assist_menu_quote_request}    xpath=//li[@data-qa='component navigation-sidebar-item']//div[contains(text(),'Quote Requests')]
${end_customer_assistance}    xpath=//a[contains(@href,'switch_user')]
${agent_logout}    xpath=//a[contains(@href,'agent/logout')]