*** Variables ****
${usercentrics_root}    id=usercentrics-root
${usercentrics_form}    ${usercentrics_root} >> css=div[data-testid='uc-banner-content']
${usercentrics_form_accept_button}    ${usercentrics_form} >> xpath=//button[@data-testid='uc-accept-all-button']
${usercentrics_form_deny_button}    ${usercentrics_form} >> xpath=//button[@data-testid='uc-deny-all-button']
