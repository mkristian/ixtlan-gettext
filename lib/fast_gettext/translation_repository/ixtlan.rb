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
require 'ixtlan/user_management/domain_resource'
require 'ixtlan/gettext/models'

module FastGettext
  module TranslationRepository
    class Ixtlan

      def initialize( name, options={} )
        @name = name
      end

      @@seperator = '||||' # string that seperates multiple plurals
      def self.seperator=(sep);@@seperator = sep;end
      def self.seperator;@@seperator;end

      def available_locales
        []
      end

      def pluralisation_rule
        nil
      end

      def [](key)
        r = ::Ixtlan::Gettext::Translation.first( ::Ixtlan::Gettext::Translation.translation_key.name => key, 
                                                  ::Ixtlan::Gettext::Translation.locale.code => FastGettext.locale, 
                                                  :domain => domain )
        r.text.to_s if r
      end

      def plural(*args)
        if translation = self[ args*self.class.seperator ]
          translation.to_s.split(self.class.seperator)
        else
          []
        end
      end

      private
      
      def domain
        @domain ||= ::Ixtlan::UserManagement::Domain.first_or_create( :name => @name )
      end
    end
  end
end
