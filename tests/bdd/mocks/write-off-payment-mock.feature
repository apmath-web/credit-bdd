Feature: stateful mock server

  Background:
    * configure cors = true
    * configure responseHeaders = { 'Content-Type': 'application/json; charset=utf-8' }

  Scenario:
    # catch-all
    * def responseStatus = 204

