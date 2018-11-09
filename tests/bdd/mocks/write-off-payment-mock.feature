Feature: stateful mock server

  Background:
    * configure cors = true
    * configure responseHeaders = { 'Content-Type': 'application/json; charset=utf-8' }
    * def date = new Date(2017, 11, 1)
    * def dateInc = function(date) { date.setMonth(date.getMonth() + 1) };
    * def dateToString = function(date) {   return date.getFullYear() + "-" + date.getMonth() + 1 + "-" + Math.floor(date.getDate()/10)*10  + date.getDate() % 10 };
  #<copy-pasted-part>
    * def id = 0
    * def credits = {}
    * def incr = function(arg) { return arg + 1;}
    * def requestMatch = read('request-match.js')
  #Creating credit
  Scenario: pathMatches('/credit') && methodIs('post') && typeContains('json') &&requestMatch({"person":{"firstName":'#string',"lastName":'#string'},"credit":'#number',"agreementAt":'#string',"currency":'#string',"duration":'#number',"percent":'#number'} )
    * def cred = request
    * eval id = incr(id)
    * eval cred.id = id
    * eval credits[id] = cred
    * def response = {id:'#(id)'}
  #</copy-pasted-part>

  #Payment with worng currency
  Scenario: pathMatches('/credit/{id}') && methodIs('put') && typeContains('json') && requestMatch({"payment": "#number", "currency":"#string"})
    * def responseStatus = 400
    * eval if (credits[id].currency === request.currency) { dateInc(date); credits[id].credit -= request.payment; responseStatus = 200 }  
    * def response = (credits[id].currency === request.currency) ? {"paymentExecuteAt" : "#(dateToString(date))"} : {"code" : -1, "message": "Credit not found."} 

  #First payment
  Scenario: pathMatches('/credit/{id}') && methodIs('put') && typeContains('json') && requestMatch({"payment": "#number"})
    * eval dateInc(date)
    * eval credits[id].credit -= request.payment
    * def response = {"paymentExecutedAt" : "#(dateToString(date))"}

  Scenario:
    # catch-all
    * def responseStatus = 204

