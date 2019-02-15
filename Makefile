# Import config.
# You can change the default config with `make cnf="config_special.env" 
cnf ?= ./.config/config.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

ifndef PORT
   $(error The PORT variable is missing.)
endif

ifndef APP_NAME
   $(error The APP_NAME variable is missing.)
endif

.PHONY: help development
.DEFAULT_GOAL := help

# ------------------------------------------------------------------------------
# Status Output
# ------------------------------------------------------------------------------

print-status: ## Command - Print environment variable
	@echo " +---------------------------------------------------------+ "
	@echo " | Current Settings                                        | "
	@echo " +---------------------------------------------------------+ "
	@echo " | APP_NAME:      $(APP_NAME) "
	@echo " | PORT:          $(PORT) "


# ------------------------------------------------------------------------------
# Task Aliases
# ------------------------------------------------------------------------------

development: development-build development-run ## Task Alias - Create and run the local development environment
production: production-build ## Task Alias - Create the production image

# ------------------------------------------------------------------------------
# Development commands
# ------------------------------------------------------------------------------

# Build the development image
development-build: ## Command - Create the development image
	@echo 'Creating development image'
	@docker build --target=development -t $(APP_NAME):development .

# Create and run the development container
development-run: ## Command - Create and run the development container
	@echo 'Starting development container'
	@docker run -d -p 3000:$(PORT) --name=$(APP_NAME) $(APP_NAME):development

# Stop the development container
development-stop: ## Command - Stop the running development container
	@echo 'Stopping development container'
	@docker stop $(APP_NAME)

# ------------------------------------------------------------------------------
# Production commands
# ------------------------------------------------------------------------------

# Build the production image
production-build: ## Command - Create the production image
	@echo 'Creating production image'
	@docker build --target=production -t $(APP_NAME):production .

# ------------------------------------------------------------------------------
# Helper commands
# ------------------------------------------------------------------------------

# Help
help: ## Command - This Makefile help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)