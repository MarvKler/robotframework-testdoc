*** Settings ***
Resource    ../pages/zed/zed_customer_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot
Resource    ../pages/zed/zed_dashboard_page.robot

*** Keywords ***
Zed: check the charts and graphs present on dashboard
    Page Should Contain Element    ${dashboard_count_orders_graph}
    Page Should Contain Element    ${dashboard_orders_by_status_graph}
    Page Should Contain Element    ${dashboard_top_orders_graph}