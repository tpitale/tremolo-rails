# Tremolo::Rails

Provides seamless integration with basic tracking of rails (timing and pageviews) into the Google Analytics Measurement API.

[![Build Status](https://travis-ci.org/tpitale/tremolo-rails.png?branch=master)](https://travis-ci.org/tpitale/tremolo-rails)
[![Code Climate](https://codeclimate.com/github/tpitale/tremolo-rails.png)](https://codeclimate.com/github/tpitale/tremolo-rails)

## Installation

Add this line to your application's Gemfile:

    gem 'tremolo-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tremolo-rails

## Provides

* Timing from instrumentation (total duration, db_runtime, view_runtime)
* Pageview tracking
* Tracker hook in controllers that can use a generated UUID request session `client_id`
* Exception tracking (tracks the exception name and line/file if available)

Session UUID for the `client_id` is handled for you. Can be overridden easily, see [Overriding the client_id](https://github.com/tpitale/tremolo-rails#overriding-the-client_id).

## Usage

In environments/production.rb (leave blank in development/test to not track):

```ruby
config.tremolo.trackers << ['0.0.0.0', 4444]
```

In controllers, `tracker` is made available to you:

```ruby
tracker.increment('count.series-name')
```

## Named trackers ##

In the example above, the tracker is named `default`. If you wish, you can make multiple trackers, each with a name.

```ruby
config.tremolo.trackers << ['0.0.0.0', 4444] # default
config.tremolo.trackers << [:secondary, '0.0.0.0', 8191]
```

This named tracker can be retrieved by passing the name to `tracker` in a controller.

```ruby
tracker(:secondary)
```

Further options can be passed to the tracker as a hash in the last element of an array (more details on the namespace below):

```ruby
config.tremolo.trackers << ['0.0.0.0', 4444, {namespace: 'website'}]
```

**Note:** tracker-specific namespace options will override global `namespace` configuration.

## Overriding the client_id ##

A method is added to your controller called `tremolo_client_id`. By default, it's implementation looks like:

```ruby
session['tremolo.client_id'] ||= Tremolo::Rails.build_client_id
```

If you wish to not store the `client_id` in session, or you wish to use another UUID value, you may override the method `tremolo_client_id` as you see fit.

## Setting a namespace ##

To set a namespace to be used to prefix all stats for all trackers:

```ruby
config.tremolo.namespace = 'tremolo' # default is nil
```

This will cause pageviews and exceptions to be tracked under the stat `tremolo.pageview` and `tremolo.exception`, for example.

The namespace can also be set per-tracker by passing it as the last argument to the configuration:

```ruby
config.tremolo.trackers << ['0.0.0.0', 4444, {namespace: 'tremolo'}]
```

## Tracking exceptions ##

```ruby
config.tremolo.exceptions = true
```

Tracking exceptions happens by adding to `ActionController::Base` a `rescue_from` for `Exception`. Because of this, it will only rescue exceptions that have not already been rescued from in your own code. If you wish to track those exceptions, as well, you can call `track_exception_with_tremolo(exception)` to your own `rescue_from` methods.

## Disable some, or all, tracking

Inside of your `environment` files, as appropriate

```ruby
config.tremolo.timing = false # stats: runtime.total, runtime.db, runtime.view
config.tremolo.pageviews = false # stats: pageview
config.tremolo.exceptions = false # default, stats: exception
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
