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
