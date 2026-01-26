*** Variables ***
${store_status_checkbox}    xpath=//web-spy-checkbox[contains(@spy-id,'onlineProfileMerchant')][contains(@spy-id,'is_active')]
${merchant_profile_name_field}    id=merchantProfile_businessInfoMerchantProfile_name
${merchant_profile_email_field}    id=merchantProfile_onlineProfileMerchantProfile_public_email
${merchant_profile_phone_field}    id=merchantProfile_onlineProfileMerchantProfile_public_phone
${merchant_profile_delivery_time_en_field}    xpath=//web-spy-card[@spy-title='Average Delivery Time']//web-spy-collapsible[@spy-title='en_US']//input
${merchant_profile_data_privacy_en_field}    xpath=//web-spy-card[@spy-title='Data Privacy']//web-spy-collapsible[@spy-title='en_US']//textarea
${merchant_profile_store_profile_url_en_field}    id=merchantProfile_onlineProfileMerchantProfile_urlCollection_0_url
${merchant_profile_store_profile_url_de_field}    id=merchantProfile_onlineProfileMerchantProfile_urlCollection_1_url