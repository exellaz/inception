COMPOSE_FILE = srcs/docker-compose.yml
COMPOSE = docker compose -f $(COMPOSE_FILE)

all: build up

build:
	@echo "Creating volumes..."
	mkdir -p ~/data/mariadb ~/data/wordpress ~/data/redis ~/data/portainer
	@echo "Building Docker images..."
	$(COMPOSE) build

up:
	@echo "Starting services..."
	$(COMPOSE) up -d

stop:
	@echo "Stopping services..."
	$(COMPOSE) stop

down:
	@echo "Stopping and removing services..."
	$(COMPOSE) down -v

restart: down up

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

# NOTE: CLEARS ALL DOCKER RELATED THINGS
fclean:
	docker stop $$(docker ps -qa) || true
	docker rm $$(docker ps -qa) || true
	docker rmi -f $$(docker images -qa) || true
	docker volume rm $$(docker volume ls -q) || true
	docker network rm $$(docker network ls -q) 2>/dev/null || true
	sudo rm -rf ~/data/mariadb/* ~/data/wordpress/* ~/data/redis/* ~/data/portainer/*


.PHONY: all build up stop down restart logs fclean