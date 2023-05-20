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

mkdir ${vardir}
touch ${vardir}/input.txt

if [ "$MASTERSERVER" = true ]; then
    set -- "/armagetron/bin/armagetronad-master" \
    --datadir ${datadir} \
    --userdatadir ${userdatadir} \
    --configdir ${configdir} \
    --userconfigdir ${userconfigdir} \
    --resourcedir ${resourcedir} \
    --autoresourcedir ${autoresourcedir} \
    --vardir ${vardir} \
    --input ${vardir}/input.txt
else
    set -- "/armagetron/bin/armagetronad-dedicated" \
    --datadir ${datadir} \
    --userdatadir ${userdatadir} \
    --configdir ${configdir} \
    --userconfigdir ${userconfigdir} \
    --resourcedir ${resourcedir} \
    --autoresourcedir ${autoresourcedir} \
    --vardir ${vardir} \
    --input ${vardir}/input.txt
fi

exec "$@"

/armagetron/bin/armagetronad-dedicated --datadir /armagetron/data --configdir /armagetron/config