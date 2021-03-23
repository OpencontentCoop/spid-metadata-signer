
[![License](https://img.shields.io/github/license/opencontentcoop/spid-metadata-signer.svg)](https://github.com/opencontentcoop/spid-metadata-signer/blob/master/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/opencontentcoop/spid-metadata-signer.svg)](https://github.com/opencontentcoop/spid-metadata-signer/issues)
[![Join the #spid channel](https://img.shields.io/badge/Slack%20channel-%23spid-blue.svg)](https://app.slack.com/client/T6C27AXE0/C7ESTJS58)
[![Get invited](https://slack.developers.italia.it/badge.svg)](https://slack.developers.italia.it/)
[![SPID on forum.italia.it](https://img.shields.io/badge/Forum-spid-blue.svg)](https://forum.italia.it/c/spid/5)
[![Image Build](https://img.shields.io/docker/cloud/build/opencontentcoop/spid-metadata-signer)](https://hub.docker.com/r/opencontentcoop/spid-metadata-signer)

# SPID Metadata Signer

Lo script permette di firmare un metadata SAML utilizzando [XmlSecTool](https://wiki.shibboleth.net/confluence/display/XSTJ3/xmlsectool+V3+Home).

## Requisiti 

### Con docker

Se si usa docker è sufficiente eseguire il comando indicato avendo cura di specificare mappare
nel container i file necessari:

 * il file dei metadata
 * la coppia di file certificato e chiave che saranno usati per la firma

### Senza docker

Per utilizzare lo script senza usare docker è necessario avere:

* [XmlSecTool](http://shibboleth.net/downloads/tools/xmlsectool/latest/xmlsectool-2.0.0-bin.zip) (scaricato e verificato automaticamente dallo script)
* Java
* Unzip
* Metadata compliant alle [Regole Tecniche SPID](http://spid-regole-tecniche.readthedocs.io/en/latest/)
* Chiave e certificato di firma (va bene anche quello utilizzato per la firma delle asserzioni saml)

### Creazione chiave (se necessario)

Per creare una chiave (con password) e un certificato:
```
openssl req -x509 -sha256 -days 365 -newkey rsa:2048 -keyout nome-chiave.key -out nome-certificato.crt
```

Nota bene: un certificato generato con questo comando avrà durata di 1 anno

Per rimuovere la password alla chiave:
```
openssl rsa -in your.encrypted.key -out your.key
```

Per aggiungere la password alla chiave:
```
openssl rsa -des3 -in your.key -out your.encrypted.key
```

## Utilizzo

### Procedura di firma con docker

Se avete i file necessari nella directory del vostro computer in `/home/lorello/spid` eseguite
il comando che segue:

    docker run -it --rm -e METADATA=/data/metadata.xml -e KEY=/data/key.pem -e CRT=/data/crt.pem -v $(pwd):/data opencontentcoop/spid-metadata-signer

Dopo l'esecuzione troverete il file firmato in `/home/lorello/spid/metadata.xml-signed`

*N.B.: se i vostri file hanno nomi diversi da `metadata.xml` o `crt.pem` dovete adattare il comando
usando i vostri nomi di file*

### Procedura di firma attraverso script 

* Scaricare e scompattare la release o clonare il repository
* Inserire la chiave e il certificato nella cartella "certs" (vanno bene anche quelli utilizzati per la firma delle asserzioni SAML)
* Inserire il metadata non firmato nella cartella "metadata/metadata-in"
* Eseguire lo script:

```
./spidMetadataSigner.sh
```

Verranno richiesti i seguenti parametri:

* nome del metadata da firmare (senza estensione - es: .xml)
* nome della chiave (con estensione - es: .key)
* password della chiave, se presente, altrimenti lasciare vuota
* nome del certificato (con estensione - es: .crt)
* JAVA_HOME (se non presente) lo script suggerirà il path

Alla fine della procedura il metadata firmato sarà caricato nella cartella "metadata/metadata-out"

### Procedura di firma manuale

Lo script automatizza e semplifica il comando di firma metadata tramite XmlSecTool:

Scaricare XmlSecTool:
* [Pacchetto precompilato](http://shibboleth.net/downloads/tools/xmlsectool/latest/xmlsectool-2.0.0-bin.zip)
* via Homebrew (OS X): ```brew install xmlsectool```

Impostare JAVA_HOME
```
export JAVA_HOME=/path/java/home

Per conoscere il path per JAVA_HOME (Java deve essere installato sul sistema):
Linux: echo $(dirname $(dirname $(readlink -f $(which javac))))
MacOS: echo $(/usr/libexec/java_home)
```

Eseguire XmlSecTool
```
xmlsectool.sh --sign --referenceIdAttributeName ID --inFile "metadata-non-firmato.xml" --outFile "metadata-firmato.xml" --digest SHA-256 --signatureAlgorithm http://www.w3.org/2001/04/xmldsig-more#rsa-sha256 --key "certificato.key" --keyPassword "password" --certificate "certificato.crt
```

Specificare --keyPassword "password" solo se la chiave è con password


### Note

* lo script funziona su sistemi Linux e MacOS
* nelle cartelle "metadata-in" e "metadata-out" è presente un esempio di metadata non firmato (metadata-in) e di uno firmato (metadata-out)
* nella cartella "certs" è presente chiave (con e senza password) e certificato di prova, la password della chiave è "test".

Si raccomanda di utilizzare i file di esempio solo per test.
