# Comandos
## Subir archivos al Servidor
    ``` bash
        $ scp main  yoel@13.68.218.250:/home/yoel/review
    ```
    ``` bash
        $ scp -rp carpeta/ yoel@13.68.218.250:/home/yoel/review
    ```

## Crear servicio en UBUNTU para manter ejecutado una app de GOLANG
Configuracion
se crea un nuevo archivo en
```
    sudo vim /etc/systemd/system/my-webapp.service
```

Luego se agrega los siguienets parametros
```
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

```
    sudo systemctl enable my-webapp.service
```

Luego se inicia el servicio
```
    sudo systemctl start my-webapp.service
```

Finalmente se verifica el estado del servicio
```
    sudo systemctl status my-webapp.service
```

