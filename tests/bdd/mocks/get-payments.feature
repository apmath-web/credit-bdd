Feature: stateful mock server

  Background:
    * configure cors = true
    * configure responseHeaders = { 'Content-Type': 'application/json; charset=utf-8' }
    * def requestMatch = read('request-match.js')

    #Probably later implementation
    #call read('classpath:take-credit.feature') config
    #call read('classpath:pay-credit.feature') config
    #call read('classpath:delete-credit.feature') config
    #take-credit-mock.feature START
    * def id = 0
    * def credits = []
    * def incr = function(arg) { return arg + 1;}
    #take-credit-mock.featureEND

    * def selectWithType = function(jsObjects,type){var results=[]; jsObjects.forEach(function(age){if(type==age.type)results.push(age)});return results}

  #Create new credit
  #take-credit-mock.feature START
  Scenario: pathMatches('/credit') && methodIs('post') && typeContains('json') && requestMatch({"person":{"firstName":'#string',"lastName":'#string'},"credit":'#number',"agreementAt":'#string',"currency":'#string',"duration":'#number',"percent":'#number'} )
    * def cred = request
    * eval id = incr(id)
    * eval cred.id = id
    #take-credit-mock.feature PAUSE
    * def payments = []
    * eval cred.payments = payments
    #take-credit-mock.feature RESUME
    * eval credits.add(cred)
    * def response = {id:'#(id-1)'}
  #take-credit-mock.feature END

  #Create new payment
  Scenario: pathMatches('/credit/{id}') && methodIs('put') && typeContains('json') && requestMatch({"payment": '#number',"type": '#string',"currency": '#string',"date": '#string'})
    * def payment = request
    * eval credits[pathParams.id].payments.add(payment)
    * def response = {paymentExecutedAt:'#(request.date)'}

  Scenario: pathMatches('/credit/{id}/payments') && (paramValue('type') == 'regular'||paramValue('type') == 'early') && paramValue('state') == 'paid'
    * def response = selectWithType(credits[pathParams.id].payments, paramValue('type'))

  Scenario: pathMatches('/credit/{id}/payments') && paramValue('type') == 'regular' && paramValue('state') == 'upcoming'
    * def response = selectWithType(credits[pathParams.id].payments, paramValue('type'))

  Scenario: pathMatches('/credit/{id}/payments') && paramValue('type') == 'early' && paramValue('state') == 'upcoming'
    * def responseStatus = 404
    * def response = { code: 1, message: 'Not implemented yet, in develop' }

  #Delete credit
  Scenario: pathMatches('/credit/{id}') && methodIs('delete')
    * def responseStatus = 204
    * def credit = []

  #404 error
  Scenario:
    * def responseStatus = 404
    * def response = { code: 1, message: 'Not found' }

