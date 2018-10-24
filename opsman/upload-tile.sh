#!/bin/bash
set -e
# update these for a   product
PRODUCT_NAME=$1
API_DOWNLOAD_LINK=$2


BASE_URL="$(echo ${API_DOWNLOAD_LINK} | sed  's/product_files.*//g')"
EULA_URL="${BASE_URL}eula_acceptance"
WIN_INJECTOR_URL="${BASE_URL}product_files/200437/download"
#accept eula
curl -k -H "Authorization: Token ${PIVOTAL_NETWORK_API_TOKEN}" -XPOST $EULA_URL

# Download product as FILENAME
wget -c --tries=0 --retry-connrefused --timeout=2 --wait=1 -O $PRODUCT_NAME --post-data="" --header="Authorization: Token ${PIVOTAL_NETWORK_API_TOKEN}" $API_DOWNLOAD_LINK

# Get ops man uaa access token
uaac target $OM_TARGET/uaa --skip-ssl-validation
uaac token owner get opsman $OM_USERNAME -s "" -p $OM_PASSWORD
UAA_ACCESS_TOKEN="$(uaac context | grep -o -P '(?<=access_token: ).*')"

pasw="pas-windows"
if [[ $API_DOWNLOAD_LINK =~ ${pasw} ]];
then
    echo "pas windows, installing winfs-injector"
    wget -c --tries=0 --retry-connrefused --timeout=2 --wait=1 -O winfs-injector.zip --post-data="" --header="Authorization: Token ${PIVOTAL_NETWORK_API_TOKEN}" $WIN_INJECTOR_URL
    unzip winfs-injector.zip
    chmod +x winfs-injector-linux
    echo "running winfs-injector"
    ./winfs-injector-linux --input-tile "${PRODUCT_NAME}" --output-tile "${PRODUCT_NAME}.injected"
    PRODUCT_NAME=${PRODUCT_NAME}.injected
fi

# upload product to ops man
curl --connect-timeout 2 --retry 0 --retry-delay 0 -k "https://localhost/api/v0/available_products" \
    -X POST \
    -H "Authorization: Bearer ${UAA_ACCESS_TOKEN}" \
    -F "product[file]=@./${PRODUCT_NAME}" \
    --progress-bar --verbose -o pcf_api_upload.txt