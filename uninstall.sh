cd /var/www/html;
installpath="/var/www/html";
read -p "Website Domain: " websitedomain;
read -p "MySQL Root Username: " mysqluser;
read -p "MySQL Root Password: " mysqlpass;
read -p "Website Database Name: " mysqlwuser;

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
fi

#delete mysql user and database only if $mysqlwuser has been entered
if [ -n "$mysqlwuser" ]
then
	echo "DROP DATABASE $mysqlwuser" | mysql -u$mysqluser -p$mysqlpass -hlocalhost;
	echo "DROP USER $mysqlwuser@localhost" | mysql -u$mysqluser -p$mysqlpass -hlocalhost;
else
	echo "Website Database Name not defined.";
fi