*** Settings ***
Library  SeleniumLibrary

*** Variables *** 
${URL}     http://www.lahitapiola.fi/henkilo
${BROWSER}     Chrome

${JSPATH_VAKUUTUKSET}    document.querySelector("#gatsby-focus-wrapper > duet-nav > div.DesktopNav__DesktopNavContainer-sc-1swhehi-0.hItAQk > duet-menu-bar > div:nth-child(1) > duet-menu-bar-link:nth-child(1)")
${JSPATH_DROPDOWN}    document.querySelector("#subsection-c0fe2db7-da3a-4782-867d-bace2883f3bd > div.CollapsibleList__ListWrapper-sc-u6z4ig-0.byUIkW > div > div:nth-child(9) > duet-collapsible").shadowRoot.querySelector("h3 > button")
${JSPATH_QA}    document.querySelector("#subsection-c0fe2db7-da3a-4782-867d-bace2883f3bd > div.CollapsibleList__ListWrapper-sc-u6z4ig-0.byUIkW > div > div:nth-child(9) > duet-collapsible > div > duet-paragraph")
${JSPATH_QA_LINK}    document.querySelector("#section_lue-lisaa-kaskovakuutuksen-bonuksesta_lue-lisaa-kaskovakuutuksen-bonuksesta > span")

${TARGET_ROW1}    1. vuoden jälkeen
${TARGET_ROW2}    5. vuoden jälkeen
${TARGET_ROW3}    7. vuoden jälkeen

*** Test Cases ***
Test insurance bonus percentages
    # Open browser and expand window
    Open browser    ${URL}   ${BROWSER}
    Maximize Browser Window

    # Accept all cookies to avoid obstruction
    Wait Until Page Contains Element    xpath=/html/body/div[2]/div[2]/div/div[1]/div/div[2]/div/button[3]
    Click Button    xpath=/html/body/div[2]/div[2]/div/div[1]/div/div[2]/div/button[3]

    # Click 'Vakuutukset' in nav bar
    Click Element    dom=${JSPATH_VAKUUTUKSET}
    Wait Until Page Contains Element    xpath=/html/body/div[1]/div[1]/div/duet-nav/div[1]/duet-submenu-bar/duet-submenu-bar-dropdown[1]/span

    # Open dropdown menu
    Click Element    xpath=/html/body/div[1]/div[1]/div/duet-nav/div[1]/duet-submenu-bar/duet-submenu-bar-dropdown[1]/span
    Wait Until Page Contains Element    xpath=//*[@id="gatsby-focus-wrapper"]/duet-nav/div[1]/duet-submenu-bar/duet-submenu-bar-dropdown[1]/duet-submenu-bar-dropdown-link[1]

    # Click 'Kaskovakuutus' from dropdown
    Click Element    xpath=//*[@id="gatsby-focus-wrapper"]/duet-nav/div[1]/duet-submenu-bar/duet-submenu-bar-dropdown[1]/duet-submenu-bar-dropdown-link[1]
    Wait Until Page Contains Element    xpath=/html/body/div[1]/div[1]/div/main/div/section[2]/div/div[2]/div[2]/div[2]/duet-button

    # Scroll to QA section
    Scroll Element Into View    xpath=/html/body/div[1]/div[1]/div/main/div/section[2]/div/div[4]/div/duet-paragraph[1]

    # Open additional QA sections
    Click Element    xpath=/html/body/div[1]/div[1]/div/main/div/section[2]/div/div[2]/div[2]/div[2]/duet-button

    # Open target QA section 'Mikä on kaskovakuutuksen täysi bonus?'
    Click Element    dom=${JSPATH_DROPDOWN}
    Scroll Element Into View    dom=${JSPATH_QA}

    # Check that the target section includes mention 'Uuteen vakuutukseen saat lähtöbonuksena pääsääntöisesti heti 70 %'
    Element Should Contain    dom=${JSPATH_QA}    Uuteen vakuutukseen saat lähtöbonuksena pääsääntöisesti heti 70 %

    # Continue to the link in the target section 
    Click Element    dom=${JSPATH_QA_LINK}

    # Verify link url with target 'https://www.lahitapiola.fi/henkilo/vakuutukset/ajoneuvovakuutukset/autovakuutus/liikennevakuutus-bonus/'
    Location Should Be    https://www.lahitapiola.fi/henkilo/vakuutukset/ajoneuvovakuutukset/autovakuutus/liikennevakuutus-bonus/
    Wait Until Page Contains Element    xpath=/html/body/div[1]/div[1]/div/main/div/section[2]/div/div[2]/duet-table

    # Scroll to bonus percentage table section
    Scroll Element Into View    xpath=/html/body/div[1]/div[1]/div/main/div/section[2]/div/div[2]/duet-table

    # Verify that given target entry rows exists in bonus percentage table
    Table Should Contain    xpath=/html/body/div[1]/div[1]/div/main/div/section[2]/div/div[2]/duet-table/table    ${TARGET_ROW1}
    Table Should Contain    xpath=/html/body/div[1]/div[1]/div/main/div/section[2]/div/div[2]/duet-table/table    ${TARGET_ROW2}
    Table Should Contain    xpath=/html/body/div[1]/div[1]/div/main/div/section[2]/div/div[2]/duet-table/table    ${TARGET_ROW3}
