*** Variables ***
${zed_first_navigation_menus_locator}    xpath=(//ul[@id='side-menu']/li/a/span[@class='nav-label']/../../a[contains(@href,'/') and not (contains(@href,'javascript'))])
${zed_root_menu_icons_locator}    xpath=//ul[@id='side-menu']/li/a/span[@class='nav-label']/../../a
${zed_second_navigation_menus_locator}    xpath=(//ul[@id='side-menu']/li/a/span[@class='nav-label']/../../a[contains(@href,'javascript')])