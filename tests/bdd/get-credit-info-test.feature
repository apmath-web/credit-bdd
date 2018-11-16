Feature: integration test

  Background:
    * def serverConfig = read('mocks/start-mock.js')
    * def serverMock = serverConfig('get-credit-info-mock')
    * url 'http://localhost:' + serverMock.port + '/credit'
    * configure afterScenario = read('mocks/stop-mock.js')
    * configure headers = { 'Content-Type': 'application/json' }



  Scenario: create a credit
    Given request {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"amount":1000000,"agreementAt":"2018-10-08","currency":"RUB","duration":6,"percent":5}
    When method post
    Then status 200
    And def id = response.id

    ##Get credit info
    Given path id
    When method get
    Then status 200
    And match response == {"person":{"firstName":'#string',"lastName":'#string'},"amount":'#number',"agreementAt":'#string',"currency":'#string',"duration":'#number',"percent":'#number'}

    ##Delete credit info
    Given path id
    When method delete
    Then status 204
    And match response == ''

    ##Get credit info
    Given path id
    When method get
    Then status 404
    And match response == {"message":"Not found"}
