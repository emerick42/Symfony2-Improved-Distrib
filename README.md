#Symfony2-Improved-Distrib

A Symfony2 distrib improved with FOSUserBundle, DoctrineFixtures and DoctrineExtensions. It also includes Yui-compressor. Everything is preconfigured as possible.

You just have to follow these short steps to start your project:
 * copy the app/config/parameter.yml.dist and fill with your database information
 * install the vendor with composer
 * reconfigure the secured area (default is /admin) and modify the prefix of the FOSUserBundle routes in app/config/routing.yml 
 * create your own bundle
 * create the User entity in your bundle : [Read the FOSUserBundle Documentation](https://github.com/FriendsOfSymfony/FOSUserBundle/blob/master/Resources/doc/index.md)
 * change default User class entry in app/config/config.yml under fos_user 
 * if you use Assetic add your bundle in its configuration in app/config/config.yml

I hope this will help kickstart your projects.
