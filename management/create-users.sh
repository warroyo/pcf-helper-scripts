#!/bin/sh
set -e

password_length=12


_jq() {
     echo ${1} | base64 --decode | jq -r ${2}
}

for row in $(cat ./users.json | jq -r '.[] | @base64'); do
    
    username=$(echo $(_jq ${row} '.name'))
    spaces=$(echo $(_jq ${row} '.spaces'))
    orgs=$(echo $(_jq ${row} '.orgs'))
    echo "generating password"
    password=$(pwgen $password_length 1)
    echo "creating user \"${username}\""
    cf create-user ${username} $password
    echo "adding org roles to ${username}"
    for org in $(echo ${orgs} | jq -r '.[] | @base64'); do
        name=$(echo $(_jq ${org} '.name') )
        role=$(echo $(_jq ${org} '.role') )
        cf set-org-role $username $name $role
    done
    echo "adding space roles to ${username}"
    for space in $(echo ${spaces} | jq -r '.[] | @base64'); do
        name=$(echo $(_jq ${space} '.name') )
        role=$(echo $(_jq ${space} '.role') )
        orgname=$(echo $(_jq ${space} '.orgname') )
        cf set-space-role $username $orgname $name $role
    done

    echo "$username:$password" >> logins.txt

done
