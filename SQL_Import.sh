#!/bin/bash

TIMESTART=$(date +%s%N)/1000000000

while getopts u:p: flag
do
        case ${flag} in
                u) #set usernameNAME
                        username=${OPTARG};;
                p) #set password
                        password=${OPTARG};;
        esac
done

echo "Username: $username"
echo "Password: $password"

#Loop through .sql files
for FILE in *.sql
do
        # Start the timer for how long it took
        timeItterationStart=$(date +%s%N)/1000000000

        # get the file name
        basename "$FILE"
        fileName="$(basename -- $FILE)"
        # echo "$fileName"
        databaseName=${fileName%.sql}
        # echo "$databaseName"

        # Create the database if it does not exist, then
        # Run the sql file in the mysql cli with the file name as the db
        if [$password != ""]
        then
                mysql -u $username -p[$password] -Bse "CREATE DATABASE IF NOT EXISTS $databaseName;"
                sleep 0.25
                mysql -u $username -p[$password] $databaseName < ./$fileName
        else
                mysql -u $username -Bse "CREATE DATABASE IF NOT EXISTS $databaseName;"
                sleep 0.25
                mysql -u $username $databaseName < ./$fileName
        fi

        echo "done with $fileName"

        # Get the time when the itteration ended
        timeItterationStop=$(date +%s%N)/1000000000

        # Print the time elapsed
        timeElapsed=$(($timeItterationStop-$timeItterationStart))
        echo "Finished after: $timeElapsed seconds!"
done

totalTimeElapsed=$(($(date +%s%N)/1000000000-$TIMESTART))

echo "Done with all sql files in this folder after $totalTimeElapsed seconds."
echo "Exiting..."