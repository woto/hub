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
- Mosquitto used for experiments with MQTT.
- Postgresql used as a main database.
- Redis used for rails caching, storing some identifiers in telegram bot, etc...
- Scrapper is a custom Node.js script used for making screenshots.
- Telegram bot used for receiving citations from as a rule mobile devices. In another words where Chrome extension could not be installed.
- Traefik used only in production environment primaraly for SSL certificates convenience.

Some services run in development mode as a separated processes, but in production all services run in Docker containers.
You may check differences in development and production files respectivly: docker-compose.yml, docker-compose.production

Also check https://github.com/woto/extension for Chrome extension which is used as the only one instrument to add citations to website.

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

# Hub
https://github.com/woto/hub

## Mentions list
![Mentions](./docs/images/mentions.png)

## Entity popup
![Entity popup](./docs/images/entity_popup.png)

## Entity page
![Show entity](./docs/images/entity.png)

## Related entities
![Show entity](./docs/images/related_entities.png)

# Google chrome Extenstion
https://github.com/woto/extension

## Context menu
![Context menu](./docs/images/context_menu.png)

## Wikipedia
![Wikipedia](./docs/images/wikipedia_extractor.png)

## Google Graph
![Google Graph](./docs/images/google_graph_extractor.png)

## Duck Duck Go
![Duck Duck Go](./docs/images/duckduckgo_extractor.png)

## Yandex
![Yandex](./docs/images/yandex_search_extractor.png)

## Google
![Google](./docs/images/google_custom_search_extractor.png)

## RDFa, Microdata, JSON-LD
![RDFa, Microdata, JSON-LD](./docs/images/iframely_extractor.png)

## Scrape
![Scrape](./docs/images/scrape_extractor.png)

## Screenshot
![Screenshot](./docs/images/screenshot_extractor.png)

## Github
![Github](./docs/images/github_extractor.png)

## Rubygems
![Github](./docs/images/rubygems_extractor.png)

## NPM
![NPM](./docs/images/npm_extractor.png)

## Youtube
![Youtube](./docs/images/youtube_extractor.png)

## Telegram
![Telegram](./docs/images/telegram_extractor.png)

## Raw metadata
![Raw metadata](./docs/images/raw_metadata_extractor.png)

## Sentiment
![Sentiment](./docs/images/sentiment.png)

## Synonyms
![Synonyms](./docs/images/synonyms.png)

## Tags
![Tags](./docs/images/tags.png)

## Publication date
![Publication date](./docs/images/publication_date.png)

## Priority
![Priority](./docs/images/priority.png)
