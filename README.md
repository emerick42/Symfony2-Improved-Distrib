#Symfony2-Improved-Distrib

A Symfony2 distrib improved with FOSUserBundle, DoctrineFixtures, DoctrineExtensions and DoctrineMigrations. It also includes Yui-compressor. Everything is preconfigured as possible.

##Features

This distribution allows you to start your Symfony2 projects really fast. You can just fork this repository and reconfigure it as you want.
Here is a list of the main features:
* uses one of the last stable version of Symfony2
* includes useful bundles like FOSUserBundle, DoctrineFixtures, DoctrineExtensions and DoctrineMigrations
* includes Assetic to manage your resources
* includes the java binary for Yui-compressor to compress your JS and CSS files with Assetic
* reconfigures user's sessions to keep them after cache:clear
* includes a default Capifony deployment file to handle Assetic, migrations and user's session
* uses Incenteev to automatically create a parameter.yml that you have to fill after composer install

##Installation and configuration

###First things you have to do

You just have to follow these short steps to start your project:
* copy the app/config/parameter.yml.dist and fill with your database information
* install the vendor with composer
* follow instructions to create your parameter.yml
* reconfigure the secured area (default is /admin) and modify the prefix of the FOSUserBundle routes in app/config/routing.yml 
* create your own bundle
* create the User entity in your bundle : [Read the FOSUserBundle Documentation](https://github.com/FriendsOfSymfony/FOSUserBundle/blob/master/Resources/doc/index.md)
* change default User class entry in app/config/config.yml under fos_user
* add your bundle in Assetic's configuration in app/config/config.yml

You can also see the optional configurations below to take the best of this distribution.
I hope this will help kickstart your projects.

###Optional configurations

####Use Capifony

If you want to use Capifony, this distribution includes a default configuration file.
There are some mandatory information to provide before using Capifony with this file:
* change your _application name_, _domain name_, _deploy path_, _username_ and _repository address_

You can also change every Capifony settings you want to meet your needs.
It's basically just a usual Capifony deployment file but configured to handle Assetic, migrations and user's sessions.

##Changelog

_**develop**_
* Now using Symfony 2.3
* Add a default Capifony configuration file

_2013/04/05: **v1.1.2**_
* Add Doctrine migrations to Composer dependencies

_2013/03/20: **v1.1.1**_
* Update config.yml to use default locale from parameters.yml

_2013/03/11: **v1.1.0**_
* Now using Symfony 2.2