Streetmom::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = true
  config.assets.compile = true
  config.assets.digest = true
  config.assets.js_compressor = :uglifier
  config.assets.version = '1.0'
  config.log_level = :debug
  config.logger = Logger.new(STDOUT)
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.time_zone = "Pacific Time (US & Canada)"

  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => ENV["AWS_BUCKET"],
      :access_key_id => ENV["AWS_KEY"],
      :secret_access_key => ENV["AWS_SECRET"]
    },
    :s3_host_alias => "concrn.s3.amazonaws.com",
    :url => ":s3_domain_url",
    :path => '/:class/:attachment/:id_partition/:style/:filename'
  }
end
