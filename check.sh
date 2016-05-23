#!/usr/bin/env bash

./node_modules/.bin/alex || true

./node_modules/.bin/mdspell "**/*.md"

