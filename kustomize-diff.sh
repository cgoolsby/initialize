#!/usr/bin/env bash
#
## strip out metadata
find $@ -maxdepth 2 -type f | while read -r filename; do
  yq -i 'del(.metadata.annotations."kubectl.kubernetes.io/last-applied-configuration")' $filename
  yq -i 'del(.metadata.generation)' $filename
  yq -i 'del(.metadata.managedFields)' $filename
done

# run a diff with color highlighting and an emphasis on compactness
diff --minimal -u -N --color $@
