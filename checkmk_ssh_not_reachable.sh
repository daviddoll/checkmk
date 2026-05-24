### local check for Checkmk (Linux)
### Exits with status "2" (error) when SSH service is reachable and "0" (ok) if SSH service is not reachable

### Date of last change: 2026-05-24
### Version 0.1

#!/bin/bash

IP='10.152.65.3'
PORT='22'

/usr/bin/wget --spider --timeout=1 --tries=2 --quiet http://$IP:$PORT

if [ $? -eq 0 ]; then
  echo 2 "SSH" - SSH ist über die IP $IP ist erreichbar - Bitte prüfen!

else
  echo 0 "SSH" - SSH ist über die IP $IP nicht erreichbar - Gut so!

fi
