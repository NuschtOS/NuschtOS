.DEFAULT_GOAL := serve
MAKEFLAGS += --warn-undefined-variables --no-print-directory
SHELL := /bin/bash

.PHONY: serve
serve:
		bundle exec jekyll serve

.PHONY: install
install:
		bundle install
