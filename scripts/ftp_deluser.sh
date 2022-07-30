#!/bin/bash
# Suppressions des utilisateurs
echo "Quels utilisateurs supprimer? (utilisateur1 utilisateur2 ...)"
read user
for i in $user
do
  # On démonte les partages de l'utilisateur
  umount /home/$i/www/*
  # Suppression de l'utilisateur
  deluser $i --remove-home -q
  # Retrait de la liste des utilisateurs autoriser à utiliser le service
  sed -i '/'$i'/d' /etc/vsftpd.userlist
  # Retrait des point de montage de l'utilisateur
  sed -i '/'$i'/d' /etc/fstab
done
