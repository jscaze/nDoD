The aim of this demo is to build a real-time datapipeline in real conditions applied to a real case

## ROADMAP
1 - get envirronement

## Technical stack
We will stream data from PostgreSQL to Kafka using Debezium
=> the plugin for Debezium has been provided, feel free to replace it with a mor recent version

Then we will analyse data through Druid.

### Docker images

## Preliminary steps
Check that docker image does not already runs

```console
docker ps -a
```
or
```console
cd nDoD/docker/kafka
docker-compose ps
```
if it already runs :
```console
docker-compose stop

docker-compose rm
```
## build and run docker image 
Build the docker image
```console
cd nDoD/docker/kafka

docker-compose up -d
```
## Check that the service runs
#### Check all the docker images which runs on the machine
```console
docker-compose ps
``` 
#### Check that zookeeper runs
```console
docker-compose logs zookeeper | grep -i binding
```
#### Check that Kafka broker runs
```console
docker-compose logs broker | grep -i started
```
Check that Kafka connect runs
```console
docker-compose logs connect | grep -i "server is started and ready to handle requests" 
```

Check that postgres run
```console
docker-compose exec postgres bash -c 'psql -U postgres postgres'
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

#### Debezium
```console
```

## Business stack

