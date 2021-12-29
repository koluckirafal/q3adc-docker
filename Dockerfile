FROM alpine:latest as builder

ENV COPYDIR /tmp/dist
ENV BUILD_CLIENT 0
ENV BUILD_SERVER 1
ENV USE_CURL 1
ENV USE_CODEC_OPUS 0
ENV USE_VOIP 0

ADD ./lilium-arena-classic source
RUN \
  apk --no-cache add curl g++ gcc git make unzip && \
  mkdir -p $COPYDIR && \
  cd source && \
  make && \
  make copyfiles

FROM alpine:latest
RUN adduser quake3 -D
COPY --chown=quake3 --from=builder /tmp/dist /home/quake3
RUN mv /home/quake3/liliumarenaclassic-server.* /home/quake3/liliumarenaclassic-server

ADD ./baseq3 /home/quake3/baseq3
ADD ./dcmappack.zip /home/quake3/baseq3/dcmappack.zip
RUN \
  chown quake3 -R /home/quake3/baseq3 && \
  cd /home/quake3/baseq3/ && \
  unzip dcmappack.zip dc-mappack.pk3 && \
  rm dcmappack.zip
USER quake3
EXPOSE 27960/udp
VOLUME ["/home/quake3/baseq3"]
CMD ["/home/quake3/liliumarenaclassic-server", "+exec server.cfg"]
