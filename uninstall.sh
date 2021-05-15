#Initialising install path
cd /var/www/html;
installpath="/var/www/html";

#Initialising colours
red=`tput setaf 1`;
green=`tput setaf 2`;
reset=`tput sgr0`;

#user input for folder and database details
read -p "Website Domain: " websitedomain;
read -p "MySQL Root Username: " mysqluser;
echo "MySQL Root Password:";
read -s mysqlpass;
read -p "Website Database Name: " mysqlwuser;

#ARE YOU SURE prompt
read -rp "ARE YOU SURE? Make sure you have a backup. This action will delete the website $websitedomain and all associated files, database and config. To proceed choose yes, no or cancel using [y/n/c]: ";
#yes, no or cancel
[[ ${REPLY,,} =~ ^(c|cancel|C|CANCEL|Cancel)$ ]] && {
	#choosing cancelled in ARE YOU SURE prompt
	echo "Website not deleted. Action cancelled.";
	exit 1;
}

#choosing yes in ARE YOU SURE prompt
if [[ ${REPLY,,} =~ ^(y|yes|Y|YES|Yes)$ ]]; then

	#delete directory only if $websitedomain has been entered, otherwise it could delete the entire /var/www/html directory
	if [ -n "$websitedomain" ] && [ -n "$mysqluser" ] && [ -n "$mysqlpass" ] && [ -n "$mysqlwuser" ]
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
		echo "DROP DATABASE $mysqlwuser" | mysql -u$mysqluser -p$mysqlpass -hlocalhost;
		echo "DROP USER $mysqlwuser@localhost" | mysql -u$mysqluser -p$mysqlpass -hlocalhost;
		echo "DELETED: MySQL database $mysqlwuser";
		echo -e "\r\n### -----------------\r\n";
		echo "${green}DELETED successfully:${reset} Folder $installpath/$websitedomain, database $mysqlwuser and NginX config.";
	else
		echo "${red}Website Domain not defined.${reset}";
	fi

#choosing no or invalid input in ARE YOU SURE prompt
else
	echo "${red}Website not deleted.${reset}";
fi