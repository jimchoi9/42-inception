NAME = inception

# Colors for terminal output
GREEN = \033[0;32m
RED = \033[0;31m
RESET = \033[0m

# Docker compose file path
DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml

# Directories for persistent data
DATA_DIR = /home/$(USER)/data
WORDPRESS_DATA = $(DATA_DIR)/wordpress
MARIADB_DATA = $(DATA_DIR)/mariadb

all: setup build up

# Create necessary directories and set permissions
setup:
	@printf "$(GREEN)Setting up directories...$(RESET)\n"
	@mkdir -p $(WORDPRESS_DATA)
	@mkdir -p $(MARIADB_DATA)
	@printf "$(GREEN)Setup completed!$(RESET)\n"

# Build the Docker images
build:
	@printf "$(GREEN)Building Docker images...$(RESET)\n"
	@docker compose -f $(DOCKER_COMPOSE_FILE) build
	@printf "$(GREEN)Build completed!$(RESET)\n"

# Start the containers
up:
	@printf "$(GREEN)Starting containers...$(RESET)\n"
	@docker compose -f $(DOCKER_COMPOSE_FILE) up -d
	@printf "$(GREEN)Containers are up and running!$(RESET)\n"

# Stop the containers
down:
	@printf "$(GREEN)Stopping containers...$(RESET)\n"
	@docker compose -f $(DOCKER_COMPOSE_FILE) down
	@printf "$(GREEN)Containers stopped!$(RESET)\n"

# Stop and remove containers, networks, and volumes
clean: down
	@printf "$(RED)Cleaning up containers, networks, and volumes...$(RESET)\n"
	@docker compose -f $(DOCKER_COMPOSE_FILE) down -v
	@docker system prune -af
	@printf "$(RED)Clean up completed!$(RESET)\n"

# Remove all data directories
fclean: clean
	@printf "$(RED)Removing data directories...$(RESET)\n"
	@sudo rm -rf $(DATA_DIR)
	@printf "$(RED)Full clean up completed!$(RESET)\n"

# Re-build and restart everything
re: fclean all

# Show container status
status:
	@docker ps
	@echo "\nVolumes:"
	@docker volume ls
	@echo "\nNetworks:"
	@docker network ls

# Show container logs
logs:
	@docker compose -f $(DOCKER_COMPOSE_FILE) logs

# Enter container shell (usage: make shell service=<service_name>)
shell:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) exec $(service) /bin/bash

.PHONY: all setup build up down clean fclean re status logs shell


#  => ERROR [nginx 2/4] RUN mkdir /etc/nginx/ssl                                            0.9s
# ------
#  > [nginx 2/4] RUN mkdir /etc/nginx/ssl:
# 0.795 mkdir: cannot create directory '/etc/nginx/ssl': No such file or directory
# ------
# failed to solve: process "/bin/sh -c mkdir /etc/nginx/ssl" did not complete successfully: exit code: 1
# make: *** [Makefile:28: build] 오류 17