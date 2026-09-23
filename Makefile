.PHONY: help start stop new-post

PORT ?= 8080

help:
	@echo "Targets:"
	@echo "  make start                      Start local preview (PORT=$(PORT))"
	@echo "  make stop                       Stop local preview"
	@echo "  make new-post TOPIC=t SLUG=s    Scaffold topic (if needed) + Markdown post"
	@echo
	@echo "Examples:"
	@echo "  make start"
	@echo "  PORT=3000 make start"
	@echo "  make new-post TOPIC=engineering SLUG=my-new-post"
	@echo "  make new-post TOPIC=infra SLUG=dns-notes TOPIC_TITLE=\"Infra\" POST_TITLE=\"DNS notes\""

start:
	PORT=$(PORT) ./scripts/start.sh

stop:
	PORT=$(PORT) ./scripts/stop.sh

new-post:
ifndef TOPIC
	$(error Usage: make new-post TOPIC=<topic-slug> SLUG=<post-slug>)
endif
ifndef SLUG
	$(error Usage: make new-post TOPIC=<topic-slug> SLUG=<post-slug>)
endif
	TOPIC_TITLE="$(TOPIC_TITLE)" TOPIC_DESCRIPTION="$(TOPIC_DESCRIPTION)" \
	POST_TITLE="$(POST_TITLE)" POST_SUMMARY="$(POST_SUMMARY)" \
	./scripts/new-post.sh "$(TOPIC)" "$(SLUG)"
