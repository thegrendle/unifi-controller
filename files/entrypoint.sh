#!/bin/bash

NAME="unifi"
BASEDIR="/usr/lib/unifi"
DATADIR=${UNIFI_DATA_DIR:-/var/lib/${NAME}}
LOGDIR=${UNIFI_LOG_DIR:-/var/log/${NAME}}
RUNDIR=${UNIFI_RUN_DIR:-/var/run/${NAME}}

UNIFI_CORE_ENABLED=${UNIFI_CORE_ENABLED:-"false"}
UNIFI_JVM_OPTS=${UNIFI_JVM_OPTS:-"-Xmx1024M -XX:+UseParallelGC"}

exec /usr/bin/java \
    -Dfile.encoding=UTF-8 \
    -Djava.awt.headless=true \
    -Dapple.awt.UIElement=true \
    -Dunifi.core.enabled=${UNIFI_CORE_ENABLED} \
    $UNIFI_JVM_OPTS \
    -XX:+ExitOnOutOfMemoryError \
    -XX:+CrashOnOutOfMemoryError \
    -XX:ErrorFile=${BASEDIR}/logs/hs_err_pid%p.log \
    -Dunifi.datadir=${DATADIR} \
    -Dunifi.logdir=${LOGDIR} \
    -Dunifi.rundir=${RUNDIR} \
    -jar ${BASEDIR}/lib/ace.jar start 
