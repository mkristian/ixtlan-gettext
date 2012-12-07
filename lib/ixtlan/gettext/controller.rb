module Ixtlan
  module Gettext
    module Controller

      def flush
        # only for localhost
        if request.remote_ip == '127.0.0.1'
          Rails.application.config.gettext.flush_caches
          head :ok
        else
          head :not_found
        end
      end

    end
  end
end
