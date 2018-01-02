#!/bin/bash
set -e

curl -X POST \
    -H "Authorization: Bearer $(.circleci/scripts/publish_jwt.rb)" \
    -H "Accept: application/vnd.github.machine-man-preview+json" \
    https://api.github.com/installations/$GITHUBAPP_INSTALATTION_ID/access_tokens \
    | jq -r .token
