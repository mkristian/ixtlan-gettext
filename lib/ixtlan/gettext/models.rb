#
# ixtlan_gettext - helper to use fast_gettext with datamapper/ixtlan
# Copyright (C) 2012 Christian Meier
#
# This file is part of ixtlan_gettext.
#
# ixtlan_gettext is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# ixtlan_gettext is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with ixtlan_gettext.  If not, see <http://www.gnu.org/licenses/>.
#
require 'ixtlan/gettext/locale_resource'
require 'ixtlan/user_management/domain_resource'

module Ixtlan
  module Gettext
    class TranslationKey
      include DataMapper::Resource

      def self.storage_name(arg)
        'gettext_keys'
      end

      property :id, Serial
      property :name, Text, :unique=>true, :required => true, :length => 4096
      
      property :updated_at, DateTime, :required => true, :lazy => true

      def self.update_all(keys)
        ids = keys.collect do |k|
          k.save
          k.id
        end
        all(:id.not => ids).destroy!
      end

      def self.translation(key, locale)
        Translation.first(TranslationKey.name => key, Locale.code => locale)
      end

      def self.available_locales
        Translation.all(:fields => [:locale_id], :unique => true).collect do |t|
          t.locale
        end
      end
      # do not record timestamps since they are set from outside
      def set_timestamps_on_save
      end
    end
    class Translation
      include DataMapper::Resource

      def self.storage_name(arg)
        'gettext_texts'
      end

      belongs_to :translation_key, TranslationKey, :key => true
      belongs_to :locale, Locale,:key => true
      belongs_to :domain, Ixtlan::UserManagement::Domain, :key => true
      
      property :text, Text, :length => 4096

      property :updated_at, DateTime, :required => true, :lazy => true

      # do not record timestamps since they are set from outside
      def set_timestamps_on_save
      end
    end
    class Flush
      # used local flush service

      def self.trigger(rest)
        begin
          rest.retrieve( self.class )
        rescue => e
          warn "error sending flush trigger for gettext #{e.message}"
        end
      end

    end
  end
end
