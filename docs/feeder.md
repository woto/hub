Собрать инфу по собственным программам

```shell
docker-compose run feeder lib/advcampaigns-website-list.py -u 7d2aa22417cce0f405a1fd72fe16cb -p 37e5e3ff364d9b470b3b4d6cd4237d -w 599023
```

Весь список офферов

```shell
docker-compose run feeder lib/advcampaigns-list.py -u 7d2aa22417cce0f405a1fd72fe16cb -p 37e5e3ff364d9b470b3b4d6cd4237d -w 599023
```

Обработать фиды

```shell
docker-compose run feeder lib/download.py
```

https://github.com/sanand0/xmljson  
https://github.com/hay/xml2json  
https://github.com/vinitkumar/json2xml  

# TODO: change token in production