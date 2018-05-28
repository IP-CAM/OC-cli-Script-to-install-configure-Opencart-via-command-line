#!/usr/bin/env bash
#
# Arquivo: oc-cli.sh
#
# Feito por Lucas Saliés Brum, lucas@archlinux.com.br
#
# Criado em: 2018-05-24 15:47:04
# Última alteração: 2018-05-28 17:51:01

banner() {
	echo
	echo "                      _ _ "
	echo "  ___   ___       ___| (_)"
	echo " / _ \ / __|____ / __| | |"
	echo "| (_) | (_|_____| (__| | |"
	echo " \___/ \___|     \___|_|_|"
	echo
}

ajuda() {
	echo
	echo "Você deve usar o programa assim: $(basename $0) --banco=banco --senha=SENHA --usuario=nginx --caminho=/var/www/opencart"
	echo
	exit 0
}



#if [ "$(mysql -uUSER -pPASS -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '$usuario')")" = 1 ]; then
#	echo "O usuário $usuario existe, abortando."
#	exit 1
#fi

#ultima=$(curl -s "https://api.github.com/repos/opencart/opencart/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
#[ -d /tmp/opencart ] &&	rm -rf /tmp/opencart
#mkdir -p /tmp/opencart/www
#curl -s -o /tmp/opencart/opencart-$ultima.zip $(curl -s "https://api.github.com/repos/opencart/opencart/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/')
#unzip /tmp/opencart/opencart-$ultima.zip

banner