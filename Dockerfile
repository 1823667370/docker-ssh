# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.txt INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#docker run -d -p 5022:22
#在宿主主机测试 ssh 192.168.10.241 -p 5022
FROM selenium/hub
LABEL authors=songer

USER root

#安装ssh服务
RUN apt-get update&&apt-get install -y openssh-server
#要正常启动ssh服务，需要目录/var/run/ssd存在
RUN mkdir -p /var/run/sshd
#在root用户下创建.ssh目录，并复制需要登录的公钥信息（一般为本地主机用户目录下的.ssh/id_rsa.pub文件，
#可由ssh-keygen -t rsa命令生成，cat /root/.ssh/id_rsa.pub >authorized-keys）到authorized-keys文件中
RUN mkdir -p /root/.ssh

#取消pam登录限制
RUN sed -ri 's/session required pam_loginuid.so/#session required pam_loginuid.so/g' /etc/pam.d/sshd
#添加认证文件和启动脚本
ADD authorized_keys /root/.ssh/authorized_keys
ADD run.sh /root/run.sh
#RUN echo "#!/bin/bash" > /root/run.sh
#RUN echo "/usr/sbin/sshd -D" >> /root/run.sh
RUN chmod u+x /root/run.sh

#暴露端口
EXPOSE 22
#设置默认启动ssh的命令
#CMD ["/root/run.sh"]
