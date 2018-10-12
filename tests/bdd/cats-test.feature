Feature: integration test

  Background:
    * def serverConfig = read('mocks/start-mock.js')
    * def catsServerMock = serverConfig('cats-mock')
    * url 'http://localhost:' + catsServerMock.port + '/cats'
    * def afterScenario = function(){ catsServerMock.stop() }
    * configure headers = { 'Content-Type': 'application/json' }

  Scenario Outline: create cat with garbage allowed
    Given request <request>
    When method post
    Then status 200

    Given url 'http://localhost:' + catsServerMock.port + '/__admin/stop'
    When method get
    Then status 200

    Examples:
      | request                                                   | name   |
      | { name: 'Billie' }                                        | Billie |
      | { name: 'Bob', other: "smth" }                            | Bob    |
      | { name: 'Ann', birthDay: 2018, city: "Saint-petersburg" } | Ann    |

  Scenario Outline: create cat with wrong data failed
    Given request <request>
    When method post
    Then status 404

    Given url 'http://localhost:' + catsServerMock.port + '/__admin/stop'
    When method get
    Then status 200

    Examples:
      | request        |
      | { name: null } |
      | { name: 123 }  |
      | { name: {} }   |
      | { name: null } |

  Scenario: create cat with future fetching
    Given request { name: 'Billie' }
    When method post
    Then status 200
    And match response == { id: '#uuid', name: 'Billie' }
    And def id = response.id

    Given path id
    When method get
    Then status 200
    And match response == { id: '#(id)', name: 'Billie' }

    When method get
    Then status 200
    And match response contains [{ id: '#(id)', name: 'Billie' }]

    Given request { name: 'Bob' }
    When method post
    Then status 200
    And match response == { id: '#uuid', name: 'Bob' }
    And def id = response.id

    Given path id
    When method get
    Then status 200
    And match response == { id: '#(id)', name: 'Bob' }

    When method get
    Then status 200
    And match response contains [{ id: '#uuid', name: 'Billie' },{ id: '#(id)', name: 'Bob' }]

    Given url 'http://localhost:' + catsServerMock.port + '/__admin/stop'
    When method get
    Then status 200

