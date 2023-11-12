# Avail
Availは、ブロックチェーン・ネットワークを拡張するために設計されたデータ可用性レイヤーを持つモジュール式ブロックチェーンです  

## 1. テストネット情報
### 1.1. 応募フォーム
- Validator / Fullnode  
https://docs.google.com/forms/d/e/1FAIpQLScvgXjSUmwPpUxf1s-MR2C2o5V79TSoud1dLPKVgeLiLFuyGQ/viewform

- Light Client  
https://docs.google.com/forms/d/e/1FAIpQLSeL6aXqz6vBbYEgD1cZKaQ4vwbN2o3Rxys-wKTuKySVR-oS8g/viewform

### 1.2. 公式ドキュメント
- 公式ホームページ  
https://docs.availproject.org/

- Github  
https://github.com/availproject/avail

### 1.3. Avail Explorer
https://telemetry.avail.tools  
https://goldberg.avail.tools

---

## 2. Hardware要件
### 2.1. 最低スペック
- 4GB RAM
- 2core CPU (amd64/x86 architecture)
- 20-40 GB Storage (SSD)

### 2.2. 推奨スペック
- 8GB RAM
- 4core CPU (amd64/x86 architecture)
- 200-300 GB Storage (SSD)

---

## 3. Network要件
### 3.1. Validator / Fullnode
30333 tcp / udp : p2p

### 3.2. Light Client
37000 tcp / udp : p2p

---

## 4. Fullnode Install手順
1. サーバにて下記のコマンドを実行
```
wget -O install-fullnode.sh https://raw.githubusercontent.com/qyeah98/avail/main/install-fullnode.sh && chmod +x install-fullnode.sh && ./install-fullnode.sh
```
* 最初にNodeの名前を入力する箇所があります。この名前をFormに登録して応募します。
* また、一部画面が止まる箇所がありますが、全てEnterを実施してください

2. [Avail Explorer](https://telemetry.avail.tools)にて設定した名前の表示があることを確認
Avail Golberg Testnetのタブを選択  
一番下までスクロール (最初は一番したにある場合が多いです)

3. [Form](https://docs.google.com/forms/d/e/1FAIpQLScvgXjSUmwPpUxf1s-MR2C2o5V79TSoud1dLPKVgeLiLFuyGQ/viewform)に登録

---

## 5. Light Client Install手順
1. サーバにて下記のコマンドを実行
```
wget -O install-light.sh https://raw.githubusercontent.com/qyeah98/avail/main/install-light.sh && chmod +x install-light.sh && ./install-light.sh
```

2. [Form](https://docs.google.com/forms/d/e/1FAIpQLSeL6aXqz6vBbYEgD1cZKaQ4vwbN2o3Rxys-wKTuKySVR-oS8g/viewform)に登録
* 一部画面が止まる箇所がありますが、全てEnterを実施してください
* Light ClientはNodeを動かなさくても応募できます

---

## 6. エンジニア向け Fullnode Install手順 (Binary)

1. 依存関係をInstall
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config protobuf-compiler libssl-dev jq build-essential protobuf-compiler bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

2. RustをInstall
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source ~/.cargo/env
rustup default stable
rustup update
rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain nightly
```

3. Avail BinaryをInstall
```
mkdir -p $HOME/goldberg
cd $HOME/goldberg

git clone https://github.com/availproject/avail.git
cd avail

mkdir -p data
git checkout v1.8.0.0
cargo build --release -p data-avail

cp -r target/release/data-avail /usr/bin
chmod +x /usr/bin/data-avail
```

4. Serviceを作成
* <名前>の箇所を登録したい名前を設定 (ローマ字のみ)
```
sudo tee /etc/systemd/system/availd.service > /dev/null <<EOF
[Unit]
Description=Avail Validator
After=network-online.target

[Service]
User=$USER
ExecStart=$(which data-avail) -d `pwd`/data --chain goldberg --validator --name <名前>
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

5. Avail Nodeの起動
```
sudo systemctl daemon-reload
sudo systemctl enable availd
sudo systemctl restart availd
```

---
## 7. エンジニア向け Light Client Install手順 (Binary)

1. 依存関係をInstall
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config protobuf-compiler libssl-dev jq build-essential protobuf-compiler bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

2. RustをInstall
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source ~/.cargo/env
rustup default stable
rustup update
rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain nightly
```

3. Avail Light BinaryをInstall
```
mkdir -p $HOME/goldberg
cd $HOME/goldberg

git clone https://github.com/availproject/avail-light.git
cd avail-light

mkdir -p data
git checkout v1.7.3
cargo build --release

cp -r target/release/avail-light /usr/bin
chmod +x /usr/bin/avail-light
```

4. Serviceを作成
```
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
```

5. Avail Nodeの起動
```
sudo systemctl daemon-reload
sudo systemctl enable availightd
sudo systemctl restart availightd
```
