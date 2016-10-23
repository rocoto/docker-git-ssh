FROM ubuntu:14.04

RUN apt-get update \
  && apt-get install -y openssh-server git \
  && locale-gen en_US.UTF-8 \
  && dpkg-reconfigure locales \
  && mkdir /var/run/sshd

RUN useradd -m \
  --home /home/git \
  --shell /bin/bash \
  --user-group \
  --comment "Git Admin" git \
  && mkdir -p /home/git/.ssh \
  && mkdir -p /home/git/repo.git \
  && cd /home/git/repo.git \
  && git init --bare \
  && chown -R git:git /home/git

ADD ./post-receive /home/git/repo.git/hooks/post-receive
ADD ./run.sh /run.sh

WORKDIR /home/git
EXPOSE 22
ENTRYPOINT ["/run.sh"]
CMD ["/usr/sbin/sshd", "-D"]
