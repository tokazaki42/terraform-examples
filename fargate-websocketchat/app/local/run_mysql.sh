
docker pull mysql

docker pull busybox

#docker run -v /var/lib/mysql --name mysql_data busybox

docker run --volumes-from mysql_data -e MYSQL_ROOT_PASSWORD=root -d -p 3306:3306 mysql

