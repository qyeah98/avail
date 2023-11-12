# Avail
Availは、ブロックチェーン・ネットワークを拡張するために設計されたデータ可用性レイヤーを持つモジュール式ブロックチェーンです  

## テストネット情報
### 応募フォーム
- Validator / Fullnode  
https://docs.google.com/forms/d/e/1FAIpQLScvgXjSUmwPpUxf1s-MR2C2o5V79TSoud1dLPKVgeLiLFuyGQ/viewform

- Light Client  
https://docs.google.com/forms/d/e/1FAIpQLSeL6aXqz6vBbYEgD1cZKaQ4vwbN2o3Rxys-wKTuKySVR-oS8g/viewform

### 公式ドキュメント
https://docs.availproject.org/
https://github.com/availproject/avail

### Avail Explorer
https://telemetry.avail.tools
https://goldberg.avail.tools


## Hardware要件
### 最低スペック
- 4GB RAM
- 2core CPU (amd64/x86 architecture)
- 20-40 GB Storage (SSD)

### 推奨スペック
- 8GB RAM
- 4core CPU (amd64/x86 architecture)
- 200-300 GB Storage (SSD)

## Network要件
### Validator / Fullnode
30333 tcp / udp : p2p

### Light Client
37000 tcp / udp : p2p

## Fullnode Install手順
```
wget -O install-fullnode.sh https://raw.githubusercontent.com/qyeah98/avail/main/install-fullnode.sh && chmod +x install-fullnode.sh && ./install-fullnode.sh
```

## Light Client Install手順
```
wget -O install-light.sh https://raw.githubusercontent.com/qyeah98/avail/main/install-light.sh && chmod +x install-light.sh && ./install-light.sh
```
