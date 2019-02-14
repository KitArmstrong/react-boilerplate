# Import config.
# You can change the default config with `make cnf="config_special.env" 
cnf ?= dev.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))


.PHONY: help development
.DEFAULT_GOAL := help


# Target builds
development: development-build develoment-run ## Create and run the local development environment


# Build the development image
development-build: ## Create the development image
	@echo 'Creating development image'
	@docker-compose

# Create and run the development container
development-run: ## Create and run the development container
	@echo 'Starting development container'
	@docker-compose

# Stop the development container
development-stop: ## Stop the running development container
	@echo 'Stopping development container'
	@docker-compose down

# Build the production image
production-build: ## Create the production image
	@echo 'Creating production image'
	@docker-compose

# Build the container
build: ## Build the release and develoment container. The development
	docker-compose build --no-cache $(APP_NAME)
	docker-compose run $(APP_NAME) grunt build
	docker build -t $(APP_NAME) .


run: stop ## Run container on port configured in `config.env`
	docker run -i -t --rm --env-file=./config.env -p=$(PORT):$(PORT) --name="$(APP_NAME)" $(APP_NAME)


dev: ## Run container in development mode
	docker-compose build --no-cache $(APP_NAME) && docker-compose run $(APP_NAME)

# Build and run the container
up: ## Spin up the project
	docker-compose up --build $(APP_NAME)

stop: ## Stop running containers
	docker stop $(APP_NAME)

rm: stop ## Stop and remove running containers
	docker rm $(APP_NAME)

clean: ## Clean the generated/compiles files
	echo "nothing clean ..."

# Docker release - build, tag and push the container
release: build publish ## Make a release by building and publishing the `{version}` ans `latest` tagged containers to ECR

# Docker publish
publish: repo-login publish-latest publish-version ## publish the `{version}` ans `latest` tagged containers to ECR

publish-latest: tag-latest ## publish the `latest` taged container to ECR
	@|
	docker push $(DOCKER_REPO)/$(APP_NAME):latest

publish-version: tag-version ## publish the `{version}` taged container to ECR
	@echo 'publish $(VERSION) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `{version}` ans `latest` tags

tag-latest: ## Generate container `{version}` tag
	@echo 'create tag latest'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):latest

tag-version: ## Generate container `latest` tag
	@echo 'create tag $(VERSION)'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):$(VERSION)





# Helpers
help: ## This Makefile help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)