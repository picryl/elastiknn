FROM adoptopenjdk/openjdk13:latest
COPY ./ /src
WORKDIR /src
RUN apt-get update && \
	apt -y install make software-properties-common && \
        add-apt-repository -y ppa:git-core/ppa && \
        apt update && \
        apt -y install git && \
	make .mk/gradle-publish-local

FROM docker.elastic.co/elasticsearch/elasticsearch:7.9.2
COPY --from=0 /src/elastiknn-plugin/build/distributions/elastiknn-0.1.0-PRE40_es7.9.2.zip /tmp/
RUN elasticsearch-plugin  install file:///tmp/elastiknn-0.1.0-PRE40_es7.9.2.zip --batch && rm /tmp/elastiknn-0.1.0-PRE40_es7.9.2.zip
