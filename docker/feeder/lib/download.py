import pymongo, mongo, pdb, json, requests, re, sys, signal, pprint, uuid, progressbar, traceback
from slugify import slugify
from pymongo import ReturnDocument
from datetime import datetime, timedelta
from xml.etree.ElementTree import XMLParser, ParseError
from json import dumps
from elasticsearch import Elasticsearch

def safe_exit(processing_finished_at, feed_name, error):
    print("Releasing job")
    doc = col.find_one_and_update(
        { "feeds_info": { "$elemMatch": { "uuid": mark } } },
        { "$set": {
            "feeds_info.$.feed_name": feed_name,
            "feeds_info.$.processing": False,
            "feeds_info.$.processing_finished_at": processing_finished_at,
            "feeds_info.$.error": error } },
        return_document=ReturnDocument.AFTER,
        projection = { "id": 1, "name": 1, "feeds_info" : { "$elemMatch": { "uuid": mark} } } )
    if doc:
        pprint.pprint(doc)
        print("Job released")
    else:
        print("Nothing to release")

def signal_handler(signal, frame):
    safe_exit(None, None, None)
    sys.exit(0)

class Import:

    BULK_AMOUNT = 1000
    PRINT_PROGRESS_EVERY_N_ROWS_COUNTER = 100
    ELASTIC = 'http://elastic:9200'
    IMPORT_EVERY_N_OFFER = 1
    TOTAL_IMPORTING_OFFERS = 2000

    def __init__(self, index):

        self.index = index
        # отмечаем, что начался <category> или <offer>
        self.in_tag = False
        # массив rows для последующей отправки в elastic
        self.rows = []
        # один элемент row
        self.row = {}
        # текущий обрабатываемый tag (чтобы понять где находимся в методе data())
        self.tag = ''

        # при каждом заходе в тег увеличиваем счетчик при выходе уменьшаем
        # (сейчас работает как ограничитель, т.к. вложенных пока не обнаружено)
        self.nest_level = 0
        # запоминает теги, которые уже встречал в row (сейчас работает как
        # ограничитель для обнаружения тегов, которые могут являться массивами,
        # например как picture или param)
        self.seen_tags = []

        # Общий счетчик количества row в одном фиде. Используется для
        # индикации прогресса
        self.rows_counter = 0

        # 1. Теги, имеющие один уровень вложения и не имеющие аттрибутов
        self.one_level_tags = ('url', 'store', 'email', 'platform', 'version', 'agency', 'buyurl', 'pickup', 'delivery', 'deliveryIncluded', 'local_delivery_cost', 'orderingTime', 'onstock', 'deliveryTime', 'price', 'wprice', 'currencyId', 'market_category', 'typePrefix', 'vendorCode', 'model', 'author', 'name', 'publisher', 'ISBN', 'volume', 'part', 'language', 'binding', 'page_extent', 'table_of_contents', 'performed_by', 'performance_type', 'storage', 'format', 'recording_length', 'series', 'year', 'artist', 'title', 'media', 'starring', 'director', 'originalName', 'country', 'description', 'sales_notes', 'promo', 'aliases', 'provider', 'tarifplan', 'xCategory', 'additional', 'worldRegion', 'region', 'days', 'dataTour', 'hotel_stars', 'room', 'meal', 'included', 'transport', 'price_min', 'price_max', 'options', 'manufacturer_warranty', 'country_of_origin', 'downloadable', 'adult', 'age', 'related_offer', 'place', 'hall_part', 'is_premiere', 'is_kids', 'date', 'oldprice', 'min-quantity', 'step-quantity', 'modified_time', 'cpa', 'rec')

        # 2. Теги, имеющие один уровень вложения и опционально имеющие аттрибуты
        self.one_level_tags_with_attribs = ('accessory')

        # 3. Теги, имеющие один уровень вложения, но являющиеся массивами и опционально имеющие аттрибуты
        # На самом деле categoryId должен быть только в единственном числе согласно документации Yandex
        # Но слишком многие нарушают это правило, поэтому он в этом tuple
        self.arrays_tags_with_attributes = ('param', 'categoryId')

        # 4. Теги, имеющие один уровень вложения, но являющиеся массивами и не имеющие аттрибутов
        self.arrays_tags_without_attributes = ('picture', 'barcode', 'vendor')

        # 5. Теги о которых мы узнали, но не хотим их использовать
        self.skipped_tags = ('itemsleft', 'topseller')

        self.categories_dict = {}
        self.categories_dict_id = None

    def dry_restrict(self, tag, attribs):
        if attribs:
            print(self.row)
            raise Exception(f"{tag} имеет аттрибуты {attribs}")
        if tag in self.seen_tags:
            print(self.row)
            raise Exception(f"{tag} является массивом")
        else:
            self.seen_tags.append(tag)

    def start(self, tag, attribs):
        self.tag = tag

        if tag == 'category':
            parent_id = None
            id = self.categories_dict_id = attribs['id']

            if 'parentId' in attribs:
                parent_id = attribs['parentId']
            elif 'parent_id' in attribs:
                parent_id = attribs['parent_id']

            self.categories_dict[id] = {
                'parent_id': parent_id,
                'id': id
            }

        if tag in ('offer', 'category'):
            self.nest_level = 0
            self.in_tag = True
            self.row = {f"@{k}": v for k, v in attribs.items()}

        elif self.in_tag:

            self.nest_level += 1
            if self.nest_level > 1:
                print(self.row)
                raise Exception(f"Уровень вложения {tag} более 1")

            # 1
            if tag in self.one_level_tags:
                self.dry_restrict(tag, attribs)
                self.row[tag] = ''
            # 2
            elif tag in self.one_level_tags_with_attribs:
                if tag in self.seen_tags:
                    print(self.row)
                    raise Exception(f"{tag} является массивом")
                else:
                    self.seen_tags.append(tag)
                self.row[tag] = {f"@{k}": v for k, v in attribs.items()}
            # 3
            elif tag in self.arrays_tags_with_attributes:
                # Если нет аттрибутов, то это не ошибка
                if tag not in self.row:
                    self.row[tag] = []
                self.row[tag].append({f"@{k}": v for k, v in attribs.items()})
            # 4
            elif tag in self.arrays_tags_without_attributes:
                if attribs:
                    print(self.row)
                    raise Exception(f"{tag} имеет аттрибуты {attribs}")
                if tag not in self.row:
                    self.row[tag] = ['']
                else:
                    self.row[tag].append('')
            # 5
            elif tag in self.skipped_tags:
                pass
            # 6
            else:
                self.dry_restrict(tag, attribs)
                # Засовываем неизвестные теги в param
                if 'param' not in self.row:
                    self.row['param'] = []
                self.row['param'].append({'@name': f"{tag}"})

    def get_path(self, id):

        if id not in self.categories_dict:
            return []

        if self.categories_dict[id]['parent_id'] is not None:
            return [self.categories_dict[id], *self.get_path(self.categories_dict[id]['parent_id'])]
        else:
            return [self.categories_dict[id]]

    def end(self, tag):

        if tag == 'categoryId':
            self.row['categories_tree'] = self.get_path(self.row['categoryId'][0]['#'])

        if tag == 'modified_time':
            self.row[tag] = int(self.row[tag]) * 1000

        # мы хотим чтобы запись в elastic осуществлялась блоками с <offer> или <category> или например
        # после закрытия </categories> или </offers> поэтому особым образом определяем имя индекса
        if tag in ('category', 'categories'):
            index_postfix = 'categories'
        elif tag in ('offer', 'offers'):
            index_postfix = 'offers'

        if tag in ('offer', 'category'):
            self.seen_tags = []
            self.rows_counter += 1

            if self.rows_counter % self.PRINT_PROGRESS_EVERY_N_ROWS_COUNTER == 0:
                self.progress(tag)

            cond1 = tag == 'category'
            cond2 = tag == 'offer' and \
                self.rows_counter % self.IMPORT_EVERY_N_OFFER == 0 and \
                self.rows_counter / self.IMPORT_EVERY_N_OFFER <= self.TOTAL_IMPORTING_OFFERS
            if cond1 or cond2:
                self.rows.append(self.row)

                if(len(self.rows) == self.BULK_AMOUNT):
                    self.bulk_save(self.index + "_" + index_postfix)

            self.in_tag = False
        elif self.in_tag:
            self.nest_level -= 1

        # Если это закрывающий тег </categories> или </offers> то мы должны произвести последнюю
        # запись self.rows
        if tag in ('categories', 'offers'):
            self.progress(tag)
            self.bulk_save(self.index + "_" + index_postfix)
            print(f"Imported: {self.rows_counter} {tag}")

        # Обнуляем счетчик при закрытии </categories> или </offers>
        if tag == 'categories':
            self.rows_counter = 0
        elif tag == 'offers':
            self.rows_counter = 0

    def data(self, data):

        if self.in_tag:

            if self.tag == 'category':
                id = self.categories_dict_id
                if 'name' in self.categories_dict[id]:
                    self.categories_dict[id]['name'] += data
                else:
                    self.categories_dict[id]['name'] = data

            # 0
            if self.tag == 'category':
                if '#' in self.row:
                    self.row['#'] += data
                else:
                    self.row['#'] = data
            # 1
            elif self.tag in self.one_level_tags:
                self.row[self.tag] += data
            # 2
            elif self.tag in self.one_level_tags_with_attribs:
                if '#' in self.row[self.tag]:
                    self.row[self.tag]['#'] += data
                else:
                    self.row[self.tag]['#'] = data
            # 3
            elif self.tag in self.arrays_tags_with_attributes:
                if '#' in self.row[self.tag][-1]:
                    self.row[self.tag][-1]['#'] += data
                else:
                    self.row[self.tag][-1]['#'] = data
            # 4
            elif self.tag in self.arrays_tags_without_attributes:
                self.row[self.tag][-1] += data
            # 5
            elif self.tag in self.skipped_tags:
                pass
            # 6
            else:
                if '#' in self.row['param'][-1]:
                    self.row['param'][-1]['#'] += data
                else:
                    self.row['param'][-1]['#'] = data

    def close(self):
        pass

    def progress(self, typ):
        sys.stdout.write(f"{typ.title()} counter: {self.rows_counter}\r")
        sys.stdout.flush()

    def bulk_save(self, index):

        headers = {'content-type': 'application/x-ndjson'}
        actions = ["""{ "index" : { "_id": "%s"} }\n""" % (self.rows[j]['@id']) + json.dumps(self.rows[j])
                        for j in range(len(self.rows))]
        serverAPI = self.ELASTIC + f"/{index}/type/_bulk"
        data='\n'.join(actions)
        data = data + '\n'
        requests.post(serverAPI, data = data, headers=headers)

        self.rows = []

