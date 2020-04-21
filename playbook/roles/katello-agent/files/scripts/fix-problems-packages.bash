#!/bin/bash

RC=0

echo "Creating temp file"
touch /tmp/yum-problem.txt

echo "Clearing temp file"
truncate -s 0 /tmp/yum-problem.txt

yum-complete-transaction --cleanup-only

echo "Getting problems packages"
package-cleanup --problems | grep -v 'Loaded plugins:' | grep -v 'No Problems Found' | sort | tee -a /tmp/yum-problem.txt
COUNT=$(cat /tmp/yum-problem.txt | wc -l)
if [[ ${COUNT} -gt 0 ]]; then
	echo "Found problems packages"
	echo "Updating packages"
	yum -y update $(cat /tmp/yum-problem.txt | awk -F' ' '{print $2}' | sed 's/-[^\-]*-[^\-]*$//' | sed 's/[0-9]://')
	RC=3
else
	echo "Not found problems packages"
	RC=0
fi

yum-complete-transaction --cleanup-only
echo "Removing temp file"
rm -f /tmp/yum-problem.txt

exit ${RC}
