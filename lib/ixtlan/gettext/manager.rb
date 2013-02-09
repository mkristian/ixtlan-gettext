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
require 'fast_gettext'
module Ixtlan
  module Gettext
    class Manager
      
      DEFAULT = 'DEFAULT' # should match ::Ixtlan::UserManagement::Domain.DEFAULT.name

      def initialize
        @default_repo = build( DEFAULT )
        FastGettext.default_text_domain = DEFAULT
        FastGettext.add_text_domain DEFAULT, :type => :ixtlan
      end

      def use( locale, name = DEFAULT )
        unless FastGettext.translation_repositories.key?( name )
          repos = [ build( "#{name}" ), @default_repo ]
          FastGettext.add_text_domain name, :type=>:chain, :chain=> repos
        end
        FastGettext.set_locale(locale)
        FastGettext.text_domain = name
      end

      def flush_caches(text_domain = nil)
        if text_domain
          (FastGettext.caches[text_domain] || {}).clear
        else
          FastGettext.caches.clear
        end
      end

      private

      def build( name )
        FastGettext::TranslationRepository.build( name, :type => :ixtlan )
      end
    end
  end
end
