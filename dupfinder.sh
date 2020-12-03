#!/bin/bash
# Duplicate Finder

declare directory="$dirname $(realpath $0)"	#get the file directory to add it to .bashrc file.
declare cmd=""		#Variable for save command
declare arg1=""		#Variable for save command arguments
declare arg2=""		#Variable for save command arguments
declare arg3=""		#Variable for save command arguments
declare alg="md5"	#Variable for save hash algorithm
declare d1="all"	#Variable for save detect command option
declare d2="output"	#Variable for save detect command option
declare reg=""		#Variable for save regex for detect command

add_to_bashrc()
{
if grep -Fxq "source$directory" ~/.bashrc
then
        # already added to the .bashrc
	echo 'already exist'
else
        chmod u+x,g+x dupfinder.sh
        echo "source$directory" >> ~/.bashrc    #with "dupfinder" command
                                                                
fi
}

#the first time that the program runs with bash it will add to shell

if [[ "$directory" =~ .*dupfinder\.sh ]]
then
	add_to_bashrc
fi

show_Help() #this function shows help
{
	echo "ls [UNIX_ls_ARGUMENTS]: UNIX ls with all supported optiones of 	 your current ls app installed on your system"
	echo ""
	echo "cd [UNIX_ls_ARGUMENTS]: UNIX cd with all supported optiones of 	 your current ls app installed on your system"
	echo ""
	echo "use [OPTIONS]: use the desired crypto hash to detect duplication"
	echo "		OPTIONS => md5 : use md5sum hash to detect duplication"
	echo ""
	echo "		OPTIONS => sha1 : use sha1 hash to detect duplication"
	echo ""
	echo "		OPTIONS => not specified : use md5sum hash to detect duplication (default)"
	echo ""
	echo "detect [OPTIONS] [OUTPUT] 'REGEX':"
	echo "		OPTIONS => -R : means in current and all sub directories"
	echo ""
	echo "		OPTIONS => -C : means in current directory only"
	echo ""
	echo "		OPTIONS => not specified : works like -R"
	echo ""
	echo "		OUTPUT => -Y : means print the output to dupfinderReport.log to current directory"
	echo ""
	echo "		OUTPUT => -N or not specified : print the file addresses to the screen only"
	echo ""
	echo "		REGEX => 'REGEX' : check the files matching the regex criteria"
	echo ""
	echo "		REGEX => not specified : check all files"
	echo ""
	echo "delete ABSOLUTE_PATH_TO_DESIRED_FILE: deletes the specified file"
	echo ""
	echo "exit : exits the program"
	echo ""
	echo "help : shows this screen"
}

detect_command() #This function detects command that user enter
{
if [ "$cmd" != "" ];
then
	if [ "$cmd" == "pwd" ];
	then
		pwd
	fi

	if [ "$cmd" == "clear" ];
	then
		clear
	fi

	if [ "$cmd" == "ls" ];
	then
		if [ "$arg1" != "" ];
		then
			ls "$arg1"
		else
			ls
		fi
	fi

	if [ "$cmd" == "cd" ];
	then
		if [ "$arg1" != "" ];
		then
			cd "$arg1"
		else
			cd
		fi
		echo "Changed directory!"
	fi
		
	if [ "$cmd" == "help" ];
	then
		show_Help
	fi
			
	if [ "$cmd" == "delete" ];
	then
		if [ "$ARG1" = "--help" ];	#help for delete command
		then
			echo "delete ABSOLOUTE_PATH_TO_DESIRED_FILE: deletes the specified file"
		else
			rm "$arg1"
		fi
	fi
			
	if [ "$cmd" == "use" ];
	then
		if [ "$arg1" == "md5" ];
		then
			alg="$arg1"
			echo "Swithched crypto algorithm to $arg1"
		fi
		if [ "$arg1" == "sha1" ];
		then
			alg="$arg1"
			echo "Swithched crypto algorithm to $arg1"
		fi
		if [ "$arg1" = "--help" ] || [ "$arg1" = "-h" ];	#help for use command
		then
			echo "use [OPTION]:use the desired crypto hash to detect duplication"
			echo " 	OPTIONS => md5: use md5sum hash to detect duplication"
			echo " 	OPTIONS => sha1 : use sha1 hash to detect duplication"
			echo " 	OPTIONS => not specified : use md5sum hash to detect duplication (default)"
	fi
		
	if [ "$cmd" == "detect" ];
	then
		if [ "$arg1" == "--help" ] || [ "$arg1" == "-h" ];	#help for detect command
		then
			echo "detect [OPTIONS] [OUTPUT] 'REGEX':"
			echo "		OPTIONS => -R : means in current and all sub directories"
			echo ""
			echo "		OPTIONS => -C : means in current directory only"
			echo ""
			echo "		OPTIONS => not specified : works like -R"
			echo ""
			echo "		OUTPUT => -Y : means print the output to dupfinderReport.log to current directory"
			echo ""
			echo "		OUTPUT => -N or not specified : print the file addresses to the screen only"
			echo ""
			echo "		REGEX => 'REGEX' : check the files matching the regex criteria"
			echo ""
			echo "		REGEX => not specified : check all files"
		else
		initiate_detect
		if [ "$alg" == "md5" ];
		then
			detect_md5
		else
			detect_sha1
		fi
		fi
	fi
fi
	
}

