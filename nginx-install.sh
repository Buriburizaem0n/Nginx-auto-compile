#!/usr/bin/env bash
#===============================================================================
# Script to compile and install Nginx with HTTP-FLV module and QUIC-enabled OpenSSL
# and configure systemd service, plus symlink nginx command
#===============================================================================

set -euo pipefail

# Variables (customize as needed)
NGINX_VER="1.28.0"
WORKDIR="$HOME/nginx-build"
FLV_MODULE_REPO="https://github.com/winshining/nginx-http-flv-module.git"
OPENSSL_REPO="https://github.com/quictls/openssl.git"
PREFIX="/etc/nginx"
SERVICE_FILE="/etc/systemd/system/nginx.service"
BIN_SYMLINK="/usr/bin/nginx"

# 1. Install build dependencies
sudo apt update
sudo apt install -y build-essential libpcre3-dev zlib1g-dev libssl-dev git wget

# 2. Prepare work directory
rm -rf "${WORKDIR}"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# 3. Clone third-party modules
git clone "${FLV_MODULE_REPO}" nginx-http-flv-module
git clone --depth 1 "${OPENSSL_REPO}" openssl

# 4. Download and extract Nginx
wget "http://nginx.org/download/nginx-${NGINX_VER}.tar.gz"
tar xzf "nginx-${NGINX_VER}.tar.gz"
cd "nginx-${NGINX_VER}"

# 5. Clean any previous build artifacts (optional)
make clean || true

# 6. Configure build with modules and OpenSSL QUIC support
./configure \
  --prefix="${PREFIX}" \
  --sbin-path="${PREFIX}/sbin/nginx" \
  --conf-path="${PREFIX}/nginx.conf" \
  --pid-path=/var/run/nginx.pid \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --with-http_ssl_module \
  --with-http_v2_module \
  --with-http_realip_module \
  --with-http_gzip_static_module \
  --with-threads \
  --with-file-aio \
  --with-http_stub_status_module \
  --with-http_sub_module \
  --with-stream \
  --with-stream_ssl_preread_module \
  --with-stream_ssl_module \
  --with-http_mp4_module \
  --with-pcre \
  --with-pcre-jit \
  --with-http_v3_module \
  --add-module="${WORKDIR}/nginx-http-flv-module" \
  --with-openssl="${WORKDIR}/openssl"

# 7. Build & install
make -j"$(nproc)"
sudo make install

# 8. Create symlink for nginx command
sudo ln -sf "${PREFIX}/sbin/nginx" "${BIN_SYMLINK}"

# 9. Create systemd service file for Nginx
sudo tee "${SERVICE_FILE}" > /dev/null << 'EOF'
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/etc/nginx/sbin/nginx -t -q -g 'daemon on; master_process on;'
ExecStart=/etc/nginx/sbin/nginx -g 'daemon on; master_process on;'
ExecReload=/etc/nginx/sbin/nginx -s reload
ExecStop=/etc/nginx/sbin/nginx -s quit
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

# 10. Reload systemd, enable and start Nginx service
sudo systemctl daemon-reload
sudo systemctl enable nginx
sudo systemctl restart nginx

# 11. Verification
sudo "${PREFIX}/sbin/nginx" -V

# 12. Completion message
echo "Nginx ${NGINX_VER} has been installed to ${PREFIX} with HTTP-FLV module, QUIC-enabled OpenSSL, symlinked to ${BIN_SYMLINK}, and systemd service configured."
