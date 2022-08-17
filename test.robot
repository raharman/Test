*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${browser}    Chrome
${url}    https://www.alza.sk/
${category}    Notebooky

*** Keywords ***
Go to store
    Open Browser    ${url}    ${browser}
    Click Element   xpath=//a[normalize-space()="Rozumiem"]
    maximize browser window

Cart Keyword 1
    Log  Payment is available

Cart Keyword 2
    Log  Payment is not available

*** Test Cases ***
Valid Interaction    
    # init
    Go to Store
    Click Element    xpath=//li[@id="litp18890188"]
    Click Link    link=${category}
    Execute JavaScript    window.scrollTo(0, 1250);
    Click Link    id=ui-id-4
    Sleep    1
    
    # first product
    Click Link    xpath=(//a[@class='btnk1'][contains(text(),'Kúpiť')])[1]
    Sleep    1

    # second product
    Go Back
    Wait until element is visible    xpath=(//a[@class='btnk1'][contains(text(),'Kúpiť')])[2]
    Click Element    xpath=(//a[@class='btnk1'][contains(text(),'Kúpiť')])[2]
    Sleep    1

    # third product
    Go back
    Wait until element is visible    xpath=(//a[@class='btnk1'][contains(text(),'Kúpiť')])[3]
    Click Element    xpath=(//a[@class='btnk1'][contains(text(),'Kúpiť')])[3]
    Sleep    1
    
    # confirmation of the cart
    Wait until element is visible    xpath=//a[@id="varBToBasketButton"]
    Click Element    xpath=//a[@id="varBToBasketButton"]
    Log    "Products added to cart"
    Sleep    1
    
    # remove a product from the cart
    Click Element    xpath=//div[@class="countMinus"]
    Sleep    1
    Click Element    xpath=//span[contains(text(), "Odobrať tovar")]
    Log    "Product removed from cart"

    Close Browser

Valid Product Search
    # init
    Go to store

    # search for the product
    Input Text    id=edtSearch    Samsung
    Click Element   id=btnSearch

    title should be   Samsung | Alza.sk
    Log     Search was successful

    Close Browser



Cart Validation
    #init
    Go to store

    # check if payment is available 
    Click Element   xpath=//div[@class="headericonsc"]
    ${test}=  Run Keyword And Return Status  Element Should Be Visible  xpath=(//a[@class='btnx normal green arrowedRight order2 js-button-order-continue'])[1]
    Run Keyword If  ${test}  Cart Keyword 1    ELSE  Cart Keyword 2

    Close Browser