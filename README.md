# Documentation du projet

Ce projet permet de réaliser une sauvegarde d'un dossier ou d'un fichier et de la partager sur un serveur via NFS et d'en avoir une chaque jour.

Ce projet a été réalisé sur des machines sous Ubuntu.

Pour ce projet il vous faudra deux machines, un serveur et un client.

Voici comment installer chacune des machines:

## Serveur

Pour installer votre serveur il vous faudra tapez plusieurs lignes de commandes, pour cela il faudra ouvrir un terminal.

### Installer nfs-kernel-serveur

Tout d'abord, il vous faudra installer le paquet nfs-kernel-server, il vous permettra d'avoir un dossier partagé entre votre client et votre serveur.
Pour cela, il vous faudra rentrez cette commande:

```bash
sudo apt install nfs-kernel-server -y
```
### Créer le dossier partagé

Ensuite il vous faudra choisir où créer votre dossier partagé et quel nom il aura.
Nous avons choisi de le créer à la racine et de l'appeler shared_folder.

```bash
sudo mkdir /shared_folder
```

### Donner à notre machine l'IP du client

Vous allez devoir dire à votre serveur quel adresse IP possède votre client. Vous allez donc devoir editer le fichier /etc/hosts.
L'adresse IP de notre client est `192.168.62.4`.
Pour nous la commande sera celle là:

```bash
sudo echo "192.168.62.4 client">>/etc/hosts
```

### Permettre au client d'accéder au dossier partagé

Maintenant il faut dire que votre client a les droits d'écriture et de lecture sur votre dossier partagé et qu'il n'a pas besoin de droits spécifiques pour y accéder.
Pour ce faire, remplacez votre /shared_folder par votre nom de dossier dans la commande suivante:

```bash
sudo echo "/backup client(rw, no_root_squash)">>/etc/exports
```

### Redémarrez le service nfs-kernel-server

Redémarrez ensuite votre service nfs-kernel-server pour qu'il prenne en compte les modifications:

```bash
sudo service nfs-kernel-service reload
sudo service nfs-kernel-service restart
```

L'installation du serveur est désormais terminée !

## Client

Passons maintenant à l'installation du client.

### Installation de nfs

Il va falloir installer nfs sur le client aussi, mais pas le même que sur le serveur, pour le client il faudra installer nfs-common, pour cela il faut rentrer cette commande:

```bash
sudo apt-get install nfs-common -y
```

### Installation de borgbackup

Il nous faut aussi borg pour pouvoir réaliser un backup car c'est le logiciel que nous allons utiliser on va donc l'installer via cette commande:

```bash
sudo apt-get install borgbackup -y
```

### Script backup

Il va maintenant vous falloir récupérer notre fichier backup.sh et le placer à la racine de votre machine et lui donner les droits d'execution:

```bash
chmod +x backup.sh
```

### Donner l'adresse de votre serveur au client

Comme pour le serveur, on va devoir dire à notre machine client où se situe notre serveur sur le réseau.
Pour cela on va editer le fichier /etc/hosts comme sur le serveur.
Notre serveur a pour ip `192.168.62.5`.

On rentre donc la commande:

```bash
sudo echo "192.168.62.5 serveur">>/etc/hosts
```

### Monter le dossier de partage

Pour vérifier que ça c'est bien passé, on rentre cette commande

```bash
sudo showmount -e serveur
```

### Créer le dossier partagé sur le client

On va donc le mettre aussi à la racine comme sur le serveur, pour cela on va faire:

```bash
sudo mkdir /mkdir /backup
```

### Editer le fichier fstab

Pour faire fonctionner le lien entre le client et le serveur il va fallori editer le fichier fstab.
Pour ce faire on va rentrer cete commande:

```bash
sudo echo "serveur:/backup/ /backup nfs defaults,user,auto,noatime,bg 0 0">>/etc/fstab
```

L'installation du client est maintenant finie !

## Utiliser le backup.sh

Pour utiliser le backup.sh vous devrez rentrer cette commande:

```bash
/backup.sh
```

Sauf que le script attends des arguments, pour savoir ce dont il a besoin, veuillez rentrer cette commande:

```bash
/backup.sh -h
```

ou encore 

```bash
/backup.sh --help
```

Vous aurez ainsi toutes les informations nécessaires à l'utilisation de ce script.

## Automatiser la sauvegarde d'un dossier

Maintenant on va pouvoir automatiser la sauvegarde d'un dossier, pour cela on v adevoir ajouter une crontab.
Rien de bien compliqué il suffit de rentrer cette commande pour accéder au fichier des crontabs:

```bash
sudo crontab -e
```

Une fois dans ce fichier vous aller devoir rajouter une ligne à la fin pour chaque fichier ou dossier que vous souhaitez sauvegarder automatiquement.

Pour automatiser la sauvegarde sur le dossier Workspace qui se situe dans mon dossier home avec le nom BackupWorkspace tout les jours à 19h00, il faut alors rentrer:

```bash
0 19 * * * /backup.sh save BackupWorkspace ~/Workspace
```