web: bundle exec rails s -p $PORT -e $RACK_ENV
worker: bundle exec rake resque:work QUEUE=*
scheduler: bundle exec rake resque:scheduler
