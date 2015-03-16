#!/usr/bin/env bash
set -ev

# only sunday
if [[ "${CIRCLE_BRANCH}" != "master" ]]; then
  # gem prepare
  gem install --no-document saddler saddler-reporter-github \
  compare_linker_wrapper text_to_checkstyle github_status_notifier

  github-status-notifier notify --state pending --context saddler/compare_linker

  git diff --name-only origin/master \
   | grep ".*[gG]emfile.lock$" || RETURN_CODE=$?

  case "$RETURN_CODE" in
   "" ) echo "found" ;;
   "1" )
     echo "not found"
     github-status-notifier notify --state success --context saddler/compare_linker
     exit 0 ;;
   * )
     echo "Error"
     github-status-notifier notify --state failure --context saddler/compare_linker
     exit $RETURN_CODE ;;
  esac

  git diff --name-only origin/master \
   | grep ".*[gG]emfile.lock$" \
   | xargs compare-linker-wrapper --base origin/master \
      --formatter CompareLinker::Formatter::Markdown \
   | text-to-checkstyle \
   | saddler report \
      --require saddler/reporter/github \
      --reporter Saddler::Reporter::Github::PullRequestComment

  github-status-notifier notify --state success --context saddler/compare_linker
fi

exit 0
