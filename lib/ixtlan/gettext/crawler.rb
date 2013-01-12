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
    class Crawler

      def self.crawl
        Crawler.new.crawl
      end

      def crawl
        keys.clear
        Dir[File.join('app', '**', '*rb')].each do |f|
          File.read(f).each_line do |line|
            extract_key(line) if line =~ /_[ (]/
          end
        end
        keys.sort!
        keys.uniq!
        keys
      end
      
      private

      def keys
        @keys ||= []
      end
      
      def extract_key(line)
        extract(line, "'")
        extract(line, '"')
      end
      
      def extract(line, sep)
        if line =~ /.*_[ (][#{sep}]/
          # non-greedy +? and *? vs. greedy + and *
          k = line.sub( /.*?_[ (][#{sep}]/, '').sub(/[#{sep}].*\n/, '')
          keys << k; puts k unless keys.member? k
          extract_key(line.sub(/[^_]*_[ (][#{sep}][^#{sep}]+[#{sep}]/, ''))
        end
      end
    end
  end
end
