# A Bash Script to import all your SQL files in your MySQL at once!

This script was created for big backup projects, where you had a lot of SQL scripts created and you want to import them back to MySQL. This script will take care of all this work by simply giving it 2 arguments, a username and a password (optional), to access MySQL on your computer.

On a later itteration, it will support custom paths, but for now, you will need to run in from the folder your SQL files are located.

It will print the time each file took, and a total time the script was running in seconds

### To run the script simply go in the folder you want it to work and type:

<code>
  sudo chmod 777 ./SQL_Import.sh
  sudo ./SQL_Import.sh -u [your db username] (-p [your password])*
</code>

*note that the password is optional, if the user you will use has no password, then you don't have to use the <code>-p</code> argument.
