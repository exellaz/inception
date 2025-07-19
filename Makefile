NAME = inception_nginx
CONTAINER = nginx-test
PORT=443
SRC = srcs/requirements/nginx
STATIC_DIR = $(shell pwd)/srcs/requirements/nginx/static

DOMAIN_NAME = kkhai-ki.42.fr

build:
	sudo docker build -t $(NAME) $(SRC)

run:
	sudo docker run -d --name $(CONTAINER) -e DOMAIN_NAME=$(DOMAIN_NAME) -p $(PORT):443 -v $(STATIC_DIR):/var/www/html:ro $(NAME)

stop:
	sudo docker rm -f $(CONTAINER)

re: stop build run