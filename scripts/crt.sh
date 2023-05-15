#!/bin/bash

for i in `cat ${1+"$@"} 2>/dev/null || echo ${1+"$@"}`;    do curl -s "https://crt.sh/?q=%25.$i&output=json" | jq -r ".[].name_value" | sed "s/*.//g" | sort -u ; done
