#!/bin/bash

echo "=================================================="
echo -e "\033[0;35m"
echo "                             .__      ";
echo "   _________.__. ____ _____  |  |__   ";
echo "  / ____<   |  |/ __ \\__  \ |  |  \  ";
echo " < <_|  |\___  \  ___/ / __ \|   Y  \ ";
echo "  \__   |/ ____|\___  >____  /___|  / ";
echo "     |__|\/         \/     \/     \/  ";
echo "                                      ";
echo -e "\e[0m"
echo "=================================================="

sleep 2

echo "=================================================="

echo -e "\e[1m\e[32m1. Input Node Name \e[0m" && sleep 1

while :
do
  read -p "INPUT Node Name: " NODENAME
  if [ -n "$NODENAME" ]; then
    break
  fi
done

echo -e "\e[1m\e[39m    OK ! Node Name is $NODENAME \n \e[0m"

echo "=================================================="

echo -e "\e[1m\e[32m1. Install dependency \e[0m" && sleep 1

sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config protobuf-compiler libssl-dev jq build-essential protobuf-compiler bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

echo "=================================================="

echo -e "\e[1m\e[32m2. Install Rust \e[0m" && sleep 1
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source ~/.cargo/env
rustup default stable
rustup update
rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain nightly

echo "=================================================="

echo -e "\e[1m\e[32m3. Download and Install Binary \e[0m" && sleep 1

mkdir -p $HOME/goldberg
cd $HOME/goldberg

git clone https://github.com/availproject/avail-light.git
cd avail-light

mkdir -p data
git checkout v1.7.3
cargo build --release

cp -r target/release/avail-light /usr/bin
chmod +x /usr/bin/avail-light

echo -e "\e[1m\e[32mAvail Light Version: \e[0m"
echo -e "\e[1m\e[39m    $(avail-light -V) \n \e[0m"

echo "=================================================="

echo -e "\e[1m\e[32m4. Create Service \e[0m" && sleep 1

sudo tee /etc/systemd/system/availightd.service > /dev/null <<EOF
[Unit]
Description=Avail Light Client
After=network-online.target

[Service]
User=$USER
ExecStart=$(which avail-light) --network goldberg
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF


echo "=================================================="

echo -e "\e[1m\e[32m5. Start Service \e[0m" && sleep 1
sudo systemctl daemon-reload
sudo systemctl enable availightd
sudo systemctl restart availightd

echo "=================================================="

echo -e "\e[1m\e[32m6. Logs \e[0m" && sleep 1

sudo journalctl -u availightd -f -o cat

echo "=================================================="
