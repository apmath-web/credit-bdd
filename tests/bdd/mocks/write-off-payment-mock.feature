Feature: stateful mock server

  Background:
    * configure cors = true
    * configure responseHeaders = { 'Content-Type': 'application/json; charset=utf-8' }
    * def date = "2017-12-01"
    #* def dateToString = function(date) {   return date.year+ "-" + Math.floor(date.month/10)*10  + date.month% 10  + "-" + Math.floor(date.day/10)*10  + date.day % 10 };
    #* def stirngToDate = function(string) {var a=string.split('-'); return {year : +a[0], month: +a[1], day: +a[2]}}
  #<copy-pasted-part>
    * def id = 0
    * def credits = {}
    * def incr = function(arg) { return arg + 1;}
    * def requestMatch = read('request-match.js')
    * def current = -1
    * table payments
      | payments                                                                                                                                                      |
      | [{"type":"regular","state":"next","date":"2018-01-01","payment":169200,"percent":4247,"body":164953,"remainCreditBody":1000000,"fullEarlyRepayment":1014425}] |
      | [{"type":"regular","state":"next","date":"2018-02-01","payment":169200,"percent":3203,"body":165997,"remainCreditBody":835047,"fullEarlyRepayment":845225}]   |
      | [{"type":"regular","state":"next","date":"2018-03-01","payment":169200,"percent":2750,"body":166450,"remainCreditBody":669050,"fullEarlyRepayment":676025}]   |
      | [{"type":"regular","state":"next","date":"2018-04-01","payment":169200,"percent":2134,"body":167066,"remainCreditBody":502600,"fullEarlyRepayment":506825}]   |
      | [{"type":"regular","state":"next","date":"2018-05-01","payment":169200,"percent":1379,"body":167821,"remainCreditBody":335534,"fullEarlyRepayment":337625}]   |
      | [{"type":"regular","state":"next","date":"2018-05-01","payment":17900,"percent":146,"body":17754,"remainCreditBody":35534,"fullEarlyRepayment":35800}]        |
      | []                                                                                                                                                            |



  #Creating credit
  Scenario: pathMatches('/credit') && methodIs('post') && typeContains('json') &&requestMatch({"person":{"firstName":'#string',"lastName":'#string'},"amount":'#number',"agreementAt":'#string',"currency":'#string',"duration":'#number',"percent":'#number'} )
    * def cred = request
    * eval id = incr(id)
    * eval cred.id = id
    * eval credits[id] = cred
    * def response = {id:'#(id)'}
  #</copy-pasted-part>

  #Geting next payment
  Scenario: pathMatches('/credit/{id}/payments') && methodIs('get') && typeContains('json') && paramValue('state') == 'next' 
  #&& requestMatch({"payments":"#array"}) 
    * eval current = incr(current)
    * def responseStatus = 200
    * def response = payments[current]

   #Payment with full data
  Scenario: pathMatches('/credit/{id}') && methodIs('put') && typeContains('json') && requestMatch({"payment":"#number","type":"#string","currency":"#string","date":"#string"}) 
    * def tempDate = date
    * def date = (tempDate >= request.date  || request.type == "early") ? date : request.date
    * def responseStatus = (tempDate >= request.date || request.type == "early") ? 400 : 200
    * def r1 = {"message" : "Credit not Found"}
    * def r2 = {"paymentExecutedAt" : "#(date)"}
    * def response = (tempDate >= request.date  || request.type == "early") ? r1 : r2

  #Payment with worng currency
  Scenario: pathMatches('/credit/{id}') && methodIs('put') && typeContains('json') && requestMatch({"payment": "#number", "currency":"#string"})
    * def responseStatus = 400
    * eval if (credits[id].currency === request.currency) { date = request.date; credits[id].credit -= request.payment; responseStatus = 200 }  
    * def response = (credits[id].currency === request.currency) ? {"paymentExecuteAt" : "#(dateToString(date))"} : {"message": "Credit not found."} 

  #Payment with date
  Scenario: pathMatches('/credit/{id}') && methodIs('put') && typeContains('json') && requestMatch({"payment": "#number", "date":"#string"}) 
    * def tempDate = date
    * def date = (tempDate >= request.date) ? date : request.date
    * def responseStatus = (tempDate >= request.date) ? 400 : 200
    * def r1 = {"message" : "Credit not Found"}
    * def r2 = {"paymentExecutedAt" : "#(date)"}
    * def response = (tempDate >= request.date) ? r1 : r2


  #First payment
  Scenario: pathMatches('/credit/{id}') && methodIs('put') && typeContains('json') && requestMatch({"payment": "#number"})
    * def date = "2018-01-01"
    #* eval credits[pathParams.id].amount -= request.payment
    * def response = {"paymentExecutedAt" : "#(date)"}

  #Delete credit
  Scenario: pathMatches('/credit/{id}') && methodIs('delete')
    * def responseStatus = 204
    * eval credits[pathParams.id] = {}

  Scenario:
    # catch-all
    * def responseStatus = 204

