#!/bin/bash

if [ -n "$DECISION_SERVICE_URL" ]; then
	echo "Update DECISION_SERVICE_URL to $DECISION_SERVICE_URL in Decision Server Console."
	sed -i 's|/DecisionService|'$DECISION_SERVICE_URL'|g' $APPS/res.war/WEB-INF/web.xml
fi

if [ -f "/config/baiemitterconfig/plugin-configuration.properties" ]; then
	echo "Enable BAI Emitter Plugin"
        sed -i 's/{pluginClass=HTDS}/&,{pluginClass=ODMEmitterForBAI}/' ra.xml
fi

if [ -f "/config/baiemitterconfig/krb5.conf" ]; then
	echo "Configure Kerberos authentication"
	echo "-Djava.security.krb5.conf=/config/baiemitterconfig/krb5.conf" >> /config/jvm.options
fi

if [ -n "$RELEASE_NAME" ]
then
  echo "Prefix decision server console cookie names with $RELEASE_NAME"
        sed -i 's|RELEASE_NAME|'$RELEASE_NAME'|g' /config/httpSession.xml
else
  echo "Prefix decision server console cookie names with $HOSTNAME"
        sed -i 's|RELEASE_NAME|'$HOSTNAME'|g' /config/httpSession.xml
fi

if [ -s "/config/auth/openIdParameters.txt" ]
then
  echo "replace resAdministators/resConfigManagers/resInstallers/resExecutors group in /config/application.xml"
  sed -i $'/<group name="resAdministrators"/{e cat /config/authOidc/resAdministrators.xml\n}' /config/application.xml
  sed -i '/<group name="resAdministrators"/d' /config/application.xml
  sed -i $'/<group name="resDeployers"/{e cat /config/authOidc/resDeployers.xml\n}' /config/application.xml
  sed -i '/<group name="rtsDeployers"/d' /config/application.xml
  sed -i $'/<group name="resMonitors"/{e cat /config/authOidc/resMonitors.xml\n}' /config/application.xml
  sed -i '/<group name="resMonitors"/d' /config/application.xml
  sed -i $'/<group name="resExecutors"/{e cat /config/authOidc/resExecutors.xml\n}' /config/application.xml
  sed -i '/<group name="resExecutors"/d' /config/application.xml
else
  echo "No provided /config/auth/openIdParameters.txt"
fi
