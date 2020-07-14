# Gandi-DDNS

通过利用Gandi的API，来搭建私人的DDNS服务。

## 使用方法

### 参数配置

- `CHECK_IP_URL`
  
  获取公网IP的网址。如果获取不到IP，会判定为联网失败，脚本会直接退出。可选的有`http://ip.3322.org` `http://myip.ipip.net`，或其他可用的网址。

- `API_KEY`
  
  Gandi的API key。可访问Gandi帐户中心 (https://account.gandi.net/) 的`Security`页面生成。

- `HOST`
  
  需要解析的子域名。例如`ddns.example.com` `xx.example.com`。 **注意：所填写的域名必须已经存在解析记录。** 如果不存在，需要自己先手动添加一次解析。

### 安装

下载此脚本到服务器中，并配置参数。使用`/bin/bash ./gandi-ddns.sh`运行。
或者给予该脚本可执行权限`chmod +x ./gandi-ddns.sh`，通过`./gandi-ddns.sh`运行。

### 计划任务(crontab)

linux自带计划任务程序`crontab`。假设脚本文件位于`/home/<user>/gandi-ddns.sh`。
可使用以下命令：
```bash
echo "* * * * * /bin/bash /home/<user>/gandi-ddns.sh &> /dev/null" | sudo tee -a /etc/crontab > /dev/null
```
