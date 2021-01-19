#!/bin/sh

set -e

id omadad

# set default time zone and notify user of time zone
TZ="${TZ:-Etc/UTC}"
export TZ

ls -l /etc/localtime
rm /etc/localtime
ln -s /usr/share/zoneinfo/$TZ /etc/localtime
ls -l /etc/localtime

echo "INFO: Time zone set to '${TZ}'"

# make sure permissions are set appropriately on each directory
for DIR in data work logs
do
  OWNER="$(stat -c '%u' /opt/tplink/OmadaController/${DIR})"
  GROUP="$(stat -c '%g' /opt/tplink/OmadaController/${DIR})"

  if [ "${OWNER}" != "508" ] || [ "${GROUP}" != "508" ]
  then
    # notify user that uid:gid are not correct and fix them
    echo "WARNING: owner or group (${OWNER}:${GROUP}) not set correctly on '/opt/tplink/OmadaController/${DIR}'"
    echo "INFO: setting correct permissions"
    chown -R 508:508 "/opt/tplink/OmadaController/${DIR}"
  fi
done

# append smallfiles if set to true
if [ "${SMALL_FILES}" = "true" ]
then
  echo "INFO: Enabling smallfiles"
  sed -i "s#eap.mongod.args=\(.*\)#eap.mongod.args=--smallfiles \1#" /opt/tplink/OmadaController/properties/mongodb.properties 
fi

# check to see if there is a db directory; create it if it is missing
if [ ! -d "/opt/tplink/OmadaController/data/db" ]
then
  echo "INFO: Database directory missing; creating '/opt/tplink/OmadaController/data/db'"
  mkdir /opt/tplink/OmadaController/data/db
  chown 508:508 /opt/tplink/OmadaController/data/db
  echo "done"
fi

#export JAVA_HOME=/usr/lib/jvm/jdk-8-oracle-arm32-vfp-hflt/jre
#export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-armhf/jre
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-armhf/jre

echo "INFO: Starting Omada Controller"
set -x
exec gosu omadad "${@}"
