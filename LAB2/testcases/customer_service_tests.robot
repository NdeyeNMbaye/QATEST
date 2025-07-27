*** Settings ***
Library    SeleniumLibrary
Resource    ../resources/customer_service_keywords.robot



*** Test Cases ***
Test 1001 - Home Page Should Load
    Ouvrir Navigateur Et Accéder À La Home Page
    Vérifier Contenu Home Page
    Fermer Navigateur