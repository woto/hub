## Server

```bash
cd /app && \
docker compose exec postgres pg_dump -d hub_production -U hub > /backup/db.dump
```

## Developer machine

```bash
cd ~/work/hub/ && \
rsync -avz root@5.101.180.153:/app/.env.production .
```

```bash
cd ~/work/hub/public/uploads && \
rsync -avz root@5.101.180.153:/var/lib/docker/volumes/app_rails_uploads/_data/ .

cd /home/woto/work/hub/storage && \
rsync -avz root@5.101.180.153:/var/lib/docker/volumes/app_rails_storage/_data/ .

cd ~/backup && \
rsync -avz root@5.101.180.153:/backup/db.dump .

cd ~/work/hub && \
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rake db:drop && \
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rake db:create && \
docker exec -i hub-postgres-1 psql -U hub -d hub_development < ~/backup/db.dump

./bin/rails c
User.find_by(email: 'admin@example.com').update(role: 'admin')
User.find_by(email: 'admin@example.com').update(password: 'password')

# NOTE: temporary workaround until it will be fixed
# TODO: limit writing error_text to Feed model
Feed.update_all(error_text: nil)

reload!
indexes = %w[users feeds posts favorites accounts transactions checks post_categories
             exchange_rates realms mentions entities topics]
indexes.each do |index_name|
    Elastic::DeleteIndexInteractor.call(index: Elastic::IndexName.pick(index_name), ignore_unavailable: true)
    Elastic::CreateIndexInteractor.call(index: Elastic::IndexName.pick(index_name))
    index_name.singularize.camelize.constantize.__elasticsearch__.import && nil
end
```
