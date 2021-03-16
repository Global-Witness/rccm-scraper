#!/bin/bash
for c1 in {a..z}
do
  for c2 in {a..z}
  do
    for c3 in {a..z}
    do
      curl 'https://rccm.cd/rccm/rest/entities/' \
        -H 'Content-Type: application/json' \
        -H 'Authorization: Bearer' \
        --data-raw "{\"criteria\":\"$c1$c2$c3\",\"page\":1}" \
        --silent |
        jq -r '. | select(.details) | .details[] | ._id'
    done
  done
done
