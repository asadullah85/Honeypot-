#!/bin/bash
WEBHOOK_URL="Example URL"

ATTACKS=$(docker logs cowrie 2>&1 | grep "login attempt" | wc -l)
LATEST_IP=$(docker logs cowrie 2>&1 | grep "login attempt" | tail -1 | grep -oP '\d+\.\d+\.\d+\.\d+' | head -1)

curl -H "Content-Type: application/json" \
-d "{
  \"embeds\": [{
    \"title\": \"ALERT\",
    \"color\": 16711680,
    \"fields\": [
      {\"name\": \"Total SSH Attempts\", \"value\": \"$ATTACKS\", \"inline\": true},
      {\"name\": \"Latest Attacker IP\", \"value\": \"$LATEST_IP\", \"inline\": true}
    ],
    \"footer\": {\"text\": \"T-Pot HoneyPot Toronto\"}
  }]
}" \
$WEBHOOK_URL
