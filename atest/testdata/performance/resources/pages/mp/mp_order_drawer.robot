*** Variables ***
${order_grand_total}    xpath=//web-spy-card[@spy-title='Totals']//div[text()='Grand Total']/following-sibling::div
${order_state_label_on_drawer}    xpath=//div[@class='mp-manage-order__states-col']//div[@class='mp-manage-order__states']