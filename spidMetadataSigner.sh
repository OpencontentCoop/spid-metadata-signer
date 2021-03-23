#!/bin/bash

set -e 
[[ -n $DEBUG ]] && set -x

echo -e "\n"
echo "==============================================="
echo "              Developers Italia                "
echo "==============================================="
echo "  SPID Sistema Pubblico di Identità Digitale   "
echo "==============================================="
echo "           SPID Metadata Signer v1.0           "
echo "             community edition :-)             "
echo "==============================================="
echo -e "\n"


# Nome del file metadata
metadataFileName=$METADATA
while [ -z "${metadataFileName}" ]
do
    read -p "> Digita il pathname del metadata da firmare (es: /data/metadata.xml): " metadataFileName
done
echo -e "\n"

# Nome della chiave
keyName=$KEY
while [ -z "${keyName}" ]
do
    read -p "> Digita il pathname della chiave (con estensione es: ./my-spid.key): " keyName
done
echo -e "\n"

# Password della chiave (non specificare se non presente)
read -s -p "> Digita la password della chiave (se presente): " keyPass
if [ ! -z "$keyPass" ]; then
    commandPass="--keyPassword $keyPass"
fi
echo -e "\n"

# Nome del certificato
crtName=$CRT
while [ -z "${crtName}" ]
do
    read -p "> Digita il pathname del certificato (con estensione es: /tmp/my-cert.pem): " crtName
done
echo -e "\n"

# Firma del metadata
echo "Firma del metadata: $metadataFileName"
echo "Il file firmato verrà salvato in ${metadataFileName}-signed"

./xmlsectool-3.0.0/xmlsectool.sh --sign --referenceIdAttributeName ID \
  --inFile "$metadataFileName" --outFile "$metadataFileName-signed" \
  --digest SHA-256 --signatureAlgorithm http://www.w3.org/2001/04/xmldsig-more#rsa-sha256 \
  --keyFile "$keyName" $commandPass --certificate "$crtName"

echo -e "\n"

