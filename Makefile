DOCKER_COMPOSE = docker-compose -f docker-compose.yml

build:
	$(DOCKER_COMPOSE) build
db:
	$(DOCKER_COMPOSE) up -d db

serve: stop build db
	$(DOCKER_COMPOSE) run --rm app rm -f tmp/pids/server.pid
	$(DOCKER_COMPOSE) run --rm app ./bin/rails db:create db:schema:load db:seed
	$(DOCKER_COMPOSE) run --rm app cp -R --remove-destination /usr/src/.node_modules ./node_modules
	$(DOCKER_COMPOSE) up -d app

bash:
	$(DOCKER_COMPOSE) exec app bash || ($(MAKE) build && $(DOCKER_COMPOSE) run --service-ports --rm app bash)

stop:
	$(DOCKER_COMPOSE) kill
	$(DOCKER_COMPOSE) rm -f

.PHONY: build db serve bash stop
