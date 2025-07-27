*** Settings ***
Library    SeleniumLibrary
Resource    ../resources/customer_service_keywords.robot



*** Test Cases ***
Test 1001 - Home Page Should Load
    Ouvrir Navigateur Et Accéder À La Home Page
    Vérifier Contenu Home Page
    Fermer Navigateur


Test 1002 - Login should succeed with valid credentials
    Ouvrir Navigateur Et Accéder À La Home Page
    Cliquer Sur Le Lien Login
    Saisir Identifiants Valides
    Cliquer Sur Le Bouton Submit
    Fermer Navigateur