#!/bin/bash

ACMEHOME=/config/.acme.sh
CA_BUNDLE=/config/ssl/cacert.pem

mkdir -p ${ACMEHOME}/dnsapi /config/scripts /config/ssl
curl -o ${ACMEHOME}/acme.sh https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh
curl -o ${ACMEHOME}/dnsapi/dns_azure.sh https://raw.githubusercontent.com/acmesh-official/acme.sh/master/dnsapi/dns_azure.sh
curl -o /config/scripts/renew.acme.sh https://raw.githubusercontent.com/eschweighofer/ubnt-acme.sh/master/renew.acme.sh
chmod 755 ${ACMEHOME}/acme.sh ${ACMEHOME}/dnsapi/dns_azure.sh /config/scripts/renew.acme.sh

if [ -s ${CA_BUNDLE} ]; then
    curl https://curl.se/ca/cacert.pem -z ${CA_BUNDLE} -o ${CA_BUNDLE}
else
    curl -k https://curl.se/ca/cacert.pem -o ${CA_BUNDLE}
fi

if ! [ -f ${ACMEHOME}/account.conf ]; then
    touch ${ACMEHOME}/account.conf
fi

sed -i "/^CA_BUNDLE='${CA_BUNDLE//\//\\/}'\$/h;\${x;/^\$/{s//CA_BUNDLE='${CA_BUNDLE//\//\\/}'/;H};x}" ${ACMEHOME}/account.conf
