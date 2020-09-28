## Install Apache
```bash
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
```bash
sudo apt-get install mysql-server mysql-client
sudo service mysql start
```


## Install php
```bash
apt-get install php libapache2-mod-php php-mysql
```

## Permisos
Es necesario crear un nuevo usuario con todo los permisos ya que el usuario root es necesasio ser un usuario **sudo**
```bash
CREATE USER 'local_yoel '@'localhost' IDENTIFIED BY 'cascadesheet';
GRANT ALL PRIVILEGES ON *.* TO 'local_yoel'@'localhost';
```