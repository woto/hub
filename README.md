# [goodreviews.ru](https://goodreviews.ru)

### Setup

```shell
docker-compose up -d
./bin/setup
./bin/webpack-dev-server
./bin/rails s
```

The following addresses available after project start up:

- Rails application: http://localhost:3000
- Mailcatcher http://localhost:1080
- Kibana http://localhost:5601


Sign in using `admin@example.com` / `password`

If things works right then you could seed some test data for development purposes:

```
rake hub:tests:seed
```

That's it. More docs available at [docs](/docs).

### Screenshots

Dashboard page  

![Dashboard page](./docs/images/dashboard_page.png)

Feeds page  
![Feeds page](./docs/images/feeds_page.png)  

Filter results  
![Filter results](./docs/images/filter_results.png)

Offers page  
![Filter results](./docs/images/offers_page.png)

Profile edit  
![Profile edit](./docs/images/profile_edit.png)

Realm  
![Realm](./docs/images/realm.png)

Widget  
![Widget](./docs/images/widget.png)

Widget modal  
![Widget modal](./docs/images/widget_modal.png)

Workspaces  
![Workspaces](./docs/images/workspaces.png)

Writing article  
![Writing article](./docs/images/writing_article.png)
