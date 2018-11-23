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

  #Get next payment
    Given path id
    And path 'payments'
    And param state = 'next'
    When method get
    Then status 200
    And match response == {"payments":[{"type":"regular","state":"next","date":"2018-01-01","payment":169106,"percent":4167,"body":164939,"remainCreditBody":835061}]}

  #Perfrom 1st payment - only payment
    Given request {"payment":169106}
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
    And match response == {"payments":[{"type":"regular","state":"next","date":"2018-02-01","payment":169106,"percent":3479,"body":165627,"remainCreditBody":669434}]}

  #Trying 2nd payment - wrong currency
    Given request {"payment":169106,"currency":"USD"}
    And path id
    When method put
    Then status 400
    And match response == {"message":'#string'}

  #Trying 2nd payment - wrong date
    Given request {"payment":169106,"date":"2018-01-01"}
    And path id
    When method put
    Then status 400
    And match response == {"message":'#string'}

  #Perfrom 2nd payment - with date
    Given request {"payment":169106,"date":"2018-02-01"}
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
    And match response == {"payments":[{"type":"regular","state":"next","date":"2018-03-01","payment":169106,"percent":2789,"body":166317,"remainCreditBody":503117}]}

  #Perfrom 3nd payment - full data
    Given request {"payment":169106,"type":"regular","currency":"RUB","date":"2018-03-01"}
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
    And match response == {"payments":[{"type":"regular","state":"next","date":"2018-04-01","payment":169106,"percent":2096,"body":167010,"remainCreditBody":336108}]}

  #Trying early payment - wrong date (4th payment missed)
    Given request {"payment":269106,"type":"early","currency":"RUB","date":"2018-04-10"}
    And path id
    When method put
    Then status 400
    And match response == {"message":'#string'}

  #Perfrom 4th payment
    Given request {"payment":169106}
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
    And match response == {"payments":[{"type":"regular","state":"next","date":"2018-05-01","payment":169106,"percent":855,"body":168251,"remainCreditBody":36963}]}

  #Perfrom early payment 
    Given request {"payment":300000,"type":"early","date":"2018-04-25"}
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
    And match response == {"payments":[{"type":"regular","state":"next","date":"2018-06-01","payment":37177,"percent":154,"body":36963,"remainCreditBody":0}]}

  #Perfrom last payment
    Given request {"payment":37177}
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
    And match response == {"payments":[]}

  #Delete credit
    Given path id
    When method DELETE
    Then status 204
    And match response == ''

