#! /bin/sh
# service_branch_install.sh
#
# $1 =	name of the cvs branch (of the module "service") to be installed
# $2 =	"createdb" if we're recreating the database, else "foo"
# $3 =	Filename of the pg_dump file, taken from existing site (running pg_sql) 
#			and to be converted by the script convert.sh and imported into mysql

# If no tag name was provided, scold and exit:
#if [ $# -ne 2 ]; then
if [ $# -lt 2 ]; then
	echo 1>&2 Usage: apc_branch_install.sh BRANCH_NAME
	exit 1
fi

INSTALL_DIR="/var/www/service"
MODULE="service"
BRANCH_NAME=$1

INI_FILE_LOCATION=""

# CD to INSTALL_DIR, then up one
cd "$INSTALL_DIR"
cd ".."

# Remove existing APC website:
rm -rf "$INSTALL_DIR"

# Set the CVS environment variables:
export CVSROOT=:ext:user@server:/var/lib/cvsroot
export CVS_RSH=ssh

# Checkout the first module:
cvs checkout -r "$BRANCH_NAME" -d service -P "$MODULE"
chmod -R 755 "$INSTALL_DIR"

# Create an empty file to use as a reference for publication date/time of this site:
touch "$INSTALL_DIR"/publication_date
# Write into that file the name of the cvs tag that was provided to this script:
echo $1 >> "$INSTALL_DIR"/publication_date

# IMPORTANT SECURITY FUNCTION: Move the config files outside the document root:
# cp "$INSTALL_DIR"/conf/digibuddy.ini "$INI_FILE_LOCATION"

# Probably not necessary:
# /usr/sbin/apache2ctl restart

# Recreate the database:
if [ "$2" == "createdb" ]
then
        echo 'creating database...'
		# Drop the database "service" (uncomment only if necessary):
		# mysqladmin -f drop service
		# Create the database "service":
		mysqladmin create service
		# Give the user "service_user" privileges to use the database:
		mysql --execute="grant all on service.* to 'service_user'@'localhost' identified by '*****';"
		mysql --execute="flush privileges"
		# Use the awk script "convert.sh" to cleanup the output of PostgreSQL's "pg_dump" tool
		# into something useable for MySQL:
		./convert.sh $3
		# Execute the SQL statements in the file "service_structure_dump.sql" to create the datastructure in the new MySQL database "service":
		mysql --database=service < "$INSTALL_DIR"/service_structure_dump.sql
		# Populate the new MySQL database ("service") by executing the SQL statements in the file "result", which is the output of convert.sh:
		mysql --database=service < result
        exit
else
        echo 'I did not re-create the database.'
fi