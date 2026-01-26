*** Settings ***
Resource    ../pages/yves/yves_catalog_page.robot
Resource    ../common/common_yves.robot
Resource    ../common/common.robot

*** Keywords ***
Yves: 'Catalog' page should show products:
    [Arguments]    ${productsCount}
    Wait Until Element Is Visible    ${catalog_products_counter_locator}[${env}]
    Element Should Contain    ${catalog_products_counter_locator}[${env}]    ${productsCount}

Yves: product with name in the catalog should have price:
    [Arguments]    ${productName}    ${expectedProductPrice}
    IF    '${env}' in ['ui_suite']
        ${actualProductPrice}=    Get Text    xpath=(//product-item[@data-qa='component product-item'])[1]//a[contains(@class,'name')][contains(.,'${productName}')]/ancestor::product-item//*[@itemprop='price'][contains(@class,'default-price')]
    ELSE
        ${actualProductPrice}=    Get Text    xpath=//product-item[@data-qa='component product-item']//*[contains(@class,'product-item__name')][contains(text(),'${productName}')]/ancestor::product-item//*[@data-qa='component money-price']/*[contains(@class,'money-price__amount')][contains(@class,'default')]
    END
    ${actualProductPrice}=    Remove String    ${actualProductPrice}    ${SPACE}
    Should Be Equal    ${actualProductPrice}    ${expectedProductPrice}    message=Actual product price is '${actualProductPrice}' but expected to have '${expectedProductPrice}'

Yves: page contains CMS element:
    [Documentation]    Arguments are ${type}    ${title}, ${type} can be: CMS Block, Banner, Product Slider, Homepage Banners, Homepage Inspirational Block, Homepage Banner Video, Footer section, CMS Page Title, CMS Page Content
    [Arguments]    ${type}    ${text}=
    IF    '${type}'=='banner'
        Element Should Be Visible    xpath=//*[contains(@class,'headline--category') and contains(text(),'${text}')]
    ELSE IF    '${type}'=='Product slider'
        Element Should Be Visible    xpath=//*[contains(@class,'catalog-cms-block')]//*[contains(@class,'title') and contains(text(),'${text}')]
    ELSE IF    '${type}'=='Homepage Banners'
        Element Should Be Visible    xpath=//div[contains(@class,'slick-carousel__container js-slick-carousel__container slick-initialized slick-slider slick-dotted')]
    ELSE IF    '${type}'=='Homepage Inspirational Block'
        Element Should Be Visible    xpath=//*[contains(@class,'multi-inspirational-block__title')]
    ELSE IF    '${type}'=='Homepage Banner Video'
        Element Should Be Visible    xpath=//*[contains(@class,'image-banner__video')]
    ELSE IF    '${type}'=='Footer section'
        Element Should Be Visible    xpath=//*[@class='footer']
    ELSE IF    '${type}'=='CMS Page Title'
        IF    '${env}' in ['ui_suite']
            Element Should Be Visible    xpath=//*[contains(@data-qa,'breadcrumb')]/ancestor::div[1]//p[contains(.,'${text}')]
        ELSE
            Element Should Be Visible    xpath=//*[contains(@class,'cms-page')][contains(@class,'title')]//*[contains(text(),'${text}')]
        END
    ELSE IF    '${type}'=='CMS Page Content' and '${env}' in ['ui_b2c','ui_mp_b2c']
        Element Should Be Visible    xpath=//*[contains(@class,'cms-page__content')]//*[contains(text(),'${text}')]
    ELSE IF    '${type}'=='CMS Page Content' and '${env}' in ['ui_b2b','ui_mp_b2b']
        Element Should Be Visible    xpath=//main[contains(@class,'cms-page')]//*[contains(text(),'${text}')]
    ELSE IF    '${type}'=='CMS Page Content' and '${env}' in ['ui_suite']
        Element Should Be Visible    xpath=//main//p[contains(.,'${text}')]
    ELSE IF    '${type}'=='CMS Block'
        Element Should Be Visible    xpath=//div[contains(@class,'catalog-cms-block')]//*[.="${text}"]
    END

Yves: change sorting order on catalog page:
    [Arguments]    ${sortingOption}
    IF    '${env}' in ['ui_suite']
        Select From List By Label    ${catalog_sorting_selector}    ${sortingOption}
        Click    ${catalog_apply_sorting_button}
    ELSE
        Click    xpath=//span[contains(@id,'select2-sort')]
        Wait Until Element Is Visible    xpath=//ul[contains(@role,'listbox')]//li[contains(@id,'select2-sort') and contains(text(),'${sortingOption}')]
        Click    xpath=//ul[contains(@role,'listbox')]//li[contains(@id,'select2-sort') and contains(text(),'${sortingOption}')]
        TRY
            Repeat Keyword    3    Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
    END

Yves: 1st product card in catalog (not)contains:
    [Documentation]    ${elementName} can be: Price, Name, Add to Cart, Color selector, Sale label, New label
    [Arguments]    ${elementName}    ${value}
    ${value}=    Convert To Lower Case    ${value}
    IF    '${elementName}'=='Price' and '${value}'=='true'
        Element Should Be Visible    xpath=//product-item[@data-qa='component product-item'][1]//span[contains(@class,'default-price') and contains(.,'${value}')]
    ELSE IF    '${elementName}'=='Price' and '${value}'=='false'
        Element Should Not Be Visible    xpath=//product-item[@data-qa='component product-item'][1]//span[contains(@class,'default-price') and contains(.,'${value}')]
    ELSE IF    '${elementName}'=='Original Price' and '${value}'=='false'
        Element Should Not Be Visible    xpath=//product-item[@data-qa='component product-item'][1]//span[contains(@class,'original-price') and contains(.,'${value}')]
    ELSE IF    '${elementName}'=='Name' and '${value}'=='true'
        Element Should Be Visible    xpath=//product-item[@data-qa='component product-item'][1]//*[contains(@class,'item__name') and contains(.,'${value}')]
    ELSE IF    '${elementName}'=='Name' and '${value}'=='false'
        Element Should Not Be Visible    xpath=//product-item[@data-qa='component product-item'][1]//*[contains(@class,'item__name') and contains(.,'${value}')]
    ELSE IF    '${env}' in ['ui_b2b','ui_mp_b2b','ui_suite'] and '${elementName}'=='Add to Cart' and '${value}'=='true'
        Page Should Not Contain Element    xpath=(//product-item[@data-qa='component product-item'])[1]//*[@class='product-item__actions']//ajax-add-to-cart//button[@disabled='']
    ELSE IF    '${env}' in ['ui_b2b','ui_mp_b2b','ui_suite'] and '${elementName}'=='Add to Cart' and '${value}'=='false'
        Page Should Contain Element    xpath=(//product-item[@data-qa='component product-item'])[1]//*[@class='product-item__actions']//ajax-add-to-cart//button[@disabled='']
    ELSE IF    '${env}' in ['ui_b2c','ui_mp_b2c'] and '${elementName}'=='Add to Cart' and '${value}'=='true'
        Element Should Be Visible    xpath=//product-item[@data-qa='component product-item'][1]//ajax-add-to-cart//button
    ELSE IF    '${env}' in ['ui_b2c','ui_mp_b2c'] and '${elementName}'=='Add to Cart' and '${value}'=='false'
        Element Should Not Be Visible    xpath=//product-item[@data-qa='component product-item'][1]//ajax-add-to-cart//button
    ELSE IF    '${elementName}'=='Color selector' and '${value}'=='true'
        Page Should Contain Element   xpath=//product-item[@data-qa='component product-item'][1]//product-item-color-selector
    ELSE IF    '${elementName}'=='Color selector' and '${value}'=='false'
        Page Should Not Contain Element   xpath=//product-item[@data-qa='component product-item'][1]//product-item-color-selector
    ELSE IF    '${elementName}'=='Sale label' and '${value}'=='true'
        Page Should Contain Element   xpath=(//product-item[@data-qa='component product-item'][1]//label-group//span[contains(text(),'SALE')])[1]
    ELSE IF    '${elementName}'=='Sale label' and '${value}'=='false'
        Page Should Not Contain Element   xpath=(//product-item[@data-qa='component product-item'][1]//label-group//span[contains(text(),'SALE')])[1]
    ELSE IF    '${elementName}'=='New label' and '${value}'=='true'
        Page Should Contain Element   xpath=(//product-item[@data-qa='component product-item'][1]//label-group//span[contains(text(),'New')])[1]
    ELSE IF    '${elementName}'=='New label' and '${value}'=='false'
        Page Should Not Contain Element   xpath=(//product-item[@data-qa='component product-item'][1]//label-group//span[contains(text(),'New')])[1]
    END

Yves: go to catalog page:
    [Arguments]    ${pageNumber}
    Click    xpath=(//a[contains(@class,'pagination__step') and contains(text(),'${pageNumber}')])[1]

Yves: catalog page contains filter:
    [Arguments]    @{listOfFilters}
    FOR    ${filter}    IN    @{listOfFilters}
        Log    Looking for filter: ${filter}
        IF    '${env}' in ['ui_suite']
            Element Should Be Visible    xpath=//section[contains(@data-qa,'component filter-section')]//*[contains(@class,'title')][contains(.,'${filter}')]
        ELSE
            Element Should Be Visible    xpath=//*[contains(@class,'filter') and contains(text(),'${filter}')]
        END
    END

Yves: select filter value:
    [Arguments]    ${filter}    ${filterValue}
    IF    '${env}' in ['ui_suite']
        Check Checkbox    xpath=//section[contains(@data-qa,'component filter-section')]//*[contains(@class,'title')][contains(.,'${filter}')]/..//input[@value='${filterValue}']    force=true
        Click    ${catalog_filter_apply_button}
    ELSE
        Wait Until Element Is Visible    xpath=//section[contains(@data-qa,'component filter-section')]//*[contains(@class,'filter-section')][contains(text(),'${filter}')]
        Click    xpath=//section[contains(@data-qa,'component filter-section')]//*[contains(@class,'filter-section')][contains(text(),'${filter}')]
        Disable Automatic Screenshots on Failure
        ${filter_expanded}=    Run Keyword And Ignore Error    Wait Until Element Is Visible    xpath=//section[contains(@data-qa,'component filter-section')]//*[contains(@class,'filter-section')][contains(text(),'${filter}')]/following-sibling::*//span[contains(@data-qa,'checkbox')][contains(.,'${filterValue}')]    timeout=400ms
        Restore Automatic Screenshots on Failure
        IF    'FAIL' in $filter_expanded
            Reload
            Wait Until Element Is Visible    xpath=//section[contains(@data-qa,'component filter-section')]//*[contains(@class,'filter-section')][contains(text(),'${filter}')]
            Click    xpath=//section[contains(@data-qa,'component filter-section')]//*[contains(@class,'filter-section')][contains(text(),'${filter}')]
        END
        Click    xpath=//section[contains(@data-qa,'component filter-section')]//*[contains(@class,'filter-section')][contains(text(),'${filter}')]/following-sibling::*//span[contains(@data-qa,'checkbox')][contains(.,'${filterValue}')]
        Click    ${catalog_filter_apply_button}
    END

Yves: quick add to cart for first item in catalog
    IF    '${env}' in ['ui_b2b','ui_mp_b2b','ui_suite']
        Click    xpath=(//product-item[@data-qa='component product-item'][1]//*[@class='product-item__actions']//ajax-add-to-cart//button)[1]
    ELSE IF    '${env}' in ['ui_b2c','ui_mp_b2c']
        Scroll Element Into View    xpath=//product-item[@data-qa='component product-item'][1]//div[contains(@class,'image-wrap')]
        Mouse Over    xpath=//product-item[@data-qa='component product-item'][1]//div[contains(@class,'image-wrap')]
        Wait Until Element Is Visible    xpath=//product-item[@data-qa='component product-item'][1]//ajax-add-to-cart//button
        Click    xpath=//product-item[@data-qa='component product-item'][1]//ajax-add-to-cart//button
    END
    Wait For Response
    TRY
        Repeat Keyword    3    Wait For Load State
    EXCEPT
        Log    Page is not loaded
    END

Yves: get current cart item counter value
    [Documentation]    returns the cart item count number as an integer
    ${currentCartCounterText}=    Evaluate Javascript    ${None}    document.evaluate("//*[@data-qa='component navigation-top']//span[contains(@class,'cart-counter__quantity js-cart-counter__quantity')]", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.textContent
    ${currentCartCounter}=    Convert To Integer    ${currentCartCounterText}
    RETURN    ${currentCartCounter}

Yves: mouse over color on product card:
    [Documentation]    the color should start with capital letter, e.g. Black, Red, White
    [Arguments]    ${colour}
    IF    '${env}' in ['ui_suite']
        Click    xpath=(//product-item[@data-qa='component product-item'])[1]//product-item-color-selector//button[contains(@style,'${colour}')]
    ELSE
        Mouse Over    xpath=//product-item[@data-qa='component product-item'][1]//*[contains(@class,'item__name')]
        TRY
            Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
        Wait Until Element Is Visible    xpath=//product-item[@data-qa='component product-item'][1]//product-item-color-selector
        Mouse Over    xpath=//product-item[@data-qa='component product-item'][1]//product-item-color-selector//span[contains(@class,'tooltip')][contains(text(),'${colour}')]/ancestor::button
        TRY
            Wait For Load State
        EXCEPT
            Log    Page is not loaded
        END
    END

Yves: at least one product is/not displayed on the search results page:
    [Arguments]    ${search_query}    ${expected_visibility}    ${wait_for_p&s}=${False}    ${iterations}=26    ${delay}=3s
    Yves: perform search by:    ${search_query}
    ${expected_visibility}=    Convert To Lower Case    ${expected_visibility}
    IF    '${expected_visibility}' == 'true'
        ${expected_visibility}=    Set Variable    ${True}
    END
    IF    '${expected_visibility}' == 'yes'
        ${expected_visibility}=    Set Variable    ${True}
    END
    IF    '${expected_visibility}' == 'displayed'
        ${expected_visibility}=    Set Variable    ${True}
    END
    IF    '${expected_visibility}' == 'is displayed'
        ${expected_visibility}=    Set Variable    ${True}
    END
    IF    '${expected_visibility}' == 'false'
        ${expected_visibility}=    Set Variable    ${False}
    END
     ${wait_for_p&s}=    Convert To String    ${wait_for_p&s}
    ${wait_for_p&s}=    Convert To Lower Case    ${wait_for_p&s}
    IF    '${wait_for_p&s}' == 'true'
        ${wait_for_p&s}=    Set Variable    ${True}
    END
    IF    '${wait_for_p&s}' == 'false'
        ${wait_for_p&s}=    Set Variable    ${False}
    END
    IF    ${wait_for_p&s}
        FOR    ${index}    IN RANGE    1    ${iterations}
            IF    ${index} == ${iterations}-1
                Take Screenshot    EMBED    fullPage=True
                Fail    Expected product visibility is not reached
            END
            IF    ${expected_visibility}
                ${result}=    Run Keyword And Ignore Error    Page Should Contain Element    ${catalog_product_card_locator}
            ELSE
                ${result}=    Run Keyword And Ignore Error    Page Should Not Contain Element    ${catalog_product_card_locator}
            END
            IF    'FAIL' in $result
                Sleep    ${delay}
                Reload
                Continue For Loop
            ELSE
                Exit For Loop
            END
        END
    ELSE
        IF    ${expected_visibility}
            Page Should Contain Element    ${catalog_product_card_locator}
        ELSE
            Page Should Not Contain Element    ${catalog_product_card_locator}
        END
    END