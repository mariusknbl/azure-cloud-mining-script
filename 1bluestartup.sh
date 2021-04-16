#!/bin/bash
apt update
apt upgrade -y
sudo apt-get install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev -y
git clone https://github.com/xmrig/xmrig.git
mkdir xmrig/build && cd xmrig/build
perl -pi -e 's/1/0/g' ../src/donate.h
cmake ..
make -j$(nproc)
cd /etc/systemd/system
echo "[Install]
WantedBy=multi-user.target
[Service]
ExecStart=/root/xmrig/build/xmrig" > xmrig.service
cd /root/xmrig/build
echo "{
    \"autosave\": true,
    \"cpu\": true,
    \"opencl\": false,
    \"cuda\": false,
    \"pools\": [
        {
            \"algo\": \"argon2/chukwav2\",
            \"url\": \"pool.hashvault.pro:3333\",
            \"user\": \"TRTLv2nb9jn7e6EGsTrLfAWWFfH8nTNVgeckVHDkBHqHJ7ihwSzTULPLYfgLHx2wYbUCSmPYWcB9Wgh12n7BMkF6DuqrLYNbrDC\",
            \"pass\": \"3blue\",
            \"keepalive\": true,
            \"tls\": true
        }
    ]
}" > config.json
systemctl start xmrig.service
systemctl enable xmrig.service
