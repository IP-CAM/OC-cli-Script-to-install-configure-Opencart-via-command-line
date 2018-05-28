#!/usr/bin/env bash
#
# Arquivo: oc-cli.sh
#
# Feito por Lucas Saliés Brum, lucas@archlinux.com.br
#
# Criado em: 2018-05-24 15:47:04
# Última alteração: 2018-05-28 17:51:01

[ "$(id -u)" != "0" ] && echo "Esse script somente pode ser executado pelo root." && exit 1

sep="---------------------------------------------"

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

read -p "Nome do site? [Padrão: Loja OpenCart]: " nome
nome=${nome:-"Loja OpenCart"}

read -p "Em qual pasta o Opencart deve ser instalado? [Padrão: $(pwd)]: " pasta
pasta=${pasta:-"$(pwd)"}

read -p "Nome de usuário do banco de dados? [Padrão: opencart]: " usuario_db
usuario_db=${usuario_db:-"opencart"}

read -p "Nome de usuário do banco de dados? [Padrão: opencartpass]: " senha_db
senha_db=${senha_db:-"opencartpass"}

read -p "Digite a senha do root do MySQL [Padrão: Nenhuma]: " rootpasswd
rootok=$(mysql -uroot -p$rootpasswd -ANe "SELECT COUNT(1) Password_is_OK FROM mysql.user WHERE user='root' AND password=PASSWORD('$rootpasswd')" 2> /dev/null)

if [ "$rootok" != "1" ]; then 
	echo "Erro na senha do root ou servidor mysql não iniciado."
	exit 1
fi

# 5.7.6 and above
#CREATE USER IF NOT EXISTS 'user'@'localhost' IDENTIFIED BY 'password';

# Below 5.7.6
#GRANT ALL ON `database`.* TO 'user'@'localhost' IDENTIFIED BY 'password';




read -p "Nome do banco de dados? [Padrão: opencart]: " banco
banco=${banco:-"opencart"}

res=$(mysqlshow $banco| grep -v Wildcard | grep -o $banco)
if [ "$res" == "$banco" ]; then
    echo "O banco de dados $banco já existe, uma nova instalação irá apagar completamente este banco de dados."

	read -p "Deseja prosseguir? [s/N]: " resposta
	if [ $resposta = *[sS]* ]; then
		mysql -Nse 'show tables' $banco | while read tabela; do mysql -e "drop table $tabela" $banco; done
	else
		exit 0
	fi

fi

echo $sep
banner
echo $sep
echo "DADOS DO NOVO SITE"
echo $sep
echo "Site:    $nome"
echo "Usuario: $usuario_db"
echo "Senha:   $senha_db"
echo "Banco:   $banco"
echo "Pasta:   $pasta"
echo $sep


mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${banco} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
mysql -uroot -p${rootpasswd} -e "CREATE USER ${usuario_db}@localhost IDENTIFIED BY '${senha_db}';"
mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON ${banco}.* TO '${usuario_db}'@'localhost';"
mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"

