# A Bash Script to import all your SQL files in your MySQL at once!

This script was created for big backup projects, where you had a lot of SQL scripts created and you want to import them back to MySQL. This script will take care of all this work by simply giving it 2 arguments, a username, a password (optional), and a path (optional), to access MySQL on your computer.

It will print the time each file took, and a total time the script was running in seconds.

### To make the script executable, type the following command:

<code>sudo chmod 777 /path/to/script/SQL_Import.sh</code>

### To run the script type the following commad:

<code>sudo /path/to/script/SQL_Import.sh -u [your db username] (-p [your password] -w [your folder path])</code>

#### You can find a analytic print of the specifications with the following command:

<code>/path/to/script/SQL_Import.sh -h</code>

*note that the password and the path are optional. if the user you will use has no password, then you don't have to use the <code>-p</code> argument. If the script is at the same folder as the files, you do not need to specify a path, it will get currcent directory as default automaticaly.
