#!/bin/bash

# fetch HN top 15 news
curl -s "https://hn.algolia.com/api/v1/search?tags=front_page&hitsPerPage=30&attributes=title&attributesToHighlight" | jq -r '.hits | .[] | .title'\
| awk '{
      if (NR>1) {
        # process str
        printf "├─ %d %s\n", NR-1, str
    }
    str=$0;
}
END {
    printf "└─ %d %s\n", NR, str
}'
