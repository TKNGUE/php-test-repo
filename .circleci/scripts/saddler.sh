#!/bin/bash

set -ex

export OCTOKIT_BEARER_TOKEN=$(.circleci/scripts/auth_token.sh)

# --------------------
#   select reporter
# --------------------
if [ -z "${CI_PULL_REQUEST}" ]; then
    # when not pull request
    REPORTER=Saddler::Reporter::Github::CommitReviewComment
else
    REPORTER=Saddler::Reporter::Github::PullRequestReviewComment
fi

#--------------------
#  checkstyle
#--------------------
if [[ -f results/phpcs.result.xml ]]; then
  cat results/phpcs.result.xml | sed "s:/root:$HOME:" \
    | bundle exec checkstyle_filter-git diff origin/master \
    | bundle exec saddler report --require saddler/reporter/github --reporter $REPORTER
fi

#--------------------
#  PWD
#--------------------
if [[ -f results/phpmd.result.xml ]]; then
  cat results/phpmd.result.xml | sed "s:/root:$HOME:" \
      | bundle exec pmd_translate_checkstyle_format translate \
      | bundle exec checkstyle_filter-git diff origin/master \
      | bundle exec saddler report --require saddler/reporter/github --reporter $REPORTER
fi

