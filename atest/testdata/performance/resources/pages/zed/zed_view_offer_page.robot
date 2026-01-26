*** Variables ***
${zed_view_offer_page_main_content_locator}    xpath=//a[contains(@class,'btn-view')][@href='/product-offer-gui/list']
${zed_view_offer_approval_status}    xpath=(//div[@class='ibox-content']/div[contains(@class,'row')])[2]/div[2]/span
${zed_view_offer_status}    xpath=(//div[@class='ibox-content']/div[contains(@class,'row')])[3]/div[2]/span
${zed_view_offer_store}    xpath=(//div[@class='ibox-content']/div[contains(@class,'row')])[4]/div[2]/span
${zed_view_offer_sku}    xpath=(//div[@class='ibox-content']/div[contains(@class,'row')])[5]/div[2]/a
${zed_view_offer_name}    xpath=(//div[@class='ibox-content']/div[contains(@class,'row')])[7]/div[2]
${zed_view_offer_merchant}    xpath=(//div[@class='ibox-content']/div[contains(@class,'row')])[11]/div[2]/a
${zed_view_offer_merchant_sku}    xpath=(//div[@class='ibox-content']/div[contains(@class,'row')])[12]/div[2]
${zed_view_offer_services}    xpath=(//div[@class='ibox-content']/div[contains(@class,'row')])[15]/div
${zed_view_offer_shipment_types}    xpath=(//div[@class='ibox-content']/div[contains(@class,'row')])[16]/div