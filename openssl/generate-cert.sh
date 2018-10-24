#!/bin/bash
./openssl.cnf.sh
echo "generating pem"
openssl req -nodes -sha256 -new -newkey rsa:2048  -reqexts req_ext -keyout pcf-admin-key.pem  -out csr.pem -config openssl.cnf

echo "generating cert"

#generate

openssl x509 -req -extensions req_ext -extfile openssl.cnf -days 365 -in csr.pem -signkey pcf-admin-key.pem -out pcf-certificate-${DOMAIN}.pem

