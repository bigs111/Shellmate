
# Shellmate

This script is used to manage SSH connections through the terminal.

**Prerequisites**
n/a

**Features**

* Save Server Connections
* Add servers
* Delete Servers
* Connect
* Edit Servers
* Search for servers

**Acknowledgments**

The script was created using Bash and various Bash tools.

**How to install**

1. Copy the code from the file "shellmate1.0.sh".
2. Create a file called "shellmate1.0.sh" and paste the code into that file.
3. In the same directory, type "chmod +x (name of file)".
4. Now, you want to copy that file. To do this, type "cp (file name) /usr/local/bin/(file name)".
5. Next, type "nano ~/.bashrc" and scroll all the way to the bottom. Type the following: alias shellmate="/usr/local/bin/(name of file)". This allows you to create an alias for this script, making it easier to execute by typing "shellmate" into the console instead of "shellmate1.0.sh".
6. Finally, type "source ~/.bashrc" into the terminal.

You're done! Hopefully, it works as expected.
