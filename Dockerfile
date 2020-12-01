FROM centos:8.1.1911
RUN if [ `uname -m` = "aarch64" ] ; then \
       cp kubernetes_arm64.repo /etc/yum.repos.d; \
       echo "Hi"; \
    else \
       cp kubernetes.repo /etc/yum.repos.d; \
       echo "Hello"; \
    fi
#COPY kubernetes.repo /etc/yum.repos.d
RUN yum -y install kubeadm-1.19.4
