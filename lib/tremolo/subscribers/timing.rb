module Tremolo
  module Subscribers
    class Timing < Base
      def total_runtime
        @total_runtime ||= event.duration
      end

      def db_runtime
        @db_runtime ||= payload[:db_runtime]
      end

      def view_runtime
        @view_runtime ||= payload[:view_runtime]
      end

      def track!
        tracker.timing('runtime.total', total_runtime, tags)
        tracker.timing('runtime.db', db_runtime, tags)
        tracker.timing('runtime.view', view_runtime, tags)
      end
    end
  end
end
