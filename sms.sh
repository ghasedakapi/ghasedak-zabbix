#!/bin/bash

# Get the API KEY from your ghasedak.io account
readonly API_KEY=''

to="$1" # Should contain the value of {ALERT.SENDTO}
from="$2" # Should contain your Ghasedak phone number
text="$3" # Should container the value of {ALERT.MESSAGE} or {ALERT.SUBJECT}

echo "$(date) ${text} ${from} $to" >> /tmp/log.txt

curl -X POST "http://api.ghasedak.io/v2/sms/send/simple" \
	-H "apikey: ${API_KEY}" \
	-H 'cache-control: no-cache' \
	-H 'content-type: application/x-www-form-urlencoded' \
	-d "message=${text}&linenumber=${from}&receptor=${to}" 2>&1 >> /tmp/log.txt
