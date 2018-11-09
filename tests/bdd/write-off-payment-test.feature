Feature: integration test

  Background:
    * def serverConfig = read('mocks/start-mock.js')
    * def serverMock = serverConfig('write-off-payment-mock')
    * url 'http://localhost:' + serverMock.port + '/credit'
    * configure afterScenario = read('mocks/stop-mock.js')
    * configure headers = { 'Content-Type': 'application/json' }

  Scenario: Create a full credit history

   #Create new credit
    Given request {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":1000000,"agreementAt":"2017-12-01","currency":"RUB","duration":6,"percent":5}
    When method post
    Then status 200
    And def id = response.id

  #Perfrom 1st payment - only payment
    Given request {"payment":172600.00}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

  #Trying 2nd payment - wrong currency
    Given request {"payment":172600.00,"currency":"USD"}
    And path id
    When method put
    Then status 400
    And match response == {"code":'#number',"message":'#string'}

  #Trying 2nd payment - wrong date
    Given request {"payment":172600.00,"date":"2018-01-01"}
    And path id
    When method put
    Then status 400
    And match response == {"code":'#number',"message":'#string'}

  #Perfrom 2nd payment - with date
    Given request {"payment":172600.00,"date":"2018-02-01"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

  #Perfrom 3nd payment - full data
    Given request {"payment":172600.00,"type":"regular","currency":"RUB","date":"2018-03-01"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

  #Trying early payment - wrong date (4th payment missed)
    Given request {"payment":272600.00,"type":"early","currency":"RUB","date":"2018-04-10"}
    And path id
    When method put
    Then status 400
    And match response == {"code":'#number',"message":'#string'}

  #Perfrom 4th payment
    Given request {"payment":172600.00}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

  #Perfrom early payment 
    Given request {"payment":300000.00,"type":"early","date":"2018-04-25"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

  #Perfrom last payment
    Given request {"payment":44490.00}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

  #Delete credit
    Given path id
    When method DELETE
    Then status 204
    And match response == ''

