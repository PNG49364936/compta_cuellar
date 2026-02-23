#!/usr/bin/env bash
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

# Seed uniquement si la base est vide (premier déploiement)
bundle exec rails runner "exit(User.count > 0 ? 0 : 1)" || bundle exec rails db:seed
