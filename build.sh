docker build -t mysql-cours .
docker run --name=cours -d -p 3306:3306 mysql-cours