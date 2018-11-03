Feature: stateful mock server

  Background:
    * configure cors = true
    * configure responseHeaders = { 'Content-Type': 'application/json; charset=utf-8' }
    * def credit = {}
    * eval credit[0] = 1
    * eval credit[1] = 2
    * eval credit[2] = 3
    * eval credit[3] = 4
    * eval credit[4] = 5

  Scenario: pathMatches('/credit/delete/{id}')
  	* def id = pathParams.id
  	* def find_id =
	"""
	function(arg)
	{
		for (var current_id in credit)
	  	{
	  		if(credit[current_id] == arg)
	  		{
	  			return "deleted";
	  		}
	  	}
	  	return 'not exist';
	}
	"""
	* def result = call find_id id
	* def code = (result == 'deleted' ?  200 :  400)
	* def responseStatus = code
	* def response = {message : '#(result)'}