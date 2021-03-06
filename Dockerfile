FROM openjdk:11-jdk

LABEL maintainer="orlando.curieles@ingeint.com"

ENV IDEMPIERE_VERSION 7.1
ENV IDEMPIERE_HOME /opt/idempiere
ENV IDEMPIERE_PLUGINS_HOME $IDEMPIERE_HOME/plugins
ENV IDEMPIERE_LOGS_HOME $IDEMPIERE_HOME/log
ENV IDEMPIERE_DAILY https://owncloud.ingeint.com/public.php\?service\=files\&t\=2fc4a2251b9196edea4c6f2ec041a848\&download

WORKDIR $IDEMPIERE_HOME

RUN apt-get update && \
    apt-get install -y --no-install-recommends nano postgresql-client && \
    apt-get install -y unzip && \
    rm -rf /var/lib/apt/lists/*

RUN wget -q $IDEMPIERE_DAILY -O /tmp/idempiere-server.zip && \
    echo "Hash: $(md5sum /tmp/idempiere-server.zip)" > $IDEMPIERE_HOME/MD5SUMS && \
    echo "Date: $(date)" >> $IDEMPIERE_HOME/MD5SUMS && \
    unzip -q -o /tmp/idempiere-server.zip -d /tmp && \
    mv /tmp/x86_64/* $IDEMPIERE_HOME && \
    rm -rf /tmp/idempiere*
RUN cat $IDEMPIERE_HOME/MD5SUMS
RUN ln -s $IDEMPIERE_HOME/idempiere-server.sh /usr/bin/idempiere

COPY docker-entrypoint.sh $IDEMPIERE_HOME
COPY idempiere-server.sh $IDEMPIERE_HOME

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["idempiere"]
