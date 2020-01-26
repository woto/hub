# nv6.ru

### Setup

Add `127.0.0.1 nv6.ru` to /etc/hosts  
Also you can use dnsmasq. Add `address=/nv6.ru/127.0.0.1` to `/etc/dnsmasq.conf` and restart service `systemctl restart dnsmasq.service`. It supports wildcard domains.

```shell
export HUB_ENV=development
docker-compose up -d
docker-compose exec rails ./bin/setup
```

**The following addressess available after project start up:**  
https://nv6.ru  
https://en.nv6.ru  
https://ru.nv6.ru  
...  
https://traefik.nv6.ru  
https://mailcatcher.nv6.ru  
https://elastic.nv6.ru  
https://kibana.nv6.ru  
https://netdata.nv6.ru  
https://swagger.nv6.ru  
https://mailcatcher.nv6.ru  
https://webpacker.nv6.ru  
https://prometheus.nv6.ru  
https://grafana.nv6.ru  
https://sentry.nv6.ru  
https://jaeger.nv6.ru  

**Anywere your encountered entering login / password try:**  
username: oganer@gmail.com  
password: qweQWE123!@#  

### Useful commands

```shell
docker-compose run -l "traefik.enable=false" --rm rails ./bin/rails c
docker-compose run -l "traefik.enable=false" --rm rails ./bin/setup
docker-compose up -d rails; docker attach hub_rails_1

docker-compose run -l "traefik.enable=false" --rm postgres psql -U hub -d postgres -h postgres
docker exec -i -t hub_postgres_1 psql -U hub -d postgres
```

### Testing

```shell
docker-compose run -l "traefik.enable=false" --rm rails rspec
docker-compose run -l "traefik.enable=false" --rm puppeteer
```

### Reverse ssh tunnel

```shell
ssh -R 80:localhost:80 -R 443:localhost:443 root@nv6.ru
```

### Style guide

- [Git commit messages rules](https://chris.beams.io/posts/git-commit/)

## Notes you should know

### Dynamic traefik routing

Due to the nature of dynamic routing in Traefik you may get stuck with unexpected problems with `Bad gateway`. It can happen because of launched engineering container. Suppose this situation. You started `rails` container (1) and you started another `rails` (2) container with console. Now Traefik may route web requests to (2) container where is the web server didn't run. To avoid this problems you should run container with `traefik.enable=false` label. Ex. `docker-compose run -l "traefik.enable=false" --rm rails ./bin/rails c`

### Environment variables
HUB_ENV must be set in host system to one of `development`, `test` or `production`
[DOMAIN_NAME is taken from .env file according to docker-compose functionality](https://docs.docker.com/compose/environment-variables/#the-env-file)



## Issues

### In case of problems with SSL certificate

```
traefik_1      | time="2019-11-04T19:21:54Z" level=info msg="Configuration loaded from flags."
traefik_1      | time="2019-11-04T19:21:54Z" level=error msg="Unable to add ACME provider to the providers list: unable to get ACME account: permissions 644 for /letsencrypt/acme.json are too open, please use 600"
```
and if will see same problem then do `chmod 600 docker/traefik/letsencrypt/acme.json`

### In case of incomprehensible mistakes with bundler gems

```
/usr/src/app/vendor/bundle/ruby/2.6.0/gems/bootsnap-1.4.4/lib/bootsnap/compile_cache/iseq.rb:37: G] Segmentation fault at 0x00000000000011c6
ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-linux-musl]

-- Control frame information -----------------------------------------------
c:0031 p:---- s:0188 e:000187 CFUNC  :fetch
c:0030 p:0069 s:0181 e:000180 METHOD /usr/src/app/vendor/bundle/ruby/2.6.0/gems/bootsnap-1.4lib/bootsnap/compile_cache/iseq.rb:37 [FINISH]
c:0029 p:---- s:0175 e:000174 CFUNC  :require
```

### In case of incomprehensible mistakes with yarn node modules

```
warning Integrity check: System parameters don't match
error Integrity check failed
error Found 1 errors.
========================================
  Your Yarn packages are out of date!
  Please run `yarn install --check-files` to update.
========================================
```

Sometimes when forgotten that all work being done in container, accidentaly commands like 'yarn install' or 'bundle install' may be issued on a host system then i highly recommend to remove './node_modules' or './vendor/bundle' and reinstall them with `docker-compose run --rm rails yarn install` or `docker-compose run --rm rails bundle install` and then recreate container `docker-compose restart webpacker` or `docker-compose restart rails`

## Database Schema

To generate database schema use following snippet:

```ruby
  require 'rails_erd/diagram/graphviz';
  RailsERD::Diagram::Graphviz.create
```

## TODO

### Domain Names

skunote.com  
shopregard.com  
skuseeker.com  
skueye.com  

### Localization

https://www.transifex.com/pricing/  
https://phrase.com/ru/pricing/  
https://weblate.org/ru/hosting/  
https://webtranslateit.com/en  
https://www.langapi.co/pricing  
https://www.oneskyapp.com/pricing/  
https://crowdin.com/pricing#annual  
