# goodreviews.ru

### Setup

```shell
export HUB_ENV=development
docker-compose up -d
docker-compose exec rails ./bin/setup
```

**The following addressess available after project start up:**  
http://localhost:3000
http://ru.localhost.lvh.me:3000/
http://en.localhost.lvh.me:3000/
...
https://traefik.nv6.ru  
https://mailcatcher.nv6.ru  
https://elastic.nv6.ru  
https://kibana.nv6.ru  
https://mailcatcher.nv6.ru  
https://webpacker.nv6.ru  

### Useful commands

```shell
bundle exec rake hub:elastic:clean db:migrate:reset db:seed
docker-compose run -l "traefik.enable=false" -v /app:/app --rm rails bundle exec rails c
docker-compose exec postgres pg_dump -d hub_production -U hub > /backup/2021-09-12
docker-compose run -l "traefik.enable=false" --rm rails ./bin/rails c
docker-compose run -l "traefik.enable=false" --rm rails ./bin/setup
docker-compose up -d rails; docker attach hub_rails_1

docker-compose run -l "traefik.enable=false" --rm postgres psql -U hub -d postgres -h postgres
docker exec -i -t hub_postgres_1 psql -U hub -d postgres
```

```ruby
Sync::AdmitadJob.perform_later
Feed.find_each { |feed| Import::ProcessJob.perform_later(feed) }
Feed.count.times { Import::ProcessJob.perform_later }
```

### Testing

```shell
docker-compose run -l "traefik.enable=false" --rm rails rspec
```

### Reverse ssh tunnel

```shell
ssh -R 80:localhost:80 -R 443:localhost:443 root@nv6.ru
```

## Notes you should know

### Dynamic traefik routing

Due to the nature of dynamic routing in Traefik you may get stuck with unexpected problems with `Bad gateway`. It can happen because of launched engineering container. Suppose this situation. You started `rails` container (1) and you started another `rails` (2) container with console. Now Traefik may route web requests to (2) container where is the web server didn't run. To avoid this problems you should run container with `traefik.enable=false` label. Ex. `docker-compose run -l "traefik.enable=false" --rm rails ./bin/rails c`

### Environment variables
HUB_ENV must be set in host system to one of `development`, `test` or `production`
[DOMAIN_NAME is taken from .env file according to docker-compose functionality](https://docs.docker.com/compose/environment-variables/#the-env-file)


## Database Schema

To generate database schema use following snippet:

```ruby
  require 'rails_erd/diagram/graphviz';
  RailsERD::Diagram::Graphviz.create
```
