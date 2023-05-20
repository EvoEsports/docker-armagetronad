#!/bin/sh
set -euo pipefail

bindir="/usr/local/bin"
basedir="/armagetron"
datadir="${basedir}/data"
userdatadir="${basedir}/userdata"
configdir="${basedir}/config"
userconfigdir="${basedir}/userconfig"
resourcedir="${basedir}/resource"
autoresourcedir="${basedir}/autoresource"
vardir="${basedir}/var"

touch ${vardir}/input.txt

if [ -z ${MASTERSERVER+x} ]; then
    set -- "${bindir}/armagetronad-dedicated" \
    --datadir ${datadir} \
    --userdatadir ${userdatadir} \
    --configdir ${configdir} \
    --userconfigdir ${userconfigdir} \
    --resourcedir ${resourcedir} \
    --autoresourcedir ${autoresourcedir} \
    --vardir ${vardir} \
    --input ${vardir}/input.txt
else
    set -- "${bindir}/armagetronad-master" \
    --datadir ${datadir} \
    --userdatadir ${userdatadir} \
    --configdir ${configdir} \
    --userconfigdir ${userconfigdir} \
    --resourcedir ${resourcedir} \
    --autoresourcedir ${autoresourcedir} \
    --vardir ${vardir}
fi

exec "$@"