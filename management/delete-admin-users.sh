#!/bin/sh
set -e



for ((n=1;n<=${1};n++))
do
 username="ops_user_${n}"

 uaac user delete ${username} 

done
