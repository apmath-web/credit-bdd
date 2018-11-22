Feature: stateful mock server

Background:
	* configure cors = true
	* configure responseHeaders = { 'Content-Type': 'application/json; charset=utf-8' }
	* def id = 8
	* def flag = {}

Scenario: pathMatches('/credit') && methodIs('post')
	* def response = {id:'#(id)'}

Scenario: pathMatches('/credit/delete/{id}') && pathParams.id == 8
	* def responseStatus = (flag[0] != 1 ? 400 : 204)

Scenario: pathMatches('/credit/delete/{id}') && (pathParams.id == 0 || pathParams.id == 1 || pathParams.id == 2 || pathParams.id == 3 || pathParams.id == 4 || pathParams.id == 5 || pathParams.id == 6 || pathParams.id == 7 || pathParams.id == 9 )
	* def responseStatus = 404

Scenario: pathMatches('/credit/delete/{id}')
	* def responseStatus = 400

Scenario: pathMatches('/credit/{id}') && methodIs('get')
	* def responseStatus = 404

Scenario: pathMatches('/credit')
	* eval flag[0] = 1
	* def responseStatus = 200
