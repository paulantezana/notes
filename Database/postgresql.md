# PostgreSQL
1. Instalacion en ubunut
    ``` bash
    sudo apt-get install postgresql
    ```

2. conectar a la base de datos
    ``` shell
    psql -U yoel -d review -h 127.0.0.1
    ```

3. Configuraciones en posgres

4. Copia de seguridad.
```bash
pg_dump --host localhost --port 5432 --username postgres --verbose --file recuperar.backup review
```

Ejecutar consultas SQL desde un archivos

```bash
\i archivo.extencion
```

mysqldump --compatible=postgresql --user=root --password= --host=localhost yarys --result-file=filename.sql 2>&1
mysqldump --compatible=postgresql --user=root --host=localhost capon --result-file=filename.sql 2>&1