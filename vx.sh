#!/bin/bash
# =======================================================
# 项目: Velox Node Engine (VX) - 极简高阶代理核心生成器
# 作者: pwenxiang51-wq
# 博客: 222382.xyz
# 版本: V3.1.0 (点亮 Hysteria2 + 极速发证机实装)
# =======================================================

export LANG=en_US.UTF-8
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
cyan='\033[0;36m'
blue='\033[0;34m'
purple='\033[0;35m'
plain='\033[0m'

CONF_DIR="/etc/velox_vne"
CERT_DIR="$CONF_DIR/cert"
BIN_FILE="/usr/local/bin/sing-box"
JSON_FILE="$CONF_DIR/config.json"
SERVICE_FILE="/etc/systemd/system/vx-core.service"
SCRIPT_URL="https://raw.githubusercontent.com/pwenxiang51-wq/VX-Node-Engine/main/vx.sh"

[[ $EUID -ne 0 ]] && echo -e "${red}❌ 致命错误: 请使用 root 用户运行此引擎！${plain}" && exit 1

# --- 全局指令自我注册 ---
if [[ ! -f "/usr/local/bin/vx" ]]; then
    curl -sL "$SCRIPT_URL" -o /usr/local/bin/vx >/dev/null 2>&1
    chmod +x /usr/local/bin/vx
fi

function show_logo() {
    clear
    echo -e "${cyan}██╗   ██╗███████╗██╗     ██████╗ ██╗  ██╗${plain}"
    echo -e "${cyan}██║   ██║██╔════╝██║    ██╔═══██╗╚██╗██╔╝${plain}"
    echo -e "${blue}██║   ██║█████╗  ██║    ██║   ██║ ╚███╔╝ ${plain}"
    echo -e "${blue}╚██╗ ██╔╝██╔══╝  ██║    ██║   ██║ ██╔██╗ ${plain}"
    echo -e "${purple} ╚████╔╝ ███████╗███████╗╚██████╔╝██╔╝ ██╗${plain}"
    echo -e "${purple}  ╚═══╝  ╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝${plain}"
    echo -e "${cyan}=======================================================${plain}"
    echo -e "      🚀 Velox Node Engine (多协议极速构建引擎 V3.1) 🚀   "
    echo -e "${cyan}=======================================================${plain}"
}

function check_sys() {
    echo -e "\n${yellow}>>> 正在执行全系统智能嗅探与依赖装载...${plain}"
    mkdir -p "$CONF_DIR"
    [[ -f /etc/os-release ]] && source /etc/os-release || (echo -e "${red}❌ 无法识别系统！${plain}" && exit 1)

    if ! command -v jq &> /dev/null || ! command -v qrencode &> /dev/null; then
        if [[ "$ID" == "debian" || "$ID" == "ubuntu" ]]; then
            apt-get update -y >/dev/null 2>&1 && apt-get install -y jq qrencode curl wget openssl tar >/dev/null 2>&1
        else
            yum install -y epel-release >/dev/null 2>&1 && yum install -y jq qrencode curl wget openssl tar >/dev/null 2>&1
        fi
    fi
}

