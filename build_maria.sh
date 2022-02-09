docker build -f Dockerfile_maria -t mariadb-cours .
docker run --name=cours -d -p 3306:3306 mariadb-cours