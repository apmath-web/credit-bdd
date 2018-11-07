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

    * def selectWithType =
    """
    function (jsObjects, type) {
        var results = [];
        jsObjects.forEach(function (result) {
            if (type === result.type) results.push(result)
        });
        return results
    }
    """
    * def getPayments =
    """
    function () {
        var duration = credits[pathParams.id].duration;
        for (var i = 0; i < payments.length; i++) {
            results.add(payments[i])
        }
        for (var i = payments.length; i < duration; i++) {
            results.add({'type':'regular','state':'paid','date':'2018-10-08','payment':22300,'percent':10000.10,'body':12299.90,'remainCreditBody':907704.11,'fullEarlyRepayment':908704})
        }
        return results
    }
    """
    * def createPayment =
    """
    function (pay) {
        payment.type = pay.type;
        payment.state = 'paid';
        payment.date = pay.date;
        payment.payment = pay.payment;
        payment.percent = pay.payment*0.18;
        payment.body = payment.payment-payment.percent;
        credits[pathParams.id].credit -= payment.body;
        payment.remainCreditBody = credits[pathParams.id].credit;

        return payment;
    }
    """


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
    * def payment = createPayment(request)
    * eval credits[pathParams.id].payments.add(payment)
    * def response = {paymentExecutedAt:'#(request.date)'}

  #Get all payments
  Scenario: pathMatches('/credit/{id}/payments') && (paramValue('type')=='regular'||paramValue('type')=='early'||paramValue('type')==null) && paramValue('state')==null
    * def results = []
    * def payments = credits[pathParams.id].payments
    * def results = getPayments()
    * def response = {payments:'#(results)'}

  Scenario: pathMatches('/credit/{id}/payments') && paramValue('type') == 'regular' && paramValue('state') == 'upcoming'
    * def response = selectWithType(credits[pathParams.id].payments, paramValue('type'))

  Scenario: pathMatches('/credit/{id}/payments') && paramValue('type') == 'early' && paramValue('state') == 'upcoming'
    * def responseStatus = 404
    * def response = { code: 1, message: 'Not implemented yet, in develop' }

  #Delete credit
  Scenario: pathMatches('/credit/{id}') && methodIs('delete')
    * def responseStatus = 204
    * eval credits[pathParams.id] = {}

  #404 error
  Scenario:
    * def responseStatus = 404
    * def response = { code: 1, message: 'Not found' }

