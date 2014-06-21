if Rails.env.development?
  require 'pusher'
  Pusher.url = "http://#{ENV['PUSHER_KEY']}:#{ENV['PUSHER_SECRET']}@api.pusherapp.com/apps/#{ENV['PUSHER_APP_ID']}"
  Pusher.logger = Rails.logger
end