function install_core() {
    if [[ ! -f "$BIN_FILE" ]]; then
        echo -e "\n${yellow}>>> 正在拉取 Sing-box 官方最新正式版内核...${plain}"
        LATEST_VERSION=$(curl -sL https://data.jsdelivr.com/v1/package/gh/SagerNet/sing-box | jq -r '.versions | map(select(test("alpha|beta|rc") | not)) | .[0]')
        SB_ARCH=$([[ "$(uname -m)" == "x86_64" ]] && echo "amd64" || echo "arm64")
        wget -qO sing-box.tar.gz "https://github.com/SagerNet/sing-box/releases/download/v${LATEST_VERSION}/sing-box-${LATEST_VERSION}-linux-${SB_ARCH}.tar.gz"
        tar -xzf sing-box.tar.gz && mv sing-box-*/sing-box $BIN_FILE && chmod +x $BIN_FILE && rm -rf sing-box*
    fi
}

# --- 极客黑科技：公共环境抓取模块 ---
function get_env_info() {
    SERVER_IP=$(curl -s4m5 icanhazip.com || curl -s6m5 icanhazip.com)
    echo -e "${cyan}正在感应地理位置与 ISP 标签...${plain}"
    IP_INFO=$(curl -s4m5 http://ip-api.com/json/)
    IP_LOC=$(echo "$IP_INFO" | jq -r '.country' | sed 's/ /_/g')
    ISP_NAME=$(echo "$IP_INFO" | jq -r '.isp' | awk '{print $1}')
    [[ -z "$IP_LOC" || "$IP_LOC" == "null" ]] && IP_LOC="Unknown"
    [[ -z "$ISP_NAME" || "$ISP_NAME" == "null" ]] && ISP_NAME="Cloud"
}

# --- 极客黑科技：0.1秒极速发证机 ---
function generate_cert() {
    mkdir -p $CERT_DIR
    if [[ ! -f "$CERT_DIR/cert.crt" ]]; then
        echo -e "${cyan}正在利用底层引擎进行 0.1秒 极速量子自签发证...${plain}"
        openssl ecparam -genkey -name prime256v1 -out $CERT_DIR/private.key >/dev/null 2>&1
        openssl req -new -x509 -days 3650 -key $CERT_DIR/private.key -out $CERT_DIR/cert.crt -subj "/C=US/ST=California/L=Los Angeles/O=Microsoft Corporation/OU=Bing/CN=bing.com" >/dev/null 2>&1
        echo -e "${green}✅ 10年期 ECC 高强度证书锻造完成！伪装SNI: bing.com${plain}"
    fi
}

# --- 核心守护进程注入 ---
function apply_systemd() {
    cat << EOF > $SERVICE_FILE
[Unit]
Description=Velox Node Engine (VX) Core
After=network.target
[Service]
ExecStart=$BIN_FILE run -c $JSON_FILE
Restart=always
RestartSec=3
LimitNOFILE=infinity
[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload && systemctl enable --now vx-core.service >/dev/null 2>&1
}

# ==================================================
# 协议 1: VLESS-Reality 部署逻辑
# ==================================================
function install_vless_reality() {
    check_sys && install_core && get_env_info
    
    echo -e "\n${yellow}>>> 开启 VLESS-Reality (TCP) 核心配置：${plain}"
    read -p "👉 请设置监听端口 (直接回车随机): " LISTEN_PORT
    LISTEN_PORT=${LISTEN_PORT:-$(shuf -i 10000-60000 -n 1)}
    read -p "👉 请设置伪装域名 (直接回车默认 apple.com): " SNI_DOMAIN
    SNI_DOMAIN=${SNI_DOMAIN:-"apple.com"}

    UUID=$($BIN_FILE generate uuid)
    KEYS=$($BIN_FILE generate reality-keypair)
    PRIVATE_KEY=$(echo "$KEYS" | awk '/PrivateKey/ {print $2}')
    PUBLIC_KEY=$(echo "$KEYS" | awk '/PublicKey/ {print $2}')
    SHORT_ID=$($BIN_FILE generate rand --hex 8)
    REMARK="VLESS-Reality-${ISP_NAME}-${IP_LOC}-VeloX"

    cat << EOF > $JSON_FILE
{
  "log": { "level": "info", "timestamp": true },
  "inbounds": [
    {
      "type": "vless", "tag": "vless-in", "listen": "::", "listen_port": $LISTEN_PORT,
      "users": [ { "uuid": "$UUID", "flow": "xtls-rprx-vision" } ],
      "tls": { "enabled": true, "server_name": "$SNI_DOMAIN", "reality": { "enabled": true, "handshake": { "server": "$SNI_DOMAIN", "server_port": 443 }, "private_key": "$PRIVATE_KEY", "short_id": [ "$SHORT_ID" ] } }
    }
  ],
  "outbounds": [ { "type": "direct", "tag": "direct" }, { "type": "block", "tag": "block" } ]
}
EOF
    apply_systemd
    SHARE_LINK="vless://$UUID@$SERVER_IP:$LISTEN_PORT?encryption=none&flow=xtls-rprx-vision&security=reality&sni=$SNI_DOMAIN&fp=chrome&pbk=$PUBLIC_KEY&sid=$SHORT_ID&type=tcp&headerType=none#$REMARK"
    print_success_info "VLESS-Reality" "$SERVER_IP" "$LISTEN_PORT" "$UUID" "$REMARK" "$SHARE_LINK"
}

# ==================================================
# 协议 3: Hysteria2 部署逻辑
# ==================================================
function install_hysteria2() {
    check_sys && install_core && get_env_info && generate_cert
    
    echo -e "\n${yellow}>>> 开启 Hysteria2 (UDP暴力发包) 核心配置：${plain}"
    read -p "👉 请设置监听端口 (直接回车随机): " LISTEN_PORT
    LISTEN_PORT=${LISTEN_PORT:-$(shuf -i 10000-60000 -n 1)}
    read -p "👉 请设置 Hys2 密码 (直接回车自动生成强密码): " HYS_PASS
    HYS_PASS=${HYS_PASS:-$($BIN_FILE generate rand --hex 16)}

    REMARK="Hys2-${ISP_NAME}-${IP_LOC}-VeloX"

    cat << EOF > $JSON_FILE
{
  "log": { "level": "info", "timestamp": true },
  "inbounds": [
    {
      "type": "hysteria2", "tag": "hy2-in", "listen": "::", "listen_port": $LISTEN_PORT,
      "users": [ { "password": "$HYS_PASS" } ],
      "tls": { "enabled": true, "alpn": ["h3"], "certificate_path": "$CERT_DIR/cert.crt", "key_path": "$CERT_DIR/private.key" }
    }
  ],
  "outbounds": [ { "type": "direct", "tag": "direct" }, { "type": "block", "tag": "block" } ]
}
EOF
    apply_systemd
    # Hysteria2 分享链接 (自签证书需加 insecure=1)
    SHARE_LINK="hysteria2://$HYS_PASS@$SERVER_IP:$LISTEN_PORT/?sni=bing.com&alpn=h3&insecure=1#$REMARK"
    print_success_info "Hysteria2" "$SERVER_IP" "$LISTEN_PORT" "$HYS_PASS" "$REMARK" "$SHARE_LINK"
}

function print_success_info() {
    echo -e "\n${cyan}=======================================================${plain}"
    echo -e " ${purple}🔥 节点构建完成！您的专属 $1 资产如下：${plain}"
    echo -e "${cyan}=======================================================${plain}"
    echo -e "🌐 ${yellow}节点 IP${plain}    : $2"
    echo -e "🚪 ${yellow}监听端口${plain}   : $3"
    echo -e "🔑 ${yellow}核心密钥${plain}   : $4"
    echo -e "🏷️ ${yellow}智能备注${plain}   : $5"
    echo -e "${cyan}-------------------------------------------------------${plain}"
    echo -e "🔗 ${green}一键导入链接：${plain}\n${blue}$6${plain}"
    echo -e "\n${yellow}📱 扫码导入：${plain}"
    qrencode -o - -t ANSIUTF8 "$6"
    echo -e "${cyan}=======================================================${plain}"
}

function update_vx() {
    echo -e "\n${yellow}>>> 🔄 正在连接 GitHub 拉取最新 VX 引擎...${plain}"
    curl -sL "$SCRIPT_URL" -o /tmp/vx_update.sh
    if [[ -f /tmp/vx_update.sh && -s /tmp/vx_update.sh ]]; then
        mv -f /tmp/vx_update.sh /usr/local/bin/vx && chmod +x /usr/local/bin/vx
        echo -e "${green}✅ VX 引擎 OTA 升级成功！请按回车键重新启动面板。${plain}"
        read -p ""
        exec vx
    else
        echo -e "${red}❌ 升级失败，请检查网络或 GitHub 连通性！${plain}"
    fi
}

function uninstall_vne() {
    echo -e "\n${yellow}⚠️ 警告: 正在彻底销毁 Velox 引擎核心...${plain}"
    systemctl stop vx-core.service >/dev/null 2>&1
    systemctl disable vx-core.service >/dev/null 2>&1
    rm -f $SERVICE_FILE && systemctl daemon-reload >/dev/null 2>&1
    rm -rf $CONF_DIR $BIN_FILE && rm -f /usr/local/bin/vx
    echo -e "${green}✅ 卸载绝杀完成！系统已恢复纯净。${plain}"
}

# ==================================================
# 动态主菜单
# ==================================================
while true; do
    show_logo
    VNE_STAT=$(systemctl is-active --quiet vx-core.service 2>/dev/null && echo -e "${green}运行中 ✅${plain}" || echo -e "${red}未部署 ❌${plain}")
    echo -e "      ${blue}当前引擎状态: [ $VNE_STAT ]${plain}"
    echo -e "${cyan}==================== [节点锻造车间] ====================${plain}"
    echo -e "  ${green}1.${plain} 🚀 独立装载: VLESS-Reality (最高级防封)"
    echo -e "  ${purple}2.${plain} 🚀 独立装载: VMess-WS + Argo (隐匿隧道) ${yellow}[待唤醒]${plain}"
    echo -e "  ${green}3.${plain} 🚀 独立装载: Hysteria2 (UDP暴力发包)"
    echo -e "  ${purple}4.${plain} 🚀 独立装载: TUIC v5 (QUIC极致并发)   ${yellow}[待唤醒]${plain}"
    echo -e "  ${purple}5.${plain} 🚀 独立装载: SS-2022 (替代AnyTLS)     ${yellow}[待唤醒]${plain}"
    echo -e "${cyan}==================== [引擎调优中心] ====================${plain}"
    echo -e "  ${purple}6.${plain} 🌍 附加挂载: WARP 解锁流媒体/ChatGPT  ${yellow}[待唤醒]${plain}"
    echo -e "  ${purple}7.${plain} ⚡ 底层调优: 一键开启 BBR/FQ 暴力加速   ${yellow}[待唤醒]${plain}"
    echo -e "${cyan}==================== [系统维护指令] ====================${plain}"
    echo -e "  ${yellow}8.${plain} 🔄 OTA 极速热更新 VX 引擎"
    echo -e "  ${red}9.${plain} 🗑️  彻底粉碎卸载 VX 节点核心"
    echo -e "  ${yellow}0.${plain} 🔙 退出脚本"
    echo -e "${cyan}-------------------------------------------------------${plain}"
    read -p "👉 请选择操作 [0-9]: " choice
    case "$choice" in
        1) install_vless_reality; echo ""; read -p "👉 按回车键返回..." ;;
        3) install_hysteria2; echo ""; read -p "👉 按回车键返回..." ;;
        2|4|5|6|7) echo -e "\n${yellow}🚧 架构师正在拼命打磨该模块的核心 JSON 代码，即将通过 OTA 升级开放！${plain}"; sleep 2 ;;
        8) update_vx ;;
        9) uninstall_vne; echo ""; read -p "👉 按回车键返回..." ;;
        0) break ;;
        *) echo -e "${red}❌ 无效输入！${plain}"; sleep 1 ;;
    esac
done
