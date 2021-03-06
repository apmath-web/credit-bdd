Feature: Get payments mock server

  Background:
    * configure cors = true
    * configure responseHeaders = { 'Content-Type': 'application/json; charset=utf-8' }
    * def requestMatch = read('request-match.js')
    * def incr = function(arg) { return arg + 1;}
    * def id = 0
    * def credits = []

    * table payments
      | payment                                                                                                                                                 |
      | {"payment":172600.0,"type":"regular","currency":"RUB","date":"2018-01-01","state":"paid","percent":31068.0,"body":141532.0,"remainCreditBody":858468.0} |
      | {"payment":172600.0,"type":"regular","currency":"RUB","date":"2018-01-02","state":"paid","percent":31068.0,"body":141532.0,"remainCreditBody":716936.0} |
      | {"payment":172600.0,"type":"regular","currency":"RUB","date":"2018-01-03","state":"paid","percent":31068.0,"body":141532.0,"remainCreditBody":575404.0} |
      | {"payment":172600.0,"type":"regular","currency":"RUB","date":"2018-01-04","state":"paid","percent":31068.0,"body":141532.0,"remainCreditBody":433872.0} |
      | {"payment":172600.0,"type":"regular","currency":"RUB","date":"2018-01-05","state":"paid","percent":31068.0,"body":141532.0,"remainCreditBody":292340.0} |
      | {"payment":171890.0,"type":"regular","currency":"RUB","date":"2018-01-06","state":"paid","percent":30940.2,"body":140949.8,"remainCreditBody":151390.2} |
    * table paymentUpcoming
      | payment                                                                                                                                                     |
      | {"payment":172600.0,"type":"regular","currency":"RUB","date":"2018-01-01","state":"upcoming","percent":31068.0,"body":141532.0,"remainCreditBody":858468.0} |

  #Create new credit
  Scenario: pathMatches('/credit') && methodIs('post') && typeContains('json') && requestMatch({"person":{"firstName":'#string',"lastName":'#string'},"amount":'#number',"agreementAt":'#string',"currency":'#string',"duration":'#number',"percent":'#number'} )
    * def cred = request
    * eval id = incr(id)
    * eval cred.payments = payments
    * eval cred.pay_id = 0
    * eval credits.add(cred)
    * def response = {id:'#(id-1)'}

  #Create new payment
  Scenario: pathMatches('/credit/{id}') && methodIs('put') && typeContains('json') && requestMatch({"payment": '#number',"type": '#string',"currency": '#string',"date": '#string'})
    * eval credits[pathParams.id].pay_id = incr(credits[pathParams.id].pay_id)
    * def response = {paymentExecutedAt:'#(request.date)'}

  #Get all payments
  Scenario: pathMatches('/credit/{id}/payments') && paramValue('type') == null && paramValue('state') == null
    * def idP = (credits[pathParams.id] == null ? 0 : credits[pathParams.id].pay_id);
    * def results = []
    * eval for (var i = 0; i < idP; i++) {results.add(payments[i].payment)}
    * eval for (var i = idP; i < 6; i++) {results.add(paymentUpcoming[0].payment)}
    * def response = (credits[pathParams.id] == null ? {message: 'Not found' } : {payments:results});
    * def responseStatus = (credits[pathParams.id] == null ? 404 : 200);

  #Get all paid payments
  Scenario: pathMatches('/credit/{id}/payments') && paramValue('type') == null && paramValue('state') == 'paid'
    * def results = []
    * eval for (var i = 0; i < credits[pathParams.id].pay_id; i++) {results.add(payments[i].payment)}
    * def response = {payments:'#(results)'}

  #Get all upcoming payments
  Scenario: pathMatches('/credit/{id}/payments') && paramValue('type') == null && paramValue('state') == 'upcoming'
    * def results = []
    * eval for (var i = credits[pathParams.id].pay_id; i < credits[pathParams.id].duration; i++) {results.add(payments[i])}
    * def response = {payments:'#(results)'}

  #Get regular or early and paid payments
  Scenario: pathMatches('/credit/{id}/payments') && (paramValue('type') == 'regular' || paramValue('type') == 'early') && paramValue('state') == 'paid'
    * def idP = (credits[pathParams.id] == null ? 0 : credits[pathParams.id].pay_id);
    * def res = []
    * eval for (var i = 0; i < idP; i++) if (payments[i].payment.type == paramValue('type')) {res.add(payments[i].payment)}
    * def res = (res.length == 0 ? null : res)
    * def response = (credits[pathParams.id] == null ? {message: 'Not found' } : response = {payments:res} )

  #Get early and upcoming payments
  Scenario: pathMatches('/credit/{id}/payments') && paramValue('type') == 'early' && paramValue('state') == 'upcoming'
    * def responseStatus = 400
    * def response = {message: 'Bad Request' }

  #Delete credit
  Scenario: pathMatches('/credit/{id}') && methodIs('delete')
    * def responseStatus = 204
    * eval credits[pathParams.id] = null

  #404 error
  Scenario:
    * def responseStatus = 404
    * def response = {message: 'Not found' }
