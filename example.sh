#!/bin/bash

# TARGET:
#
# {
#   "name": "John",
#   "isAlive": true,
#   "age": 25,
#   "height_cm": 167.64,
#   "address": {
#     "streetAddress": "19 W 21st Street",
#     "city": "New York",
#     "state": "NY"
#   },
#   "phoneNumbers": [
#     { "type": "home", "number": "212-555-1234" },
#     { "type": "office",  "number": "646-555-4567" }
#   ]
# }

## setup
source `echo $PWD/jiffy.sh`
buf=""

## JSON-ify some info
for cmd in \
  "-k firstName" "-S John"  \
  "-k isAlive"   "-E true"  \
  "-k age"       "-E 25"    \
  "-k height_cm" "-E 167.6"
do
  buf+="`jiffy $cmd`"
done

echo -e "$buf"
