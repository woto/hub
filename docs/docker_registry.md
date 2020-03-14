# Docker registry setting up

```
docker run \
  --entrypoint htpasswd \
  registry:2 -Bbn oganer@gmail.com qweQWE123\!@# > auth/htpasswd
```

```shell
docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name registry \
  -v "$(pwd)"/auth:/auth \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  -v "$(pwd)"/certs:/certs \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.nv6.ru.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/registry.nv6.ru.key \
  registry:2
```

certificates extracts from acme.json
