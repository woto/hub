# nv6.ru

```
docker-compose up -d
docker-compose exec rails ./bin/setup
```

```
ssh -R 80:localhost:80 -R 443:localhost:443 -R 8080:localhost:8080 -R 3035:localhost:3035 root@nv6.ru
```

## Issues

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


## Notes

Obtaining of SSL Certificate with certbot is based on article:  
https://medium.com/@pentacent/nginx-and-lets-encrypt-with-docker-in-less-than-5-minutes-b4b8a60d3a71
