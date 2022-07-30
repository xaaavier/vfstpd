#!/bin/bash
# Vérification que l'utilisateur ftpsecure existe
function user_ftpsecure {
  if cat /etc/passwd | grep "ftpsecure" > /dev/null
    then
      :
    else
      adduser -q --disabled-login --disabled-password --gecos "" ftpsecure
  fi
}
# Création des groupes nécessaires
function groups {
  if cat /etc/group | grep "developpeur" > /dev/null
    then
      :
    else
      addgroup developpeur
  fi
  if cat /etc/group | grep "graphiste" > /dev/null
    then
      :
    else
      addgroup graphiste
  fi
}
# Création des utilisateurs
function ftp_users {
  echo "Quels utilisateurs créer? (utilisateur1 utilisateur2 ...)"
  read user
  for i in $user
  do
    echo -e "\e[1;32mQuelle est la fonction de $i ?\e[0;m \n     1) \e[1;34mDéveloppeur\e[0;m \n     2) \e[1;34mGraphiste\e[0;m"
    read fonction
    if [ "$fonction" -eq 1 ];
      then
        adduser -q --gecos "" $i
        echo $i >> /etc/vsftpd.userlist
        usermod -aG developpeur $i
        mkdir /home/$i/www
        chown nobody:nogroup /home/$i/www
        chmod a-w /home/$i/www
        mkdir -p /home/$i/www/la_racine_du_site/
        chown $i:$i /home/$i/www/la_racine_du_site
        chmod -R 777 /home/$i/www/la_racine_du_site
        # On ajoute un point de montage, on monte puis on modifie le point de montage pour le rendre non-automatique (procéder ainsi permet d'éviter d'avoir a reboot la machine)
        echo "/var/www/la_racine_du_site/ /home/$i/www/la_racine_du_site  none  bind,x-systemd.automount  0  0" >> /etc/fstab
        mount -a
        sed -i -e 's/\/var\/www\/la_racine_du_site\/ \/home\/'$i'\/www\/la_racine_du_site  none  bind,x-systemd.automount  0  0/\/var\/www\/la_racine_du_site\/ \/home\/'$i'\/www\/la_racine_du_site  none  bind,noauto,x-systemd.automount  0  0/g' /etc/fstab
    elif  [ "$fonction" -eq 2 ];
      then
        adduser -q --gecos "" $i
        echo $i >> /etc/vsftpd.userlist
        usermod -aG graphiste $i
        mkdir /home/$i/www
        chown nobody:nogroup /home/$i/www
        chmod a-w /home/$i/www
        mkdir -p /home/$i/www/la_racine_du_site/
        chown $i:$i /home/$i/www/la_racine_du_site
        chmod -R 777 /home/$i/www/la_racine_du_site
        echo "/var/www/la_racine_du_site/images/ /home/$i/www/la_racine_du_site  none  bind,x-systemd.automount  0  0" >> /etc/fstab
        mount -a
        sed -i -e 's/\/var\/www\/la_racine_du_site\/images\/ \/home\/'$i'\/www\/la_racine_du_site  none  bind,x-systemd.automount  0  0/\/var\/www\/la_racine_du_site\/ \/home\/'$i'\/www\/la_racine_du_site  none  bind,noauto,x-systemd.automount  0  0/g' /etc/fstab
    else
      echo -e "\e[0;31mCréation échouée pour $i, merci de recommencer\e[0;m"
    fi
  done
}
function autorisations {
  # Attribution du dossier racine www-data
  chown www-data:www-data /var/www/la_racine_du_site/
  # Attribution des éléments dans la racine aux développeurs
  chown -R www-data:developpeur /var/www/la_racine_du_site/*
  # Attribution des dossiers images aux graphistes
  chown -R www-data:graphiste /var/www/la_racine_du_site/images/
  # Interdiction d'accès à un dossier ayant pour vocation le déversement d'éléments par les utilisateurs du site
  chown -R www-data:www-data /var/www/la_racine_du_site/pdf/
  chmod 700 /var/www/la_racine_du_site/pdf/
  # Permission d'écriture pour le groupe dans un dossier
  chmod -R g+w /var/www/la_racine_du_site/
}
function install_ftp {
  user_ftpsecure
  groups
  ftp_users
  autorisations
}
install_ftp
