NGINX_NAME = inception_nginx
NGINX_CONTAINER = nginx
NGINX_SRC = srcs/requirements/nginx
PORT=443
STATIC_DIR = $(shell pwd)/srcs/requirements/nginx/static
DOMAIN_NAME = kkhai-ki.42.fr

MARIADB_NAME = inception_mariadb
MARIADB_CONTAINER = mariadb
MARIADB_SRC = srcs/requirements/mariadb

WORDPRESS_NAME = inception_wordpress
WORDPRESS_CONTAINER = wordpress
WORDPRESS_SRC = srcs/requirements/wordpress

NETWORK = inception_net

build:
	docker build -t $(NGINX_NAME) $(NGINX_SRC)
	docker build -t $(MARIADB_NAME) $(MARIADB_SRC)
	docker build -t $(WORDPRESS_NAME) $(WORDPRESS_SRC)

run:
	docker run -d --name $(WORDPRESS_CONTAINER) --env-file srcs/.env --network $(NETWORK) -v wordpress_data:/var/www/wordpress $(WORDPRESS_NAME)
	docker run -d --name $(MARIADB_CONTAINER) --env-file srcs/.env --network $(NETWORK) $(MARIADB_NAME)
	docker run -d --name $(NGINX_CONTAINER) -e DOMAIN_NAME=$(DOMAIN_NAME) -p $(PORT):443 -v wordpress_data:/var/www/html:ro --network $(NETWORK) $(NGINX_NAME)

stop:
	docker rm -f $(NGINX_CONTAINER)
	docker rm -f $(MARIADB_CONTAINER)
	docker rm -f $(WORDPRESS_CONTAINER)

fclean:
	docker stop $$(docker ps -qa) || true
	docker rm $$(docker ps -qa) || true
	docker rmi -f $$(docker images -qa) || true
	docker volume rm $$(docker volume ls -q) || true
	docker network rm $$(docker network ls -q) 2>/dev/null || true


re: stop build run