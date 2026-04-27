#!/bin/bash
#!/bin/bash
workdir=~/etcd
cd $workdir

#部署
tar -xf etcd-v3.4.13-linux-amd64.tar.gz
cp -p etcd-v3.4.13-linux-amd64/etcd* /usr/local/bin/

#创建启动数据目录
mkdir -p /var/lib/etcd/default.etcd 



systemctl daemon-reload 
systemctl enable etcd.service
systemctl start etcd.service 
systemctl status etcd