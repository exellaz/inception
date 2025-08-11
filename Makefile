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
	sudo docker build -t $(NGINX_NAME) $(NGINX_SRC)
	sudo docker build -t $(MARIADB_NAME) $(MARIADB_SRC)
	sudo docker build -t $(WORDPRESS_NAME) $(WORDPRESS_SRC)

run:
	sudo docker run -d --name $(WORDPRESS_CONTAINER) --env-file srcs/.env --network $(NETWORK) -v wordpress_data:/var/www/wordpress $(WORDPRESS_NAME)
	sudo docker run -d --name $(MARIADB_CONTAINER) --env-file srcs/.env --network $(NETWORK) $(MARIADB_NAME)
	sudo docker run -d --name $(NGINX_CONTAINER) -e DOMAIN_NAME=$(DOMAIN_NAME) -p $(PORT):443 -v wordpress_data:/var/www/html:ro --network $(NETWORK) $(NGINX_NAME)

stop:
	sudo docker rm -f $(NGINX_CONTAINER)
	sudo docker rm -f $(MARIADB_CONTAINER)
	sudo docker rm -f $(WORDPRESS_CONTAINER)

fclean:
	sudo docker stop $$(sudo docker ps -qa) || true
	sudo docker rm $$(sudo docker ps -qa) || true
	sudo docker rmi -f $$(sudo docker images -qa) || true
	sudo docker volume rm $$(sudo docker volume ls -q) || true
	sudo docker network rm $$(sudo docker network ls -q) 2>/dev/null || true


re: stop build run