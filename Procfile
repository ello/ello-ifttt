web: bin/rails server -p $PORT -e $RAILS_ENV
worker: bundle exec sidekiq -c ${SIDEKIQ_CONCURRENCY:-1} -q default -i ${DYNO:-1}
kinesis_consumer: bundle exec rake kinesis:consumer
