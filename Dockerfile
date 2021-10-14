FROM ubi8


ARG GOGS_VERSION=0.12.3

LABEL name="Gogs - Go Git Service" \
      vendor="Gogs" \
      io.k8s.display-name="Gogs - Go Git Service" \
      io.k8s.description="The goal of this project is to make the easiest, fastest, and most painless way of setting up a self-hosted Git service." \
      summary="The goal of this project is to make the easiest, fastest, and most painless way of setting up a self-hosted Git service." \
      io.openshift.expose-services="3000,gogs" \
      io.openshift.tags="gogs" \
      release="${GOGS_VERSION}"

ENV HOME=/home/gogs

COPY ./root /

RUN curl -o gogs.zip https://dl.gogs.io/${GOGS_VERSION}/gogs_${GOGS_VERSION}_linux_amd64.zip && \
    yum -y --setopt=tsflags=nodocs install nss_wrapper gettext && \
    yum -y install unzip git && \
    yum -y clean all && \
    mkdir -p /opt/gogs && \
    mkdir -p /opt/gogs/data && \
    unzip gogs.zip -d /opt/gogs && \
    adduser --uid 1000 --gid 0 gogs && \
    /usr/bin/fix-permissions ${HOME} && \
    /usr/bin/fix-permissions /opt/gogs

EXPOSE 3000
USER gogs

CMD ["/usr/bin/rungogs"]
