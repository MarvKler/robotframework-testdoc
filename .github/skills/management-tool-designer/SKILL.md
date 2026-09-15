---
name: management-tool-designer
description: Strict guidelines for developing the "testdoc management" tool to track also the test result history.
---


# Tool Description

This skill is required to develop the new "testdoc management" tool / subcommand.
This new subcommand generates the already implemented test documentation, but additionally to that it can read Robot Framework output.xml files (test execution results) and map those results to the previous created test documentation.

The test documentation object must be parsed against the test result object to map the test cases to each other - afterwards we have a new python dto which contains both, the test documentation with the test result history per test case.

The test result history must be stored in a local database file which gets defined by the CLI call via argument.^
The user must ensure that he is reusing the same database file every time he calls the testdoc management tool, because this is the single source of persistant data which stores the test results over time. Every stored test result must have a static link to the test case in the test case documentation.

# Web Frontend

The web frontend should be a simple web app based on HTML, CSS and JavaScript.
Do NOT use any UI framework like angular, etc. !!!

## Strict Design Guidelines

- Collapsible menu on the left side 
  - Menu item 1: "Dashboard"
  - Menu item 2: "Test Case Repository"
  - Menu item 3: "Test Result History"
- Header bar at the top of the desktop screen contains title of currently open page and button to return to home page
- Menu contains a button at the bottom to expand / collapse the menu
  - if collapsed, only icons should be shown for the the menus
- Use a modern design for all elements - modern web app in year 2026.
- The color theme of the complete app should be light with a good contrast to ensure a good readability
- Page "Test Case Repository"
  - this page must contain another container where all the test suites / test cases are visible as clickable tree menu.
    - only the first layer of the directory is visible - after clicking on a test suite item, the next layer of test suite should be visible - this should avoid the visualization of a very big tree menu which is not readable
  - every time when clicking on a test suite directory item, the statistics should be shown in a main area view
    - statistics like "X tests in suite directory"
  - when clicking on a test suite (.robot file), the available test cases are shown in this div container and they are clickable.
    - clicking on the test case shows all test case details from the python dto in the main area view.
  - every shown test case has a button which navigates immediately to the results trend in the test result history page
- Page "Test Case Repository"
  - overview of all latest test results 
  - contains same navigation like test case repository page
    - clicking on a test case shows the complete available result trend received from the database entries. 
- Page "Dashboard"
  - Implement some useful metrics the user needs on a dashboard page.