ixtlan-gettext
-------------

* [![Build Status](https://secure.travis-ci.org/mkristian/ixtlan-gettext.png)](http://travis-ci.org/mkristian/ixtlan-remote)
* [![Dependency Status](https://gemnasium.com/mkristian/ixtlan-gettext.png)](https://gemnasium.com/mkristian/ixtlan-remote)
* [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/mkristian/ixtlan-gettext)

these are some helper classes to provide translation text via the fast_gettext gem from a database usng datamapper. (it will not work with activerecord !!). beside the locale there is also a text domain which can be used to overlay the default text domain. for example you have a rideshare board for several locations but want to have slightly different text/translation here or there, then you canuse the default text domain for the common text and overwrite some passages in the respective text domain for a location.

setup the datamapper resources
==============================

    require 'dm-migrations'
    require 'dm-validations'
    require 'dm-timestamps'
    require 'dm-sqlite-adapter' # use any other adapter you need
    require 'ixtlan/gettext/models'
	
    DataMapper.auto_upgrade!

that prolog is the minimal datamapper setup and might be already in place in your project.

the model
=========

* Ixtlan::Gettext::Locale(code:String)
* Ixtlan::UserManagement::Domain(name:String)
* Ixtlan::Gettext::TranslationKey(name:String)
* Ixtlan::Gettext::Translation(text:String, translation_key:Ixtlan::Gettext::TranslationKey, locale:Ixtlan::Gettext::Locale, domain:Ixtlan::UserManagement::Domain)

usage
=====

    require 'ixtlan/gettext/manager'
    include FastGettext::Translation

    gettext = Ixtlan::Gettext::Manager.new
	gettext.use( 'en' )
	
	puts _("phrase to translate")
	
after the data in datbase changed you might need to clear the cache

    gettext.flush_caches

rails
=====

within rails if you have an instance of the manager via the config (keeping a single instance per application):

    Rails.application.config.gettext
	
or (assuming your rails is named 'rideboards')

    Rideboards::Application.config.gettext

using a rails app with ixtlan-translations
==========================================

see [http://github.com/mkristian/ixtlan-translations](ixtlan-translations)

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

meta-fu
-------

enjoy :) 

