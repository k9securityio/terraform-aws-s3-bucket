#!/usr/bin/env bash

filename=$1
echo "generating access capability lists from ${filename}"

access_capabilities='administer-resource read-config use-resource read-data write-data delete-data'

for access_capability in ${access_capabilities};
do
  grep "^S3\t${access_capability}" "${filename}" | grep "${access_capability}" | awk '{ print $3}' | tee "k9-access_capability.${access_capability}.tsv"
done;