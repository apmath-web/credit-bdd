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
    And match response == {"payments":[{"type":"regular","state":"next","date":"2018-01-01","payment":169200,"percent":4247,"body":164953,"remainCreditBody":1000000,"fullEarlyRepayment":1014425}]}

  #Perfrom 1st payment - only payment
    Given request {"payment":169200}
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
    And match response == {"payments":[{"type":"regular","state":"next","date":"2018-02-01","payment":169200,"percent":3203,"body":165997,"remainCreditBody":835047,"fullEarlyRepayment":845225}]}

  #Trying 2nd payment - wrong currency
    Given request {"payment":169200,"currency":"USD"}
    And path id
    When method put
    Then status 400
    And match response == {"message":'#string'}

  #Trying 2nd payment - wrong date
    Given request {"payment":169200,"date":"2018-01-01"}
    And path id
    When method put
    Then status 400
    And match response == {"message":'#string'}

  #Perfrom 2nd payment - with date
    Given request {"payment":169200,"date":"2018-02-01"}
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
    And match response == {"payments":[{"type":"regular","state":"next","date":"2018-03-01","payment":169200,"percent":2750,"body":166450,"remainCreditBody":669050,"fullEarlyRepayment":676025}]}

  #Perfrom 3nd payment - full data
    Given request {"payment":169200,"type":"regular","currency":"RUB","date":"2018-03-01"}
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
    And match response == {"payments":[{"type":"regular","state":"next","date":"2018-04-01","payment":169200,"percent":2134,"body":167066,"remainCreditBody":502600,"fullEarlyRepayment":506825}]}

  #Trying early payment - wrong date (4th payment missed)
    Given request {"payment":269200,"type":"early","currency":"RUB","date":"2018-04-10"}
    And path id
    When method put
    Then status 400
    And match response == {"message":'#string'}

  #Perfrom 4th payment
    Given request {"payment":169200}
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
    And match response == {"payments":[{"type":"regular","state":"next","date":"2018-05-01","payment":169200,"percent":1379,"body":167821,"remainCreditBody":335534,"fullEarlyRepayment":337625}]}

  #Perfrom early payment 
    Given request {"payment":300000,"type":"early","date":"2018-04-25"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

  #Get next payment - must be recounted
    Given path id
    And path 'payments'
    And param state = 'next'
    When method get
    Then status 200
    And match response == {"payments":[{"type":"regular","state":"next","date":"2018-05-01","payment":17900,"percent":146,"body":17754,"remainCreditBody":35534,"fullEarlyRepayment":35800}]}

  #Perfrom last payment
    Given request {"payment":35800,"type":"early","date":"2018-05-01"}
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

