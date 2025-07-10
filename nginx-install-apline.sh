#!/usr/bin/env sh
#===============================================================================
# Alpine Linux 脚本：编译安装 Nginx + HTTP-FLV 模块 + QUIC 支持，并配置 OpenRC 服务
#===============================================================================

set -euo pipefail

#—— 可按需自定义 ——#
NGINX_VER="1.28.0"
WORKDIR="/tmp/nginx-build"
FLV_MODULE_REPO="https://github.com/winshining/nginx-http-flv-module.git"
OPENSSL_REPO="https://github.com/quictls/openssl.git"
PREFIX="/etc/nginx"
BIN_SYMLINK="/usr/bin/nginx"

# 1. 安装编译依赖
sudo apk update
sudo apk add --no-cache \
    build-base \
    pcre-dev \
    zlib-dev \
    git \
    wget \
    linux-headers \
    perl

# 2. 准备工作目录
rm -rf "${WORKDIR}"
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# 3. 拉取第三方模块与 QUIC-enabled OpenSSL
git clone "${FLV_MODULE_REPO}" nginx-http-flv-module
git clone --depth 1 "${OPENSSL_REPO}" openssl

# 4. 下载并解压 Nginx 源码
wget "http://nginx.org/download/nginx-${NGINX_VER}.tar.gz"
tar xzf "nginx-${NGINX_VER}.tar.gz"
cd "nginx-${NGINX_VER}"

# 5. 可选：清理旧构建
make clean || true

# 6. 配置编译选项
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

# 7. 并行编译 & 安装
make -j"$(nproc)"
sudo make install

# 8. 建立 nginx 命令软链接
sudo ln -sf "${PREFIX}/sbin/nginx" "${BIN_SYMLINK}"

# 9. 生成 OpenRC 服务脚本
sudo tee /etc/init.d/nginx > /dev/null << 'EOF'
#!/sbin/openrc-run
description="Nginx HTTP and reverse proxy server"
command="/etc/nginx/sbin/nginx"
pidfile="/var/run/nginx.pid"
depend() {
    need net
}
start_pre() {
    # 检查配置
    /etc/nginx/sbin/nginx -t
}
EOF

sudo chmod +x /etc/init.d/nginx
sudo rc-update add nginx default

# 10. 启动 Nginx 服务
sudo rc-service nginx start

# 11. 验证安装
"${PREFIX}/sbin/nginx" -V

# 12. 完成提示
echo "✔ Nginx ${NGINX_VER} 已安装至 ${PREFIX}，包含 HTTP-FLV 模块与 QUIC-enabled OpenSSL，已配置 OpenRC 服务。"
