module Tremolo
  class Railtie < ::Rails::Railtie
    config.before_configuration do |app|
      app.config.tremolo = ActiveSupport::OrderedOptions.new

      # set defaults
      app.config.tremolo.trackers = []
      app.config.tremolo.namespace = nil
      app.config.tremolo.timing = true
      app.config.tremolo.pageviews = true
      app.config.tremolo.exceptions = false

      # optional, for page subscribers
      app.config.tremolo.hostname = nil
      app.config.tremolo.path_prefix = nil
    end

    initializer "tremolo.build_trackers" do
      config.tremolo.trackers.each do |args|
        # cheap way to detect a named tracker
        args.unshift(:default) unless args.first.is_a? Symbol

        args << {namespace: config.tremolo.namespace}

        Tremolo.supervised_tracker(*args)
      end
    end

    initializer "tremolo.controller_extension" do
      track_exceptions = config.tremolo.exceptions

      ActiveSupport.on_load(:action_controller) do
        include Tremolo::SessionTracking

        include Tremolo::ExceptionTracking if track_exceptions
      end
    end

    initializer "tremolo.configure_subscribers" do
      if config.tremolo.timing
        ActiveSupport::Notifications.subscribe('process_action.action_controller', Tremolo::Subscribers::Timing)
      end

      if config.tremolo.pageviews
        ActiveSupport::Notifications.subscribe('process_action.action_controller', Tremolo::Subscribers::Page)
      end
    end
  end
end
