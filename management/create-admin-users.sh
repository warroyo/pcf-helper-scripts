#!/bin/sh
set -e

password_length=12


for ((n=1;n<=${1};n++))
do
 username="ops_user_${n}"
 password=$(pwgen $password_length 1)

 uaac user add ${username} -p $password --emails ${username}@localhost.com

 uaac member add cloud_controller.admin ${username}
 uaac member add uaa.admin ${username}
 uaac member add scim.read ${username}
 uaac member add scim.write ${username}


 echo "$username:$password" >> admin-logins.txt
done
