Server

```bash
docker-compose exec postgres pg_dump -d hub_production -U hub > /backup/db.dump
cp -R /var/lib/docker/volumes/app_rails_storage/ /backup/
cp -R /var/lib/docker/volumes/app_rails_uploads/ /backup/
```

Developer machine

```bash
cd ~/work/hub/public/uploads
rsync -avz root@116.202.134.96:/backup/app_rails_uploads/_data/ .

cd /home/woto/work/hub/storage
rsync -avz root@116.202.134.96:/backup/app_rails_storage/_data/ .

cd ~/backup
rsync -avz root@116.202.134.96:/backup/db.dump .

rake db:drop
rake db:create
docker exec -i hub_postgres_1 psql -U hub -d hub_development < ~/backup/db.dump
пользователем migrations и создают партиции. Но эти таблицы никак между

User.find_by(email: 'admin@example.com').update(role: 'admin')
User.find_by(email: 'admin@example.com').update(password: 'password')

reload!; Elastic::DeleteIndex.call(index_name: 'development.entities', ignore_unavailable: true); Elastic::CreateIndex.call(index_name: 'en
tity'); Entity.__elasticsearch__.import && nil
```