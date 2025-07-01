# Project: Custom Nginx Build with HTTP-FLV, QUIC-enabled OpenSSL, and Systemd Service

中文版见下方
## Overview

This repository provides a single bash script, `build-nginx.sh`, to automate the process of:

1. Cloning required third-party modules:

   * **nginx-http-flv-module** for HTTP-FLV support
   * **QuicTLS OpenSSL** for HTTP/3 (QUIC) support
2. Downloading and compiling a specified Nginx version from source
3. Installing Nginx to `/etc/nginx` with the configured modules
4. Creating a symlink at `/usr/bin/nginx` for easy CLI access
5. Configuring and enabling a systemd service for Nginx

## Prerequisites

* A Debian/Ubuntu-based system
* Root or `sudo` privileges
* Internet connectivity to clone repositories and download sources

## Usage

1. **Clone this repository**

   ```bash
   git clone https://github.com/Buriburizaem0n/Nginx-auto-compile.git
   cd Nginx-auto-compile
   ```

2. **Make the script executable**

   ```bash
   chmod +x nginx-install.sh
   ```

3. **Customize variables (optional)**

   * `NGINX_VER`: Nginx version to build (default: 1.28.0)
   * `WORKDIR`: Temporary build directory (default: `$HOME/nginx-build`)
   * `PREFIX`: Installation prefix (default: `/etc/nginx`)

   Edit these at the top of `nginx-install.sh` if needed.

4. **Run the script**

   ```bash
   ./nginx-install.sh
   ```

   * The script installs dependencies, builds Nginx, sets up a systemd service, and symlinks the `nginx` command.

5. **Verify installation**

   ```bash
   nginx -V   # shows compile options
   systemctl status nginx   # ensures service is running
   ```

## Script Breakdown

* **Dependencies**: Installs `build-essential`, `libpcre3-dev`, `zlib1g-dev`, `git`, `wget`, etc.
* **Modules**:

  * `--add-module=nginx-http-flv-module`
  * `--with-openssl=<quictls-openssl>`
* **Systemd**: Creates `/etc/systemd/system/nginx.service` for start/stop/reload
* **Symlink**: Links `/etc/nginx/sbin/nginx` to `/usr/bin/nginx`

## License

This project is released under the MIT License. See [LICENSE](LICENSE) for details.

## Contributing

Feel free to submit issues or pull requests for improvements. Ensure any new modules or flags are documented in both the script and this README.

## Acknowledgments

* [nginx-http-flv-module](https://github.com/winshining/nginx-http-flv-module)
* [QuicTLS OpenSSL](https://github.com/quictls/openssl)
* [nginx.org](http://nginx.org) source distributions

---


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
