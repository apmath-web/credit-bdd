Feature: Get payments list integration test

  Background:
    * url 'http://localhost:8080/credit'
    * configure headers = { 'Content-Type': 'application/json' }


  Scenario: List with invalid query parameters returns validation errors

    Given request {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"amount":1000000,"agreementAt":"2010-01-01","currency":"RUR","duration":6,"percent":300}
    When method post
    Then status 200
    And def id = response.id
    And match response == {id:'#number'}

    Given path id
    And path 'payments'
    And param type = 'Regular'
    When method get
    Then status 400

    Given path id
    And path 'payments'
    And param type = 'soft'
    When method get
    Then status 400

    Given path id
    And path 'payments'
    And param state = 'Upcoming'
    When method get
    Then status 400

    Given path id
    And path 'payments'
    And param state = 'next'
    When method get
    Then status 400

    Given path id
    And path 'payments'
    And param type = ''
    And param state = ''
    When method get
    Then status 400

  Scenario: Check List fetched after Credit created

    Given request {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"amount":1000000,"agreementAt":"2010-01-01","currency":"RUR","duration":6,"percent":300}
    When method post
    Then status 200
    And def id = response.id
    And match response == {id:'#number'}

    Given path id
    And path 'payments'
    When method get
    Then status 200
    And match response == {"payments":[{"type":"next","state":"upcoming","currency":"RUR","date":"2010-02-01","payment":338900,"percent":254795,"body":84105,"remainCreditBody":1000000,"fullEarlyRepayment":1254790},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-03-01","payment":338900,"percent":210781,"body":128119,"remainCreditBody":915895,"fullEarlyRepayment":1126670},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-04-01","payment":338900,"percent":200721,"body":138179,"remainCreditBody":787776,"fullEarlyRepayment":988490},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-05-01","payment":338900,"percent":160175,"body":178725,"remainCreditBody":649597,"fullEarlyRepayment":809770},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-06-01","payment":338900,"percent":119976,"body":218924,"remainCreditBody":470872,"fullEarlyRepayment":590840},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-07-01","payment":314070,"percent":62122,"body":251948,"remainCreditBody":251948,"fullEarlyRepayment":314070}]}

    Given path id
    And path 'payments'
    And param type = 'regular'
    When method get
    Then status 200
    And match response == {"payments":[{"type":"next","state":"upcoming","currency":"RUR","date":"2010-02-01","payment":338900,"percent":254795,"body":84105,"remainCreditBody":1000000,"fullEarlyRepayment":1254790},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-03-01","payment":338900,"percent":210781,"body":128119,"remainCreditBody":915895,"fullEarlyRepayment":1126670},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-04-01","payment":338900,"percent":200721,"body":138179,"remainCreditBody":787776,"fullEarlyRepayment":988490},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-05-01","payment":338900,"percent":160175,"body":178725,"remainCreditBody":649597,"fullEarlyRepayment":809770},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-06-01","payment":338900,"percent":119976,"body":218924,"remainCreditBody":470872,"fullEarlyRepayment":590840},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-07-01","payment":314070,"percent":62122,"body":251948,"remainCreditBody":251948,"fullEarlyRepayment":314070}]}

    Given path id
    And path 'payments'
    And param state = 'upcoming'
    When method get
    Then status 200
    And match response == {"payments":[{"type":"next","state":"upcoming","currency":"RUR","date":"2010-02-01","payment":338900,"percent":254795,"body":84105,"remainCreditBody":1000000,"fullEarlyRepayment":1254790},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-03-01","payment":338900,"percent":210781,"body":128119,"remainCreditBody":915895,"fullEarlyRepayment":1126670},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-04-01","payment":338900,"percent":200721,"body":138179,"remainCreditBody":787776,"fullEarlyRepayment":988490},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-05-01","payment":338900,"percent":160175,"body":178725,"remainCreditBody":649597,"fullEarlyRepayment":809770},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-06-01","payment":338900,"percent":119976,"body":218924,"remainCreditBody":470872,"fullEarlyRepayment":590840},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-07-01","payment":314070,"percent":62122,"body":251948,"remainCreditBody":251948,"fullEarlyRepayment":314070}]}

    Given path id
    And path 'payments'
    And param type = 'regular'
    And param state = 'upcoming'
    When method get
    Then status 200
    And match response == {"payments":[{"type":"next","state":"upcoming","currency":"RUR","date":"2010-02-01","payment":338900,"percent":254795,"body":84105,"remainCreditBody":1000000,"fullEarlyRepayment":1254790},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-03-01","payment":338900,"percent":210781,"body":128119,"remainCreditBody":915895,"fullEarlyRepayment":1126670},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-04-01","payment":338900,"percent":200721,"body":138179,"remainCreditBody":787776,"fullEarlyRepayment":988490},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-05-01","payment":338900,"percent":160175,"body":178725,"remainCreditBody":649597,"fullEarlyRepayment":809770},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-06-01","payment":338900,"percent":119976,"body":218924,"remainCreditBody":470872,"fullEarlyRepayment":590840},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-07-01","payment":314070,"percent":62122,"body":251948,"remainCreditBody":251948,"fullEarlyRepayment":314070}]}

    Given path id
    And path 'payments'
    And param type = 'next'
    When method get
    Then status 200
    And match response == {"payments":[{"type":"next","state":"upcoming","currency":"RUR","date":"2010-02-01","payment":338900,"percent":254795,"body":84105,"remainCreditBody":1000000,"fullEarlyRepayment":1254790}]}

    Given path id
    And path 'payments'
    And param type = 'early'
    When method get
    Then status 200
    And match response == {"payments":[]}

    Given path id
    And path 'payments'
    And param state = 'paid'
    When method get
    Then status 200
    And match response == {"payments":[]}

    Given path id
    And path 'payments'
    And param type = 'early'
    And param state = 'paid'
    When method get
    Then status 200
    And match response == {"payments":[]}

  Scenario: Check List fetched after first payment

    Given request {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"amount":1000000,"agreementAt":"2010-01-01","currency":"RUR","duration":6,"percent":300}
    When method post
    Then status 200
    And def id = response.id
    And match response == {id:'#number'}

    Given request {"payment":338900}
    And path id
    When method put
    Then status 200

    Given path id
    And path 'payments'
    When method get
    Then status 200
    And match response == {"payments":[{"type":"regular","state":"paid","currency":"RUR","date":"2010-02-01","payment":338900,"percent":254795,"body":84105,"remainCreditBody":1000000,"fullEarlyRepayment":1254790},{"type":"next","state":"upcoming","currency":"RUR","date":"2010-03-01","payment":338900,"percent":210781,"body":128119,"remainCreditBody":915895,"fullEarlyRepayment":1126670},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-04-01","payment":338900,"percent":200721,"body":138179,"remainCreditBody":787776,"fullEarlyRepayment":988490},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-05-01","payment":338900,"percent":160175,"body":178725,"remainCreditBody":649597,"fullEarlyRepayment":809770},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-06-01","payment":338900,"percent":119976,"body":218924,"remainCreditBody":470872,"fullEarlyRepayment":590840},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-07-01","payment":314070,"percent":62122,"body":251948,"remainCreditBody":251948,"fullEarlyRepayment":314070}]}

    Given path id
    And path 'payments'
    And param type = 'regular'
    When method get
    Then status 200
    And match response == {"payments":[{"type":"regular","state":"paid","currency":"RUR","date":"2010-02-01","payment":338900,"percent":254795,"body":84105,"remainCreditBody":1000000,"fullEarlyRepayment":1254790},{"type":"next","state":"upcoming","currency":"RUR","date":"2010-03-01","payment":338900,"percent":210781,"body":128119,"remainCreditBody":915895,"fullEarlyRepayment":1126670},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-04-01","payment":338900,"percent":200721,"body":138179,"remainCreditBody":787776,"fullEarlyRepayment":988490},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-05-01","payment":338900,"percent":160175,"body":178725,"remainCreditBody":649597,"fullEarlyRepayment":809770},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-06-01","payment":338900,"percent":119976,"body":218924,"remainCreditBody":470872,"fullEarlyRepayment":590840},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-07-01","payment":314070,"percent":62122,"body":251948,"remainCreditBody":251948,"fullEarlyRepayment":314070}]}

    Given path id
    And path 'payments'
    And param state = 'upcoming'
    When method get
    Then status 200
    And match response == {"payments":[{"type":"next","state":"upcoming","currency":"RUR","date":"2010-03-01","payment":338900,"percent":210781,"body":128119,"remainCreditBody":915895,"fullEarlyRepayment":1126670},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-04-01","payment":338900,"percent":200721,"body":138179,"remainCreditBody":787776,"fullEarlyRepayment":988490},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-05-01","payment":338900,"percent":160175,"body":178725,"remainCreditBody":649597,"fullEarlyRepayment":809770},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-06-01","payment":338900,"percent":119976,"body":218924,"remainCreditBody":470872,"fullEarlyRepayment":590840},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-07-01","payment":314070,"percent":62122,"body":251948,"remainCreditBody":251948,"fullEarlyRepayment":314070}]}


    Given path id
    And path 'payments'
    And param type = 'regular'
    And param state = 'upcoming'
    When method get
    Then status 200
    And match response == {"payments":[{"type":"next","state":"upcoming","currency":"RUR","date":"2010-03-01","payment":338900,"percent":210781,"body":128119,"remainCreditBody":915895,"fullEarlyRepayment":1126670},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-04-01","payment":338900,"percent":200721,"body":138179,"remainCreditBody":787776,"fullEarlyRepayment":988490},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-05-01","payment":338900,"percent":160175,"body":178725,"remainCreditBody":649597,"fullEarlyRepayment":809770},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-06-01","payment":338900,"percent":119976,"body":218924,"remainCreditBody":470872,"fullEarlyRepayment":590840},{"type":"regular","state":"upcoming","currency":"RUR","date":"2010-07-01","payment":314070,"percent":62122,"body":251948,"remainCreditBody":251948,"fullEarlyRepayment":314070}]}

    Given path id
    And path 'payments'
    And param type = 'next'
    When method get
    Then status 200
    And match response == {"payments":[{"type":"next","state":"upcoming","currency":"RUR","date":"2010-03-01","payment":338900,"percent":210781,"body":128119,"remainCreditBody":915895,"fullEarlyRepayment":1126670}]}

    Given path id
    And path 'payments'
    And param type = 'early'
    When method get
    Then status 200
    And match response == {"payments":[]}

    Given path id
    And path 'payments'
    And param state = 'paid'
    When method get
    Then status 200
    And match response == {"payments":[{"type":"regular","state":"paid","currency":"RUR","date":"2010-02-01","payment":338900,"percent":254795,"body":84105,"remainCreditBody":1000000,"fullEarlyRepayment":1254790}]}

    Given path id
    And path 'payments'
    And param type = 'early'
    And param state = 'paid'
    When method get
    Then status 200
    And match response == {"payments":[]}

# provide Scenarios for 5 payments and 6 payments. Make 5 payment early to test filters on early.
