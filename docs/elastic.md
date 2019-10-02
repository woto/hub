# Copied from old project cpa-elastic

Sort out with this. And remove legacy also as unnessary later network *cpa* in docker-compose.yml

```shell
docker run --rm -it \
  --network=cpa \
  --network=hub_hub \
  -p 9200:9200 \
  -p 9300:9300 \
  --ulimit nofile=65536:65536 \
  --ulimit core=100000000:100000000 \
  --ulimit memlock=100000000:100000000 \
  -e bootstrap.memory_lock=true \
  -e ES_JAVA_OPTS="-Xms8g -Xmx8g" \
  -e "discovery.type=single-node" \
  -v cpa-elastic:/usr/share/elasticsearch/data \
  -d \
  --name=cpa-elastic docker.elastic.co/elasticsearch/elasticsearch-oss:6.1.2
```

На хост системе должен быть выставлен vm.max_map_count=262144
https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-cli-run-prod-mode


```bash
curl -XGET 'localhost:9200/_search?pretty' -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "must": [
        { "match": { "name":   "Idealia Ночной пилинг" }}
      ]
    }
  }
}
' | less
```

```bash
curl -XGET 'localhost:9200/_search?pretty' -H 'Content-Type: application/json' -d'
{
    "size": 10000,
    "query": {
        "bool": {
            "must_not": {
              "term": {
                "_index": "1000-razmerov-18831-15860.yml_offers"
              }
            },
            "must": {
              "range" : {
                  "modified_time" : {
                      "lte": 1511100000001
                  }
              }
            }
        }
    }
}
' | less
```

http://localhost:9200/*offers/_search?q=%D0%BA%D0%B8%D1%81%D1%82%D0%BE%D1%87%D0%BA%D0%B0&pretty