#!/usr/bin/env bash
# This script has been adapted from https://github.com/davatorium/rofi-scripts/blob/master/rofi-finder/finder.sh

ITEM_LIMIT=64
SHOW_HELP="true"

print_help() {
    echo "Returns matches from all local files"
    echo "Type search term, hit enter"
    echo "Type more for further filtering"
    echo "or scroll down"
    echo "Hit <enter> on a line to copy path"
    echo "To scroll horizontally: <alt> ."
}

if [ ! -z "$@" ]; then
  # A search parameter was passed from the dialog
  QUERY=$@
  if [[ "$@" == /* ]]; then
    # A search item was selected, try to launch it
    if [[ "$@" == *\?\? ]]; then
	echo $QUERY | xclip
        coproc ( echo $QUERY | xclip 2>&1 )
        exec 1>&-
      exit;
    else
        coproc ( echo $@ | xclip 2>&1 )
        exec 1>&-
      exit;
    fi
  elif [[ "$@" == \!\!* ]]; then
    # Help was requested, print it.
    print_help
  elif [[ "$@" == \?* ]]; then
    # Filter existing results
    while read -r line; do
      echo "$line" \?\?
    done <<< $(locate --limit $ITEM_LIMIT "$QUERY" 2>&1 | grep -v 'Permission denied\|Input/output error')
  else
    if [[ $QUERY = "~/"* ]]; then 
      # Manually expand ~ to $HOME, based on https://unix.stackexchange.com/a/399439      
      QUERY="${HOME}/${QUERY#"~/"}"
    fi
    if [[ -f "$QUERY" ]]; then
      # User entered a complete file path, so just launch it
      coproc ( xdg-open "$QUERY"  > /dev/null 2>&1 )
      exec 1>&-
      exit;
    else
      # Search for query
      locate --limit $ITEM_LIMIT $QUERY 2>&1 | grep -v 'Permission denied\|Input/output error'
    fi
  fi
elif [[ "$SHOW_HELP" == "true" ]]; then
  #Initial execution, print help
  print_help
fi
