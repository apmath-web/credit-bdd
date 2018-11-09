Feature: integration test

  Background:
    * def serverConfig = read('mocks/start-mock.js')
    * def serverMock = serverConfig('get-credit-info-mock')
    * url 'http://localhost:' + serverMock.port + '/credit'
    * configure afterScenario = read('mocks/stop-mock.js')
    * configure headers = { 'Content-Type': 'application/json' }



  Scenario: create a credit
    Given request {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":1000000,"agreementAt":"2018-10-08","currency":"RUB","duration":6,"percent":5}
    When method post
    Then status 200
    And def id = response.id

    ## Get credit info
    credit was found
    Given path id
    When method get
    Then status 200
    And match response == {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":1000000,"agreementAt":"2018-10-08","currency":"RUB","duration":6,"percent":5}

    

