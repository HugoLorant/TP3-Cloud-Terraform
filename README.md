# TP3-Cloud-Terraform

Le but de ce TP est de déployer Nextcloud sur Scaleway en utilisant Terraform et Ansible

## Prérequis sur les machines clientes

### Installer Terraform

Sur notre machine, nous devons télécharger Terraform <br />
Sous Linux, on peut le télécharger avec :
```
apt install terraform
```
Sous macOS, on peut le télécharger avec :
```
brew install terraform
```

### Installer les clés SSH Scaleway

Tout d'abord, on doit installer le paquet correspondant au provider Scaleway <br />
Sous Linux :
```
apt install scw
```
Sous macOS :
```
brew install scw
```
Ensuite, on utilise la commande ```scw init``` qui va nous demander un ID de projet. Cet ID se trouve sur la console du projet sur le site de Scaleway

## Configuration avec les fichiers Terraform

Le fichier Terraform va permettre de créer les instances sur Scaleway grace à notre fichier ```main.tf``` <br />
Ce fichier contient les instructions qui vont dire à la console Scaleway quel type de serveur il faut créer, avec quel paramètre, etc...

Lorsque l'on est prêt à lancer le déploiement on éxécute ces commandes à la suite :

Cette commande va permettre d'initialiser le projet Terraform :
```
terraform init
```
Puis, on peut valider les modifications :
```
terraform plan
```
Et ensuite, appliquer les modifications pour que le déploiement se lance :
```
terraform apply
```
-----
Pour vérifier si une configuration est valide ou non, on peut lancer la commande :
```
terraform validate
```
Et pour détruire le projet si le résultat n'est pas celui attendu :
```
terraform destroy
```

## Lien avec Ansible

### Pour quoi faire ?

Terraform est utilisé pour créér les instances sur le provider. Cependant, les instances sont vierges et non configurées <br />
C'est pour cela que l'on utilise un playbook Ansible afin de paramétrer nos instances pour les rendres fonctionnelles

### Lier Terraform et Ansible

On peut lier les instances Terraform avec le playbook Ansible en utilisant les propriétés ```cloud-init``` ainsi qu'en liant les clés SSH entre les 2

### Configuration Ansible

Dans le fichier de configuration Ansible on retrouvera les étapes nécessaires à la création des élements suivantes nécessaires pour Nextcloud :
- Installation du serveur Web Apache2
- Installation de PHP 7.4
- Installation de Unzip
- Le téléchargement de l'archive .zip contenant Nextcloud
- L'extraction de l'archive
- L'attribution des droits nécessaires au bon fonctionnement de Nextcloud
- La modification du répertoire web par défaut d'Apache2
- Le redémarrage du service Apache2
