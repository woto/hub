#### Completely clean and reseed

```
rake hub:elastic:clean db:migrate:reset db:seed hub:tests:seed
```

docker-compose up -d rails; docker attach hub_rails_1

#### Environment variables

HUB_ENV must be set in host system to one of `development`, `test` or `production`
[DOMAIN_NAME is taken from .env file according to docker-compose functionality]()