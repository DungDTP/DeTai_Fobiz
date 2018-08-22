*** Settings ***
Library           SeleniumLibrary    5    1
Library           RequestsLibrary
Library           String

*** Test Cases ***
CreateOrder
    [Documentation]    1. Vào danh sách contacts
    ...    2. Chọn những contact có Stage = L1; lấy phần tử đầu tiên
    ...    3. Click nút Add Event
    ...    4. Chọn trạng thái Agree
    ...    5. Điền đầy đủ thông tin
    [Setup]    Setup
    [Template]
    ChooseMenu    contacts
    ChooseContactByLevel    1
    AddEvent4Contact    1    4    2    3
    ChooseMenu    orders
    Order    10143
    [Teardown]

*** Keywords ***
Setup
    [Arguments]    ${url}=https://2-ad.e.gobizdev.com/#/    ${browser}=chrome
    Set Selenium Speed    0.8
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
    Input Text    name=_username    taomanhdung
    Input Password    name=_password    123456
    Click Element    css=#fobiz-main > div > div.login-layout > div > div > form > div > div.login-form > button

ChooseMenu
    [Arguments]    ${menu}
    Set Selenium Speed    1
    Run Keyword If    '${menu}'=='contacts'    Click Element    css=a[href='#/contacts']
    #Click Element    css=a[href='#/${menu}']
    #Run Keyword If    '${menu}'=='orders'    Click Element    css=a[href='#/orders']

ChooseContactByName
    [Arguments]    ${name}
    #Run Keyword If    '${menu}'=='contacts'    Click Element    css=a[href='#/contacts']
    Click Element    css=a[href='#/${menu}']
    Sleep    4s

ChooseContactByLevel
    [Arguments]    ${level}
    [Documentation]    Lấy danh sách các contacts có Level = tham số truyền vào
    ...    Chọn phần tử đầu tiên để tạo Event cho phần tử đó
    #Run Keyword If    '${menu}'=='contacts'    Click Element    css=a[href='#/contacts']
    Click Element    css=#fobiz-main > div > div.content-wrapper > div.content.contact-list > div.contact-list-top > div.list-filter.contact-list-filter > div.toggle-filter > div._contactStatus-${level}.btn-group
    #Run Keyword If    Page Should Not Contain    'Found no record'    Click Element    css=#_table_row_0 > td._customerName > a
    Click Element    css=#_table_row_0 > td._customerName > a

AddEvent4Contact
    [Arguments]    ${status}    ${province_id}    ${city_id}    ${quality_number}
    [Documentation]    Lấy danh sách các contacts có Level = tham số truyền vào
    ...    Chọn phần tử đầu tiên để tạo Event cho phần tử đó
    ...    Điền đầy đủ thông tin và tạo event ở trạng thái Agree
    Click Element    css=#sumary > div.col-md-7.content-right._contact-detail-body-right > div > div.box-header.with-border._activity-content-right > div.box-tools.pull-right._activity-button-right > button
    Select From List By Value    css=#myModal > div > div > div.modal-body.no-padding._add-event-body > div > div.box-body > div:nth-child(2) > div > select    ${status}
    Input Text    name=note    Hồng, Hào, Dung xinh gái
    Click Element    css = #i-province-id > span > i
    Click Element    css = #i-province-id > div > div > div > div > ul > li:nth-child(${province_id})
    Click Element    css=#i-city-id > span > i
    Click Element    css = #i-city-id > div > div > div > div > ul > li:nth-child(${city_id})
    Input Text    css =#myModal > div > div > div.modal-body.no-padding._add-event-body > div > div.box-body > div:nth-child(5) > div:nth-child(5) > div > textarea    33 Tran Phu, Hoang Dieu
    Click Element    class= _add-properties-btn
    Sleep    3s
    #Select Radio Button    class=form-check-input    black
    Click Element    css = #myModal > div > div > div.modal-body.no-padding._add-event-body > div > div.box-body > div:nth-child(5) > div.input-group-btn.po-markup._popup-properties > div > div > div.popover-content._popup-properties-content > div:nth-child(3) > input
    Input Text    quantityAdd    ${quality_number}
    Click Element    class=_popup-properties-button-Ok
    Click Element    class=_add-event-button-finish
    Sleep    3s
    Element Should Be Visible    class = _order-code
    ${order}    Get Text    class = _order-code
    [Return]    ${order}

Order
    [Arguments]    ${order}
    Search    ${order}
    Sleep    3
    Go To    https://2-ad.e.gobizdev.com/#/orders/10143
    Sleep    3

Search
    [Arguments]    ${order_code}
    Click Element    name=code
    Input Text    name=code    ${order_code}
