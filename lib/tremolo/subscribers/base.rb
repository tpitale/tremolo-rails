module Tremolo
  module Subscribers
    class Base
      def self.call(*args)
        new(args).track!
      end

      def initialize(args)
        @args = args
      end

      def track!
        # noop, done by page/timing
      end

      protected

      def tags
        {
          path: path,
          hostname: hostname,
          method: method,
          client_id: client_id
        }
      end

      def method
        payload[:method]
      end

      def path_prefix
        ::Rails.application.config.tremolo.path_prefix.to_s
      end

      def path
        path_prefix.to_s + payload[:path]
      end

      def hostname
        ::Rails.configuration.tremolo.hostname
      end

      def client_id
        payload['tremolo.client_id']
      end

      def tracker
        @tracker ||= payload['tremolo.tracker']
      end

      def payload
        @payload ||= event.payload
      end

      def event
        @event ||= ActiveSupport::Notifications::Event.new(*@args)
      end
    end
  end
end
