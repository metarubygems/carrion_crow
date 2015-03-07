#!/usr/bin/env bash
set -ev

if [[ "${CIRCLE_BRANCH}" != "master" && "${CIRCLE_BRANCH}" =~ ^cron_for_github/.* ]]; then
  # gem prepare
  gem install --no-document git_httpsable-push pull_request-create

  # git prepare
  git config user.name sanemat
  git config user.email ogataken@gmail.com
  HEAD_DATE=$(date +%Y%m%d_%H-%M-%S)
  HEAD="tachikoma/update-${HEAD_DATE}"

  # checkout
  git checkout -b "${HEAD}" origin/master

  # bundle install
  bundle --no-deployment --without nothing --jobs 4

  # bundle update
  bundle update

  git add Gemfile.lock
  git commit -m "Bundle update ${HEAD_DATE}"

  # git push
  git httpsable-push origin "${HEAD}"

  # pull request
  pull-request-create
fi

exit 0
