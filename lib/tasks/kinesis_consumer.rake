namespace :kinesis do
  desc 'Parses and saves events from kinesis queue'
  task consumer: :environment do

    stream = StreamReader.new(
      stream_name: ENV['KINESIS_STREAM_NAME'],
      prefix:      ENV['KINESIS_STREAM_PREFIX'] || ''
    )
    batch_size = Integer(ENV['CONSUMER_BATCH_SIZE'] || StreamReader::DEFAULT_BATCH_SIZE)
    stream.run!(batch_size: batch_size) do |record, kind|
      CreateEventFromStream.perform_async(record: record, kind: kind.underscore)
    end
  end
end
