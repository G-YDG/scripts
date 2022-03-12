#!/bin/bash

# -----------------------------------------------------------------------------------------------------
# 安装 Nginx 脚本
# 仅适用于 CentOS7 发行版本
# -----------------------------------------------------------------------------------------------------

# ------------------------------- env -------------------------------

# Regular Color
export ENV_COLOR_BLACK="\033[0;30m"
export ENV_COLOR_RED="\033[0;31m"
export ENV_COLOR_GREEN="\033[0;32m"
export ENV_COLOR_YELLOW="\033[0;33m"
export ENV_COLOR_BLUE="\033[0;34m"
export ENV_COLOR_MAGENTA="\033[0;35m"
export ENV_COLOR_CYAN="\033[0;36m"
export ENV_COLOR_WHITE="\033[0;37m"

# Bold Color
export ENV_COLOR_B_BLACK="\033[1;30m"
export ENV_COLOR_B_RED="\033[1;31m"
export ENV_COLOR_B_GREEN="\033[1;32m"
export ENV_COLOR_B_YELLOW="\033[1;33m"
export ENV_COLOR_B_BLUE="\033[1;34m"
export ENV_COLOR_B_MAGENTA="\033[1;35m"
export ENV_COLOR_B_CYAN="\033[1;36m"
export ENV_COLOR_B_WHITE="\033[1;37m"

# Reset Color
export ENV_COLOR_RESET="$(tput sgr0)"

# status
export ENV_YES=0
export ENV_NO=1
export ENV_SUCCEED=0
export ENV_FAILED=1

# ------------------------------- function -------------------------------

# 显示打印日志的时间
SHELL_LOG_TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# 显示当前用户
USER=$(whoami)

redOutput() {
    echo -e "${ENV_COLOR_RED} $@${ENV_COLOR_RESET}"
}

greenOutput() {
    echo -e "${ENV_COLOR_B_GREEN} $@${ENV_COLOR_RESET}"
}

yellowOutput() {
    echo -e "${ENV_COLOR_YELLOW} $@${ENV_COLOR_RESET}"
}

blueOutput() {
    echo -e "${ENV_COLOR_BLUE} $@${ENV_COLOR_RESET}"
}

magentaOutput() {
    echo -e "${ENV_COLOR_MAGENTA} $@${ENV_COLOR_RESET}"
}

cyanOutput() {
    echo -e "${ENV_COLOR_CYAN} $@${ENV_COLOR_RESET}"
}

whiteOutput() {
    echo -e "${ENV_COLOR_WHITE} $@${ENV_COLOR_RESET}"
}

printInfo() {
    echo -e "${ENV_COLOR_B_GREEN}[INFO] $@${ENV_COLOR_RESET}"
}

printWarn() {
    echo -e "${ENV_COLOR_B_YELLOW}[WARN] $@${ENV_COLOR_RESET}"
}

printError() {
    echo -e "${ENV_COLOR_B_RED}[ERROR] $@${ENV_COLOR_RESET}"
}

callAndLog () {
    $*
    if [[ $? -eq ${ENV_SUCCEED} ]]; then
        printInfo "$@"
        return ${ENV_SUCCEED}
    else
        printError "$@ EXECUTE FAILED"
        return ${ENV_FAILED}
    fi
}

# ------------------------------- main -------------------------------

printInfo ">>>> install nginx begin"

command -v wget > /dev/null 2>&1 || {
	printError "Require wget but it's not installed"
	exit 1;
}

command -v yum > /dev/null 2>&1 || {
	printError "Require yum but it's not installed"
	exit 1;
}

printInfo ">>>> yum install"
yum install vim gcc pcre pcre-devel zlib-devel openssl openssl-devel -y

printInfo ">>>> wget nginx"
wget http://nginx.org/download/nginx-1.17.10.tar.gz
tar -zxvf nginx-1.17.10.tar.gz

printInfo ">>>> make install"
cd nginx-1.17.10
./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
make && make install

printInfo ">>>> start nginx"
cd /usr/local/nginx/ && sbin/nginx

printInfo "<<<< install nginx success"
