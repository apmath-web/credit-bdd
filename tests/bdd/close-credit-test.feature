Feature: integration test

  Background:
    * def serverConfig = read('mocks/start-mock.js')
    * def serverMock = serverConfig('close-credit-mock')
    * url 'http://localhost:' + serverMock.port + '/credit' + '/delete'
    * configure afterScenario = read('mocks/stop-mock.js')
    * configure headers = { 'Content-Type': 'application/json' }

    Scenario: Add credit
        Given request {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":1000000,"agreementAt":"2018-10-08","currency":"RUB","duration":6,"percent":5}
        When method post
        Then status 200
        And def id1 = response.id

        Given request {"person":{"firstName":"Alexandra","lastName":"Chnyshova"},"credit":1000000,"agreementAt":"2018-10-08","currency":"RUB","duration":6,"percent":5}
        When method post
        Then status 200
        And def id2 = response.id

        Given request {"person":{"firstName":"Alndra","lastName":"Chernyshova"},"credit":1000000,"agreementAt":"2018-10-08","currency":"RUB","duration":6,"percent":5}
        When method post
        Then status 200
        And def id3 = response.id

        Given path id1
    	When method get
    	Then status 200
        And match response == {message : 'Done'}

        Given path id2
        When method get
        Then status 200
        And match response == {message : 'Done'}

        Given path id3
        When method get
        Then status 200
        And match response == {message : 'Done'}

        Given path "i"
        When method get
        Then status 400
        And match response == {message : 'Uncorrect'}

        Given path 10
        When method get
        Then status 404
        And match response == {message : 'Not exist'}