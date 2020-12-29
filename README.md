The aim of this demo is to build a real-time datapipeline in real conditions applied to a real case

## ROADMAP
1 - get envirronement

## Technical stack
We will stream data from PostgreSQL to Kafka using Debezium
Then we will analyse data through Druid.

### Docker images
This demo rely on several docker images

#### Confluent community edition 
Get the git repository
```console
git clone https://github.com/confluentinc/cp-all-in-one.git
```
Go into the community directory 
```console
cd cp-all-in-one/cp-all-in-one-community
```
Get the latest version
```console
git checkout 6.0.1-post
```
Build the docker image
```console
docker-compose up -d
```
##### Check that the service runs
Check all the docker images which runs on the machine
```console
docker ps 

docker compose ps
```
Check that zookeeper runs
```console
docker-compose logs zookeeper | grep -i binding
```
Check that Kafka broker runs
```console
docker-compose logs broker | grep -i started
```
Check that Kafka connect runs
```console
docker-compose logs connect | grep -i "server is started and ready to handle requests" 
```
##### Test the broker 

```console
docker-compose exec broker kafka-topics --create --topic foo --partitions 1 --replication-factor 1 --if-not-exists --zookeeper localhost:32181
```

##### Test that Kafka connect contains the plugins 

```console
docker-compose exec  connect ls -l /etc/kafka-connect/plugins/ 
```

####  
```console
docker pull obsidiandynamics/kafdrop
```
```console
```

Then access the UI at http://localhost:9000

#### PostgresSQL
```console
docker pull debezium/postgres
```
```console
docker run --name postgres -p 5000:5432 -e POSTGRES_PASSWORD="postgrespwd" -e POSTGRES_USER="postgres"  debezium/postgres
```
##### Connection throught pgAdmin

#### Debezium
```console
docker run -it --name connect -p 8083:8083 -e GROUP_ID=1 -e CONFIG_STORAGE_TOPIC=my-connect-configs -e OFFSET_STORAGE_TOPIC=my-connect-offsets -e ADVERTISED_HOST_NAME=$(echo $DOCKER_HOST | cut -f3 -d'/' | cut -f1 -d':') --link zookeeper:zookeeper --link postgres:postgres --link broker:kafka debezium/connect
```

## Business stack

