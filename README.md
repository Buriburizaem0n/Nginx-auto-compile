# Project: Custom Nginx Build with HTTP-FLV, QUIC-enabled OpenSSL, and Systemd Service

中文版见
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
