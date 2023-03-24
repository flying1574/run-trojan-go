#!/bin/bash
echo 
-e "\033[47;31m You need open 80,443 Port \033[0m"
echo -e "\033[47;31m You need open 80,443 Port \033[0m"
echo -e "\033[47;31m You need open 80,443 Port \033[0m"
domain=azhk.onebin.me
password=Wdnmd1234.
apt-get -y install wget unzip nginx socat
systemctl stop nginx
wget https://github.com/p4gefau1t/trojan-go/releases/download/v0.10.6/trojan-go-linux-amd64.zip
unzip trojan-go-linux-amd64.zip -d trojan
cd trojan

cat > config.json <<EOF
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 443,
    "remote_addr": "0.0.0.0",
    "remote_port": 80,
    "password": [
        "$password"
    ],
    "ssl": {
        "cert": "server.cert",
        "key": "server.key"
    }
}
EOF


curl https://get.acme.sh | sh
ln -s  /root/.acme.sh/acme.sh /usr/local/bin/acme.sh
acme.sh --register-account -m admin@3acloud.com
acme.sh  --issue -d ${domain}  --standalone -k ec-256
cp /root/.acme.sh/${domain}_ecc/fullchain.cer /root/trojan/server.cert
cp /root/.acme.sh/${domain}_ecc/$domain.key /root/trojan/server.key
acme.sh --installcert -d azhk.onebin.me --ecc  --key-file   /root/trojan/server.key   --fullchain-file /root/trojan/server.cert
systemctl start nginx
nohup /root/trojan/trojan-go > trojan.log 2>&1 &
