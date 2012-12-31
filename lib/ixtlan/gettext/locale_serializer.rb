require 'ixtlan/babel/serializer'

module Ixtlan
  module Gettext

    class LocaleSerializer < Ixtlan::Babel::Serializer

      root 'locale'

      add_context( :single )

      add_context( :collection )

    end
  end
end
