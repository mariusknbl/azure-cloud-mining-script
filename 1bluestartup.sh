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
            \"url\": \"turtlecoin.herominers.com:10381\",
            \"user\": \"TRTLv2ZZFo9U39opHvhZTAZf26hex6JqGWpYr1sFBa2xFuwJoy4mWexEKnKLzPnbrdE7EEGzeBFzZDTic8R1khbmetXzYWo6Ge9\",
            \"pass\": \"server1\",
            \"keepalive\": true,
            \"tls\": true
        }
    ]
}" > config.json
systemctl start xmrig.service
systemctl enable xmrig.service
