## Install Apache
```bash
sudo apt-get update
sudo apt-get install apache2
sudo service apache2 start
```

```bash
/etc/apache2/apache2.conf

<Directory /var/www/html/>
        Options Indexes FollowSymLinks
        AllowOverride All               # Modificar solo este parametro en caso de que .htacces no funcione
        Require all granted
</Directory>
```
```bash
sudo a2enmod rewrite
sudo service apache2 restart
```

## Install MySQL
https://noviello.it/es/como-instalar-mysql-5-7-en-ubuntu-20-04-lts/
sudo apt install -f mysql-client=5.7.36-1ubuntu18.04 mysql-community-server=5.7.36-1ubuntu18.04 mysql-server=5.7.36-1ubuntu18.04

```bash
# sudo apt-get install mysql-server@5.7* mysql-client@5.7*
# sudo service mysql start
# sudo systemctl status mysql
```

## Install php
```bash
sudo apt-get install php libapache2-mod-php php-mysql
```

## Permisos
Es necesario crear un nuevo usuario con todo los permisos ya que el usuario root es necesasio ser un usuario **sudo**
```bash
CREATE USER 'local_yoel '@'localhost' IDENTIFIED BY 'cascadesheet';
GRANT ALL PRIVILEGES ON *.* TO 'local_yoel'@'localhost';
```
## Remote user
Configurar usuario remoto para coneciones remotas
```bash
sudo grep -R bind /etc/mysql
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
# bind-address            = 0.0.0.0

sudo grep -R bind /etc/mysql
sudo /etc/init.d/mysql restart


sudo mysql -u root -p
```
```sql
CREATE USER 'store_desa'@'localhost' IDENTIFIED BY 'hD^0$5E4O!Gp';

CREATE USER 'store_desa'@'%' IDENTIFIED BY 'hD^0$5E4O!Gp';

GRANT ALL PRIVILEGES ON *.* to store_desa@localhost IDENTIFIED BY 'hD^0$5E4O!Gp' WITH GRANT OPTION;

GRANT ALL PRIVILEGES ON *.* to store_desa@'%' IDENTIFIED BY 'hD^0$5E4O!Gp' WITH GRANT OPTION;

FLUSH PRIVILEGES;

EXIT;
```








# GitHub
```bash
ssh-keygen -t rsa -b 4096 -C "yoel.antezana@gmail.com"
```