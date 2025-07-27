*** Settings ***
Library    SeleniumLibrary
Variables  ../pageobject/variables.py


*** Keywords ***
Ouvrir Navigateur Et Accéder À La Home Page
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    # Set Selenium Timeout    10s
    # Set Selenium Speed      0.5s

Vérifier Contenu Home Page
    Wait Until Page Contains    Customer Service

Fermer Navigateur
    Close Browser