# Production

#### Scrapper shell
```shell
docker compose exec scrapper bash
```

#### Rails shell

From running container
```shell
docker compose exec rails sh
```

or from new container
```shell
docker compose run -l "traefik.enable=false" --rm rails sh
```

### Rails migrations

```shell
docker compose run -l "traefik.enable=false" --rm rails rake db:migrate
```

#### Rails console

```shell
docker compose run -l "traefik.enable=false" --rm rails rails c
docker compose run -l "traefik.enable=false" --rm rails -v /app:/app rails c
```

#### PostgreSQL console

From running container
```shell
docker exec -i -t hub_postgres_1 psql -U hub -d postgres
```

or from new container
```shell
docker compose run -l "traefik.enable=false" --rm postgres psql -U hub -d postgres -h postgres
```

#### Reverse ssh tunnel

```shell
ssh -R 80:localhost:80 -R 443:localhost:443 root@goodreviews.ru
```

#### Delete github workflows

```shell
gh api repos/woto/hub/actions/runs | jq -r '.workflow_runs[] | "\(.id)"' | xargs -n1 -I % gh api repos/woto/hub/actions/runs/% -X DELETE
```
