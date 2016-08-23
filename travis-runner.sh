#!/bin/bash -e
set -o pipefail

echo "$TRAVIS_BRANCH"

if [ "$TRAVIS_BRANCH" = "master" ] && [ "$TRAVIS_PULL_REQUEST" = "false" ]
then
  echo "Deploying!"
  cd public
  git init
  git add .
  git commit -m "deploy"
  git push --force --quiet "https://${GH_TOKEN}@github.com/marionettejs/blog.git" master:gh-pages > /dev/null 2>&1
fi
