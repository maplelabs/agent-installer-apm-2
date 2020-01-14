#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -h Hostname -e ESHostname -p Project -a Application -i inputFile"
   echo -e "\t-h Hostname where agent is installed"
   echo -e "\t-e Elasticsearch Server Name"
   echo -e "\t-p APM Project Name"
   echo -e "\t-a APM Application Name"
   echo -e "\t-i Input file Name"
   exit 1 # Exit script after printing help
}

while getopts "h:e:p:a:i:" opt
do
   case "$opt" in
      h ) hostname="$OPTARG" ;;
      e ) esname="$OPTARG" ;;
      p ) projectname="$OPTARG" ;;
      a ) appname="$OPTARG" ;;
      i ) infile="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$hostname" ] || [ -z "$esname" ] || [ -z "$projectname" ] || [ -z "$appname" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
echo "$hostname"
echo "$esname"
echo "$projectname"
echo "$appname"
sed "s/@h/$hostname/g" $infile > payload.json
sed -i "s/@e/$esname/g" payload.json
sed -i "s/@p/$projectname/g" payload.json
sed -i "s/@a/$appname/g" payload.json
#curl -X POST "localhost:8585/api/config" -d @payload.json -H "Content-Type: application/json"

