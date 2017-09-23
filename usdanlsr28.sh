#!/bin/bash

# The data can be downloaded by
# https://www.ars.usda.gov/ARSUserFiles/80400525/Data/SR/SR28/dnload/sr28asc.zip

echo "Downloading the ASCII database"
curl -sO https://www.ars.usda.gov/ARSUserFiles/80400525/Data/SR/SR28/dnload/sr28asc.zip

echo "Uncompressing"
# Uncompressing the data
unzip -q ./sr28asc.zip

echo "Normalizing the data"
# Remove tildas
perl -pi -e s,~,,g sr28asc/*.txt
# Replace micro (mu) symbol to mc for ASCII compatibility
perl -C1 -i -pe 's/\x{00B5}/mc/' sr28asc/NUTR_DEF.txt

echo "Making the database"
# It executes the database definition and the import phase
cat schema.sql import.sql | sqlite3 usdanlrs28.sql3

echo "Cleaning up"
rm -rf sr28asc sr28asc.zip

echo "The database is in usdanlrs28.sql3"