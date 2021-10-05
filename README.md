# goodreviews.ru

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

That's it. More docs available at `/docs`

![Dashboard page](./docs/images/dashboard_page.png)
Dashboard page

![Feeds page](./docs/images/feeds_page.png)
Feeds page

![Filter results](./docs/images/filter_results.png)
Filter results

![Filter results](./docs/images/offers_page.png)
Offers page

![Profile edit](./docs/images/profile_edit.png)
Profile edit

![Realm](./docs/images/realm.png)
Realm

![Widget](./docs/images/widget.png)
Widget

![Widget modal](./docs/images/widget_modal.png)
Widget modal

![Workspaces](./docs/images/workspaces.png)
Workspaces

![Writing article](./docs/images/writing_article.png)
Writing article