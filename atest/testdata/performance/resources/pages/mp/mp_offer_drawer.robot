*** Variables ***
${offer_active_checkbox}    xpath=//web-spy-checkbox[@spy-id='productOffer_isActive']//span[@class='ant-checkbox-inner']
${offer_merchant_sku}    id=productOffer_merchantSku
${stores_list_selector}    xpath=//web-spy-select[@spy-id='productOffer_stores']//nz-select
${offer_stock_input}    xpath=//web-spy-input[@spy-id='productOffer_productOfferStocks_quantity']//input
${offer_saved_popup}    xpath=//spy-notification-view//span[contains(@class,'success')]
${offer_always_in_stock_checkbox}    xpath=//web-spy-checkbox[contains(@name,'Stock')]/label/span[contains(@class,'checkbox')]
${offer_service_point_selector}    xpath=//web-spy-select[@spy-id='productOffer_idServicePoint']//nz-select
${offer_service_point_search_field}    xpath=//web-spy-select[@spy-id='productOffer_idServicePoint']//nz-select//input
${offer_services_selector}    xpath=//web-spy-select[@spy-id='productOffer_services']//nz-select
${offer_shipment_types_selector}    xpath=//web-spy-select[@spy-id='productOffer_shipmentTypes']//nz-select