#filename = 'test.xml'
#
#with open(filename) as f:
#  while True:
#    c = f.read(1000)
#    if not c:
#      break
#    parser.feed(c)

col = mongo.db().advcampaigns_for_website
signal.signal(signal.SIGINT, signal_handler)

while True:

    mark = uuid.uuid4()

    print()
    print("-----------------")
    print("Searching for job")
    print("-----------------")

    # "feeds_info.name": {"$regex": ".*just.*", '$options':'i'},
    doc = col.find_one_and_update(
        { "feeds_info": { "$elemMatch": { "$or": [
            #{ "feed_name": {"$regex": ".*intimshop.*", '$options':'i'} },
            #{ "error": { "$ne": None } },
            { "processing": { "$exists": False } },
            { "processing": False, "processing_finished_at": { "$lt": datetime.now() - timedelta(days=1) } },
            { "processing": False, "processing_finished_at": None }
            ] } } },
        { "$set": {
            "feeds_info.$.uuid": mark, "feeds_info.$.processing": True,
            "feeds_info.$.processing_started_at": datetime.now(),
            "feeds_info.$.processing_finished_at": None } },
        return_document=ReturnDocument.AFTER,
        projection = { "id": 1, "name": 1, "feeds_info" : { "$elemMatch": { "uuid": mark} } } )
        #sort = [("feeds_info.$.processing_finished_at", pymongo.DESCENDING)]


    if doc is None:
        print("Nothing to process. Exiting")
        sys.exit()
    else:
        feed_info = doc['feeds_info'][0]
        pprint.pprint(doc)
        print("Job taken")


    adv_name = slugify(doc['name'])
    adv_id = doc['id']
    feed_url = feed_info['xml_link']


    m = re.search('(?<=feed_id=)\d+', feed_url)
    print(f"Requesting {feed_url}")
    r = requests.get(feed_url, stream=True)
    feed_name = f"{adv_name}-{adv_id}-{m.group(0)}.yml"
    target = Import(feed_name)
    parser = XMLParser(target=target)

    error = None

    try:

        if not r.ok:
            raise Exception(f"Download error. Status code: {r.status_code}")

        print(f"Saving to feeds/{feed_name}")

        with open(f"feeds/{feed_name}", "wb") as f:
            for chunk in r.iter_content(chunk_size=102400):
                if chunk: # filter out keep-alive new chunks
                    f.write(chunk)
                    parser.feed(chunk)

        parser.close()

    except (Exception, UnicodeEncodeError, ParseError) as e:
        error = traceback.format_exc()
        print(e)
        print(error)

    safe_exit(datetime.now(), feed_name, error)
