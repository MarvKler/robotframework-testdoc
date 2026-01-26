*** Variables ***
${apps_payone_payment_cc_card_type}       id=cardtype
${apps_payone_payment_cc_name_on_card}    id=cardholder
${apps_payone_payment_cc_card_number}     xpath=//div[@id='cardpan']//iframe >>> //input[@id='cardpan']
${apps_payone_payment_cc_expire_year}     xpath=//div[@id='cardexpireyear']//iframe >>> //select[@id='cardexpireyear']
${apps_payone_payment_cc_expire_month}    xpath=//div[@id='cardexpiremonth']//iframe >>> //select[@id='cardexpiremonth']
${apps_payone_payment_cc_cvc}             xpath=//div[@id='cardcvc2']//iframe >>> //input[@id='cardcvc2']
${apps_payone_payment_pay_btn}            id=paymentsubmit
${apps_payone_payment_cancel_btn}         xpath=//a[contains(@class, 'btn') and contains(text(), 'cancel')]
