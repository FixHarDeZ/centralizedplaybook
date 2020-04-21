#!/bin/bash

RC=0

echo "Creating temp file"
touch /tmp/yum-dup.txt

echo "Clearing temp file"
truncate -s 0 /tmp/yum-dup.txt

yum-complete-transaction --cleanup-only

echo "Getting Duplicate packages"
package-cleanup --dupes | grep -v 'Loaded plugins:' | sort | tee -a /tmp/yum-dup.txt
COUNT=$(cat /tmp/yum-dup.txt | wc -l)
if [[ ${COUNT} -gt 0 ]]; then
	echo "Found dupes packages"
	echo "Removing old packages"
	rpm --erase --nodeps --noscript $(cat /tmp/yum-dup.txt | awk 'NR%2==1')

	echo "Reinstalling packages"
	yum -y reinstall $(cat /tmp/yum-dup.txt | awk 'NR%2==1' | sed 's/-[^\-]*-[^\-]*$//')
	RC=3
else
	echo "Not found dupes packages"
	RC=0
fi

yum-complete-transaction --cleanup-only
echo "Removing temp file"
rm -f /tmp/yum-dup.txt

exit ${RC}
