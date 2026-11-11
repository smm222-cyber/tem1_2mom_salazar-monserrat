FROM crs4/hadoopclient:3.2.1

USER root

ADD https://archive.apache.org/dist/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz /opt/

RUN tar -xzf /opt/apache-hive-3.1.2-bin.tar.gz -C /opt \
    && mv /opt/apache-hive-3.1.2-bin /opt/hive \
    && rm /opt/apache-hive-3.1.2-bin.tar.gz \
    && rm /opt/hive/lib/guava-*.jar \
    && cp /opt/hadoop/share/hadoop/hdfs/lib/guava-*.jar /opt/hive/lib/ \
    && echo 'export HIVE_HOME=/opt/hive; export PATH=$PATH:/opt/hive/bin' > /etc/profile.d/hive.sh \
    && /opt/hive/bin/schematool -dbType derby -initSchema

ENV HIVE_HOME=/opt/hive
ENV PATH=$PATH:/opt/hive/bin

WORKDIR /opt/hive-work

CMD ["tail", "-f", "/dev/null"]
