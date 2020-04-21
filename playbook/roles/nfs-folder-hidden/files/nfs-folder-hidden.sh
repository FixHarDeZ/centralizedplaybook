#!/bin/bash

folders_arr=( $(find /jenkins_jobs_*/* -type d \( -iname ".*" ! -iname ".git" ! -iname ".settings" ! -iname ".mvn" ! -iname ".gitignore" \)) )

for (( folder_number = 0; folder_number < ${#folders_arr[@]}; folder_number++ )); do
	echo "--------------------------------------------------------------------------------------------------"
	directory_full_name=$(echo ${folders_arr[${folder_number}]})
	echo "directory full name 	: ${directory_full_name}" 	# config-server-monitoring/builds/.55166
	folder_name=$(echo ${directory_full_name#*.})
	echo "folder name 		: ${folder_name}" 				# 55166
	directory_name=$(echo ${directory_full_name%%.*})
	echo "directory name 		: ${directory_name}"		# config-server-monitoring/builds/
	
	if [[ $folder_name == *"/"* ]]; then					# 307/.307
		folder_name=${folder_name%/*} 						# 307
		if [[ -d "${directory_name}${folder_name}/${folder_name}" ]]; then # 307/307
			echo "command 		: mv ${directory_name}${folder_name}/${folder_name}/* ${directory_name}${folder_name}/"
			mv ${directory_name}${folder_name}/${folder_name}/* ${directory_name}${folder_name}/
		elif [[ -d "${directory_name}${folder_name}/.${folder_name}" ]]; then # 307/.307
			echo "command 		: mv ${directory_name}${folder_name}/.${folder_name}/* ${directory_name}${folder_name}/"
			mv ${directory_name}${folder_name}/.${folder_name}/* ${directory_name}${folder_name}/
		elif [[ -d "${directory_name}.${folder_name}/${folder_name}" ]]; then # .307/307
			echo "command 		: mv ${directory_name}.${folder_name}/${folder_name}/* ${directory_name}${folder_name}/"
			mv ${directory_name}.${folder_name}/${folder_name}/* ${directory_name}${folder_name}/
		elif [[ -d "${directory_name}.${folder_name}/.${folder_name}" ]]; then # .307/.307
			echo "command 		: mv ${directory_name}.${folder_name}/.${folder_name}/* ${directory_name}${folder_name}/"
			mv ${directory_name}.${folder_name}/.${folder_name}/* ${directory_name}${folder_name}/
		fi
	else
		echo "command 		: mv ${directory_full_name} ${directory_name}${folder_name}"
		mv ${directory_full_name} ${directory_name}${folder_name}
	fi
	echo "--------------------------------------------------------------------------------------------------"
done
chmod -R 777 /jenkins_jobs_*