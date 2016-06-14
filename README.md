# Puppet module: locales

## [Maintainer wanted](https://github.com/netmanagers/puppet-locales/issues/new)

**WARNING WARNING WARNING**

[puppet-locales](https://github.com/netmanagers/puppet-locales) is not currently being maintained, 
and may have unresolved issues or not be up-to-date. 

I'm still using it on a daily basis (with Puppet 3.8.5) and fixing issues I find
while using it. But sadly, I don't have the time required to actively add new features,
fix issues other people report or port it to Puppet 4.x.

If you would like to maintain this module,
please create an issue at: https://github.com/netmanagers/puppet-locales/issues
offering yourself.

## Getting started

This is a Puppet module for locales
It provides only package installation and file configuration.

Made by Javier Bértoli / Netmanagers

Official site: http://www.netmanagers.com.ar

Official git repository: http://github.com/netmanagers/puppet-locales

Released under the terms of Apache 2 License.

This module requires the presence of Example42 Puppi module in your modulepath.


## USAGE - Basic management

* Install locales with default settings

        class { 'locales': }

* Install a specific version of locales package

        class { 'locales':
          version => '1.0.1',
        }

* Install and configure a particular locale

        class { 'locales':
          locales => 'en_US.UTF-8 UTF-8',
        }

  This parameter can be an array. Read the comments in the init file for more details.

* Remove locales resources

        class { 'locales':
          absent => true
        }

* Enable auditing without without making changes on existing locales configuration *files*

        class { 'locales':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'locales':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'locales':
          source => [ "puppet:///modules/example42/locales/locales.conf-${hostname}" , "puppet:///modules/example42/locales/locales.conf" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'locales':
          source_dir       => 'puppet:///modules/example42/locales/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'locales':
          template => 'example42/locales/locales.conf.erb',
        }

* Automatically include a custom subclass

        class { 'locales':
          my_class => 'example42::my_locales',
        }



## TESTING
[![Build Status](https://travis-ci.org/netmanagers/puppet-locales.png?branch=master)](https://travis-ci.org/netmanagers/puppet-locales)
