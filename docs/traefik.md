### Traefik

Due to the nature of dynamic routing in Traefik you may get stuck with unexpected
problems with `Bad gateway`. It can happen because of launched engineering container.
Suppose this situation: You started `rails server` container (1) which supposed serve requests
and you started another `rails console` (2) container with console. Now Traefik may route web
requests to (2) container where is the web server didn't run. To avoid this problems
you should run container with `traefik.enable=false` label.
Ex. `docker-compose run -l "traefik.enable=false" --rm rails ./bin/rails c`
