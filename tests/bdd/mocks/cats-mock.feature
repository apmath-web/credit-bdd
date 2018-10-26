Feature: stateful mock server

  Background:
    * configure cors = true
    * configure responseHeaders = { 'Content-Type': 'application/json; charset=utf-8' }
    * def uuid = function(){ return java.util.UUID.randomUUID() + '' }
    * def cats = {}
    * def requestMatch = read('request-match.js')

  Scenario: pathMatches('/cats') && methodIs('post') && typeContains('json') && requestMatch({ name: '#string' })
    * def cat = request
    * def id = uuid()
    * set cat.id = id
    * eval cats[id] = cat
    * def response = cat

  Scenario: pathMatches('/cats') && methodIs('get') && typeContains('json')
    * def response = $cats.*

  Scenario: pathMatches('/cats/{id}') && methodIs('get') && typeContains('json')
    * def response = cats[pathParams.id]

  Scenario:
    # catch-all
    * def responseStatus = 400
    * def response = { code: 400, message: 'Invalid request' }

