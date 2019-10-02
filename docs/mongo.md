Sort out with this. And later remove.

Подрубиться
```
docker run -it --rm --network=cpa mongo mongo cpa-mongo/admitad
```

Все регионы, дорвей траффик, товары (остальное по дефолту)
```
db.advcampaigns.count({traffics: {$elemMatch: {id: 4, enabled: true}}})
# 350
```

Россия, товары (остальное по дефолту)
```
> db.advcampaigns.count({regions: {$elemMatch: {"region": "RU"}}})
# 510
```
Странно, что через веб интерфейс отдаётся при этом больше - 548 программ

Загадка для чего website параметр в advcampaigns-list.py. Что с ним, что без него на первый взгляд ничего не меняется.
```
db.advcampaigns.count({status: "active", regions: {$elemMatch: {"region": "RU"}}, traffics: {$elemMatch: {id: 4, enabled: true}}})
```

Не обрабатываемые сейчас (пример)
```
db.advcampaigns_for_website.aggregate([{$unwind: "$feeds_info"}, {$match: {"feeds_info.processing": false}}, {$skip: 0}, {$limit: 3}, {$project: {"feeds_info": 1}}]).pretty()
```

Посчитать количество фидов, у которых processing отсутствует (пример)
```
db.advcampaigns_for_website.aggregate([{$unwind: "$feeds_info"}, {$match: {"feeds_info.processing": {$exists: false}}}, {$count: "name"}]).pretty()
```

Выбрать те, которые с ненулёвым error

```
db.advcampaigns_for_website.aggregate([{$unwind: "$feeds_info"}, {$match: {"feeds_info.error": {$ne: null}}}, {$project: {"name": 1, "feeds_info.error": 1, "feeds_info.processing_finished_at": 1}}]).pretty()
```


Посчитать количество, которых с ненулёвым error
```
db.advcampaigns_for_website.aggregate([{$unwind: "$feeds_info"}, {$match: {"feeds_info.error": {$ne: null}}}, {$project: {"feeds_info": 1}}, {$count: "name"}]).pretty()
```

Выбрать с определенным feeds_info.feed_name, показать только даты обновления
```
db.advcampaigns_for_website.aggregate([{$unwind: "$feeds_info"}, {$match: {"feeds_info.feed_name": "12storeez-17057-15283.yml"}}, { $project: { "feeds_info.advertiser_last_update": 1, "feeds_info.admitad_last_update": 1 } }]).pretty()
```