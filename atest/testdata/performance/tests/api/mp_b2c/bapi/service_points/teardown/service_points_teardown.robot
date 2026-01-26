*** Settings ***
Suite Setup       API_suite_setup
Test Setup        API_test_setup
Resource    ../../../../../../resources/common/common_api.robot
Resource    ../../../../../../resources/steps/api_service_point_steps.robot

*** Test Cases ***
Delete_all_non-default_service_points_from_DB_with_p&s
    Delete all non-default service points from DB with p&s