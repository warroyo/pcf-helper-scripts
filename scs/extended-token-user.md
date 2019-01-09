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

    `uaac client add --name <client-name> -s '<client-secret>' --scope uaa.none  --authorities 'p-config-server.<unique-id>.read' --access_token_validity <time-in-seconds> --authorized_grant_types client_credentials`

8. generate a new token from the client 

    `curl -k -X POST -d "client_id=<client-name>&client_secret=<client-secret>&grant_type=client_credentials" https://p-spring-cloud-services.uaa.<your-system-url>/oauth/token`

9. copy the `access_token` from the output above and now access your config server

    `curl https://config-<unique-id>.<apps-domain>/?access_token=<access_token>`

    an example may be
    `https://config-ed608d55-be4c-436c-ac6a-844a93dfc002.apps.pas.yourcompany.com/?access_token=eyJhbGciOiJSUzI1NiIsImprdSI6Imh0dHBzOi8vdWFhLnN5cy5wYXMud2Fycm95by5jb20vdG9rZW5fa2V5cyIsImtpZCI6ImtleS0xIiwidHlwIjoiSldUIn0.eyJqdGkiOiJiOTM0MjlmOWU5MzA0YjAxYmM5ZDc4YzQ3ZDE3ZDBlMSIsInN1YiI6ImplbmtpbnMiLCJhdXRob3JpdGllcyI6WyJ1YWEubm9uZSJdLCJzY29wZSI6WyJ1YWEubm9uZSJdLCJjbGllbnRfaWQiOiJqZW5raW5zIiwiY2lkIjoiamVua2lucyIsImF6cCI6ImplbmtpbnMiLCJncmFudF90eXBlIjoiY2xpZW50X2NyZWRlbnRpYWxzIiwicmV2X3NpZyI6IjMzMzdmOTU0IiwiaWF0IjoxNTQ3MDczMTQ5LCJleHAiOjE1NDcwNzcxNDksImlzcyI6Imh0dHBzOi8vdWFhLnN5cy5wYXMud2Fycm95by5jb20vb2F1dGgvdG9rZW4iLCJ6aWQiOiJ1YWEiLCJhdWQiOlsiamVua2lucyJdfQ.hEtpC_E967y2Qud781kws_qaoLGfmlaFPVzqQ8-hvdLzmzeK1fEw75ptPi827jYmpH1tzTpSS5UCYZTmKDIne3Om4jCENWAT4zJsjNRN3JKXqat-xmc540OoQrN17_cLiJGRsLGVzV0sLFzHjlsOsOySZEIq_0QPuBq0jglbQvlBDA8Uts1CfKQrP2h9hXpctrFSSGyh4TvkA0Z2sNEDBuiu1MVFCkJOe9LqWjuW_KnLFfEuEUZ2j0Tz-P1xbvOVhHEGqhMJAUXCi3uEW4O-8Ftn9Q4PpZIMMeABHF0v5Scvs9-y2g6USRIG5ha9aU0jGqWTdta00ixc_MsF3E_sEg.eyJqdGkiOiJlMTc1YWMxOTQ1MmM0ZTRjOWRkZmFmNjMxNDk2YTk2YSIsInN1YiI6ImplbmtpbnMiLCJhdXRob3JpdGllcyI6WyJ1YWEubm9uZSJdLCJzY29wZSI6WyJ1YWEubm9uZSJdLCJjbGllbnRfaWQiOiJqZW5raW5zIiwiY2lkIjoiamVua2lucyIsImF6cCI6ImplbmtpbnMiLCJncmFudF90eXBlIjoiY2xpZW50X2NyZWRlbnRpYWxzIiwicmV2X3NpZyI6IjMzMzdmOTU0IiwiaWF0IjoxNTQ3MDczMDA5LCJleHAiOjE1NDcwNzcwMDksImlzcyI6Imh0dHBzOi8vdWFhLnN5cy5wYXMud2Fycm95by5jb20vb2F1dGgvdG9rZW4iLCJ6aWQiOiJ1YWEiLCJhdWQiOlsiamVua2lucyJdfQ.guiskTRP1hOF5yfmRLvJL1Fe0GvXTVeJEFO7TbR3eRVNrWlOoxYWyVc_i_pOHIsAV8CNIB4h3FyjFu47rJtMred0q5_LTjZAGKbXLgDfLELsMjTs6-XunmmH--9aY3tsO2sGIMNnEY2lTUGqrxOu8ZRODpsfcpSnDXE9WvyivxZEqBb_RIeUC0cTsQxRSbel1Mt0BHuQeDlY0AktM-kEMFmJa6yrzAPn231MFPLmS5XTgif58wWmyyPGP3WDS3J2hEPz0JO6iEa8z_foNl-JrYoD8UUubhR5V_5bNZP138rsN9qp03WMID4tPefF724HRtV_N38VV6ihMctywP4OSg`