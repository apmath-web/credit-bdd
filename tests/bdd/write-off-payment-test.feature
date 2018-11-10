Feature: integration test

  Background:
    * def serverConfig = read('mocks/start-mock.js')
    * def serverMock = serverConfig('write-off-payment-mock')
    * url 'http://localhost:' + serverMock.port + '/credit'
    * configure afterScenario = read('mocks/stop-mock.js')
    * configure headers = { 'Content-Type': 'application/json' }

  Scenario: Create a full credit history

  #Create new credit
    Given request {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"amount":1000000,"agreementAt":"2017-12-01","currency":"RUB","duration":6,"percent":5}
    When method post
    Then status 200
    And def id = response.id

  #Perfrom 1st payment - only payment
    Given request {"payment":169106.00}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

  #Get next payment
    Given path id
    And path 'payments'
    And param state = 'next'
    When method get
    Then status 200
    And match response == {"payments":[{"type":"regular","state":"next","date":"2018-02-01","payment":169106.00,"percent":4167.00,"body":164939.00,"remainCreditBody":835061.00}]}

  #Trying 2nd payment - wrong currency
    Given request {"payment":169106.00,"currency":"USD"}
    And path id
    When method put
    Then status 400
    And match response == {"code":'#number',"message":'#string'}

  #Trying 2nd payment - wrong date
    Given request {"payment":169106.00,"date":"2018-01-01"}
    And path id
    When method put
    Then status 400
    And match response == {"code":'#number',"message":'#string'}

  #Perfrom 2nd payment - with date
    Given request {"payment":169106.00,"date":"2018-02-01"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

  #Perfrom 3nd payment - full data
    Given request {"payment":169106.00,"type":"regular","currency":"RUB","date":"2018-03-01"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

  #Trying early payment - wrong date (4th payment missed)
    Given request {"payment":269106.00,"type":"early","currency":"RUB","date":"2018-04-10"}
    And path id
    When method put
    Then status 400
    And match response == {"code":'#number',"message":'#string'}

  #Perfrom 4th payment
    Given request {"payment":169106.00}
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

  #Get next payment
    Given path id
    And path 'payments'
    And param state = 'next'
    When method get
    Then status 200
    And match response == {"payments":[{"type":"regular","state":"next","date":"2018-06-01","payment":37177.00,"percent":154.00,"body":36963.00,"remainCreditBody":0.00}]}

  #Perfrom last payment
    Given request {"payment":37177.00}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

  #Delete credit
    Given path id
    When method DELETE
    Then status 204
    And match response == ''

