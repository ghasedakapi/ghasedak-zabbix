#!/bin/bash

# Get the API KEY from your ghasedak account
readonly API_KEY=''

# Parameters passed by Zabbix
to="$1"      # Should contain the value of {ALERT.SENDTO}
from="$2"    # Should contain your Ghasedak phone number (like "300028")
text="$3"    # Should contain the value of {ALERT.MESSAGE} or {ALERT.SUBJECT}

# Log the request details for debugging purposes
echo "$(date) Sending SMS to: $to from: $from with text: $text" >> /tmp/sms_log.txt

# Prepare JSON payload
json_payload=$(cat <<EOF
{
  "sender": "$from",
  "receptor": "$to",
  "message": "$text"
}
EOF
)

# Send the SMS using curl
response=$(curl -s -o /tmp/curl_response.txt -w "%{http_code}" -X POST 'https://gateway.ghasedaksms.com/api/v1/Send/Simple' \
    -H 'accept: */*' \
    -H "ApiKey: ${API_KEY}" \
    -H 'Content-Type: application/json' \
    -d "$json_payload")

# Check the HTTP response code
if [ "$response" -eq 200 ]; then
    echo "$(date) SMS sent successfully to $to" >> /tmp/sms_log.txt
else
    echo "$(date) Failed to send SMS to $to. HTTP Response: $response. Details:" >> /tmp/sms_log.txt
    cat /tmp/curl_response.txt >> /tmp/sms_log.txt
fi
