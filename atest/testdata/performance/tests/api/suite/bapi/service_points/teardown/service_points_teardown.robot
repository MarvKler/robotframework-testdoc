*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/api_service_point_steps.robot
Test Tags    bapi    spryker-core    spryker-core-back-office    service-points    shipment-service-points    product-offer-service-points    service-points-cart    product-offer-service-points-availability    marketplace-merchant-product-offer-service-points-availability    shipment-product-offer-service-points-availability    marketplace-merchant-portal-product-offer-service-points    inventory-management    marketplace-inventory-management 

*** Test Cases ***
Delete_all_non-default_service_points_from_DB_with_p&s
    Delete all non-default service points from DB with p&s