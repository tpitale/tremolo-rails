module Tremolo
  module Subscribers
    class Page < Base
      def track!
        tracker.increment('pageview', tags)
      end
    end
  end
end
