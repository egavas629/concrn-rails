require 'pusher'

Pusher.url = ENV['PUSHER_URL'] || "http://#{ENV['PUSHER_KEY']}:#{ENV['PUSHER_SECRET']}@api.pusherapp.com/apps/#{ENV['PUSHER_APP_ID']}"
Pusher.logger = Rails.logger
