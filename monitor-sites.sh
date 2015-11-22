#!/bin/bash

SITESFILE=sites.txt #list the sites you want to monitor in this file
EMAILS="kieranmcgowan@yahoo.com" #list of email addresses to receive alerts (comma separated)

while read site; do
 if [ ! -z "${site}" ]; then
   if [[ "${site}" != "#"* ]]; then 
        
        CURL=$(curl -s --insecure --head $site)
  
        if echo $CURL | grep "200 OK" > /dev/null
        then
            echo "The HTTP server on ${site} is up!"
        else    

            MESSAGE="This is an alert that site ${site} has failed to respond 200 OK."

            for EMAIL in $(echo $EMAILS | tr "," " "); do
                SUBJECT="$site (http) Failed"
                echo "$MESSAGE" | mail -s "$SUBJECT" $EMAIL
                echo $SUBJECT
                echo "Alert sent to $EMAIL"
            done      
        fi
	sleep 5
   fi
fi
done < $SITESFILE
