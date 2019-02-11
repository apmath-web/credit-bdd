Feature: Read credit information integration test

  Background:
    * url 'http://localhost:8080/credit'
    * configure headers = { 'Content-Type': 'application/json' }

  Scenario Outline: positive tests
    Given request <info>
    When method post
    Then status 200
    And match response == { id:'#number' }
    And def id = response.id

    Given path id
    When method get
    Then status 200
    And match response == {"person":{"firstName":'#string',"lastName":'#string'},"amount":'#number',"agreementAt":'#string',"currency":'#string',"duration":'#number',"percent":'#number'}
    And match response == <info>

  Examples:
    | info                                                                                                                                                   |
    | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"amount":2000000,"agreementAt":"2018-10-08","currency":"USD","duration":60,"percent":5}   |
    | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"amount":23450,"agreementAt":"2018-10-08","currency":"USD","duration":10,"percent":10}    |
    | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"amount":34500000,"agreementAt":"2018-10-08","currency":"USD","duration":20,"percent":5}  |
    | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"amount":2000000,"agreementAt":"2018-10-08","currency":"USD","duration":16,"percent":14}  |
    | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"amount":2000000,"agreementAt":"2018-10-08","currency":"USD","duration":23,"percent":15}  |
    | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"amount":134500,"agreementAt":"2018-10-08","currency":"USD","duration":50,"percent":16}   |

  Scenario Outline: negative test
    Given path <ID>
    When method get
    Then status 404
    And match response == {"message":"#string"}

   Examples:
    |ID    |
    |234590|
    |126754|
    |435466|
    |097655|
    |364765|
    |548788|

    #TODO test finished credit info returns 404
