Feature: stateful mock server

  Background:
    * table payments
      | remainCreditBody | percent  | body     | payment | date         | state  | type      |
      | 987891,78        | 10191,78 | 12108,22 | 22300   | '2018-01-01' | 'paid' | 'regular' |
      | 974685,8         | 9094,02  | 13205,98 | 22300   | '2018-02-01' | 'paid' | 'regular' |
      | 962319,58        | 9933,78  | 12366,22 | 22300   | '2018-03-01' | 'paid' | 'regular' |
      | 949510,95        | 9491,37  | 12808,63 | 22300   | '2018-04-01' | 'paid' | 'regular' |
      | 936888,16        | 9677,21  | 12622,79 | 22300   | '2018-05-01' | 'paid' | 'regular' |
      | 923828,7         | 9240,54  | 13059,46 | 22300   | '2018-06-01' | 'paid' | 'regular' |
      | 910944,16        | 9415,46  | 12884,54 | 22300   | '2018-07-01' | 'paid' | 'regular' |
      | 897928,3         | 9284,14  | 13015,86 | 22300   | '2018-08-01' | 'paid' | 'regular' |
      | 884484,58        | 8856,28  | 13443,72 | 22300   | '2018-09-01' | 'paid' | 'regular' |
      | 871199,05        | 9014,47  | 13285,53 | 22300   | '2018-10-01' | 'paid' | 'regular' |
      | 857491,7         | 8592,65  | 13707,35 | 22300   | '2018-11-01' | 'paid' | 'regular' |
      | 843931,07        | 8739,37  | 13560,63 | 22300   | '2018-12-01' | 'paid' | 'regular' |
      | 830232,23        | 8601,16  | 13698,84 | 22300   | '2019-01-01' | 'paid' | 'regular' |
      | 815574,92        | 7642,69  | 14657,31 | 22300   | '2019-02-01' | 'paid' | 'regular' |
      | 801587,08        | 8312,16  | 13987,84 | 22300   | '2019-03-01' | 'paid' | 'regular' |
      | 787193,14        | 7906,06  | 14393,94 | 22300   | '2019-04-01' | 'paid' | 'regular' |
      | 772916,04        | 8022,9   | 14277,1  | 22300   | '2019-05-01' | 'paid' | 'regular' |
      | 758239,32        | 7623,28  | 14676,72 | 22300   | '2019-06-01' | 'paid' | 'regular' |
      | 743667,13        | 7727,81  | 14572,19 | 22300   | '2019-07-01' | 'paid' | 'regular' |
      | 728946,42        | 7579,29  | 14720,71 | 22300   | '2019-08-01' | 'paid' | 'regular' |
      | 713836,03        | 7189,61  | 15110,39 | 22300   | '2019-09-01' | 'paid' | 'regular' |
      | 698811,29        | 7275,26  | 15024,74 | 22300   | '2019-10-01' | 'paid' | 'regular' |
      | 683403,68        | 6892,39  | 15407,61 | 22300   | '2019-11-01' | 'paid' | 'regular' |
      | 668068,78        | 6965,1   | 15334,9  | 22300   | '2019-12-01' | 'paid' | 'regular' |
      | 652577,59        | 6808,81  | 15491,19 | 22300   | '2020-01-01' | 'paid' | 'regular' |
      | 636499,43        | 6221,84  | 16078,16 | 22300   | '2020-02-01' | 'paid' | 'regular' |
      | 620686,49        | 6487,06  | 15812,94 | 22300   | '2020-03-01' | 'paid' | 'regular' |
      | 604508,33        | 6121,84  | 16178,16 | 22300   | '2020-04-01' | 'paid' | 'regular' |
      | 588369,35        | 6161,02  | 16138,98 | 22300   | '2020-05-01' | 'paid' | 'regular' |
      | 572230,37        | 5803,09  | 16496,91 | 22300   | '2020-06-01' | 'paid' | 'regular' |
    * table credits
      | id | person                                                | credit  | agreementAt  | duration | percent | payments |
      | 0  | {"firstName": "Alexandra", "lastName": "Chernyshova"} | 2000000 | "2018-10-08" | 60       | 5       | payments |
    * configure cors = true
    * configure responseHeaders = { 'Content-Type': 'application/json; charset=utf-8' }
    * def requestMatch = read('request-match.js')
    * def selectWithType = function(jsObjects,type){var results=[]; jsObjects.forEach(function(age){if(type==age.type)results.push(age)});return results}
    #Probably later implementation
    #call read('classpath:take-credit.feature') config
    #call read('classpath:pay-credit.feature') config

  Scenario: pathMatches('/credit/{id}/payments') && (paramValue('type') == 'regular'||paramValue('type') == 'early') && paramValue('state') == 'paid'

    * def response = selectWithType(credits[pathParams.id].payments, paramValue('type'))

  Scenario: pathMatches('/credit/{id}/payments') && paramValue('type') == 'regular' && paramValue('state') == 'upcoming'
    * def response = selectWithType(credits[pathParams.id].payments, paramValue('type'))

  Scenario: pathMatches('/credit/{id}/payments') && paramValue('type') == 'early' && paramValue('state') == 'upcoming'
    * def responseStatus = 404
    * def response = { code: 1, message: 'Not implemented yet, in develop' }

  Scenario:
    * def responseStatus = 404
    * def response = { code: 1, message: 'Not found' }

