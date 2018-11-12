Feature: integration test

  Background:
    * def serverConfig = read('mocks/start-mock.js')
    * def serverMock = serverConfig('take-credit-mock')
    * url 'http://localhost:' + serverMock.port + '/credit'
    * configure afterScenario = read('mocks/stop-mock.js')
    * configure headers = { 'Content-Type': 'application/json' }

  Scenario Outline: create credit positive
    Given request <request>
    When method post
    Then status 200
    And match response == { id:'#number' }

    Examples:
      | request                                                                                                                                                |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":2000000,"agreementAt":"2018-10-08","currency":"USD","duration":60,"percent":5}   |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":23450,"agreementAt":"2018-10-08","currency":"USD","duration":10,"percent":10}    |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":34500000,"agreementAt":"2018-10-08","currency":"USD","duration":20,"percent":5}  |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":2000000,"agreementAt":"2018-10-08","currency":"USD","duration":16,"percent":14}  |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":2000000,"agreementAt":"2018-10-08","currency":"USD","duration":23,"percent":15}  |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":134500,"agreementAt":"2018-10-08","currency":"USD","duration":50,"percent":16}   |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":2000000,"agreementAt":"2018-10-08","currency":"TRU","duration":34,"percent":101} |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":2000000,"agreementAt":"2018-10-08","currency":"EUR","duration":10,"percent":100} |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":50000,"agreementAt":"2018-10-08","currency":"USD","duration":25,"percent":18}    |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":20000,"agreementAt":"2018-10-08","currency":"USD","duration":100,"percent":19}   |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":23240,"agreementAt":"2018-10-08","currency":"USD","duration":17,"percent":20}    |


    Scenario Outline: create credit negative
    Given request <request>
    When method post
    Then status 400
    And match response contains{ message:'#string' }
    And match response contains any { message:'#string',description:'#object'}

    Examples:
      | request                                                                                                                                               |
      | {"credit":2000000,"agreementAt":"2018-10-08","currency":"USD","duration":60,"percent":0}                                                              |
      | {"person":{"lastName":"Chernyshova"},"credit":0,"agreementAt":"2018-10-08","currency":"USD","duration":10,"percent":-1}                               |
      | {"person":{"firstName":"Alexandra"},"credit":-200000,"agreementAt":"2018-10-08","currency":"USD","duration":20,"percent":5}                           |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"agreementAt":"2018-10-08","currency":"USD","duration":1,"percent":14}                   |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":2000000,"currency":"USD","duration":0,"percent":15}                             |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":1000,"agreementAt":"2018-10-08","duration":50,"percent":16}                     |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":2000000,"agreementAt":"2018-10-08","currency":"TRU","percent":101}              |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":2000000,"agreementAt":"2018-10-08","currency":"EUR","duration":10}              |
      | {"person":{"firstName":"Alexandra","lastName":1},"credit":20,"agreementAt":"2018-10-08","currency":"USD","duration":25,"percent":18}                  |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":null,"agreementAt":"2018-10-08","currency":"USD","duration":-1,"percent":19}    |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":20,"agreementAt":null,"currency":"USD","duration":17,"percent":20}              |
      | {"person":{},"credit":2000000,"agreementAt":"2018-10-08","currency":"USD","duration":60,"percent":5}                                                  |
      | {"person":{"firstName":123,"lastName":"Chernyshova"},"credit":23450,"agreementAt":"2018-10-08","currency":"USD","duration":10,"percent":10}           |
      | {"person":"dsfdfs","credit":34500000,"agreementAt":"2018-10-08","currency":"USD","duration":20,"percent":5}                                           |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":"dsf","agreementAt":"2018-10-08","currency":"USD","duration":1,2"percent":14}   |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":2000000,"agreementAt":2018,"currency":"USD","duration":23,"percent":15}         |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":134500,"agreementAt":"2018-10-08","currency":74,"duration":50,"percent":16}     |
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":2000000,"agreementAt":"2018-10-08","currency":"TRU","duration":"1","percent":11}|
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":2000000,"agreementAt":"2018-10-08","currency":"EUR","duration":10,"percent":"1"}|
      | {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":50000,"agreementAt":null,"currency":"USD","duration":25,"percent":18}           |
      | {"person":{"firstName":"Alexandra","lastName":null},"credit":20000,"agreementAt":"2018-10-08","currency":"USD","duration":100,"percent":""}           |
      | {}                                                                                                                                                    |