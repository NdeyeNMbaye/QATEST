*** Settings ***
Library           ../Ressource/mongo_library.py
Library           BuiltIn

*** Variables ***
${uri}               mongodb+srv://nmbaye:passer@cluster0.wgydv1y.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0
${db_name}           fakestoredb
${COLLECTION_NAME}   orders

*** Test Cases ***

# ====== CREATE ======

Créer Une Commande Valide
    [Documentation]    C-01 Scénario passant - création d’une commande valide
    Connect To Mongo    ${uri}    ${db_name}
    ${order}=    Create Dictionary    
    ...    userId=507f1f77bcf86cd799439011
    ...    date=2020-03-02T00:00:00.000Z
    ...    products=[{"productId": "507f1f77bcf86cd799439012", "quantity": 4}, {"productId": "507f1f77bcf86cd799439013", "quantity": 1}]
    ${result}=    Insert Document    ${COLLECTION_NAME}    ${order}
    Should Not Be Empty   ${result}

Créer Commande Sans UserId (Invalide)
    [Documentation]    C-02 Scénario non passant - création sans userId => erreur
    Connect To Mongo    ${uri}    ${db_name}
    ${order}=    Create Dictionary
    ...    date=2020-03-02T00:00:00.000Z
    ...    products=[{"productId": "507f1f77bcf86cd799439012", "quantity": 4}]
    Run Keyword And Expect Error    *    Insert Document    ${COLLECTION_NAME}    ${order}

Créer Commande Avec Produits Vides (Invalide)
    [Documentation]    C-03 Scénario non passant - produits vides => erreur
    Connect To Mongo    ${uri}    ${db_name}
    ${order}=    Create Dictionary    
    ...    userId=507f1f77bcf86cd799439011
    ...    date=2020-03-02T00:00:00.000Z
    ...    products=[]
    Run Keyword And Expect Error    *    Insert Document    ${COLLECTION_NAME}    ${order}

# ====== READ ======

Lire Toutes Les Commandes
    [Documentation]    R-01 Scénario passant - lire toutes les commandes (doit retourner > 0)
    Connect To Mongo    ${uri}    ${db_name}
    ${result}=    Find Documents    ${COLLECTION_NAME}
    Should Be True    len(${result}) > 0

Lire Commandes Sans Date (Invalide)
    [Documentation]    R-02 Scénario non passant - commandes sans date ne doivent pas exister
    Connect To Mongo    ${uri}    ${db_name}
    ${result}=    Find Documents    ${COLLECTION_NAME}
    ${no_date}=    Evaluate    [item for item in ${result} if 'date' not in item or not item['date']]
    Length Should Be    ${no_date}    0

Lire Commandes Avec Produits Vides (Invalide)
    [Documentation]    R-03 Scénario non passant - commandes avec liste produits vide ne doivent pas exister
    Connect To Mongo    ${uri}    ${db_name}
    ${result}=    Find Documents    ${COLLECTION_NAME}
    ${empty_products}=    Evaluate    [item for item in ${result} if 'products' in item and len(item['products']) == 0]
    Length Should Be    ${empty_products}    0

# ====== UPDATE ======

Mettre à Jour Quantité Produit Valide
    [Documentation]    U-01 Scénario passant - mise à jour quantité produit dans commande
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=    Create Dictionary    userId=507f1f77bcf86cd799439011
    ${update}=    Create Dictionary    products=[{"productId": "507f1f77bcf86cd799439012", "quantity": 10}]
    ${result}=    Update Document    ${COLLECTION_NAME}    ${query}    ${update}
    Should Be True    ${result} >= 1

Mettre à Jour Commande Inexistante (Invalide)
    [Documentation]    U-02 Scénario non passant - mise à jour commande inexistante
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=    Create Dictionary    userId=000000000000000000000000
    ${update}=    Create Dictionary    products=[{"productId": "507f1f77bcf86cd799439012", "quantity": 5}]
    ${result}=    Update Document    ${COLLECTION_NAME}    ${query}    ${update}
    Should Be Equal As Integers    ${result}    0

# ====== DELETE ======

Supprimer Commande Valide
    [Documentation]    D-01 Scénario passant - suppression commande existante
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=    Create Dictionary    userId=507f1f77bcf86cd799439011
    ${result}=    Delete Document    ${COLLECTION_NAME}    ${query}
    Should Be True    ${result} >= 1

Supprimer Commande Inexistante
    [Documentation]    D-02 Scénario non passant - suppression commande inexistante => 0 suppression
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=    Create Dictionary    userId=000000000000000000000000
    ${result}=    Delete Document    ${COLLECTION_NAME}    ${query}
    Should Be Equal As Integers    ${result}    0

Supprimer Avec Champs Vide (Invalide)
    [Documentation]    D-03 Scénario non passant - suppression avec requête vide => erreur
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=    Create Dictionary
    Run Keyword And Expect Error    *    Delete Document    ${COLLECTION_NAME}    ${query}
