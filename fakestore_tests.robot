*** Settings ***
Library           ../Ressource/mongo_library.py
Library           BuiltIn

*** Variables ***
${uri}               mongodb+srv://nmbaye:passer@cluster0.wgydv1y.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0
${db_name}           fakestoredb
${COLLECTION_NAME}   products

*** Test Cases ***

# ====== CREATE ======

Créer Un Produit Valide
    [Documentation]    C-01 Scénario passant - création d’un produit valide
    Connect To Mongo    ${uri}    ${db_name}
    ${product}=    Create Dictionary    title=Test Product    price=99.99    category=electronics    image=test.jpg    phone=770000000
    ${result}=    Insert Document    ${COLLECTION_NAME}    ${product}
    Should Not Be Empty   ${result}

Créer Produit Sans Titre (Invalide)
    [Documentation]    C-02 Scénarios non passant - produit sans title => erreur
    Connect To Mongo    ${uri}    ${db_name}
    ${product}=    Create Dictionary    price=99.99    category=electronics    image=test.jpg    phone=770000000
    Run Keyword And Expect Error    *    Insert Document    ${COLLECTION_NAME}    ${product}

Créer Produit Prix Texte (Invalide)
    [Documentation]    C-03 Scénarios non passant - produit avec prix non numérique => erreur
    Connect To Mongo    ${uri}    ${db_name}
    ${product}=    Create Dictionary    title=Produit Test    price=invalidPrice    category=electronics    image=test.jpg    phone=770000000
    Run Keyword And Expect Error    *    Insert Document    ${COLLECTION_NAME}    ${product}

# ====== READ ======

Lire Tous Les Produits
    [Documentation]    R-01 Scénario passant - lire tous les produits (doit retourner > 0)
    Connect To Mongo    ${uri}    ${db_name}
    ${result}=    Find Documents    ${COLLECTION_NAME}
    Should Be True    len(${result}) > 0

Lire Produits Avec Catégorie Vide (Invalide)
    [Documentation]    R-02 Scénario non passant - aucun produit ne doit avoir une catégorie vide
    Connect To Mongo    ${uri}    ${db_name}
    ${result}=    Find Documents    ${COLLECTION_NAME}
    ${vide}=      Evaluate    [item for item in ${result} if 'category' in item and item['category'] == '']
    Length Should Be    ${vide}    0

Lire Produits Avec Prix Negatif (Invalide)
    [Documentation]    R-03 Scénario non passant - aucun produit ne doit avoir un prix négatif
    Connect To Mongo    ${uri}    ${db_name}
    ${result}=    Find Documents    ${COLLECTION_NAME}
    ${negatifs}=  Evaluate    [item for item in ${result} if 'price' in item and float(item['price']) < 0]
    Length Should Be    ${negatifs}    0

# ====== UPDATE ======

Mettre à Jour Prix Produit Valide
    [Documentation]    U-01 Scénario passant - mise à jour prix valide
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=     Create Dictionary    title=Test Product
    ${update}=    Create Dictionary    price=79.99
    ${result}=    Update Document      ${COLLECTION_NAME}    ${query}    ${update}
    Should Be True    ${result} >= 1

Mettre Prix Vide (Invalide)
    [Documentation]    U-02 Scénarios non passant - mise à jour avec prix vide => erreur
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=     Create Dictionary    title=Test Product
    ${update}=    Evaluate    {"price": None}
    Run Keyword And Expect Error    *    Update Document    ${COLLECTION_NAME}    ${query}    ${update}

Mettre Prix Négatif (Invalide)
    [Documentation]    U-03 Scénarios non passant - mise à jour avec prix négatif => erreur
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=     Create Dictionary    title=Test Product
    ${update}=    Create Dictionary    price=-100
    Run Keyword And Expect Error    *    Update Document    ${COLLECTION_NAME}    ${query}    ${update}

# ====== DELETE ======

Supprimer Produit Valide
    [Documentation]    D-01 Scénario passant - suppression d’un produit existant
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=    Create Dictionary    title=Test Product
    ${result}=   Delete Document       ${COLLECTION_NAME}    ${query}
    Should Be True    ${result} >= 1

Supprimer Produit Inexistant
    [Documentation]    D-02 Scénario non passant - suppression produit inexistant => 0 suppression
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=    Create Dictionary    title=Produit Inexistant
    ${result}=   Delete Document       ${COLLECTION_NAME}    ${query}
    Should Be Equal As Integers    ${result}    0

Supprimer Avec Champs Vide (Invalide)
    [Documentation]    D-03 Scénario non passant - suppression avec requête vide => erreur
    Connect To Mongo    ${uri}    ${db_name}
    ${query}=    Create Dictionary
    Run Keyword And Expect Error    *    Delete Document    ${COLLECTION_NAME}    ${query}
