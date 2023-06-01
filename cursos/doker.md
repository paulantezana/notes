# Requerimientos
- WSL => Una manera de instalar Linux
    * Es necesario que este actualizado

# CLI
Se puede usar doker desde la consola de comandos usando el comando ``docker``
```cmd
docker --version
```

# Que es docker
![Que es docker](https://ualmtorres.github.io/SeminarioDockerPresentacion/images/DockerEngine.png)

## Contenedor
Un contenedor es como una maquina virtual, pero mucho mas liviano.

## Comandos
```cmd
$ docker run hello-world (corro el contenedor hello-world)
$ docker ps (muestra los contenedores activos)
$ docker ps -a (muestra todos los contenedores)
$ docker inspect <containe ID> (muestra el detalle completo de un contenedor)
$ docker inspect <name> (igual que el anterior pero invocado con el nombre)
$ docker run –-name hello-platzi hello-world (le asigno un nombre custom “hello-platzi”)
$ docker rename hello-platzi hola-platzy (cambio el nombre de hello-platzi a hola-platzi)
$ docker rm <ID o nombre> (borro un contenedor)
$ docker container prune (borro todos lo contenedores que esten parados)
```
## Ejecutar ubuntu:
Correr ubuntu
```cmd
docker run ubuntu 
```
Cada vez que un contendor se ejecuta, en realidad lo que ejecuta es un proceso del sistema operativo. Este proceso se le conoce como Main process.
* Main process: Determina la vida del contenedor, un contendor corre siempre y cuando su proceso principal este corriendo.
* Sub process: Un contenedor puede tener o lanzar procesos alternos al main process, si estos fallan el contenedor va a seguir encedido a menos que falle el main.
```cmd
docker run --name alwaysup -d ubuntu tail -f /dev/null
```
## Ejecutar nuevamente eun contenerdor activo
Te puedes conectar al contenedor y hacer cosas dentro del él con el siguiente comando (sub proceso)
```cmd
docker exec -it alwaysup bash
```
## Matar un proceso
Se puede matar un Main process desde afuera del contenedor, esto se logra conociendo el id del proceso principal del contenedor que se tiene en la maquina. Para saberlo se ejecuta los siguientes comandos;
```cmd
docker inspect --format '{{.State.Pid}}' alwaysup
```
_El output del comando es el process ID (2474) _
Para matar el proceso principal del contenedor desde afuera se ejecuta el siguiente comando (solo funciona en linux)
```cmd
kill -9 2474
```

## Comandos Con NGINX
Exponiendo contenedores: es decir hacer visible un puerto 80 en docker a la maquina en otro puerto
```cmd
$ docker run -d --name proxy nginx (corro un nginx)
$ docker stop proxy (apaga el contenedor)
$ docker rm proxy (borro el contenedor)
$ docker rm -f <contenedor> (lo para y lo borra)
$ docker run -d --name proxy -p 8080:80 nginx (corro un nginx y expongo el puerto 80 del contenedor en el puerto 8080 de mi máquina)
localhost:8080 (desde mi navegador compruebo que funcione)
$ docker logs proxy (veo los logs)
$ docker logs -f proxy (hago un follow del log)
$ docker logs --tail 10 -f proxy (veo y sigo solo las 10 últimas entradas del log)
```

## Comandos (bind mounts)
Compartir contenido entre contenedores o fuera del contenedor
```cmd
$ mkdir dockerdata (creo un directorio en mi máquina)
$ docker run -d --name db mongo
$ docker ps (veo los contenedores activos)
$ docker exec -it db bash (entro al bash del contenedor)
$ mongosh (me conecto a la BBDD)

    shows dbs (listo las BBDD)
    use platzi ( creo la BBDD platzi)
    db.users.insert({“nombre”:“guido”}) (inserto un nuevo dato)
    db.users.find() (veo el dato que cargué)
$ docker run -d --name db -v <path de mi maquina>:<path dentro del contenedor(/data/db mongo)> (corro un contenedor de mongo y creo un bind mount)
```

# Valumnes
Comandos:
```cmd
$ docker volume ls (listo los volumes)
$ docker volume create dbdata (creo un volume)
$ docker run -d --name db --mount src=dbdata,dst=/data/db mongo (corro la BBDD y monto el volume) en windows //data/db
$ docker inspect db (veo la información detallada del contenedor)
$ mongo (me conecto a la BBDD)

shows dbs (listo las BBDD)
use platzi ( creo la BBDD platzi)
db.users.insert({“nombre”:“guido”}) (inserto un nuevo dato)
db.users.find() (veo el dato que cargué)
```


# Insertar y extraer archivos en un contenedor
Comandos:
```cmd
$ touch prueba.txt (creo un archivo en mi máquina)
$ docker run -d --name copytest ubuntu tail -f /dev/null (corron un ubuntu y le agrego el tail para que quede activo)
$ docker exec -it copytest bash (entro al contenedor)
$ mkdir testing (creo un directorio en el contenedor)
$ docker cp prueba.txt copytest:/testing/test.txt (copio el archivo dentro del contenedor)
$ docker cp copytest:/testing localtesting (copio el directorio de un contenedor a mi máquina)
con “docker cp” no hace falta que el contenedor esté corriendo
```

## Construir propia imagen
```cmd
$ mkdir imagenes (creo un directorio en mi máquina)
$ cd imagenes (entro al directorio)
$ touch Dockerfile (creo un Dockerfile)
$ code . (abro code en el direcotrio en el que estoy)

##Contenido del Dockerfile##
FROM ubuntu:latest
RUN touch /ust/src/hola-platzi.txt (comando a ejecutar en tiempo de build)
##fin##

$ docker build -t ubuntu:platzi . (creo una imagen con el contexto de build <directorio>)
$ docker run -it ubuntu:platzi (corro el contenedor con la nueva imagen)
$ docker login (me logueo en docker hub)
$ docker tag ubuntu:platzi miusuario/ubuntu:platzy (cambio el tag para poder subirla a mi docker hub)
$ docker push miusuario/ubuntu:platzi (publico la imagen a mi docker hub)
```

# Usar docker para el desarrollo de aplicaciones
```cmd
$ git clone https://github.com/platzi/docker
$ docker build platziapp . (creo la imagen local)
$ docker image ls (listo las imagenes locales)
$ docker run --rm -p 3000:3000 platziapp (creo el contenedor y cuando se detenga se borra, lo publica el puerto 3000)
$ docker ps (veo los contenedores activos)
```

# Docker compose
## Docker compose comandos
```cmd
$ docker network ls (listo las redes)
$ docker network inspect docker_default (veo la definición de la red)
$ docker-compose logs (veo todos los logs)
$ docker-compose logs app (solo veo el log de “app”)
$ docker-compose logs -f app (hago un follow del log de app)
$ docker-compose exec app bash (entro al shell del contenedor app)
$ docker-compose ps (veo los contenedores generados por docker compose)
$ docker-compose down (borro todo lo generado por docker compose)
```

Archivo composer
```yml
version: "3.8"

services:
  app:
    build: .
    environment:
      MONGO_URL: "mongodb://db:27017/test"
    depends_on:
      - db
    ports:
      - "3000:3000"
    volumes:
      - .:/usr/src
      - /usr/src/node_modules
    command: npx nodemon --legacy-watch index.js

  db:
    image: mongo
```

Archivo imagen
```Dockerfile
FROM node:12

COPY ["package.json", "package-lock.json", "/usr/src/"]

WORKDIR /usr/src

RUN npm install

COPY [".", "/usr/src/"]

EXPOSE 3000

CMD ["node", "index.js"]
```