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

    * eval code = 200

    * def typeFlag  =
    """
    function(arg)
    {
        if (!parseInt(arg, 10))
        {
            return 'false';
        }
        else
        {
            return  'true';
        }
    }
    """

    * def find_id =
    """
    function(arg)
    {
        for (var current_id in credit)
        {
            if(credit[current_id] == arg)
            {
                return "true";
            }
        }
        return "false";
    }
    """

    * def getResponse =
    """
        function(arg)
        {
            var isCorrect = typeFlag(arg);
            if (isCorrect == "true")
            {
                var isFound = find_id(arg);
                if (isFound === "true")
                {
                    code = 200;
                    return "Done";
                }
                else
                {
                    code = 404;
                    return "Not exist";
                }
            }
            else
            {
                code = 400;
                return "Uncorrect";
            }
        }
    """
  Scenario: pathMatches('/credit/delete/{id}')
    * def id = pathParams.id
    * def result = call getResponse id 
    * def responseStatus = code
    * def response = {message: '#(result)'}