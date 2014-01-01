# SSH-DOCKER
#
# VERSION       1

FROM centos

MAINTAINER yoshiso

RUN yum -y update

#Dev tools for all Docker
RUN yum -y install git vim

RUN yum -y install passwd openssh openssh-server openssh-clients sudo


# create user

RUN useradd yoshiso
RUN passwd -f -u yoshiso
RUN mkdir -p /home/yoshiso/.ssh;chown yoshiso /home/yoshiso/.ssh; chmod 700 /home/yoshiso/.ssh
ADD ./authorized_keys /home/yoshiso/.ssh/authorized_keys
RUN chown yoshiso /home/yoshiso/.ssh/authorized_keys;chmod 600 /home/yoshiso/.ssh/authorized_keys

# setup sudoers
RUN echo "yoshiso ALL=(ALL) ALL" >> /etc/sudoers.d/yoshiso

# setup sshd
ADD ./sshd_config /etc/ssh/sshd_config
RUN /etc/init.d/sshd start;/etc/init.d/sshd stop

# expose for sshd
EXPOSE 2222

CMD ["/usr/sbin/sshd","-D"]