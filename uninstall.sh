#Initialising install path
cd /var/www/html;
installpath="/var/www/html";

#user input for folder and database details
read -p "Website Domain: " websitedomain;
read -p "MySQL Root Username: " mysqluser;
read -p "MySQL Root Password: " mysqlpass;
read -p "Website Database Name: " mysqlwuser;

#ARE YOU SURE prompt
read -rp "ARE YOU SURE? Make sure you have a backup. This action will delete the website and all associated files. To proceed choose yes, no or cancel using [y/n/c].";
#yes, no or cancel
[[ ${REPLY,,} =~ ^(c|cancel|C|CANCEL|Cancel)$ ]] && {
	#choosing cancelled in ARE YOU SURE prompt
	echo "Website not deleted. Action cancelled.";
	exit 1;
}

#choosing yes in ARE YOU SURE prompt
if [[ ${REPLY,,} =~ ^(y|yes|Y|YES|Yes)$ ]]; then

	#delete directory only if $websitedomain has been entered, otherwise it could delete the entire /var/www/html directory
	if [ -n "$websitedomain" ]
	then
		sudo rm $installpath/$websitedomain -R;
		sudo rm /etc/nginx/sites-available/$websitedomain;
		sudo rm /etc/nginx/sites-enabled/$websitedomain;
		sudo rm /etc/nginx/sites-available/app.$websitedomain;
		sudo rm /etc/nginx/sites-enabled/app.$websitedomain;
		sudo rm /etc/apache2/sites-enabled/$websitedomain.conf;
		sudo rm /etc/apache2/sites-available/$websitedomain.conf;
		sudo rm /etc/apache2/sites-enabled/app.$websitedomain.conf;
		sudo rm /etc/apache2/sites-available/app.$websitedomain.conf;
	else
		echo "Website Domain not defined.";
		echo "DELETED: Folder $installpath/$websitedomain";
	fi

	#delete mysql user and database only if $mysqlwuser has been entered
	if [ -n "$mysqlwuser" ]
	then
		echo "DROP DATABASE $mysqlwuser" | mysql -u$mysqluser -p$mysqlpass -hlocalhost;
		echo "DROP USER $mysqlwuser@localhost" | mysql -u$mysqluser -p$mysqlpass -hlocalhost;
		echo "DELETED: MySQL database $mysqlwuser";
	else
		echo "Website Database Name not defined.";
	fi

#choosing no or invalid input in ARE YOU SURE prompt
else
	echo "Website not deleted.";
fi