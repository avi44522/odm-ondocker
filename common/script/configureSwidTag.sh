#!/bin/bash

function removeSwidTag () {
        local swidtagToRemove=$1
        if [ -f $swidtagToRemove ]; then
                echo "remove $swidtagToRemove"
                rm $swidtagToRemove
        fi
}

function removeAllSwidTag () {
	local swidtagToRemove=$1
        removeSwidTag /config/apps/decisioncenter.war/META-INF/swidtag/$swidtagToRemove
        removeSwidTag /config/apps/decisionmodel.war/META-INF/swidtag/$swidtagToRemove
        removeSwidTag /config/apps/decisioncenter-api.war/META-INF/swidtag/$swidtagToRemove
        removeSwidTag /config/apps/teamserver.war/META-INF/swidtag/$swidtagToRemove

        removeSwidTag /config/apps/DecisionRunner.war/META-INF/swidtag/$swidtagToRemove
        removeSwidTag /config/apps/DecisionService.war/META-INF/swidtag/$swidtagToRemove
        removeSwidTag /config/apps/res.war/META-INF/swidtag/$swidtagToRemove
}

if [ -n "$KubeVersion" ]
then
  if [[ $KubeVersion =~ "icp" ]] || [[ $KubeVersion =~ "ODM on K8s" ]]
  then
    if [ -n "$DEPLOY_FOR_PRODUCTION" ]
    then
    	if [[ "$DEPLOY_FOR_PRODUCTION" =~ "TRUE" ]]
        then
        	echo "DEPLOY_FOR_PRODUCTION is true then ODM production configuration : remove ODM non production Swidtag"
        	removeAllSwidTag ibm.com_IBM_ODM_Server_for_Non-Production-*.swidtag
    	else
        	echo "DEPLOY_FOR_PRODUCTION is false then ODM non production configuration : remove ODM production Swidtag"
        	removeAllSwidTag ibm.com_IBM_ODM_Server-*.swidtag
    	fi
    else
      echo "DEPLOY_FOR_PRODUCTION not set then ODM production configuration : remove ODM non production Swidtag"
      removeAllSwidTag ibm.com_IBM_ODM_Server_for_Non-Production-*.swidtag
    fi
  else
    echo "DBAMC configuration : remove all ODM Swidtag"
    removeAllSwidTag ibm.com_IBM_ODM_Server*.swidtag
    removeAllSwidTag ibm.com_IBM_ODM_Server_for_Non-Production*.swidtag
  fi
fi
