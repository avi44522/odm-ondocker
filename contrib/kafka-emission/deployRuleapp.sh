#!/bin/bash

curl -i --header "accept: application/xml"  --header "Content-type: application/octet-stream" -X POST --data-binary @./ruleApp_LoanValidationDS_1.0.jar http://resAdmin:resAdmin@$localhost:9060/res/apiauth/ruleapps -k
