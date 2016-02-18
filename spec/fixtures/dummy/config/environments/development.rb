Dummy::Application.configure do
  config.cache_classes = true
  config.eager_load = true

  # Tremolo configuration
  config.tremolo.hostname = 'domain.com' # optional, but recommended
  config.tremolo.exceptions = true
end
