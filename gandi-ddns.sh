#!/bin/bash

# url for get my IP
CHECK_IP_URL='http://ip.3322.org/'
# Gandi API key
API_KEY='abcdefg123456789'
# host
HOST='ddns.example.com'

# IP RegExp
IPREX='([1-9]?[0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([1-9]?[0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}'
# Get my IP
MYIP=$(curl -k -s $CHECK_IP_URL | grep -Eo "$IPREX" | tail -n1)

if [ -z "$MYIP" ]; then
  echo 'My IP not found. Exit.'
  exit
fi
echo "[My IP]:$MYIP"

# Get DNS record
DNSIP=$(ping -c1 $HOST | grep -Eo "$IPREX" | tail -n1)
echo "[DNS IP]:$DNSIP"

# check DNS IP
if [ "$DNSIP" == "$MYIP" ]; then
  echo 'The Same IP in DNS. Exit.'
  exit
fi

# domain and record-name
DOAMIN_REX='[^\.]*\.[^\.]+$'
RRSET_NAME_REX='^[^.]+'

DOMAIN=$(echo $HOST | grep -Eo "$DOAMIN_REX" | tail -n1)
RRSET_NAME=$(echo $HOST | grep -Eo "$RRSET_NAME_REX" | tail -n1)

# Gandi API url
# see https://api.gandi.net/docs/livedns/
# Single domain's record, by name and type
# https://api.gandi.net/v5/livedns/domains/{fqdn}/records/{rrset_name}/{rrset_type}
API_URL="https://api.gandi.net/v5/livedns/domains/$DOMAIN/records/$RRSET_NAME/A"

# Update DNS records
# body data
JSON="{\"rrset_values\": [\"$MYIP\"], \"rrset_ttl\": 1800}"

UPDATE_RESPONSE=$(curl -s -o /dev/null -i -w %{http_code} $API_URL -X PUT -d "$JSON" -H "Authorization: Apikey $API_KEY" -H 'Content-Type: application/json')

if [ "$UPDATE_RESPONSE" != 201 ]; then
  echo "Error: HTTP Code $UPDATE_RESPONSE. Exit."
  exit
fi

echo "DNS IP updated to $MYIP. End"
