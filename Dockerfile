FROM openjdk:11

WORKDIR /opt

RUN curl -OJ https://shibboleth.net/downloads/tools/xmlsectool/latest/xmlsectool-3.0.0-bin.zip && \
    unzip -qq xmlsectool-3.0.0-bin.zip && \
    rm -f xmlsectool-3.0.0-bin.zip 

COPY spidMetadataSigner.sh /usr/bin/spid-metadata-signer

CMD [ "/usr/bin/spid-metadata-signer" ]
