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
    Scenario: pathMatches('/credit') && methodIs('post') && typeContains('json') && requestMatch({"person":{"firstName":'#string',"lastName":'#string'},"credit":'#number',"agreementAt":'#string',"currency":'#string',"duration":'#number',"percent":'#number'})
        * def cred = request
        * eval id = incr(id)
        * eval cred.id = id
        * def payments = []
        * eval cred.payments = payments
        * eval credits.add(cred)
        * def response = {id:'#(id-1)'}

    #Get credit info
    Scenario: pathMatches('/credit/{id}') && methodIs('get') && typeContains('json')
        * def result = {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":1000000,"agreementAt":"2018-10-08","currency":"RUB","duration":6,"percent":5}
        * def response = (credits[pathParams.id] == null ? {message: "Not found"} : result)
        * def responseStatus = (credits[pathParams.id] == null ? 404 : 200)

    #Delete credit
    Scenario: pathMatches('/credit/{id}') && methodIs('delete')
        * def responseStatus = 204
        * eval credits[pathParams.id] = null

    Scenario:
        * def responseStatus = 404
        * def response = { code: 1, message: 'Not found' }