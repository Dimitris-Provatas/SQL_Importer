#!/bin/bash

# MIT License

# Copyright (c) 2020 Dimitrios Provatas

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

myHelp ()
{
        echo "----- SQL_Import.sh Script -----"
        echo ""
        echo "This script was created for folders with many .sql files, e.g. server backups."
        echo "This script will take care of all this work by simply giving it 3 (1 necessary and 2 optional) arguments, a username, a password (optional), and a path (optional), to access MySQL on your computer."
        echo "It will print the time each file took, and a total time the script was running in seconds."
        echo ""
        echo "Arguments:"
        echo "  -u (Required) The username of the user you want to use. Note that the user must have all the privileges."
        echo "  -p (Optional) The password of the user. Not required if the user has no password."
        echo "  -w (Optional) The path to the folder containing the files. Not required if the script is in the same folder as the files"
        echo "  -h Prints this message. Note that the -h terminates the program, so I suggest you do not use it with other arguments."
}

# When it started
TIMESTART=$(date +%s%N)/1000000000

# Get the arguments the user provided
while getopts u:p:w:h option
do
        case ${option} in
                u) #set usernameNAME
                        username="${OPTARG}";;
                p) #set password
                        password="${OPTARG}";;
                w) #set the path
                        path="${OPTARG}";;
                h) #help preview
                        myHelp
                        exit 0;;
                \?) #illigal options
                        myHelp
                        exit 128;;
        esac
done

if [ "$username" != "" ]
then
        # Set the path
        if [ "$path" == "" ]
        then
                # Set the path to the same as the script
                finalPath='.'
        else
                if [ ${path:-1} == '/' ]
                then
                        # Remove the last slash from the path, if any
                        finalPath=${path%?}
                else
                        finalPath=$path
                fi
        fi

        # Create the log file in the same path as the sql files
        LOGFILENAME="$finalPath/SQL_Import_$(date +%F-%T).log"

        # Log file title
        echo "$(date): Log File for import operation!" >> $LOGFILENAME
        echo "" >> $LOGFILENAME

        # Print the arguments given by the user in the log file
        echo "Username: $username" >> $LOGFILENAME
        echo "Password: $password" >> $LOGFILENAME
        echo "Folder Path: $finalPath" >> $LOGFILENAME

        echo "" >> $LOGFILENAME

        # Loop through .sql files
        for FILE in $finalPath/*.sql
        do
		# Log the name of the file and the time it started
		echo "$(date): Started with $fileName." >> $LOGFILENAME
		
                # Start the timer for how long it took
                timeItterationStart=$(date +%s%N)/1000000000

                # get the file name
                fileName="$(basename -- $FILE)"
                # echo "$fileName"
                databaseName=${fileName%.sql}
                # echo "$databaseName"

                # Create the database if it does not exist, then
                # Run the sql file in the mysql cli with the file name as the db
                if [ "$password" != "" ]
                then
                        mysql -u "$username" -p$password -Bse "CREATE DATABASE IF NOT EXISTS \`$databaseName\`;" >> $LOGFILENAME
                        sleep 0.25
                        mysql -u "$username" -p$password -f -D "$databaseName" < "$finalPath/$fileName" >> $LOGFILENAME
                else
                        mysql -u "$username" -Bse "CREATE DATABASE IF NOT EXISTS \`$databaseName\`;" >> $LOGFILENAME
                        sleep 0.25
                        mysql -u "$username" -f -D "$databaseName" < "$finalPath/$fileName" >> $LOGFILENAME
                fi

                # Get the time when the itteration ended
                timeItterationStop=$(date +%s%N)/1000000000

                # Get the time elapsed
                timeElapsed=$(($timeItterationStop-$timeItterationStart))
                # Log the name of the file and the time it took to the log file
                echo "$(date): Done with $fileName after $timeElapsed seconds." >> $LOGFILENAME
        done

        # Print the total time ellapsed
        totalTimeElapsed=$(($(date +%s%N)/1000000000-$TIMESTART))

        echo "Done with all sql files in this folder after $totalTimeElapsed seconds."

        # Print final time in the log file
        echo "" >> $LOGFILENAME
        echo "$(date): Done with all sql files in this folder after $totalTimeElapsed seconds." >> $LOGFILENAME
	echo "You can find a complete log of the program at '$LOGFILENAME'"
        echo ""
        echo "Exiting..."
        exit 0
else
        # No user was given
        echo "You need to specify at least a user with the -u argument."
        exit 128
fi
