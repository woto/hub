# [roastme.ru](https://roastme.ru)

"Roastme" project aim to unite developers willing to create. It is list of manually picked news about programming, AI, contries legislations, digital nomands, SaaS instruments, github repositories... with precise enumeration of entities mentioned in this news for faster understanding does this news deserve attention or must be roasted. It helps to discover new things just before you think of.

## CircleCI Tests

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/woto/hub/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/woto/hub/tree/master)

## Github Actions Tests

[![Github](https://github.com/woto/hub/actions/workflows/main.yml/badge.svg)](https://github.com/woto/hub/actions)

# Setup

```shell
git clone https://github.com/woto/hub --recurse-submodules
cd hub
docker compose up -d
./bin/setup
yarn install
gem install foreman
foreman start -f ./Procfile.dev
# Run in separate processes rails and sidekiq
sidekiq: bundle exec sidekiq
rails: bin/rails server -p 3000 -b 0.0.0.0
# You may uncomment this lines in Procfile.dev
```

The following addresses available after project start up:

- Rails application: http://localhost:3000
- Elasticsearch used for storing and search. All data could be erased and reindexed from Postgres.
- Iframely used for getting metainformation about interested webpage: microdata, rdfa, microformat, json-ld...
- Imgproxy used for proxying images. To be more specific for displaying image on the same host to pass CORS while uploading images with "drag and drop" or "copy paste".
- Kibana used as UI for Elasticsearch. http://localhost:5601
- Mailcatcher used as a mock service for emails sent from website. http://localhost:1080
- Postgresql used as a main database.
- Redis used for rails caching, storing some identifiers in telegram bot, etc...
- Scrapper is a custom Node.js script used for making screenshots.
- Telegram bot used for receiving citations from as a rule mobile devices. In another words where Chrome extension could not be installed.
- Traefik used only in production environment primaraly for SSL certificates convenience.

Some services run in development mode as a separated processes, but in production all services run in Docker containers.
You may check differences in development and production files respectivly: docker-compose.yml, docker-compose.production

You also may want to view Procfile.dev and modify them as you wish. For example you may want to comment rails and run it separatly if you want for example to debug interactively.


Sign in using `admin@example.com` / `password`

If things work right then you could seed some test data for development purposes:

```
rake hub:tests:seed
```

That's it. More docs available at [docs](/docs).

# Tests

```shell
bundle exec rspec
```

## Google Chrome extension
Check https://github.com/woto/extension. It is the only one way to add new citations to https://roastme.ru.
![Widget](./docs/images/widget.png)

## Mentions list
![Mentions](./docs/images/mentions.png)

## Entity popup
![Entity popup](./docs/images/entity_popup.png)

## Entity page
![Show entity](./docs/images/entity.png)

## Related entities
![Show entity](./docs/images/related_entities.png)

## Multiple related entities
![Multiple related entities](./docs/images/multiple_related.png)

## Collections popup
![Collections popup](./docs/images/collections_popup.png)

## Collection edit
![Collection edit](./docs/images/collection_edit.png)

## Edit entity
![Edit entity](./docs/images/edit_entity.png)
Editing entity is also done through https://github.com/woto/extension

## Entity changes log
![Entity changes log](./docs/images/changes_log.png)

## Complains
![Complains](./docs/images/complains.png)

## OAuth / email authentication
![Authentication](./docs/images/authentication.png)

## Profile edit
![Profile edit](./docs/images/profile_edit.png)
