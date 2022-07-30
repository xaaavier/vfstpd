Script de mise en place d'un service FTPS utilisant le paquet VSFTPD.
# Avertissements
Ce script a été conçu pour fonctionner avec un serveur WEB (Apache ou Nginx) tournant sous Docker, je ne garantie pas son utilisation sans cela. De plus, ce git ayant pour fonction principale de sauvegarder et partager le travail réaliser lors de la formation Administrateur Systèmes et Réseaux que j'ai suivit, je ne peux que déconseiller son utilisation en production sans tests préalable.
Ce script fonctionne sur la distribution Debian 11. J'imagine qu'il devrait également être fonctionnel sur ses dérivées.
## Fonctionnement
Copier, télécharger, giter l'ensemble des fichiers et lancer

`./install_ftp.sh`

### Ajout et suppression d'utilisateur ultérieur
Sont inclus : 
- ftp_adduser.sh : script permettent de créer de nouveau(x) utilisateur(s)
- ftp_deluser.sh : script gérant la suppression d'utilisateur(s)

Ses deux scripts pourront être lancer depuis la racine du serveur à l'aide de la commande : 
"ftp_adduser.sh" ou "ftp_deluser.sh"
Selon le besoin.
