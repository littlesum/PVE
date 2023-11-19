# 没有IPv4公网，Plex 设置 IPv6访问

## 准备条件
- domain name 你需要有域名一枚
- 公网IPv6地址 IPv6 address
- 证书获取工具 推荐使用 acme.sh

## 主机环境 Host is PVE



### 安装 acme.sh Install acme.sh

- 命令

		curl https://get.acme.sh | sh -s email=my@example.com

- 添加 acme.sh 启动环境，安装 acme.sh 到 home 目录下
	
	`~/.acme.sh/`

- 并创建 一个 shell 的 alias, 例如 .bashrc，方便你的使用:
  `alias acme.sh=~/.acme.sh/acme.sh`
  
- 启用环境
  
  `source .bashrc`
### 生成证书

- 手动 dns 方式

	```
	这种方式的好处是, 你不需要任何服务器, 不需要任何公网 ip, 只需要 dns 的解析记录即可	完成验证. 坏处是，如果不同时配置 Automatic DNS API，使用这种方式 acme.sh 将无法	自动更新证书，每次都需要手动再次重新解析验证域名所有权。
	```
	
	```
	acme.sh --issue --dns -d mydomain.com \
	 --yes-I-know-dns-manual-mode-enough-go-ahead-please
	```
	然后, acme.sh 会生成相应的解析记录显示出来, 你只需要在你的域名管理面板中添加这条 txt 记录即可.

	等待解析完成之后, 重新生成证书:
	
  ```
	acme.sh --renew -d mydomain.com \
	--yes-I-know-dns-manual-mode-enough-go-ahead-please
	
	```
	
	注意第二次这里用的是 --renew

	dns 方式的真正强大之处在于可以使用域名解析商提供的 api 自动添加 txt 记录完成验证.


​	
- api 认证方式

  **acme.sh** 目前支持 cloudflare, dnspod, cloudxns, godaddy 以及 ovh 等数十种解析商的自动集成.
  
  以 dnspod 为例, 由于我用的 dnspod 的域名服务。 你需要先登录到 dnspod 账号, 生成你的 api id 和 api key, 都是免费的. 然后:
  
  ```
  export DP_Id="1234"
  
  export DP_Key="sADDsdasdgdsf"
  
  acme.sh --issue --dns dns_dp -d aa.com -d www.aa.com
  
  ```
  
  证书就会自动生成了. 这里给出的 api id 和 api key 会被自动记录下来, 将来你在使用 dnspod api 的时候, 就不需要再次指定了. 直接生成就好了:
  
  ```
  acme.sh --issue -d mydomain2.com --dns  dns_dp
  ```
  
- copy/安装 证书

  注意, 默认生成的证书都放在安装目录下: `~/.acme.sh/`, 请不要直接使用此目录下的文件, 例如: 不要直接让 nginx/apache 的配置文件使用这下面的文件. 这里面的文件都是内部使用, 而且目录结构可能会变化.
  
  正确的使用方法是使用 `--install-cert` 命令,并指定目标位置, 然后证书文件会被copy到相应的位置, 例如:
  
  ## Apache example:
  
  ```
  acme.sh --install-cert -d example.com \
  --cert-file      /path/to/certfile/in/apache/cert.pem  \
  --key-file       /path/to/keyfile/in/apache/key.pem  \
  --fullchain-file /path/to/fullchain/certfile/apache/fullchain.pem \
  --reloadcmd     "service apache2 force-reload"
  ```



## Plex 证书准备

- 自定义域支持 PKCS #12 文件路径，其中包含启用 TLS 的证书和私钥。

	由于 Plex 需要 PKCS#12 证书，我们需要把通过 acme.sh 获取的证书转换一下。
	
	`openssl pkcs12 -export -out yourdomain.pfx -inkey yourdomain.key -in fullchain.cer`

​	**说明：**

​	```
​	openssl pkcs12 --export --out 我们需要的证书 --inkey 刚获取的证书密钥 --in 					  fullchain.cer 	(这个不用	变，用 acme.sh 获取的证书)
​	```

- Plex 相关设置

  进入设置 —— 网络 ——

  - [x] 启动支持 IPv6 的服务器选中☑️ check in
  
  - 自定义证书位置
  
    - 这里填写上面一步转换获取的 pkcs#12 的证书保存位置 /your/dir/yourdomain.pfx
  
  - 自定义证书加密密钥
  
    - 这里填写 acme.sh 的证书私钥 /your/domain/key
  
  - 自定义证书域
  
    - 你的域名 yourdomain.com
  
  - 自定义服务器访问 URL
  
    - https://yourdomain:port 
  
    - 例如： https://yourdoain.com:9999
  

