### 概述

本仓库提供了一个 Bash 脚本 `build-nginx.sh`，用于自动化完成以下操作：

1. 克隆所需的第三方模块：

   * **nginx-http-flv-module**：支持 HTTP-FLV
   * **QuicTLS OpenSSL**：支持 HTTP/3 (QUIC)
2. 下载并编译指定版本的 Nginx 源码
3. 将编译后的 Nginx 安装到 `/etc/nginx`
4. 在 `/usr/bin/nginx` 创建符号链接，方便在 CLI 中使用 `nginx` 命令
5. 自动配置并启用 systemd 服务来管理 Nginx

### 前提条件

* Debian/Ubuntu 系统
* Root 或 `sudo` 权限
* 可访问互联网以克隆仓库并下载源码

### 使用方法

1. **克隆仓库**

   ```bash
   git clone https://github.com/Buriburizaem0n/Nginx-auto-compile.git
   cd Nginx-auto-compile
   ```

2. **赋予脚本执行权限**

   ```bash
   chmod +x nginx-install.sh
   ```

3. **可选：修改脚本变量**

   * `NGINX_VER`：要构建的 Nginx 版本（默认：1.28.0）
   * `WORKDIR`：临时构建目录（默认：`$HOME/nginx-build`）
   * `PREFIX`：安装前缀（默认：`/etc/nginx`）

   如需更改，请编辑 `nginx-install.sh` 顶部的变量。

4. **运行脚本**

   ```bash
   ./nginx-install.sh
   ```

   脚本将自动安装依赖、编译 Nginx、配置 systemd 服务，并创建 `nginx` 命令的符号链接。

5. **验证安装**

   ```bash
   nginx -V           # 查看 Nginx 编译参数
   systemctl status nginx   # 检查服务运行状态
   ```

### 脚本解析

* **依赖**：安装 `build-essential`、`libpcre3-dev`、`zlib1g-dev`、`git`、`wget` 等
* **模块**：

  * `--add-module=nginx-http-flv-module`
  * `--with-openssl=<quictls-openssl>`
* **systemd**：创建 `/etc/systemd/system/nginx.service`，提供启动/停止/重载功能
* **符号链接**：将 `/etc/nginx/sbin/nginx` 链接到 `/usr/bin/nginx`

### 许可证

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE)。

### 贡献

欢迎提交 Issue 或 Pull Request。如添加新模块或选项，请同时更新脚本和 README。

### 致谢

* [nginx-http-flv-module](https://github.com/winshining/nginx-http-flv-module)
* [QuicTLS OpenSSL](https://github.com/quictls/openssl)
* [nginx.org](http://nginx.org) 源码分发
