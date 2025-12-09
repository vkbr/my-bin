#! /usr/bin/env bash

underline=`tput smul`
nounderline=`tput rmul`
bold=`tput bold`
normal=`tput sgr0`

current_branch=$(git rev-parse --abbrev-ref HEAD)
ticket=""

if [[ $current_branch =~ ^([a-zA-Z]+-[0-9]+) ]]; then
  ticket="${BASH_REMATCH[1]}"
fi

echo "Working branch = $current_branch";

if [[ -z $ticket ]]; then
  while true; do
    printf "Unable to find branch pattern (ABCD-1234). Continue? \033[90m(Y/n)\033[0m "
    read yn
    case $yn in
        [Nn]* ) exit;;
        [Yy]* | "" ) break;;
        * );;
    esac
  done
fi

case "$1" in
  -f|--feat)
    prefix="(feat) "
    ;;
  -b|--bug|--fix)
    prefix="(fix) "
    ;;
  -c|--chore)
    prefix="(chore) "
    ;;
  -d|--docs)
    prefix="(docs) "
    ;;
  -r|--refactor)
    prefix="(refactor) "
    ;;
esac

if [[ -z "$prefix" ]]; then
  message="$1";
else
  message="$2";
fi

if [[ -z "$message" ]]; then
  echo "No message provided";
  exit 1;
fi

if [[ -z "$prefix" ]]; then
  message="$1";
  type_options=("feat" "fix" "chore" "docs" "refactor")
  select type in "${type_options[@]}";
  do
    case $type in
      feat)
        prefix="(feat) "
        break;;
      fix)
        prefix="(fix) "
        break;;
      chore)
        prefix="(chore) "
        break;;
      docs)
        prefix="(docs) "
        break;;
      refactor)
        prefix="(refactor) "
        break;;
    esac
  done
fi

if [[ -n "$ticket" ]]; then
  ticket_prefix="$ticket: "
else
  ticket_prefix=""
fi

commit_message="$ticket_prefix$prefix$message"

printf "\033[34m${bold}$commit_message${normal}\033[0m\n"

git commit -m "$commit_message"