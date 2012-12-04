require 'ixtlan/gettext/manager'
module Ixtlan
  module Gettext
    class Railtie < Rails::Railtie
      
      config.gettext = Ixtlan::Gettext::Manager.new
      
      rake_tasks do
        load 'ixtlan/gettext/translation.rake'
      end

    end
  end
end
