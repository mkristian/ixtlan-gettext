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
module Ixtlan
  module Gettext
    class Locale
      include DataMapper::Resource

      def self.storage_name(arg)
        'gettext_locales'
      end

      # key for selectng the IdentityMap should remain this class if
      # there is no single table inheritance with Discriminator in place
      # i.e. the subclass used as key for the IdentityMap
      def self.base_model
        self
      end

      property :id, Serial, :auto_validation => false
      property :code, String, :unique=>true, :required => true, :format => /^[a-z][a-z](_[A-Z][A-Z])?$/, :length => 5
      
      property :updated_at, DateTime, :required => true, :lazy => true

      # do not record timestamps since they are set from outside
      def set_timestamps_on_save
      end
    end
  end
end