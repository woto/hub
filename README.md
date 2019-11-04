# nv6.ru

### Setup

```shell
docker-compose up -d
docker-compose exec rails ./bin/setup
```

### Testing

```shell
dco run --rm rails rspec
dco run --rm webpacker yarn test
```

```shell
ssh -R 80:localhost:80 -R 443:localhost:443 -R 8080:localhost:8080 -R 3035:localhost:3035 -R 19999:localhost:19999 root@nv6.ru
```

## Issues

### In case of problems with SSL certificate

```
traefik_1      | time="2019-11-04T19:21:54Z" level=info msg="Configuration loaded from flags."
traefik_1      | time="2019-11-04T19:21:54Z" level=error msg="Unable to add ACME provider to the providers list: unable to get ACME account: permissions 644 for /letsencrypt/acme.json are too open, please use 600"
```
and if will see same problem then do `chmod 600 docker/traefik/letsencrypt/acme.json`

### In case of incomprehensible mistakes

```
/usr/src/app/vendor/bundle/ruby/2.6.0/gems/bootsnap-1.4.4/lib/bootsnap/compile_cache/iseq.rb:37: G] Segmentation fault at 0x00000000000011c6
ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-linux-musl]

-- Control frame information -----------------------------------------------
c:0031 p:---- s:0188 e:000187 CFUNC  :fetch
c:0030 p:0069 s:0181 e:000180 METHOD /usr/src/app/vendor/bundle/ruby/2.6.0/gems/bootsnap-1.4lib/bootsnap/compile_cache/iseq.rb:37 [FINISH]
c:0029 p:---- s:0175 e:000174 CFUNC  :require
```

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