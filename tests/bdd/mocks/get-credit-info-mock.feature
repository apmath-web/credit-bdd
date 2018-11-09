Feature: stateful mock server

    Background:
        * configure cors = true
        * configure responseHeaders = { 'Content-Type': 'application/json; charset=utf-8' }
        * def credits = {}
        * def person = {}
        * def requestMatch = read('request-match.js')

    #take-credit-mock.feature START
    * def id = 0
    * def credits = []
    * def incr = function(arg) { return arg + 1;}
    #take-credit-mock.feature END

    #Create new credit
    #take-credit-mock.feature START
    Scenario: pathMatches('/credit') && methodIs('post') && typeContains('json') && requestMatch({"person":{"firstName":'#string',"lastName":'#string'},"credit":'#number',"agreementAt":'#string',"currency":'#string',"duration":'#number',"percent":'#number'} )
        * def cred = request
        * eval id = incr(id)
        * eval cred.id = id
        * def payments = []
        * eval cred.payments = payments
        * eval credits.add(cred)
        * def response = {id:'#(id-1)'}
    #take-credit-mock.feature END

    #Get credit info
    Scenario: pathMatches('/credit/{id}') && methodIs('get') && typeContains('json')
        * def response = {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":2000000,"agreementAt":"2018-10-08","currency":"USD","duration":60,"percent":5}

    Scenario:
        * def responseStatus = 404
        * def response = { code: 1, message: 'Not found' }