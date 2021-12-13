#### Server

```bash
cd /app
docker-compose exec postgres pg_dump -d hub_production -U hub > /backup/db.dump
cp -R /var/lib/docker/volumes/app_rails_storage/ /backup/
cp -R /var/lib/docker/volumes/app_rails_uploads/ /backup/
```

#### Developer machine

```bash
cd ~/work/hub/public/uploads
rsync -avz root@116.202.134.96:/backup/app_rails_uploads/_data/ .

cd /home/woto/work/hub/storage
rsync -avz root@116.202.134.96:/backup/app_rails_storage/_data/ .

cd ~/backup
rsync -avz root@116.202.134.96:/backup/db.dump .

cd ~/work/hub
rake db:drop
rake db:create
docker exec -i hub_postgres_1 psql -U hub -d hub_development < ~/backup/db.dump

./bin/rails c
User.find_by(email: 'admin@example.com').update(role: 'admin')
User.find_by(email: 'admin@example.com').update(password: 'password')

reload!
indexes = %w[users feeds posts favorites accounts transactions checks post_categories
             exchange_rates realms mentions entities topics]
indexes.each do |index_name|
    Elastic::DeleteIndex.call(index: Elastic::IndexName.pick(index_name), ignore_unavailable: true) 
    Elastic::CreateIndex.call(index: Elastic::IndexName.pick(index_name)) 
    index_name.singularize.camelize.constantize.__elasticsearch__.import && nil
end
```