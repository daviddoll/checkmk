### local check for Checkmk (Linux)
### Exits with status "2" (error) when IP is reachable and "0" (ok) if IP is not reachable

### Date of last change: 2026-05-24
### Version 0.1

#!/bin/bash

IP='10.152.65.12'

/usr/bin/fping -c3 -t300 $IP 2>/dev/null 1>/dev/null

if [ "$?" = 0 ]
then
  echo 2 "CIMC_IP" - CIMC IP $IP ist erreichbar - Bitte prüfen!

else
  echo 0 "CIMC_IP" - CIMC IP $IP ist nicht erreichbar - Gut so!

fi
