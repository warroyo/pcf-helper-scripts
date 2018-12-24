#!/bin/sh
set -e

password_length=12

read -p "This will remove existing users, are you sure? [Yy] "  -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  for row in $(cat ./users.json | jq -r '.[] | @base64'); do
    name=$(echo ${row} | base64 --decode | jq -r '.name')
    echo "deleting user \"${name}\""
    cf delete-user -f ${name} $password
done
rm logins.txt
fi
