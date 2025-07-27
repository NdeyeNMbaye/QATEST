*** Settings ***
Library    SeleniumLibrary
Variables  ../pageobject/variables.py


*** Keywords ***
Ouvrir Navigateur Et Accéder À La Home Page
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    10s
    Set Selenium Speed      0.5s

Vérifier Contenu Home Page
    Wait Until Page Contains    Customer Service

### Teste 2

Cliquer Sur Le Lien Login
    Click Link   xpath=/html/body/nav/ul/li/a 
    Wait Until Page Contains    Login
   

Saisir Identifiants Valides
    Input Text    id=email-id    ${USERNAME}
    Input Text    id=password    ${PASSWORD}

Cliquer Sur Le Bouton Submit
    Click Button    id=submit-id
    Wait Until Page Contains    Our Happy Customers


### Test 3

Clique sur Login
    Click Link    xpath=/html/body/nav/ul/li/a
    Wait Until Page Contains    Login
    

Laisser Champs Vides Et Soumettre
    Click Button    id=submit-id
    Wait Until Page Contains    Login


Fermer Navigateur
    Close Browser


