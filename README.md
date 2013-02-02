#Symfony2-Improved-Distrib

A Symfony2 distrib improved with FOSUserBundle, DoctrineFixtures and DoctrineExtensions. It also includes Yui-compressor. Everything is preconfigured.

You just have to follow these short steps to start your project:
 * copy the app/config/parameter.yml.dist and fill with your database information
 * install the vendor with composer
 * reconfigure the secured area (default is /admin)
 * create your own bundle
 * create the User entity in your bundle and change default entry in config.yml

I hope this will help kickstart your projects.