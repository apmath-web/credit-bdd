Feature: stateful mock server

    Background:
        * configure cors = true
        * configure responseHeaders = { 'Content-Type': 'application/json; charset=utf-8' }
        * def credits = {}
        * def person = {}
        * def requestMatch = read('request-match.js')

    * def id = 0
    * def credits = []
    * def incr = function(arg) { return arg + 1;}
    * def credit = ''

    #Create new credit
    Scenario: pathMatches('/credit') && methodIs('post') && typeContains('json') && requestMatch({"person":{"firstName":'#string',"lastName":'#string'},"amount":'#number',"agreementAt":'#string',"currency":'#string',"duration":'#number',"percent":'#number'})
        * def cred = request
        * eval credit = request
        * eval id = incr(id)
        * eval credits.add(cred)
        * def response = {id:'#(id-1)'}

    #Get credit info
    Scenario: pathMatches('/credit/{id}') && methodIs('get') && typeContains('json')
        * def response = (credits[pathParams.id] == null ? {message: "Not found"} : credit)
        * def responseStatus = (credits[pathParams.id] == null ? 404 : 200)

    #Delete credit
    Scenario: pathMatches('/credit/{id}') && methodIs('delete')
        * def responseStatus = 204
        * eval credits[pathParams.id] = null

    Scenario:
        * def responseStatus = 404
        * def response = { code: 1, message: 'Not found' }
