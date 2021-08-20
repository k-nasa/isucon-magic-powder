
## dstat

```sh
dstat -tlnr --top-cpu --top-mem --top-io --top-bio
```

## sar

### install

```
sudo apt install sysstat -y
```

/etc/default/sysstat を編集してENABLEDをtrueに

```
ENABLED="true"
```

sysstatを再起動
```
sudo systemctl restart sysstat
```

## top (htop)

topコマンドの操作コマンド

| | |
|---|---|
|M|     メモリ使用量が多いもの順|
|N|     プロセスID順|
|P|     CPUの使用時間率の長いもの順|
|T|     実行時間が長い順|
|q|     topコマンドの終了|
|u|     特定のユーザー権限のプロセスだけ|