initiate_detect()	#A function for initiate setting for detect command
{
	reg=""
	case "$arg1" in
		-R) 
			d1="all"
			;;
		-C)
			d1="current"
			;;
		-Y)
			d2="file"
			;;
		-N)
			d2="output"
			;;
		*)	
			if [ -n $arg1 ];
			then
				arg1="${arg1%\"}"
				reg="${arg1#\"}"
			fi
			;;
	esac

	case "$arg2" in
		-Y)
			d2="file"
			;;
		-N)
			d2="output"
			;;
		*)	
			if [ -n $arg2 ];
			then
				arg2="${arg2%\"}"
				reg="${arg2#\"}"
			fi
			;;
	esac	
	
	if [ -n $arg3 ];
		then
			arg3="${arg3%\"}"
			reg="${arg3#\"}"
		fi 
		
}
 
detect_md5()		#A function for implement detect command
{
	if [ "$reg" != "" ];
	then
	if [ "$d2" == "file" ];
	then
		if [ "$d1" == "all" ];
		then
			find -regex $reg -type f -exec md5sum {} + | sort | uniq -w32 -Dd >> "$(pwd -P)""/dupfinderReport.log"
		else
			find -maxdepth 1 -regex $reg -type f -exec md5sum {} + | sort | uniq -w32 -Dd >> "$(pwd -P)""/dupfinderReport.log"
		fi
	else
		if [ "$d1" == "all" ];
		then
			find -regex $reg -type f -exec md5sum {} + | sort | uniq -w32 -Dd
		else
			find -maxdepth 1 -regex $reg -type f -exec md5sum {} + | sort | uniq -w32 -Dd
		fi

	fi
	else
	if [ "$d2" == "file" ];
	then
		if [ "$d1" == "all" ];
		then
			find -maxdepth 1 -type f -exec md5sum {} + | sort | uniq -w32 -Dd >> "$(pwd -P)""/dupfinderReport.log"
		else
			find -maxdepth 1 -type f -exec md5sum {} + | sort | uniq -w32 -Dd >> "$(pwd -P)""/dupfinderReport.log"
		fi
	else
		if [ "$d1" == "all" ];
		then
			find -type f -exec md5sum {} + | sort | uniq -w32 -Dd
		else
			find -maxdepth 1 -type f -exec md5sum {} + | sort | uniq -w32 -Dd
		fi

	fi
	fi

}

detect_sha1()		#A function for implement detect command
{
	if [ "$reg" != "" ];
	then
	
	if [ "$d2" == "file" ];
	then
		if [ "$d1" == "all" ];
		then
			find -regex $reg -type f -exec sha1sum {} + | sort | uniq -w32 -Dd >> "$(pwd -P)""/dupfinderReport.log"
		else
			find -maxdepth 1 -regex $reg -type f -exec sha1sum {} + | sort | uniq -w32 -Dd >> "$(pwd -P)""/dupfinderReport.log"
		fi
	else
		if [ "$d1" == "all" ];
		then
			find -regex $reg -type f -exec sha1sum {} + | sort | uniq -w32 -Dd
		else
			find -maxdepth 1 -regex $reg -type f -exec sha1sum {} + | sort | uniq -w32 -Dd
		fi
		
	fi
	else
	if [ "$d2" == "file" ];
	then
		if [ "$d1" == "all" ];
		then
			find -type f -exec sha1sum {} + | sort | uniq -w32 -Dd >> "$(pwd -P)""/dupfinderReport.log"
		else
			find -maxdepth 1 -type f -exec sha1sum {} + | sort | uniq -w32 -Dd >> "$(pwd -P)""/dupfinderReport.log"
		fi
	else
		if [ "$d1" == "all" ];
		then
			find -type f -exec sha1sum {} + | sort | uniq -w32 -Dd
		else
			find -maxdepth 1 -type f -exec sha1sum {} + | sort | uniq -w32 -Dd
		fi
		
	fi
	fi

}


#############################################################################

dupfinder()
{
echo "Welcome to dupfinder!"
echo "type help to get list of commands!"
while [ "$cmd" != "exit" ]
do
	cmd=""
	read cmd arg1 arg2 arg3
	detect_command
done
}
