*** Settings ***
Resource    ../common/common_yves.robot
Resource    ../common/common.robot
Resource    ../steps/customer_account_steps.robot
Resource    ../pages/zed/zed_order_details_page.robot
Resource    ../pages/yves/yves_order_details_page.robot
Resource    ../pages/yves/yves_shopping_cart_page.robot
Resource    ../common/common_zed.robot
Resource    order_history_steps.robot

*** Keywords ***
Yves: add comment on cart:
    [Arguments]    ${comment}
    Click With Options    ${shopping_cart_write_comment_placeholder}    delay=0.5s    force=true
    Type Text    ${shopping_cart_write_comment_placeholder}    ${comment}    delay=50ms
    Keyboard Key    press    Enter
    Click    ${shopping_cart_add_comment_button}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END

Yves: check comments are visible or not in cart:
    [Arguments]    ${condition}    @{comments}    
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    FOR    ${element}    IN    @{comments}
        IF    '${env}' in ['ui_suite']
            IF    '${condition}' == 'true'    Page Should Contain Element    xpath=(//comment-form[@data-qa='component comment-form']//*[contains(text(),'${element}')])[1]    message=Comment '${element}' is not visible in the shopping cart but should    timeout=${browser_timeout}
            IF    '${condition}' == 'false'    Page Should Not Contain Element    xpath=(//comment-form[@data-qa='component comment-form']//*[contains(text(),'${element}')])[1]    message=Comment '${element}' is visible in the shopping cart but should not    timeout=${browser_timeout}
        ELSE
            IF    '${condition}' == 'true'    Page Should Contain Element    xpath=(//comment-form[@data-qa='component comment-form']//p[contains(text(),'${element}')])[1]    message=Comment '${element}' is not visible in the shopping cart but should    timeout=${browser_timeout}
            IF    '${condition}' == 'false'    Page Should Not Contain Element    xpath=(//comment-form[@data-qa='component comment-form']//p[contains(text(),'${element}')])[1]    message=Comment '${element}' is visible in the shopping cart but should not    timeout=${browser_timeout}
        END
    END

Yves: check comments is visible or not in order:
    [Arguments]    ${condition}    @{comments}    
    FOR    ${element}    IN    @{comments}
        IF    '${env}' in ['ui_suite']
            IF    '${condition}' == 'true'    Element Should Be Visible    xpath=(//comment-thread-list//comment-form[@data-qa='component comment-form']//textarea[contains(text(),'${element}')])[1]    message=Comment '${element}' is not visible in BO:order details page but should
            IF    '${condition}' == 'false'    Element Should Not Be Visible    xpath=(//comment-thread-list//comment-form[@data-qa='component comment-form']//textarea[contains(text(),'${element}')])[1]   message=Comment '${element}' is visible in BO:order details page but should not
        ELSE
            IF    '${condition}' == 'true'    Element Should Be Visible    xpath=(//comment-form[@data-qa='component comment-form']//p[contains(text(),'${element}')])[1]    message=Comment '${element}' is not visible in BO:order details page but should
            IF    '${condition}' == 'false'    Element Should Not Be Visible    xpath=(//div[contains(@class,"comment-form__readonly")]/p[contains(text(),'${element}')])[1]   message=Comment '${element}' is visible in BO:order details page but should not
        END
    END

Yves: go to order details page to check comment:
    [Arguments]    ${comment}    ${lastPlacedOrder}
    Yves: go to 'Order History' page
    Yves: 'View Order/Reorder/Return' on the order history page:    View Order    ${lastPlacedOrder}
    ${text_entered}    Get Text    ${yves_order_details_page_comments}
    IF    '${text_entered}' == '${comment}'
        Log    text entered in comments appears in order details page in Yves
    ELSE
        Fail    comments not added successfully to order details page in Yves
    END    

Zed: check comment appears at order detailed page in zed:
    [Arguments]    ${comment}    ${lastPlacedOrder}
    Zed: go to URL:    /sales
    Zed: click Action Button in a table for row that contains:    ${lastPlacedOrder}    View 
    Wait Until Element Is Visible    ${zed_order_details_page_comments}
    ${text_entered}    Get Text    ${zed_order_details_page_comments}
       IF    '${text_entered}' == '${comment}'
            Log    comments added to cart appears in order details page in zed
       ELSE
            Fail    comments added to cart does not appears in order details page in zed
       END

Yves: edit comment on cart:
    [Arguments]    ${comment_to_set}
    Reload
    TRY    
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END
    IF    '${env}' not in ['ui_suite']    Click    ${shopping_cart_edit_comment_button}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    Fill Text    ${shopping_cart_edit_comment_placeholder}    ${EMPTY}    force=true
    Fill Text    ${shopping_cart_edit_comment_placeholder}    ${comment_to_set}    force=true
    Click    ${shopping_cart_update_comment_button}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END

Yves: delete comment on cart
    Click    ${shopping_cart_remove_comment_button}
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END
    Page Should Not Contain Element    ${shopping_cart_remove_comment_button}

Yves: add comment on order in order detail page:
    [Arguments]    ${comment}
    Click With Options    ${order_details_page_add_comments_textbox}    delay=0.5s
    Type Text    ${order_details_page_add_comments_textbox}    ${comment}    delay=50ms
    Click With Options    ${add_comment_button_order_details_page}    delay=0.5s
    TRY
        Repeat Keyword    3    Wait For Load State
        Wait For Load State    domcontentloaded
    EXCEPT
        Log    Page is not loaded
    END