#!/bin/bash
# Installation de VSFTPD
function vsftpd {
  apt install vsftpd open-ssl -y
}
# Certificat pour le service ftp
function certificat {
  mkdir /etc/cert/
  mkdir /etc/cert/ftp/
  openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -subj "/C=FR/ST=LA REGION/L=MA VILLE/O=MON ORGANISATION/CN=MON FQDN/OU=MON SERVICE/emailAddress=admin@mondomaine" -addext "subjectAltName=DNS:*.monFQDN,DNS:monFQDN" -keyout /etc/cert/ftp/mon_site.key -out /etc/cert/ftp/mon_site.pem;
}
# Mise en place de la configuration
function vsftpd_conf {
  cp config/vsftpd.conf /etc/
}
# Création du dossier de logs
function vsftpd_log {
  mkdir /var/log/vsftpd/
  touch /var/log/vsftpd/vsftpd.log
}
# Mise en place du script de création d'utilisateur(s)
function ftp_adduser {
  cp scripts/ftp_adduser.sh /usr/sbin/
  chmod +x /usr/sbin/ftp_adduser.sh
}
# Mise en place du script de suppression d'utilisateur(s)
function ftp_deluser {
  cp scripts/ftp_deluser.sh /usr/sbin/
  chmod +x /usr/sbin/ftp_deluser.sh
}
# Création d'utilisateur(s)
function ftp_create_users {
  /usr/sbin/ftp_adduser.sh
}
# Fonction principale
function install_vsftp {
  vsftpd
  certificat
  vsftpd_conf
  vsftpd_log
  ftp_adduser
  ftp_deluser
  ftp_create_users
}
install_vsftp
