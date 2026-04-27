#!/bin/bash
workdir=~/etcd
cd $workdir
#安装工具cfssl
chmod +x cfssl*
mv cfssl_linux-amd64 /usr/local/bin/cfssl
mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
mv cfssl-certinfo_linux-amd64 /usr/local/bin/cfssl-certinfo 
ls -l /usr/local/bin/cfssl /usr/local/bin/cfssljson /usr/local/bin/cfssl-certinfo 

#生成证书
#生成 ca 证书请求文件 
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
echo "ca请求文件已生成-->>>"

#生成 etcd 证书
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes etcd-csr.json | cfssljson -bare etcd
ls etcd*.pem
echo "etcd 证书文件已生成-->>>"

#移动配置、证书和启动文件
cp ca*.pem /etc/etcd/ssl/
cp etcd*.pem /etc/etcd/ssl/
cp etcd.conf /etc/etcd/
cp etcd.service /usr/lib/systemd/system/

#copy到etcd2-3
for i in master2 master3;do rsync -vaz /etc/etcd/ssl/*.pem $i:/etc/etcd/ssl/;done
for i in master2 master3;do rsync -vaz etcd.service $i:/usr/lib/systemd/system/;done
