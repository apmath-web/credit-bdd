Feature: stateful mock server

  Background:
    * configure cors = true
    * configure responseHeaders = { 'Content-Type': 'application/json; charset=utf-8' }
    * def id = 0
    * def credits = {}
    * def incr = function(arg) { return arg + 1;}
    * def requestMatch = read('request-match.js')

  Scenario: pathMatches('/credit') && methodIs('post') && typeContains('json') &&requestMatch({"person":{"firstName":'#string',"lastName":'#string'},"credit":'#number',"agreementAt":'#string',"currency":'#string',"duration":'#number',"percent":'#number'} )
    * def cred = request
    * eval id = incr(id)
    * eval cred.id = id
    * eval credits[id] = cred
    * def response = {id:'#(id)'}

  Scenario: pathMatches('/credit') && methodIs('get') && typeContains('json')
    * def response = credits

  Scenario:
    # catch-all
    * def responseStatus = 400
    * def response = { message: "Invalid request format", description: {something: "wrong"} }
