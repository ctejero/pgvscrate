#!/bin/bash

#Debemos indicar con el parametros $1, la carga de datos a utilizar por TPC-H
carga=$1
echo $carga


####################
# INSTALACION BASE #
####################

#Instalacion de herramientas necesarias
yum install wget unzip gcc java-1.8.0-openjdk -y


################################
# INSTALACION JMETER + DRIVERS #
################################

#Instalamos jmeter
wget -q -O jmeter.tgz http://apache.dattatec.com/jmeter/binaries/apache-jmeter-5.1.1.tgz
tar xfz jmeter.tgz -C /opt/
rm -f jmeter.tgz

#Instalamos los drivers JDBC
wget -q -O /opt/apache-jmeter-5.1.1/lib/postgresql-42.2.5.jar https://jdbc.postgresql.org/download/postgresql-42.2.5.jar
wget -q -O /opt/apache-jmeter-5.1.1/lib/crate-jdbc-standalone-2.5.1.jar https://bintray.com/crate/crate/download_file?file_path=io/crate/crate-jdbc-standalone/2.5.1/crate-jdbc-standalone-2.5.1.jar


#############################
# GENERACION DE DATOS TPC-H #
#############################

#Vamos a construir el DBGEN, que es la herramienta de TPCH que nos genera los datos
unzip /vagrant/tpch.zip -d /vagrant/tpch
cd /vagrant/tpch/dbgen
cp -v makefile.suite Makefile
sed -i 's/^CC.*=/CC=gcc/g' Makefile
sed -i 's/^DATABASE.*=/DATABASE=ORACLE/g' Makefile
sed -i 's/^MACHINE.*=/MACHINE=LINUX/g' Makefile
sed -i 's/^WORKLOAD.*=/WORKLOAD=TPCH/g' Makefile
make

#Generamos los datos, pasa que lo hace para ORACLE, asi que le quitamos una | demas que le pone al final
./dbgen $carga -f
for i in `ls *.tbl`; do sed 's/|$//' $i > /tmp/${i/tbl/csv}; rm -f $i; done;


##########################
# INSTALACION POSTGRESQL #
##########################

#Instalacion de PostgreSQL 11
yum install https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-7-ppc64le/pgdg-centos11-11-2.noarch.rpm -y
yum install postgresql11-server -y

#Inicializamos el cluster
/usr/pgsql-11/bin/postgresql-11-setup initdb

#Permitimos la conexion de usuarios por socket con usuario y contraseña
sed -i 's/ident$/md5/g' /var/lib/pgsql/11/data/pg_hba.conf

#Iniciamos el servidor
systemctl start postgresql-11


########################
# POSTGRESQL BENCHMARK #
########################

#Creamos la base TPC-H en PostgreSQL
runuser -l postgres -c "psql -c \"CREATE USER vagrant WITH SUPERUSER PASSWORD 'vagrant';\""
runuser -l postgres -c "psql -c \"CREATE DATABASE tpch;\""
runuser -l postgres -c "psql -c \"ALTER DATABASE tpch OWNER TO vagrant;\""

#Creamos la estructura TPC-H en PostgreSQL
runuser -l vagrant -c "psql -f /vagrant/postgresql/01-create.sql tpch"

#Ejecutamos las pruebas de rendimiento de carga
/opt/apache-jmeter-5.1.1/bin/jmeter -n -t /vagrant/PostgreSQLLoad.jmx -l /vagrant/PostgreSQLLoad.csv

#Borramos los datos, ya no hacen falta
rm -f /tmp/*.csv

#Creamos los indices
runuser -l vagrant -c "psql -f /vagrant/postgresql/02-index.sql tpch"

#Ejecutamos las pruebas de rendimiento de consulta
/opt/apache-jmeter-5.1.1/bin/jmeter -n -t /vagrant/PostgreSQLQuery.jmx -l /vagrant/PostgreSQLQuery.csv


#####################
# INSTALACION CRATE #
#####################

#Preparamos los datos para crate (usando postgreslql)
runuser -l vagrant -c "psql -f /vagrant/postgresql/03-dump.sql tpch"
chown root:vagrant /tmp/*.csv
chmod 0666 /tmp/*.csv

#Borramos la base y detenemos postgresql, ya no lo necesitamos
runuser -l postgres -c "psql -c \"DROP DATABASE tpch;\""
systemctl stop postgresql-11

#Instalacion de Crate
rpm --import https://cdn.crate.io/downloads/yum/RPM-GPG-KEY-crate
rpm -Uvh https://cdn.crate.io/downloads/yum/7/noarch/crate-release-7.0-1.noarch.rpm
yum install crate -y

#Instalacion del cliente de linea de comando de Crate
mkdir /root/bin
wget -q -O /root/bin/crash https://cdn.crate.io/downloads/releases/crash_standalone_0.23.0
chmod u+x /root/bin/crash

#Le agrandamos el HEAP (por defecto viene muy pequeño)
sed -i 's/^CRATE_HEAP_SIZE.*=.*m$/CRATE_HEAP_SIZE=4096m/g' /etc/sysconfig/crate

#Lo ponemos a correr
systemctl start crate

#El inicio es asincronico, asi que puede fallar al conectarse, lo vamos a esperar
salir=0
while [ $salir -eq 0 ]; do
    /root/bin/crash --sysinfo > /dev/null 2> /dev/null
    if [ $? -ne 0 ]; then
        sleep 1
    else
        salir=1
    fi    
done


###################
# CRATE BENCHMARK #
###################

#Creamos la base TPC-H en Crate
for sql in $(ls /vagrant/crate/*.sql); do crash -c "$(cat $sql)"; done

#Ejecutamos las pruebas de rendimiento de carga
/opt/apache-jmeter-5.1.1/bin/jmeter -n -t /vagrant/CrateLoad.jmx -l /vagrant/CrateLoad.csv

#Borramos los datos, ya no hacen falta
rm -f /tmp/*.csv

#Ejecutamos las pruebas de rendimiento de consulta
/opt/apache-jmeter-5.1.1/bin/jmeter -n -t /vagrant/CrateQuery.jmx -l /vagrant/CrateQuery.csv

