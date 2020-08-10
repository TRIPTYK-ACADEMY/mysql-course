FROM mysql

ENV MYSQL_ROOT_PASSWORD "test123*"

COPY ./sql /docker-entrypoint-initdb.d/