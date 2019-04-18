# Ubunut
Hay muchas operaciones que se realizaran mediante ssh. Ahora bien, copiar, mover y renombrar directorios (carpetas) desde la línea de comandos es un proceso de rutina pero que puede ser confuso cuando estamos iniciándonos. Así que aquí veremos cómo hacerlo:

## Copiar directorios
Para copiar directorios completos (con todos sus archivos y subcarpetas internas):
```bash
cp -r directorio/ ruta_de_destino/nombre_copia
```

Lo explico:

* El comando cp en Linux crea una copia.
* Al escribir cp -r indicamos recursividad, es decir, que haga lo mismo con todos los elementos internos (archivos y subcarpetas)
* El nombre del directorio debe terminar con una barra (/), asi indicamos que se trata de una carpeta. Sin la barra, Linux considera que estamos manejando un archivo y nos dará error.
* Luego de un espacio se escribe el nombre del directorio de destino y su ruta (puede ser relativa al directorio origen o a la raiz)
* Las rutas del directorio de origen y el de destino pueden ser relativas a la raiz o al directorio de trabajo actual.

Ejemplos:

Para copiar el directorio fonts al directorio fonts2 en una carpeta por encima de la actual:
```bash
cp -r fonts/ ../fonts2
```

Para copiar el directorio fonts al directorio fonts2 en la misma carpeta
```bash
cp -r fonts/ fonts2
```

## Mover directorios
Para mover directorios la sintaxis es casi la misma, con la diferencia que no se necesita indicar recursividad.
```bash
mv directorio ruta_de_destino/nombre_directorio
```

Lo explico:

* El comando mv mueve un directorio o un archivo (lo elimina de su ubicación original y lo "coloca" en una nueva ubicacion).
Ejemplo 1 (mover el directorio img a un nivel por encima sin cambiarle el nombre)
```bash
mv img ../img
```

Ejemplo 2 (mover el directorio img a la carpeta interna files cambiandole el nombre a images)
```bash
mv img files/images
```

## Renombrar directorios
Para renombrar directorios usamos el mismo comando mv, pero no es necesario indicar una nueva ruta para el directorio, solo un nuevo nombre.
```bash
mv directorio directorio_renombrado
```

Como vemos basta escribir el nombre del directorio (sin barra al final) y dejando un espacio, el nuevo nombre. Así, si queremos renombrar el directorio img a images lo haríamos así:
```bash
mv img images
```

# Comandos
## Instalar Node js en Ubuntu producción

siguiendo las instrucciones de jonatan mircha YOUTUBE

https://www.youtube.com/watch?v=s_mNK_lg2Jw&list=PLvq-jIkSeTUY3gY-ptuqkNEXZHsNwlkND&index=67

```bash
sudo apt-get update
sudo apt-get install nodejs
sudo apt-get install npm
sudo apt-get install git
```

Instalar nodejs con NVM

```bash
sudo apt-get remove nodejs
sudo apt-get install build-essential libssl-dev
```

ir a [repositorio](https://github.com/creationix/nvm) para la instalación de NVM

```bash
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
source ~/.bashrc
nvm install 10.15.1
nvm use 10.15.1
nvm ls
```

Configurar un Servidor Proxy

```bash
sudo apt-get update
sudo apt-get install nginx
sudo vi /etc/nginx/sites-available/default
```

```nginx
server {
    listen 80;
    server_name example.com;
    location / {
        proxy_pass http://APP_PRIVATE_IP_ADDRESS:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

```bash
sudo service nginx restart
```

Instalación i configuración PM2 para mantener ejecutando app nodejs 

```bash
npm install pm2 -g
```

```bash
pm2 start server.js
```

en caso de no tener un dominio se puede configurar la tarjeta de red en ubuntu SOLO EN DEV

```bash
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3102
```

```bash
sudo service nginx restart
```



## Subir archivos al Servidor

```shell
scp main  yoel@13.68.218.250:/home/yoel/review
```
carpetas
```shell
scp -rp carpeta/ yoel@13.68.218.250:/home/yoel/review
```

## Crear servicio en UBUNTU para manter ejecutado una app de GOLANG
Configuracion
se crea un nuevo archivo en

```shell
    sudo vim /etc/systemd/system/my-webapp.service
```

Luego se agrega los siguientes parámetros
```vi
    [Unit]
    Description="API service de go para distintas aplicaciones"

    [Service]
    ExecStart=/home/yoel/review/main
    WorkingDirectory=/home/yoel/review
    User=yoel
    Restart=always

    [Install]
    WantedBy=multi-user.target
```

Luego se registra este servicio

```shell
    sudo systemctl enable my-webapp.service
```

Luego se inicia el servicio
```shell
    sudo systemctl start my-webapp.service
```

Finalmente se verifica el estado del servicio
```shell
    sudo systemctl status my-webapp.service
```

mkdir admission review certificate monitoring librarie student web