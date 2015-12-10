FROM ubuntu-oracle-java8:14.04-u66

RUN apt-get update && apt-get install -y curl

# grab gosu for easy step-down from root
RUN arch="$(dpkg --print-architecture)" \
	&& set -x \
	&& curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$arch" \
	&& chmod +x /usr/local/bin/gosu

RUN wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

ENV ELASTICSEARCH_MAJOR 2.1
ENV ELASTICSEARCH_VERSION 2.1.0
ENV ELASTICSEARCH_REPO_BASE http://packages.elastic.co/elasticsearch/2.x/debian

RUN echo "deb $ELASTICSEARCH_REPO_BASE stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list

RUN set -x \
        && apt-get update \
	&& apt-get install -y --no-install-recommends elasticsearch=$ELASTICSEARCH_VERSION \
	&& rm -rf /var/lib/apt/lists/*

ENV PATH /usr/share/elasticsearch/bin:$PATH

RUN set -ex \
	&& for path in \
		/usr/share/elasticsearch/data \
		/usr/share/elasticsearch/logs \
		/usr/share/elasticsearch/config \
		/usr/share/elasticsearch/config/scripts \
	; do \
		mkdir -p "$path"; \
		chown -R elasticsearch:elasticsearch "$path"; \
	done

COPY config /usr/share/elasticsearch/config

COPY docker-entrypoint.sh /

WORKDIR /root

RUN wget https://download.elastic.co/kibana/kibana/kibana-4.3.0-linux-x64.tar.gz

WORKDIR /usr/share

RUN tar -xzf /root/kibana-4.3.0-linux-x64.tar.gz \
  && ln -s kibana-4.3.0-linux-x64 kibana \
  && cd /bin \
  && ln -s /usr/share/kibana/bin/kibana kibana \
  && cd / \
  && kibana plugin --install elastic/sense

VOLUME /usr/share/elasticsearch/data

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5601 9200 9300

CMD ["elasticsearch"]
