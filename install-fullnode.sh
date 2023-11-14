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

git clone https://github.com/availproject/avail.git
cd avail

mkdir -p data
git checkout v1.8.0.0
cargo build --release -p data-avail

cp -r target/release/data-avail /usr/bin
chmod +x /usr/bin/data-avail

echo -e "\e[1m\e[32mAvail Version: \e[0m"
echo -e "\e[1m\e[39m    $(data-avail -V) \n \e[0m"

echo "=================================================="

echo -e "\e[1m\e[32m4. Create Service \e[0m" && sleep 1
sudo tee /etc/systemd/system/availd.service > /dev/null <<EOF
[Unit]
Description=Avail Validator
After=network-online.target

[Service]
User=$USER
ExecStart=$(which data-avail) -d `pwd`/data --chain goldberg --validator --name $NODENAME
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

echo "=================================================="

echo -e "\e[1m\e[32m5. Start Service \e[0m" && sleep 1
sudo systemctl daemon-reload
sudo systemctl enable availd
sudo systemctl restart availd

echo "=================================================="

echo -e "\e[1m\e[32m6. Logs \e[0m" && sleep 1

echo -e "\e[1m\e[32mTo Check log : "sudo journalctl -u availd -f -o cat" \e[0m"
echo -e "\e[1m\e[32mTo Stop log : "Ctrl + c" \e[0m" && sleep 1
sudo journalctl -u availd -f -o cat

echo "=================================================="
