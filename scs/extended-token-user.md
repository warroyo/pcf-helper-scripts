# Description

this document will explain how to create a client for SCS that has read access and an arbitrary token expiration. this could be useful for creating an oauth client that has tokens that can last longer than the default 30 second max. these could be used  by external services to CF that cannot handle being a normal oauth client.

# Steps

1. ssh to your bosh director ex. `10.0.0.10` this ip could be different.


2. connect to credhub
   
    `credhub api  --server 10.0.0.10:8844 --ca-cert /var/tempest/workspaces/default/root_ca_certificate`

3. login to credhub using the credentials `uaa_admin_user_credentials` these can be found in the bosh director tile credntials section.

    `credhub login`

4. search for the spring cloud broker uaa credentials

    `credhub find | grep SCS-WORKER-CLIENT-SECRET`

5. get the credentials from that entry

    `credhub get -n /p-bosh/p-spring-cloud-services-<some-id>/SCS-WORKER-CLIENT-SECRET`

6. login to the scs uaa with that client

    `uaac target --skip-ssl-validation https://p-spring-cloud-services.uaa.<your-system-url>`

    your system url will be something like `sys.pas.company.com`

    `uaac token client get p-spring-cloud-services-worker -s <secret-from-above>`

7. create a new client 

    `uaac client add --name <client-name> -s '<client-secret>' --scope uaa.none --access_token_validity <time-in-seconds> --authorized_grant_types client_credentials`

8. generate a new token from the client 

    `curl -k -X POST -d "client_id=<client-name>&client_secret=<client-secret>&grant_type=client_credentials" https://p-spring-cloud-services.uaa.<your-system-url>/oauth/token`

9. copy the `access_token` from the output above and now access your config server

 `curl https://config-<unique-id>.<apps-domain>/?access_token=<access_token>`

 an example may be `https://config-ed608d55-be4c-446c-ac7a-844a99dfc002.apps.pas.yourcompany.com`