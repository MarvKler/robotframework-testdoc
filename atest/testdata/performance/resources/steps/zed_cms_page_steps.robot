*** Settings ***
Resource    ../pages/zed/zed_cms_page_page.robot
Resource    ../common/common_zed.robot
Resource    ../common/common.robot

*** Keywords ***
Zed: create a cms page and publish it:
    [Arguments]    ${enName}    ${enURL}    ${enTitlePlaceholder}    ${enContentPlaceholder}
    ${currentURL}=    Get Location
    IF    'list-page' not in '${currentURL}'    Zed: go to URL:    /cms-gui/list-page
    Click    ${zed_new_cms_page_create_button}
    ### General page information input
    Page Should Contain Element    xpath=//body//*[contains(text(),'Create CMS Page')]    message=Page for CMS creation is not opened
    Element Should Be Visible    ${zed_cms_page_general_first_locale_name_field}    message=First locale section of CMS page is not open
    Scroll Element Into View    ${zed_cms_page_general_second_locale_collapsed_section}
    Set Browser Timeout    5s
    TRY
        Click    ${zed_cms_page_general_second_locale_collapsed_section}
    EXCEPT    
        Log    Second locale section of CMS is already open
    END
    Set Browser Timeout    ${browser_timeout}
    Disable Automatic Screenshots on Failure
    ${second_locale_section_expanded}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${zed_cms_page_general_second_locale_name_field}    message=DE section of CMS page is not open    timeout=3s
    Restore Automatic Screenshots on Failure
    IF    '${second_locale_section_expanded}'=='False'
        Scroll Element Into View    ${zed_cms_page_general_second_locale_collapsed_section}
        Click    ${zed_cms_page_general_second_locale_collapsed_section}
    END
    Wait Until Element Is Visible    ${zed_cms_page_general_second_locale_name_field}    message=Second locale section of CMS page is not open
    Check checkbox    ${zed_cms_page_general_is_searchable_checkbox}
    Type Text    ${zed_cms_page_general_first_locale_name_field}    ${enName}    delay=50ms
    Type Text    ${zed_cms_page_general_first_locale_url_field}    ${enURL}    delay=50ms
    Type Text    ${zed_cms_page_general_second_locale_name_field}    ${enName}    delay=50ms
    Type Text    ${zed_cms_page_general_second_locale_url_field}    ${enURL}    delay=50ms
    Sleep    0.5s
    Click    ${zed_cms_page_save_button}
    TRY
        Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is already loaded
    END
    ### Placeholder information input
    Disable Automatic Screenshots on Failure
    ${page_was_created}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//body//*[contains(text(),'Edit Placeholders: ${enName}')]
    Restore Automatic Screenshots on Failure
    IF    '${page_was_created}'=='False'    Click    ${zed_cms_page_save_button}
    TRY    
        Page Should Contain Element    xpath=//body//*[contains(text(),'Edit Placeholders: ${enName}')]    message=CMS page was not created
    EXCEPT
        Click    ${zed_cms_page_save_button}
        TRY
            Wait For Load State
            Wait For Load State    domcontentloaded
        EXCEPT
            Log    Page is already loaded
        END
        Page Should Contain Element    xpath=//body//*[contains(text(),'Edit Placeholders: ${enName}')]    message=CMS page was not created    timeout=10s
    END
    Scroll Element Into View    ${zed_cms_page_content_second_locale_title_collapsed_section}
    Click    ${zed_cms_page_content_second_locale_title_collapsed_section}
    Disable Automatic Screenshots on Failure
    ${second_locale_section_expanded}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${zed_cms_page_placeholder_title_deDE_field}    message=DE section of CMS page is not open    timeout=3s
    Restore Automatic Screenshots on Failure
    IF    '${second_locale_section_expanded}'=='False'
        Scroll Element Into View    ${zed_cms_page_content_second_locale_title_collapsed_section}
        Click    ${zed_cms_page_content_second_locale_title_collapsed_section}
    END
    Wait Until Element Is Visible    ${zed_cms_page_placeholder_title_deDE_field}    message=DE section of Title tab is not open
    Clear Text    ${zed_cms_page_placeholder_title_enUS_field}
    Type Text    ${zed_cms_page_placeholder_title_enUS_field}    ${enTitlePlaceholder}    delay=50ms
    Clear Text    ${zed_cms_page_placeholder_title_deDE_field}
    Type Text    ${zed_cms_page_placeholder_title_deDE_field}    ${enTitlePlaceholder}    delay=50ms
    Zed: go to tab by link href that contains:    content-content
    Page Should Contain Element    ${zed_cms_page_placeholder_content_enUS_field}    message=EN section of Content tab is not visible
    Scroll Element Into View    ${zed_cms_page_content_second_locale_content_collapsed_section}
    Click    ${zed_cms_page_content_second_locale_content_collapsed_section}
    Disable Automatic Screenshots on Failure
    ${second_locale_section_expanded}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${zed_cms_page_placeholder_content_deDE_field}    message=DE section of CMS page is not open    timeout=3s
    Restore Automatic Screenshots on Failure
    IF    '${second_locale_section_expanded}'=='False'
        Scroll Element Into View    ${zed_cms_page_content_second_locale_content_collapsed_section}
        Click    ${zed_cms_page_content_second_locale_content_collapsed_section}
    END
    Clear Text    ${zed_cms_page_placeholder_content_enUS_field}
    Type Text    ${zed_cms_page_placeholder_content_enUS_field}    ${enContentPlaceholder}    delay=50ms
    Clear Text    ${zed_cms_page_placeholder_content_deDE_field}
    Type Text    ${zed_cms_page_placeholder_content_deDE_field}    ${enContentPlaceholder}    delay=50ms
    Sleep    0.5s
    ### Save and publish
    Click    ${zed_cms_page_save_button}
    Zed: message should be shown:    Placeholder translations successfully updated.
    Click    ${zed_cms_page_publish_button}
    Zed: message should be shown:    successfully published
    ### Check the CMS page in Zed table
    Zed: go to URL:    /cms-gui/list-page
    Zed: perform search by:    ${enName}
    Page Should Contain Element    xpath=//td[contains(@class,'name') and contains(text(),'${enName}')]/following-sibling::td[contains(@class,'status')]//span[contains(@class,'label') and contains(text(),'Active')]    message=CMS page is not found or not activated
    Trigger multistore p&s

Zed: update cms page and publish it:
    [Arguments]    @{args}
    ${cmsPageData}=    Set Up Keyword Arguments    @{args}
    Zed: go to URL:    /cms-gui/list-page
    Zed: click Action Button in a table for row that contains:     ${cmsPage}     Edit
    Set Browser Timeout    5s
    TRY
        Click    xpath=(//a[contains(@href,'edit-page')])[2]
    EXCEPT    
        Set Browser Timeout    ${browser_timeout}
        Click    xpath=(//a[contains(@href,'edit-page')])[1]
    END
    Set Browser Timeout    ${browser_timeout}
    Wait Until Element Is Visible    ${zed_cms_page_general_is_searchable_checkbox}
    FOR    ${key}    ${value}    IN    &{cmsPageData}
        IF    '${key}'=='unselect store' and '${value}' != '${EMPTY}'    
            Zed: Uncheck Checkbox by Label:    ${value}
        END
    END
    Click    ${zed_cms_page_save_button}
    Click    ${zed_cms_page_publish_button}
    Zed: message should be shown:    successfully published
    Trigger multistore p&s