require 'securerandom'
require 'tremolo'

require 'tremolo/session_tracking'
require 'tremolo/exception_tracking'
require 'tremolo/subscribers/base'
require 'tremolo/subscribers/page'
require 'tremolo/subscribers/timing'

module Tremolo
  module Rails
    module_function def build_client_id
      SecureRandom.uuid
    end
  end
end

require 'tremolo/railtie' if defined?(::Rails)
