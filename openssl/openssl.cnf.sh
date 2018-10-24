cat << EOF > openssl.cnf
[req]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C=$COUNTRY
ST=$STATE
L=$CITY
O=$COMPANY
OU=IT
CN = *.$DOMAIN


[ req_ext ]
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.sys.$DOMAIN
DNS.2 = *.login.sys.$DOMAIN
DNS.3 = *.uaa.sys.$DOMAIN
DNS.4 = *.apps.$DOMAIN
EOF