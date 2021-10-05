# Production

#### Rails console

```shell
docker-compose run -l "traefik.enable=false" --rm rails rails c
docker-compose run -l "traefik.enable=false" --rm rails -v /app:/app rails c
```

#### Dump PostgreSQL

```shell
docker-compose exec postgres pg_dump -d hub_production -U hub > /backup/db.dump
```

#### PostgreSQL console

From running container
```shell
docker exec -i -t hub_postgres_1 psql -U hub -d postgres
```
or from new container
```shell
docker-compose run -l "traefik.enable=false" --rm postgres psql -U hub -d postgres -h postgres
```

#### Reverse ssh tunnel

```shell
ssh -R 80:localhost:80 -R 443:localhost:443 root@goodreviews.ru
```