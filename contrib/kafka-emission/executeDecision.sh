#!/bin/bash

# Invoke an execution with Curl
CALLREST=$(curl -i --header "accept: application/xml" --header "Content-type: application/json; charset=UTF-8" --data @./loanpayload.json -X POST  http://resAdmin:resAdmin@localhost:9060/DecisionService/rest/LoanValidationDS/loan_validation_production)
echo "Result of the RESTAPI call : $CALLREST"
if [[ $CALLREST =~ .*"Too big Debt/Income ratio".* ]]; then
	echo "Execution seems correct."
else
	echo  "the execution does not return the correct message."
	exit 1
fi
