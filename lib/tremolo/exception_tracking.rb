module Tremolo
  module ExceptionTracking

    def self.included(controller)
      controller.rescue_from ::Exception,
        with: :track_exception_with_tremolo_and_raise
    end

    def track_exception_with_tremolo(exception)
      tracker.increment('exception', backtrace_tags(exception))
    end

    def backtrace_tags(exception)
      {
        name: exception.class.name
      }.merge!(backtrace_location(exception))
    end

    def backtrace_location(exception)
      if exception.respond_to?(:backtrace_locations)
        if location = (exception.backtrace_locations || []).first

          {
            path: location.path,
            line: location.lineno
          }
        else
          {}
        end
      else
        {}
      end
    end

    def track_exception_with_tremolo_and_raise(exception)
      track_exception_with_tremolo(exception)

      # re-raise the exception as normal
      raise exception
    end
  end
end
