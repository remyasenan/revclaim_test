#!/bin/bash

# This is not very flexible at present. It expects files to be in a subdirectory of the Rails
# directory named "data", and it expects to be run from that same Rails directory.
#
# It unzips the A20 file to get the embedded DBF. It then renames that DBF to a canonical 
# name that is passed to the import routine. The ZIP file name is also passed for record
# keeping purposes.

for zipfile in data/*.A20; do
	if [ -s $zipfile ]; then
		unzip $zipfile 
		mv UB*.DBF data/a20_import.dbf
		script/runner "Runner.import_a20('$zipfile', 'data/a20_import.dbf')"
		rm data/a20_import.dbf
	fi
  # move the A20 zipfile to archive folder. All the processed zip files will be moved to a
  # single directory. 
  mv $zipfile data/archive/.
done