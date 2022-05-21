# TRY6101 - Tecnologias de Respaldo y Recuperacion

### Comprobaciones
- [x] RockyLinux 8 + MySQL 8 (Repo Default)

### Notas
- En RockyLinux 8 el MySQL que se instala por defecto desde el repositorio es version 8 el cual tiene por defecto el engine INNODB activado, para el caso de "Hot backup - Database freezing" el comando sirve para bases de datos que estan en el Engine MyISAM, lo que no quita que debamos ejecutar para tener un respaldo consistente.

Update: 21/05/2022
