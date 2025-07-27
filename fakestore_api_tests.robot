*** Settings ***
Resource    ../resources/fakestore_keywords.robot
Suite Setup    Create Session To FakeStore

*** Test Cases ***
Get List Of All Products
    ${products}=    Get All Products
    Should Be True    len(${products}) > 0

Create A New User
    ${new_user}=    Create New User
    Should Contain    ${new_user}    id

Update A Cart
    ${updated_cart}=    Update Cart
    Should Contain    ${updated_cart}    id
